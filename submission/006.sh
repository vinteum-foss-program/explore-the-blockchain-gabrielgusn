# Which tx in block 257,343 spends the coinbase output of block 256,128?
# BLOCK=$(bitcoin-cli getblock $(bitcoin-cli getblockhash 256128))
# BLOCK_TXS=$(echo $BLOCK | jq .tx)
# for tx in $(echo $BLOCK_TXS | jq -r '.[]'); do
#     TRANSACTION=$(bitcoin-cli decoderawtransaction $(bitcoin-cli getrawtransaction $tx))
#     if echo $TRANSACTION | jq 'select(.vin | map(select(.coinbase != null)) | length > 0) | .' > /dev/null; then
#         COINBASE_TX=$tx
#         break
#     fi
# done

COINBASE_TX=611c5a0972d28e421a2308cb2a2adb8f369bb003b96eb04a3ec781bf295b74bc

BLOCK_2=$(bitcoin-cli getblock $(bitcoin-cli getblockhash 257343))
BLOCK_2_TXS=$(echo $BLOCK_2 | jq -r '.tx')
for tx in $(echo $BLOCK_2_TXS | jq -r '.[]'); do
    RAW_TX=$(bitcoin-cli decoderawtransaction $(bitcoin-cli getrawtransaction $tx))
   
    MATCH=$(echo "$RAW_TX" | jq --arg COINBASE_TX "$COINBASE_TX" '.vin[] | select(.txid == $COINBASE_TX)')
    if [ -n "$MATCH" ]; then
        echo $tx
        exit 0
    fi
done
