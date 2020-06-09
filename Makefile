RELEASE_TAG := v$(shell date +%Y%m%d-%H%M%S-%3N)

build:
	docker build -t galexrt/ts3server:latest .

release:
	git tag $(RELEASE_TAG)
	git push origin $(RELEASE_TAG)

release-and-build: build
	git tag $(RELEASE_TAG)
	docker tag galexrt/ts3server:latest galexrt/ts3server:$(RELEASE_TAG)
	git push origin $(RELEASE_TAG)
	docker push galexrt/ts3server:$(RELEASE_TAG)
	docker push galexrt/ts3server:latest
