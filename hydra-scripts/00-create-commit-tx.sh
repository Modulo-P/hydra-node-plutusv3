#! /bin/bash -i
LOVELACE=1000000

echo "Put some funds in the address: $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)"

cardano-cli query utxo \
  --address $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr) \
  --output-json \
  --testnet-magic 4 > cardano-funds-1-commit-utxo.json

cat cardano-funds-1-commit-utxo.json | \
  jq "with_entries(select(.value.value.lovelace != ${LOVELACE}))" \
  > cardano-funds-1-commit-utxo-filtered.json

curl -X POST 127.0.0.1:4001/commit \
  --data @cardano-funds-1-commit-utxo-filtered.json \
  > cardano-funds-1-commit-tx.json

cardano-cli transaction sign \
  --tx-file cardano-funds-1-commit-tx.json \
  --signing-key-file ../hydra-node-plutusv3/credentials/cardano-funds-1.sk \
  --out-file cardano-funds-1-commit-tx-signed.json