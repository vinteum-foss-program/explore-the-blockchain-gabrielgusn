# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
TRANSACTION=$(bitcoin-cli decoderawtransaction $(bitcoin-cli getrawtransaction "e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"))
TX_INPUT=$(echo $TRANSACTION | jq -r '.vin[0]')
INPUT_WITNESS=$(echo $TX_INPUT | jq .txinwitness)
WITNESS_SCRIPT=$(echo $INPUT_WITNESS | jq -r '.[-1]')

INPUT_PUBKEY=$(bitcoin-cli decodescript $WITNESS_SCRIPT | jq -r ".asm" | awk '{print $2}')

echo $INPUT_PUBKEY