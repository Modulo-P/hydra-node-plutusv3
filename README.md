# Hydra platform compatible with PlutusV3

This repo contains a docker compose setup with:

- 2x Hydra node which has Conway support
- Cardano Node version 8.9.0 connected to Sanchonet

## Configuration

You'll need to setup some credentials in the folder `/hydra-node-plutusv3/credentials`. You'll need to set up cardano-funds-1, cardano-funds-2, hydra-node-1 and hydra-node-2 keys. This tutorial has all the necessary steps to generate the sk, vk and addr files URL: [Quickstart](https://hydra.family/head-protocol/docs/getting-started/quickstart). 

You can use Mithril to download the latest snapshot. Follow this tutorial [Bootstrap a Cardano node from a testnet Mithril snapshot](https://mithril.network/doc/manual/getting-started/bootstrap-cardano-node#step-3-show-snapshot-details)

## Run

It's recommended to execute first the node and let it to synchronize. 

```bash
$ cd hydra-node-plutusv3
$ docker compose up -d cardano-node
```

You can see the Cardano node logs:

```bash
$ docker compose logs -f cardano-node
```

Once the node is synchronized, you can run all the solution:

```bash
$ docker compose up -d
```

Check if the hydra nodes are running:

```bash
$ docker compose logs -f hydra-node-1 hydra-node-2
```

