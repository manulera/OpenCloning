ARG FRONTEND_TAG="prod"
ARG BACKEND_TAG="prod"

FROM manulera/opencloningfrontend:${FRONTEND_TAG} AS frontend

FROM manulera/opencloningbackend:${BACKEND_TAG} AS backend
WORKDIR /home/backend
COPY --from=frontend /build ./frontend

USER backend

ENV SERVE_FRONTEND=1
ENV BACKEND_URL="/"
ENV SHOW_APP_BAR=true
ENV NO_EXTERNAL_REQUESTS=false
ENV ENABLE_PLANNOTATE=false
ENV ENABLE_ASSEMBLER=false

ARG OPENCLONING_VERSION=""
ENV OPENCLONING_VERSION=${OPENCLONING_VERSION}

CMD ["bash", "docker_entrypoint.sh"]
