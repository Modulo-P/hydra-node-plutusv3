#! /bin/bash -i

echo "Put some funds in the address: $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr)"

cardano-cli query utxo \
  --address $(cat ../hydra-node-plutusv3/credentials/cardano-funds-1.addr) \
  --output-json \
  --testnet-magic 4 > cardano-funds-1-commit-utxo.json

curl -X POST 127.0.0.1:4001/commit \
  --data @cardano-funds-1-commit-utxo.json \
  > cardano-funds-1-commit-tx.json

cardano-cli transaction sign \
  --tx-file cardano-funds-1-commit-tx.json \
  --signing-key-file ../hydra-node-plutusv3/credentials/cardano-funds-1.sk \
  --out-file cardano-funds-1-commit-tx-signed.json