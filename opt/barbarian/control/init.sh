#!/bin/mksh

if [[ -z "${GLIBC_REPO}" ]]
then
	GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
fi

if [[ -z "${GLIBC_VERSION}" ]]
then
	GLIBC_VERSION=2.28-r0
fi

if [[ -z "${JAVA8_DOWNLOAD}" ]]
then
	JAVA8_DOWNLOAD=https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u181-b13/jdk-8u181-ojdkbuild-linux-x64.zip
fi

if [[ -z "${JAVA_INSTALL_VERSION}" ]]
then
	JAVA_INSTALL_VERSION=jdk-8u181-ojdkbuild-linux-x64
fi

PYTHON=/opt/python27/bin/python
DOWNLOADER=/opt/barbarian/control/download.py
UNTAR=/opt/barbarian/control/untar.py
UNZIP=/opt/barbarian/control/unzip.py
PIP_INSTALLER=/opt/python27/get-pip.py
PIP=/opt/python27/bin/pip
JAVA_INSTALL_DIR=/opt/java8

$PYTHON $PIP_INSTALLER
$PIP install urllib3

for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}
do 
	$PYTHON $DOWNLOADER -u ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -t /tmp/${pkg}.apk
done

#todo: MUST be a zip file currently, but the script *could* detect the filetype
$PYTHON $DOWNLOADER -u $JAVA8_DOWNLOAD -t /tmp/jdk.zip

mkdir -p $JAVA_INSTALL_DIR

$PYTHON $UNZIP -t /tmp/jdk.zip -o $JAVA_INSTALL_DIR

for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}
do 
	$PYTHON $UNTAR /tmp/${pkg}.apk
done

#todo: fails currently
#/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 

mkdir -p /etc/profile.d
echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh

/usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

chmod +x $JAVA_INSTALL_DIR/$JAVA_INSTALL_VERSION/jre/bin/java
