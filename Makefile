image: builder
	docker run --rm nsenter:builder tar -cvf - nsenter.static Dockerfile | docker build -t nsenter -
	
builder:
	docker build -t nsenter:builder -f Dockerfile.builder .
	
.PHONY: image builder