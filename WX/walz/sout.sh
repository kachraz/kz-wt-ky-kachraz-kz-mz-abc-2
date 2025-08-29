#!/usr/bin/env bash
# =====================================================================
# Solana Devnet Wallet Batch (Reliable & Modular)
# =====================================================================

set -euo pipefail

# ---------------- CONFIG ----------------
COUNT=2
AIRDROP_SOL=2
# ✅ Clean, working RPC (from your knowledge base + reliable fallback)
RPC_URL="https://api.devnet.solana.com"
OUTDIR=""
RETRIES=5
SLEEP_BETWEEN=2
TIMEOUT=15
# ----------------------------------------

# ---------------- COLORS ----------------
if [[ -t 1 ]]; then
  BOLD='\e[1m'; DIM='\e[2m'; RESET='\e[0m'
  RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m'; BLUE='\e[34m'; MAGENTA='\e[35m'; CYAN='\e[36m'
else
  BOLD=''; DIM=''; RESET=''; RED=''; GREEN=''; YELLOW=''; BLUE=''; MAGENTA=''; CYAN=''
fi

bar() { printf "${DIM}───────────────────────────────────────────────${RESET}\n"; }
title() { bar; printf "${BOLD}${CYAN}%s${RESET}\n" "$1"; bar; }
# ----------------------------------------

# ---------------- CHECKS ----------------
need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo -e "${RED}Error:${RESET} '$1' not found. Install Solana CLI first."
    exit 1
  }
}

check_deps() {
  need solana
  need solana-keygen
}
# ----------------------------------------

# ---------------- GLOBAL ----------------
declare -a PUBS JSONS BALS
# ----------------------------------------

# ---------------- FUNCS -----------------

# Create wallet -> returns "json|pubkey"
create_wallet() {
  local idx=$1
  local json="${OUTDIR}/wallet_${idx}.json"
  solana-keygen new --no-bip39-passphrase --silent --outfile "$json" >/dev/null 2>&1
  local pk=$(solana-keygen pubkey "$json")
  [[ -z "$pk" ]] && { echo -e "${RED}Failed to create wallet $idx${RESET}"; exit 1; }
  echo "$json|$pk"
}

request_airdrop() {
  local pk=$1
  timeout "$TIMEOUT"s solana airdrop "$AIRDROP_SOL" "$pk" \
    --url "$RPC_URL" --commitment processed >/dev/null 2>&1
}

get_balance() {
  local pk=$1
  solana balance "$pk" --url "$RPC_URL" 2>/dev/null | awk '{print $1}'
}

with_retries() {
  local action=$1 arg=$2
  for i in $(seq 1 "$RETRIES"); do
    local out
    if out=$($action "$arg" 2>/dev/null); then
      if [[ -n "$out" && "$out" != "0" ]]; then
        echo "$out"
        return 0
      fi
    fi
    echo -e "   ${YELLOW}Attempt $i failed, retrying...${RESET}"
    sleep "$SLEEP_BETWEEN"
  done
  echo "0"
}

save_info() {
  local idx=$1 json=$2 pk=$3 bal=$4
  local txt="${OUTDIR}/wallet_${idx}.txt"
  mkdir -p "$OUTDIR"  # Only create when saving
  cat > "$txt" <<EOF
Wallet #$idx
Public Key   : $pk
Keypair JSON : $json
Balance      : $bal SOL
EOF
  echo -e "   ${GREEN}Info saved: ${txt}${RESET}"
}

# Auto-detect latest wallet directory
find_latest_wallet_dir() {
  local dir=$(ls -1td ./solana_wallets_*/ 2>/dev/null | head -n1)
  if [[ -n "$dir" && -d "$dir" ]]; then
    OUTDIR="$dir"
    echo -e "${GREEN}Found wallet directory: ${BOLD}$OUTDIR${RESET}"
  else
    echo -e "${RED}No existing wallet directory found.${RESET}"
    return 1
  fi
}

# Load wallets from disk
load_wallets() {
  title "Loading Wallets from Disk"
  if ! find_latest_wallet_dir; then
    echo -e "${RED}Aborting: Cannot load wallets.${RESET}"
    return 1
  fi

  local loaded=0
  for i in $(seq 1 "$COUNT"); do
    local json="$OUTDIR/wallet_${i}.json"
    if [[ -f "$json" ]]; then
      local pk=$(solana-keygen pubkey "$json" 2>/dev/null || true)
      if [[ -n "$pk" ]]; then
        PUBS[i]="$pk"
        JSONS[i]="$json"
        echo -e "   ${BLUE}[Wallet $i]${RESET} Loaded: $pk"
        ((loaded++))
      fi
    fi
  done

  if (( loaded == 0 )); then
    echo -e "${RED}No wallets loaded. Run 'step_create_wallets' first.${RESET}"
    return 1
  fi
  echo -e "${GREEN}✓ Loaded $loaded wallets${RESET}"
}

# Create wallets
step_create_wallets() {
  OUTDIR="${PWD}/solana_wallets_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$OUTDIR"
  title "Step 1: Creating $COUNT Wallets"
  echo -e "${GREEN}Saving to: ${BOLD}$OUTDIR${RESET}"

  for i in $(seq 1 "$COUNT"); do
    local result
    result=$(create_wallet "$i")
    local json="${result%%|*}"
    local pk="${result##*|}"
    PUBS[i]="$pk"
    JSONS[i]="$json"
    echo -e "   ${BLUE}[Wallet $i]${RESET} Created: $pk"
  done
}

# Request airdrops
step_airdrops() {
  title "Step 2: Requesting Airdrops"
  for i in $(seq 1 "$COUNT"); do
    local pk="${PUBS[i]:-}"
    [[ -z "$pk" ]] && { echo -e "   ${RED}[Wallet $i] No public key${RESET}"; continue; }
    echo -e "   ${BLUE}Airdropping $AIRDROP_SOL SOL to $pk${RESET}"
    if with_retries request_airdrop "$pk" >/dev/null; then
      echo -e "   ${GREEN}✓ Success${RESET}"
    else
      echo -e "   ${RED}✗ Failed after $RETRIES attempts${RESET}"
    fi
  done
}

# Check balances
step_balances() {
  title "Step 3: Checking Balances"
  if [[ -z "${PUBS[1]:-}" ]]; then
    echo -e "${YELLOW}Public keys not found. Attempting to load from disk...${RESET}"
    load_wallets || return 1
  fi

  for i in $(seq 1 "$COUNT"); do
    local pk="${PUBS[i]:-}"
    [[ -z "$pk" ]] && { echo -e "   ${RED}[Wallet $i] Missing key${RESET}"; BALS[i]="0"; continue; }
    local bal
    bal=$(with_retries get_balance "$pk")
    BALS[i]="$bal"
    echo -e "   ${GREEN}[Wallet $i] Balance: $bal SOL${RESET}"
    save_info "$i" "${JSONS[i]:-}" "$pk" "$bal"
  done
}

# Final summary
step_summary() {
  title "Summary"
  printf "${BOLD}Index  Public Key                                   Balance (SOL)${RESET}\n"
  for i in $(seq 1 "$COUNT"); do
    printf "[%02d]   %-44s %8s\n" "$i" "${PUBS[i]:-N/A}" "${BALS[i]:-0}"
  done
  [[ -n "$OUTDIR" ]] && echo -e "\n${GREEN}Done!${RESET} Wallets saved in: ${BOLD}$OUTDIR${RESET}"
}
# ----------------------------------------

# ---------------- MAIN ------------------
main() {
  trap 'echo -e "\n${YELLOW}Interrupted.${RESET}"; exit 1' INT
  check_deps

  title "Solana Devnet Wallet Batch"

  # ✅ Enable only the steps you need
  step_create_wallets   # Run once to generate wallets
  step_airdrops         # Run once to get free SOL
  step_balances         # Check balance (auto-loads if needed)
  step_summary          # Final report
}
# ----------------------------------------

main "$@"