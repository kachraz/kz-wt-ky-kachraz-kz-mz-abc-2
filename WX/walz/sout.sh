#!/usr/bin/env bash
# =====================================================================
# Solana Devnet Wallet Batch (Stable Flow)
# 1. Create N wallets
# 2. Request airdrops (with timeout + retry)
# 3. Check balances
# 4. Write per-wallet summaries
# Author: You
# =====================================================================

set -euo pipefail

# ---------------- CONFIG ----------------
COUNT=10
AIRDROP_SOL=2
RPC_URL="https://api.devnet.solana.com"
OUTDIR="${PWD}/solana_wallets_$(date +%Y%m%d_%H%M%S)"
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
check_deps() { need solana; need solana-keygen; }
# ----------------------------------------

# ---------------- FUNCS -----------------

# Create wallet, return "json|pubkey"
create_wallet() {
  local idx=$1
  local json="${OUTDIR}/wallet_${idx}.json"
  solana-keygen new --no-bip39-passphrase --silent --outfile "$json"
  local pk=$(solana-keygen pubkey "$json")
  echo "$json|$pk"
}

# Request airdrop (safe with timeout)
request_airdrop() {
  local pk=$1
  timeout "$TIMEOUT"s solana airdrop "$AIRDROP_SOL" "$pk" \
    --url "$RPC_URL" --commitment processed >/dev/null 2>&1
}

# Get balance
get_balance() {
  local pk=$1
  solana balance "$pk" --url "$RPC_URL" 2>/dev/null | awk '{print $1}'
}

# Retry wrapper
with_retries() {
  local action=$1 arg=$2
  local out="0"
  for i in $(seq 1 "$RETRIES"); do
    if out=$($action "$arg"); then
      if [[ -n "$out" && "$out" != "0" ]]; then
        echo "$out"
        return
      fi
    fi
    echo -e "   ${YELLOW}Attempt $i failed, retrying...${RESET}"
    sleep "$SLEEP_BETWEEN"
  done
  echo "$out"
}

# Save per-wallet text file
save_info() {
  local idx=$1 json=$2 pk=$3 bal=$4
  local txt="${OUTDIR}/wallet_${idx}.txt"
  cat > "$txt" <<EOF
Wallet #$idx
Public Key   : $pk
Keypair JSON : $json
Balance      : $bal SOL
EOF
}
# ----------------------------------------

# ---------------- MAIN ------------------
main() {
  trap 'echo -e "\n${YELLOW}Interrupted.${RESET}"; exit 1' INT
  mkdir -p "$OUTDIR"
  check_deps

  title "Solana Devnet Wallet Batch"
  echo "Creating $COUNT wallets, requesting $AIRDROP_SOL SOL each"
  echo "Output dir: $OUTDIR"
  echo "RPC URL   : $RPC_URL"
  echo

  declare -a PUBS JSONS BALS

  # Step 1: Create wallets
  title "Step 1: Creating wallets"
  for i in $(seq 1 "$COUNT"); do
    result=$(create_wallet "$i")
    json="${result%%|*}"; pk="${result##*|}"
    echo -e "${BLUE}[Wallet $i]${RESET} Created: $pk"
    PUBS[$i]="$pk"; JSONS[$i]="$json"
  done

  # Step 2: Airdrop requests
  title "Step 2: Requesting airdrops"
  for i in $(seq 1 "$COUNT"); do
    pk="${PUBS[$i]}"
    echo -e "${BLUE}[Wallet $i]${RESET} Requesting airdrop for $pk..."
    with_retries request_airdrop "$pk" >/dev/null
  done

  # Step 3: Balance checks
  title "Step 3: Checking balances"
  for i in $(seq 1 "$COUNT"); do
    pk="${PUBS[$i]}"
    bal=$(with_retries get_balance "$pk")
    BALS[$i]="$bal"
    echo -e "${GREEN}[Wallet $i] Balance:${RESET} $bal SOL"
    save_info "$i" "${JSONS[$i]}" "$pk" "$bal"
  done

  # Step 4: Summary
  title "Summary"
  printf "${BOLD}Index  Public Key                                   Balance (SOL)${RESET}\n"
  for i in $(seq 1 "$COUNT"); do
    printf "[%02d]   %-44s %8s\n" "$i" "${PUBS[$i]}" "${BALS[$i]}"
  done
  echo -e "\n${GREEN}Done!${RESET} Wallets saved in: ${BOLD}$OUTDIR${RESET}"
}
# ----------------------------------------

main "$@"
