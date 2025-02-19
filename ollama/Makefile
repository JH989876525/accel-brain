# Copyright (c) 2024 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

RM = rm -rf

VERSION = latest
IMAGE_NAME = ollama
HOST_TYPE = $(shell uname -m)
TARGET := arm

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make all'
	@echo '  make image'
	@echo '  make clean'
	@echo ''

.PHONY: all
all: image

.PHONY: image
image: $(IMAGE_NAME).tar
$(IMAGE_NAME).tar:
ifeq ($(TARGET),x86)
	@docker buildx build --platform linux/amd64 \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--output type=docker,dest=$(IMAGE_NAME).tar \
		-t ollama/ollama:$(VERSION) .
else
ifeq ($(HOST_TYPE),aarch64)
	@docker build -t ollama/ollama:$(VERSION) .
	@docker save -o $(IMAGE_NAME).tar ollama/ollama:$(VERSION)
else
	@docker buildx build --platform linux/arm64 \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--output type=docker,dest=$(IMAGE_NAME).tar \
		-t ollama/ollama:$(VERSION) .
endif
endif
	@chmod 666 $(IMAGE_NAME).tar


.PHONY: clean
clean:
	-@$(RM) $(IMAGE_NAME).tar