SKIP_SQUASH?=1

.PHONY: build
build:
	@@SKIP_SQUASH=$(SKIP_SQUASH) hack/build.sh
.PHONY: test
test:
	@@SKIP_SQUASH=$(SKIP_SQUASH) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true hack/build.sh

run:
	@@docker run wsweet/rgwexporter

demo:
	@@MAINDEV=`ip r | awk '/default/' | sed 's|.* dev \([^ ]*\).*|\1|'`; \
	MAINIP=`ip r | awk "/ dev $$MAINDEV .* src /" | sed 's|.* src \([^ ]*\).*$$|\1|'`; \
	docker run -e RADOSGW_HOST=$$MAINIP -p 9113:9113 wsweet/rgwexporter

.PHONY: ocbuild
ocbuild: occheck
	oc process -f openshift/imagestream.yaml -p FRONTNAME=wsweet | oc apply -f-
	BRANCH=`git rev-parse --abbrev-ref HEAD`; \
	if test "$$GIT_DEPLOYMENT_TOKEN"; then \
	    oc process -f openshift/build-with-secret.yaml \
		-p "FRONTNAME=wsweet" \
		-p "GIT_DEPLOYMENT_TOKEN=$$GIT_DEPLOYMENT_TOKEN" \
		-p "RADOSGW_EXPORTER_REPOSITORY_REF=$$BRANCH" \
		| oc apply -f-; \
	else \
	    oc process -f openshift/build.yaml \
		-p "FRONTNAME=wsweet" \
		-p "RADOSGW_EXPORTER_REPOSITORY_REF=$$BRANCH" \
		| oc apply -f-; \
	fi

.PHONY: occheck
occheck:
	oc whoami >/dev/null 2>&1 || exit 42

.PHONY: ocpurge
ocpurge:
	oc process -f openshift/build.yaml -p FRONTNAME=wsweet | oc delete -f- || true
	oc process -f openshift/imagestream.yaml -p FRONTNAME=wsweet | oc delete -f- || true
