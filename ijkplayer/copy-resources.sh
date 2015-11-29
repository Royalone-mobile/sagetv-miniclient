#!/bin/sh

VERSION=0.4.3.5
OUTPUT=release
ARCHES="arm64 armv7a x86 java exo"

if [ "$ANDROID_SDK" == "" ] ; then
   echo "ANDROID_SDK needs to be set"
   exit 1
fi


echo "BUILDING NATIVES..."
cd ijkplayer/android/
./compile-ijk.sh all
cd -

export ANDROID_HOME=$ANDROID_SDK

echo "PACKAGING..."
cd ijkplayer/android/ijkplayer/
cp build.gradle build.gradle.orig
cat build.gradle.orig | sed 's/23.0.0/23.0.1/g' > build.gradle
./gradlew assemble
cd -

echo "COPYING..."
for ARCH in $ARCHES; do
   echo "COPY ARCH: $ARCH"
   mkdir -p ../android/mavenlocal/sagetv/ijkplayer/ijkplayer-${ARCH}/${VERSION}/
   cp -fv ijkplayer/android/ijkplayer/ijkplayer-${ARCH}/build/outputs/aar/ijkplayer-${ARCH}-${OUTPUT}.aar ../android/mavenlocal/sagetv/ijkplayer/ijkplayer-${ARCH}/${VERSION}/ijkplayer-${ARCH}-${VERSION}.aar
done

#echo "REMOVING CACHES..."
#find ~/.gradle/caches/ -iname 'ijk*' -exec rm -rfv {} \;

