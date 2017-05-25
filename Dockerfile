ARG NSENTER_VERSION=v2.29.2

FROM buildpack-deps:jessie AS build-env
RUN apt-get update && apt-get install -y gettext bison
WORKDIR /usr/local/src
RUN git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
WORKDIR ./util-linux
ARG NSENTER_VERSION
RUN git checkout $NSENTER_VERSION \
  && ./autogen.sh \
	&& ./configure --enable-static-programs=nsenter \
	&& make nsenter.static

FROM scratch
COPY --from=build-env /usr/local/src/util-linux/nsenter.static /nsenter
ENTRYPOINT ["/nsenter"]