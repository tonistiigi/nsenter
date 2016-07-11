from buildpack-deps:jessie
run apt-get update && apt-get install -y gettext
run git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
workdir ./util-linux
run ./autogen.sh && ./configure --enable-static-programs=nsenter && make nsenter.static
add Dockerfile .