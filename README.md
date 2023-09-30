# Solar Production Forecasting using PostgresML

This project is a proof of concept for using PostgresML to forecast solar production.

## Getting Started

1. Install as per the instructions in the [PostgresML documentation](https://postgresml.org/docs/guides/setup/quick_start_with_docker)

```bash
#As documented here: https://postgresml.org/docs/guides/setup/quick_start_with_docker

# Start PostgresML
docker run \
    -v postgresml_data:/var/lib/postgresql \
    --gpus all \
    -p 5433:5432 \
    -p 8000:8000 \
    ghcr.io/postgresml/postgresml:2.7.3

```