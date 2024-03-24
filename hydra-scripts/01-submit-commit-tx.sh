#! /bin/bash

cardano-cli transaction submit --tx-file cardano-funds-1-commit-tx-signed.json

curl -X POST 127.0.0.1:4002/commit --data "{}" > cardano-node-2-commit-tx.json
cardano-cli transaction submit --tx-file cardano-node-2-commit-tx.json