#!/bin/bash

usage () {
cat << EOF
Usage: fetch-cardano-cfg.sh [options] environment

environments:
 mainnet
 preprod
 preview
 all

Options:
  -h, --help                Show this help text
EOF
}

if ! OPTS=$(getopt -o h --long help -n "fetch-cardano-cfg.sh" -- "$@"); then
  exit 1
fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help)
      HELP=
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Internal error!" >&2
      exit 1
      ;;
  esac
done

if [[ ${HELP+DEFINED} ]]; then
  usage
  exit 1
fi

if [[ "$#" -eq 0 ||  -z "$1" ]]; then
  echo "Missing required argument environment!" >&2
  exit 1
else
  ENV=$1
fi

case $ENV in
  mainnet|preprod|preview)
    ENVS=( "$ENV" )
    ;;
  all)
    ENVS=(mainnet preprod preview)
    ;;
  *)
    echo "Invalid environment: '$ENV'" >&2
    exit 1
esac

CFG_FILES=(\
  config.json \
  config-bp.json \
  db-sync-config.json \
  submit-api-config.json \
  topology-genesis-mode.json \
  topology.json \
  peer-snapshot.json \
  byron-genesis.json \
  shelley-genesis.json \
  alonzo-genesis.json \
  conway-genesis.json \
  guardrails-script.plutus \
)

for env in "${ENVS[@]}"; do
  mkdir -p "$env"

  for file in "${CFG_FILES[@]}"; do
    wget --directory-prefix "$env" "https://book.world.dev.cardano.org/environments/${env}/${file}"
  done
done
