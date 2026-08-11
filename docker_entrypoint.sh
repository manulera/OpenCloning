# APP_TARGET: which app to run — must be exactly one of:
#   cloning  -> opencloning.main:app
#   db       -> opencloning_db.combined:app
#
# GUNICORN_WORKERS: Gunicorn worker processes (default: 2).
# GUNICORN_TIMEOUT: the timeout for each worker process (default: 20).

case "${APP_TARGET}" in
    cloning) APP_MODULE=opencloning.main ;;
    db) APP_MODULE=opencloning_db.combined ;;
    *)
        echo "Error: APP_TARGET must be cloning or db" >&2
        exit 1
        ;;
esac

echo "GUNICORN_WORKERS: $GUNICORN_WORKERS"
echo "APP_MODULE: $APP_MODULE"

GUNICORN_ARGS=(
    -k uvicorn.workers.UvicornWorker
    -w "${GUNICORN_WORKERS:-2}"
    --bind 0.0.0.0:8000
    --timeout "${GUNICORN_TIMEOUT:-20}"
    --access-logfile -
    --error-logfile -
    --no-control-socket
    "${APP_MODULE}:app"
)

if [ "$USE_HTTPS" = "true" ]; then
    echo "Using HTTPS"
    if [ ! -f "/certs/key.pem" ] || [ ! -f "/certs/cert.pem" ] || [ ! -r "/certs/key.pem" ] || [ ! -r "/certs/cert.pem" ]; then
        echo "Error: TLS certificate files /certs/key.pem and /certs/cert.pem must both exist and be readable"
        exit 1
    fi
    exec gunicorn "${GUNICORN_ARGS[@]}" --keyfile /certs/key.pem --certfile /certs/cert.pem
else
    echo "Using HTTP"
    exec gunicorn "${GUNICORN_ARGS[@]}"
fi
