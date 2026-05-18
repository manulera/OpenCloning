docker pull manulera/opencloningbackend:local
docker pull manulera/opencloningfrontend:prod-baseurl-opencloning
docker build --build-arg BACKEND_TAG=local --build-arg FRONTEND_TAG=prod-baseurl-opencloning -t manulera/opencloning:local .