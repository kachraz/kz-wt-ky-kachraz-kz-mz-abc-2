#!/usr/bin/env bash
# =====================================================================
# Solana Devnet Wallet Batch (Modular Execution)
# Steps can be enabled/disabled in main()
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
need() { command -v "$1" >/dev/null 2>&1 || { echo -e "${RED}Error:${RESET} '$1' not found. Install Solana CLI first."; exit 1; }; }
check_deps() { need solana; need solana-keygen; }
# ----------------------------------------

# ---------------- GLOBAL ----------------
declare -a PUBS JSONS BALS
# ----------------------------------------

# ---------------- FUNCS -----------------

# Create wallet -> returns "json|pubkey"
create_wallet() {
  local idx=$1
  local json="${OUTDIR}/wallet_${idx}.json"
  solana-keygen new --no-bip39-passphrase --silent --outfile "$json"
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

# -------- BLOCKS (Steps) ----------------

step_create_wallets() {
  title "Step 1: Creating wallets"
  for i in $(seq 1 "$COUNT"); do
    result=$(create_wallet "$i")
    json="${result%%|*}"; pk="${result##*|}"
    echo -e "${BLUE}[Wallet $i]${RESET} Created: $pk"
    PUBS[$i]="$pk"; JSONS[$i]="$json"
  done
}

step_airdrops() {
  title "Step 2: Requesting airdrops"
  for i in $(seq 1 "$COUNT"); do
    pk="${PUBS[$i]}"
    [[ -z "$pk" ]] && { echo -e "${RED}[Wallet $i] Missing public key!${RESET}"; continue; }
    echo -e "${BLUE}[Wallet $i]${RESET} Requesting airdrop for $pk..."
    with_retries request_airdrop "$pk" >/dev/null
  done
}

step_balances() {
  title "Step 3: Checking balances"
  for i in $(seq 1 "$COUNT"); do
    pk="${PUBS[$i]}"
    [[ -z "$pk" ]] && { echo -e "${RED}[Wallet $i] Missing public key!${RESET}"; continue; }
    bal=$(with_retries get_balance "$pk")
    BALS[$i]="$bal"
    echo -e "${GREEN}[Wallet $i] Balance:${RESET} $bal SOL"
    save_info "$i" "${JSONS[$i]}" "$pk" "$bal"
  done
}

step_summary() {
  title "Summary"
  printf "${BOLD}Index  Public Key                                   Balance (SOL)${RESET}\n"
  for i in $(seq 1 "$COUNT"); do
    printf "[%02d]   %-44s %8s\n" "$i" "${PUBS[$i]}" "${BALS[$i]}"
  done
  echo -e "\n${GREEN}Done!${RESET} Wallets saved in: ${BOLD}$OUTDIR${RESET}"
}
# ----------------------------------------

# ---------------- MAIN ------------------
main() {
  trap 'echo -e "\n${YELLOW}Interrupted.${RESET}"; exit 1' INT
  mkdir -p "$OUTDIR"
  check_deps

  title "Solana Devnet Wallet Batch"

  # >>>>> Comment/uncomment the blocks you need <<<<<
  step_create_wallets      # Step 1
  step_airdrops            # Step 2
  step_balances            # Step 3
  step_summary             # Step 4
}
# ----------------------------------------

main "$@"
