#! /bin/bash

websocat -U "ws://0.0.0.0:4001?history=no" \
  | jq "select(.tag == \"Greetings\") \
    | .snapshotUtxo \
    | with_entries(select(.value.address == \"$(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)\"))" \
  > head-utxo.json

websocat -U "ws://0.0.0.0:4001?history=no" \
  | jq "select(.tag == \"Greetings\") \
    | .snapshotUtxo \
    | with_entries(select(.value.address == \"$(cat ../plutusv3-validator/script.addr)\"))" \
  > script-head-utxo.json



LOVELACE=1000000
cardano-cli conway transaction build-raw \
  --tx-in $(jq -r 'to_entries[0].key' < script-head-utxo.json) \
  --tx-in-script-file ../plutusv3-validator/cli-plutus.json \
  --tx-in-inline-datum-present \
  --tx-in-redeemer-value 42 \
  --tx-in-execution-units "(10000000000, 14000000)" \
  --tx-in-collateral $(jq -r 'to_entries[0].key' < head-utxo.json) \
  --tx-out $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)+"${LOVELACE}" \
  --protocol-params-file ../hydra-node-plutusv3/node/protocol-parameters.json \
  --fee 0 \
  --out-file unlock-tx.json

cardano-cli conway transaction sign \
  --tx-body-file unlock-tx.json \
  --signing-key-file ../hydra-node-plutusv3/credentials/cardano-funds-1.sk \
  --out-file unlock-tx-signed.json

cat unlock-tx-signed.json | jq -c '{tag: "NewTx", transaction: { type: "Tx ConwayEra", description: "", cborHex: .cborHex}}'