ARG NSENTER_REPO=git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
ARG NSENTER_VERSION=HEAD
ARG ALPINE_VERSION=latest

FROM --platform=${BUILDPLATFORM} tonistiigi/xx AS xx

FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS build
COPY --from=xx / /
RUN apk add --no-cache git clang lld libtool autoconf bison gettext-dev automake pkgconfig make binutils
ARG NSENTER_REPO
ARG NSENTER_VERSION
WORKDIR /work
RUN git clone ${NSENTER_REPO} && \
	cd util-linux && git checkout "${NSENTER_VERSION}"
WORKDIR util-linux

ARG TARGETPLATFORM
RUN xx-apk add --no-cache gcc musl-dev linux-headers gettext-static
ARG NSENTER_LDFLAGS=-Wl,-s
RUN export CC=$(xx-clang --print-target-triple)-clang LDFLAGS="${NSENTER_LDFLAGS}" && ./autogen.sh \
	&& ./configure --enable-static-programs=nsenter --host=$(xx-clang --print-target-triple) \
	&& make -j $(nproc) nsenter.static \
	&& xx-verify --static nsenter.static && \
	mkdir /out && cp -a nsenter.static /out && make clean

FROM scratch
COPY --from=build /out/nsenter.static /nsenter
ENTRYPOINT ["/nsenter"]
CMD ["-t", "1", "-m", "-n", "-i", "-u", "sh"]
