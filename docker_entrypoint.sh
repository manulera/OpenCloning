set -e
echo "ROOT_PATH: ${ROOT_PATH}"
echo "BACKEND_URL: ${BACKEND_URL}"
cd frontend
# Create config.json with env vars
echo "Generating config.json"
envsubst < config.env.json > config.json
echo "------------------------------------"
cat config.json
echo ""
echo "------------------------------------"
cd ..


if [ "$USE_HTTPS" = "true" ]; then
    echo "Using HTTPS"
    if [ ! -f "/certs/key.pem" ] || [ ! -f "/certs/cert.pem" ] || [ ! -r "/certs/key.pem" ] || [ ! -r "/certs/cert.pem" ]; then
        echo "Error: TLS certificate files /certs/key.pem and /certs/cert.pem must both exist and be readable"
        exit 1
    fi
    uvicorn opencloning.main:app --host 0.0.0.0 --port 8000 --ssl-keyfile /certs/key.pem --ssl-certfile /certs/cert.pem ${ROOT_PATH:+--root-path ${ROOT_PATH}}
else
    echo "Using HTTP"
    uvicorn opencloning.main:app --host 0.0.0.0 --port 8000 ${ROOT_PATH:+--root-path ${ROOT_PATH}}
fi
