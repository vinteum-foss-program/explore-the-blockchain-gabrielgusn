# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
RAW_TX=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517)
DECODED_TX=$(bitcoin-cli decoderawtransaction $RAW_TX)
TXIN_PUBKEYS=$(echo $DECODED_TX | jq -c "[.vin[].txinwitness[1]]")
bitcoin-cli createmultisig 1 $TXIN_PUBKEYS | jq -r ".address"