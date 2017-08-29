### Installs the framework for Typhoon motion estimator compilation ###
#######################################################################
#
# Warning:
#   - this framework does not handle the CUDA-accelerated versions.
#   - screen display is not handled at the moment (needs X11 forwarding or VNC setup)
#
# Setup:
#   1. create Docker image:
#       docker build -t typhoon .
#   2. run container, mounting Typhoon sources as a volume:
#       docker run -v /path/to/src:/src -t -i typhoon /bin/bash
#   3. cmake then make.
#
# Notes:
#   - blas, lapack, fftw, tiff are in /usr/include/, /usr/lib/.
#   - lbfgs should be by default in /usr/local/include, /usr/local/lib.
#
FROM ubuntu:latest
MAINTAINER Pierre Derian, contact@pierrederian.net, www.pierrederian.net

### Note on user packages:
# nano, python2.7 are not mandatory but useful when we have to work in the container
ENV PACKAGES="make cmake g++ wget tar" \
    PACKAGES_CIMG="libx11-dev libfftw3-dev libtiff5-dev libblas-dev imagemagick" \
    PACKAGES_TYPHOON="liblapack-dev" \
    PACKAGES_USER="nano python2.7"

### first update then install the main packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES} ${PACKAGES_CIMG} ${PACKAGES_TYPHOON} ${PACKAGES_USER}

### download and install liblbfgs
RUN cd /tmp; wget --no-check-certificate https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz && \
    tar -xvf liblbfgs-1.10.tar.gz && \
    cd liblbfgs-1.10; ./configure; make; make install; cd /
ENV LD_LIBRARY_PATH=/usr/local/lib

### at this point Typhoon can be compiled (CUDA accelerated versions will be ignored)
