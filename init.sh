#!/bin/bash

TOOLS_DIR=$PWD/tools

LINARO_GCC_URL=http://releases.linaro.org/14.06/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06_linux.tar.xz
LINARO_GCC_TARXZ=$TOOLS_DIR/gcc-linaro-arm-linux-gnueabihf-4.9-2014.06.tar.xz


mkdir -p $TOOLS_DIR
curl $LINARO_GCC_URL > $LINARO_GCC_TARXZ

pushd $TOOLS_DIR
tar xvJf $LINARO_GCC_TARXZ
popd


git submodule init
git submodule update

pushd tools/qemu-linaro

git submodule init
git submodule update

./configure --prefix=$PWD/build --target-list=arm-softmmu,arm-linux-user
make -j16
make install
