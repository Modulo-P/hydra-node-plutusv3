websocat -U "ws://0.0.0.0:4001?history=no" \
  | jq "select(.tag == \"Greetings\") \
    | .snapshotUtxo \
    | with_entries(select(.value.address == \"$(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)\"))" \
  > head-utxo.json

LOVELACE=1000000
cardano-cli conway transaction build-raw \
  --tx-in $(jq -r 'to_entries[0].key' < head-utxo.json) \
  --tx-out $(cat ../plutusv3-validator/script.addr)+${LOVELACE} \
  --tx-out-inline-datum-value {} \
  --tx-out $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)+$(jq "to_entries[0].value.value.lovelace - ${LOVELACE}" < head-utxo.json) \
  --fee 0 \
  --out-file tx.json


cardano-cli conway transaction sign \
  --tx-body-file tx.json \
  --signing-key-file ../hydra-node-plutusv3/credentials/cardano-funds-1.sk \
  --out-file tx-signed.json

cat tx-signed.json | jq -c '{tag: "NewTx", transaction: .cborHex}'
