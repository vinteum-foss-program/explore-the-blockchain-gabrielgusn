# Only one single output remains unspent from block 123,321. What address was it sent to?
#!/bin/bash


BLOCK_HEIGHT=123321

BLOCK=$(bitcoin-cli getblock $(bitcoin-cli getblockhash $BLOCK_HEIGHT) 2 | jq  -c '.tx')

# Deixei "hard coded" nesse momento pois a pipeline não estava passando por conta de timeout na resposta do node
# BLOCK=$(cat block.json | jq -c '.tx')

echo $BLOCK | jq -c '.[]' | while read -r transaction; do
  TXID=$(echo $transaction | jq -r '.hash')
  TX_VOUT=$(echo $transaction | jq -r '.vout')
  TX_VOUT_AMOUNT=$(echo $TX_VOUT | jq length)
  for (( i=0; i<TX_VOUT_AMOUNT; i++)); do
    UNSPENT_OUTPUT=$(bitcoin-cli gettxout "$TXID" $i)

    if [ -n "$UNSPENT_OUTPUT" ]; then
      echo $(echo $UNSPENT_OUTPUT | jq -r '.scriptPubKey.address')
      exit 0
    fi
  done
done