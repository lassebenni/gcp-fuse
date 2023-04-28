# Variables
IMAGE_NAME := fuse
GCR_IMAGE := eu.gcr.io/lasse-benninga-sndbx-y/$(IMAGE_NAME)
TAG := latest

# Targets
.PHONY: build tag push run-gcr run-local

build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME) .

tag:
	docker tag $(IMAGE_NAME) $(GCR_IMAGE):$(TAG)

push:
	docker push $(GCR_IMAGE):$(TAG)

run-local:
	docker run --rm -v $(shell pwd)/storage:/usr/src/app/storage $(IMAGE_NAME)


run-gcr:
	docker run --rm -v $(shell pwd)/storage:/usr/src/app/storage $(GCR_IMAGE):$(TAG)

ssh-local:
	docker run \
	--privileged \
	-it \
	--rm \
	-e GOOGLE_APPLICATION_CREDENTIALS="/app/credentials.json" \
	-e BUCKET="lasse-benninga-sndbx-y-funda" \
	-e MNT_DIR=/mnt/gcs \
	-v $(shell pwd)/storage:/tmp/storage \
	-v ~/.config/gcloud/application_default_credentials.json:/app/credentials.json \
	--entrypoint bash \
	$(IMAGE_NAME)