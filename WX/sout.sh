#!/usr/bin/env bash
# =====================================================================
# Solana Devnet Wallet Batch (Latest CLI Usage)
# - Generates N wallets
# - Airdrops SOL to each
# - Checks balances
# - Backups each in a simple text summary beside JSON keypair
# Author: You
# =====================================================================

set -euo pipefail

# ---------- CONFIGURATION ----------
COUNT=10
AIRDROP_SOL=1
RPC_URL="https://api.devnet.solana.com"
OUTDIR="${PWD}/solana_devnet_wallets_$(date +%Y%m%d_%H%M%S)"
RETRIES=6
SLEEP_BETWEEN=2
# -----------------------------------

# ---------- COLORS ----------
if [[ -t 1 ]]; then
  BOLD='\e[1m'; DIM='\e[2m'; RESET='\e[0m'
  RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m'; BLUE='\e[34m'; MAGENTA='\e[35m'; CYAN='\e[36m'
else
  BOLD=''; DIM=''; RESET=''; RED=''; GREEN=''; YELLOW=''; BLUE=''; MAGENTA=''; CYAN=''
fi
bar() { printf "${DIM}──────────────────────────────────────────────────────────────────────${RESET}\n"; }
title() { bar; printf "${BOLD}${CYAN}%s${RESET}\n" "$1"; bar; }
# -----------------------------------

# ---------- DEPENDENCY CHECK ----------
command -v solana >/dev/null 2>&1 || { echo -e "${RED}Error:${RESET} 'solana' CLI not found."; exit 1; }
command -v solana-keygen >/dev/null 2>&1 || { echo -e "${RED}Error:${RESET} 'solana-keygen' not found."; exit 1; }
# -------------------------------------

# ---------- FUNCTION DEFINITIONS ----------

# Create a new wallet, returns JSON path and pubkey
create_wallet() {
  local idx=$1
  local json="${OUTDIR}/wallet_${idx}.json"
  solana-keygen new --no-bip39-passphrase --silent --outfile "$json"
  local pk=$(solana-keygen pubkey "$json")
  echo "$json|$pk"
}

# Airdrop SOL (latest CLI usage)
airdrop_to() {
  local pk=$1
  solana airdrop "$AIRDROP_SOL" "$pk" --url "$RPC_URL" >/dev/null
}

# Get wallet balance (in SOL)
get_balance() {
  local pk=$1
  solana balance "$pk" --url "$RPC_URL" | awk '{print $1}'
}

# Airdrop with retries until balance >= target
airdrop_with_retry() {
  local pk=$1
  for i in $(seq 1 "$RETRIES"); do
    airdrop_to "$pk"
    sleep "$SLEEP_BETWEEN"
    local bal=$(get_balance "$pk" || echo "0")
    if awk "BEGIN{exit !($bal+0 >= $AIRDROP_SOL)}"; then
      echo "$bal"
      return
    fi
    echo "Retry $i/$RETRIES..."
  done
  get_balance "$pk" || echo "0"
}

# Save summary to .txt file
save_summary() {
  local idx=$1 json=$2 pk=$3 bal=$4
  local txt="${OUTDIR}/wallet_${idx}.txt"
  cat > "$txt" <<EOF
Wallet #$idx
Public Key   : $pk
Keypair JSON : $json
Balance      : $bal SOL
EOF
}

# Print final summary
print_summary() {
  local -n pks=$1 bals=$2
  title "Summary"
  printf "${BOLD}Index  Public Key                                     Balance (SOL)${RESET}\n"
  for i in "${!pks[@]}"; do
    printf "[%02d]   %-44s %8s\n" $((i+1)) "${pks[$i]}" "${bals[$i]}"
  done
  echo -e "\n${GREEN}Completed.${RESET} Wallets stored in $OUTDIR"
}

# --------------------------------------------

# ---------- MAIN EXECUTION ----------
mkdir -p "$OUTDIR"
title "Solana Devnet Batch | $COUNT wallets | $AIRDROP_SOL SOL each"
echo "Output directory: $OUTDIR"
echo "RPC Endpoint   : $RPC_URL"
echo

declare -a PUBS BAL

for i in $(seq 1 "$COUNT"); do
  result=$(create_wallet "$i")
  json="${result%%|*}"; pk="${result##*|}"
  echo -e "${BLUE}[Wallet $i]${RESET} Created: $pk"

  bal=$(airdrop_with_retry "$pk")
  echo -e "${GREEN}  Final Balance: ${bal} SOL${RESET}"

  save_summary "$i" "$json" "$pk" "$bal"

  PUBS+=("$pk"); BAL+=("$bal")
  bar
done

print_summary PUBS BAL
# --------------------------------------------
