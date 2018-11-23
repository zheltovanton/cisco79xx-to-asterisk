#!/bin/bash 
# 
# copstart.sh
#
# This script will install the firmware and device defaults
#
# SYNOPSIS
# copstart.sh <context> <logfile>
#
# turn it on for debug
#set x

#
# Checking parameters
#
if [ $# -lt 1 ]
then
  CONTEXT="options"
else
  CONTEXT=$1
fi
#
# Set some env variables
#
# Context will be either options (default), install or L2
#
TMPDIR=`pwd`
LOGFILE=${TMPDIR}/install.log
TFTPDIR=/usr/local/cm/tftp
LOADINFODIR=/usr/local/cm/db/loadinfo
INSTALLDB=/usr/local/cm/bin/installdb

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cm/lib
export LD_LIBRARY_PATH

#
# Copy files and change permissions
#
echo "Installing *.sgn, *.loads and load info files" > ${LOGFILE}
/bin/chmod 770 ${TMPDIR}/*.txt ${TMPDIR}/*.loads ${TMPDIR}/*.sgn

/bin/chown ctftp ${TMPDIR}/*.loads ${TMPDIR}/*.sgn
/bin/chown database ${TMPDIR}/*.txt

/bin/chgrp ccmbase ${TMPDIR}/*.txt ${TMPDIR}/*.loads ${TMPDIR}/*.sgn

/bin/cp -fp ${TMPDIR}/*.txt ${LOADINFODIR}/
/bin/cp -fp ${TMPDIR}/*.loads ${TFTPDIR}/
/bin/cp -fp ${TMPDIR}/*.sgn ${TFTPDIR}/

#
# Update the device defaults
#
echo "Updating device defaults..." >> ${LOGFILE}
echo "hardcode filenames of load txt" >> ${LOGFILE}
#load_files="`/bin/ls ${TMPDIR}/*.txt`";
load_files="load495.txt load496.txt load497.txt";

# Context equals 'L2', 'options' or 'install'
if [ ${CONTEXT} != "L2" ]
then 
  echo "Updating device defaults for non-L2" >> ${LOGFILE}
  L2_OPT=
else
  echo "Updating device defaults for L2" >> ${LOGFILE}
  L2_OPT=L2
fi
for load_file in $load_files
do
  /bin/su -l informix -s /bin/sh -c "source /usr/local/cm/db/dblenv.bash /usr/local/cm ; source /usr/local/cm/db/informix/local/ids.env ${L2_OPT}; $INSTALLDB -l ${LOADINFODIR}/$load_file" >> ${LOGFILE}
done
exit 0

