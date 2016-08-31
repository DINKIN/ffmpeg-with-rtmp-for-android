#!/bin/bash
NDK=/usr/local/ndk 
SYSROOT=$NDK/platforms/android-19/arch-arm/ 
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 

OPENSSL_DIR=/usr/local/src/ffmpeg/openssl-android/ 
LIBRTMP_DIR=/usr/local/src/ffmpeg/rtmpdump/librtmp/
# Note: Change above variables to match your system
function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-librtmp \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --disable-programs \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make -j8
make install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm -I${OPENSSL_DIR}include -I${LIBRTMP_DIR}android/arm/include -L${LIBRTMP_DIR}android/arm/lib -lrtmp"
ADDI_LFLAGS="-L${OPENSSL_DIR}libs/armeabi -L${LIBRTMP_DIR}android/arm/lib -lrtmp" 
#-L${SYSROOT}usr/lib"
build_one
