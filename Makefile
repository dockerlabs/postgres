#!make
.DEFAULT_GOAL=build

VERSIONS = $(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%))

build: $(VERSIONS)

define postgis-version
$1:
	docker build -t dockerlabs/postgres:$(shell echo $1 | sed -e 's/-.*//g') $1
endef
$(foreach version,$(VERSIONS),$(eval $(call postgis-version,$(version))))

.PHONY: build $(VERSIONS)
