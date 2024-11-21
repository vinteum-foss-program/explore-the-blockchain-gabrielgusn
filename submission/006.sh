# Which tx in block 257,343 spends the coinbase output of block 256,128?
BLOCK=$(bitcoin-cli getblock $(bitcoin-cli getblockhash 256128))
BLOCK_TXS=$(echo $BLOCK | jq .tx)
for tx in $(echo $BLOCK_TXS | jq -r '.[]'); do
    TRANSACTION=$(bitcoin-cli decoderawtransaction $(bitcoin-cli getrawtransaction $tx))
    if echo $TRANSACTION | jq 'select(.vin | map(select(.coinbase != null)) | length > 0) | .' > /dev/null; then
        COINBASE_TX=$tx
        break
    fi
done

