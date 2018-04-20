#!/bin/bash

VER=${VER:=4.4.3}
ITER=${ITER:=1}
UPL=${UPL:=0} # Disable Repo upload by default

APP_ZIP="AppServerAgent-"${VER}"*.zip"
MAC_ZIP="MachineAgent-"${VER}"*.zip"

if ! ls /mnt/${APP_ZIP} &> /dev/null
then
	echo "AppServerAgent zip file ${APP_ZIP} is NOT present in /mnt"
	exit 1
fi

if ! ls /mnt/${MAC_ZIP} &> /dev/null
then
	echo "MachineAgent  zip file ${MAC_ZIP} is NOT present in /mnt"
	exit 1
fi

MAC_VERS=`cd /mnt && ls -1 $MAC_ZIP`
APP_VERS=`cd /mnt && ls -1 $APP_ZIP`
TMP_DIR="/tmp/appd/opt/appdynamics"
mkdir -p ${TMP_DIR}
mkdir -p ${TMP_DIR}/appserveragent
mkdir -p ${TMP_DIR}/machineagent
cp /mnt/${APP_ZIP} ${TMP_DIR}
cp /mnt/${MAC_ZIP} ${TMP_DIR}
cd ${TMP_DIR}/appserveragent
unzip -q ../${APP_ZIP}
rm -rf conf
dname=`ls -1d ver${VER}*`
if [[ "${dname}" != "ver${VER}" ]]
then
	echo "Creating symlink"
	ln -s ${dname} ver${VER}
fi
cd ${TMP_DIR}/machineagent
unzip -q ../${MAC_ZIP}
rm ${TMP_DIR}/*.zip

cd /root
source /etc/profile.d/rvm.sh
fpm -s dir -t rpm -C /tmp/appd --name appd --version ${VER} --iteration ${ITER} --before-install /root/preinstall --url "http://www.appdynamics.com/" --description "Repackaged AppDynamics AppServerAgent: ${APP_VERS} & MachineAgent: ${MAC_VERS} into a single RPM" 

RPM_FILE=appd-${VER}-${ITER}.x86_64.rpm 
if [[ $? -eq 0 && -f ${RPM_FILE} ]]
then
        echo "RPM built!!"
        ls -lh /root/${RPM_FILE}
        echo " ======   md5sum   ======="; echo;
        md5sum /root/${RPM_FILE}
        cp /root/${RPM_FILE} /mnt/
        if [[ ${UPL} -eq 1 ]]
        then
            curl -F "r=${REPO}" -F "g=com.appdynamics" -F "a=appd" -F "v=${VER}" -F "p=rpm" -F "e=rpm" -F "file=@./${RPM_FILE}" -u ${USER_PASS} http://${NEXUS_HOST}/service/local/artifact/maven/content
        fi
        exit 0
else
        echo "Failed to build RPM"
        exit 1
fi
