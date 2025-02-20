# Copyright (c) 2024 innodisk Crop.
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

RM = rm -rf

CURRENT_DIR = $(shell pwd)
VERSION = 0.0.1
HOST_TYPE = $(shell uname -m)
TARGET := arm
PKGNAME = accelbrain-$(TARGET)
IPK = $(PKGNAME).ipk

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make all'
	@echo '  make data'
	@echo '  make clean'
	@echo ''

.PHONY: all
all: $(IPK)

.PHONY: images
images:
	make all -C ollama
	make all -C open-webui

.PHONY: data
data: images
	@mkdir -p data
	@sed -i s/@@VERSION@@/$(VERSION)/g 		CONTROL/control
	@sed -i s/@@TARGET@@/$(TARGET)/g 		CONTROL/control
	@mkdir -p data/opt/innodisk/accelbrain
	@cp ollama/ollama.tar					data/opt/innodisk/accelbrain/
	@cp open-webui/open-webui.tar			data/opt/innodisk/accelbrain/
	@mkdir -p data/usr/share/container-images/
	@cp system_service/docker-compose.yml	data/usr/share/container-images/
	@mkdir -p data/etc/systemd/system
	@cp system_service/accel-brain.service	data/etc/systemd/system/accel-brain.service
	@chmod 644 data/etc/systemd/system/accel-brain.service
	@mkdir -p data/usr/bin/
	@cp system_service/mount-noauto.sh		data/usr/bin/mount-noauto
	@chmod 755 data/usr/bin/mount-noauto
	@cp system_service/mount-noauto.service	data/etc/systemd/system/mount-noauto.service
	@chmod 644 data/etc/systemd/system/mount-noauto.service

.PHONY: $(IPK)
$(IPK): data
	tar --numeric-owner --owner=0 --group=0 -cvzf control.tar.gz CONTROL
	tar --numeric-owner --owner=0 --group=0 -cvzf data.tar.gz data
	tar -I pigz -cf data.tar.gz data
	@echo $(VERSION) > debian-binary
	ar rcs $(IPK) debian-binary control.tar.gz data.tar.gz

.PHONY: clean
clean:
	-@$(RM) ollama/*.tar open-webui/*.tar *.tar.gz *.ipk data