GIT_VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
GIT_COMMIT=$(git rev-parse --short HEAD)
RECSYS_IMAGE="cambridgeltl/glances:${GIT_VERSION}-${GIT_COMMIT}-gpu"
sudo docker run --runtime=nvidia -h $(hostname)_glances -d -p 9091:9091 --name glances-docker $RECSYS_IMAGE