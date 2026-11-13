#!/usr/bin/env bash
# Genera visitas a la app para que el dashboard muestre datos.
# Uso: bash generar-trafico.sh http://IP_EC2:8000 200
URL="${1:-http://localhost:8000}"
N="${2:-100}"
for i in $(seq 1 "$N"); do
  curl -s "$URL/" > /dev/null
  sleep 0.$((RANDOM % 9 + 1))
done
echo "Se enviaron $N visitas a $URL"
