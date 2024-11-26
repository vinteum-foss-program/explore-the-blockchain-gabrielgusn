# Only one single output remains unspent from block 123,321. What address was it sent to?
#!/bin/bash

BLOCK_HEIGHT=123321

BLOCK=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $BLOCK_HEIGHT) | jq -r '.tx')

for TXID in $(echo "$BLOCK" | jq -r '.[]'); do

  TX_DETAILS=$(bitcoin-cli decoderawtransaction $(bitcoin-cli getrawtransaction "$TXID"))
  TX_VOUT_AMOUNT=$(echo $TX_DETAILS | jq .vout | jq length)

  for (( i=0; i<TX_VOUT_AMOUNT; i++)); do
    UNSPENT_OUTPUT=$(bitcoin-cli gettxout "$TXID" $i)
    [[ -n "$UNSPENT_OUTPUT" ]] && echo $(echo $UNSPENT_OUTPUT | jq -r '.scriptPubKey.address') && break

  done


done