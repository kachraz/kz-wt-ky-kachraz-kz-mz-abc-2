#!/usr/bin/env bash
# =====================================================================
# Solana Devnet Wallet Batch (Modular Execution)
# Steps can be enabled/disabled in main()
# =====================================================================

set -euo pipefail

# ---------------- CONFIG ----------------
COUNT=10
AIRDROP_SOL=2
# ✅ Fixed RPC URL (clean + from your provided source)
RPC_URL="https://api.devnet.solana.com"
OUTDIR=""  # Will be set dynamically
RETRIES=5
SLEEP_BETWEEN=3
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

# Dynamically set OUTDIR only once
set_outdir() {
  OUTDIR="${PWD}/solana_wallets_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$OUTDIR"
  echo -e "${GREEN}Output directory: ${BOLD}$OUTDIR${RESET}"
}

# Create wallet -> returns "json|pubkey"
create_wallet() {
  local idx=$1
  local json="${OUTDIR}/wallet_${idx}.json"
  solana-keygen new --no-bip39-passphrase --silent --outfile "$json" >/dev/null 2>&1
  local pk=$(solana-keygen pubkey "$json")
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
  cat > "$txt" <<EOF
Wallet #$idx
Public Key   : $pk
Keypair JSON : $json
Balance      : $bal SOL
EOF
  echo -e "   ${GREEN}Info saved: ${txt}${RESET}"
}

# -------- BLOCKS (Steps) ----------------

step_create_wallets() {
  title "Step 1: Creating Wallets"
  set_outdir  # Create OUTDIR only when creating wallets

  for i in $(seq 1 "$COUNT"); do
    local result
    result=$(create_wallet "$i")
    local json="${result%%|*}"
    local pk="${result##*|}"

    echo -e "${BLUE}[Wallet $i]${RESET} Created: $pk"
    PUBS[i]="$pk"
    JSONS[i]="$json"
  done
}

step_airdrops() {
  title "Step 2: Requesting Airdrops"
  [[ -z "$OUTDIR" ]] && set_outdir  # Ensure OUTDIR exists

  for i in $(seq 1 "$COUNT"); do
    local pk="${PUBS[i]:-}"
    if [[ -z "$pk" ]]; then
      echo -e "   ${RED}[Wallet $i] No public key available${RESET}"
      continue
    fi
    echo -e "   ${BLUE}Requesting $AIRDROP_SOL SOL airdrop to $pk${RESET}"
    if with_retries request_airdrop "$pk" >/dev/null; then
      echo -e "   ${GREEN}✓ Airdrop successful${RESET}"
    else
      echo -e "   ${RED}✗ Airdrop failed after $RETRIES attempts${RESET}"
    fi
  done
}

step_balances() {
  title "Step 3: Checking Balances"
  [[ -z "$OUTDIR" ]] && set_outdir

  for i in $(seq 1 "$COUNT"); do
    local pk="${PUBS[i]:-}"
    if [[ -z "$pk" ]]; then
      echo -e "   ${RED}[Wallet $i] Missing public key!${RESET}"
      BALS[i]="0"
      continue
    fi
    local bal
    bal=$(with_retries get_balance "$pk")
    BALS[i]="$bal"
    echo -e "   ${GREEN}[Wallet $i] Balance: $bal SOL${RESET}"
    save_info "$i" "${JSONS[i]:-}" "$pk" "$bal"
  done
}

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

  # --- Enable the steps you need ---
  step_create_wallets   # ✅ Generate wallets
  step_airdrops         # 💸 Get free SOL
  step_balances         # 📊 Check balances
  step_summary          # 📋 Final report
  # ---------------------------------
}
# ----------------------------------------

main "$@"