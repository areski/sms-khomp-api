#!/bin/bash
#
#
# This Source Code Form is subject to the terms of the Mozilla Public 
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (C) 2011-2012 Star2Billing S.L.
# 
# The Initial Developer of the Original Code is
# Arezqui Belaid <info@star2billing.com>
#


#Include general functions
source bash-common-functions.sh

#Identify the OS
func_identify_os


#add service for socketio server
echo "Add service for sms-khomp-api server..."
cp init/sms-khomp-api /etc/init.d/sms-khomp-api
chmod +x /etc/init.d/sms-khomp-api
case $DIST in
    'DEBIAN')
        #Add Service
        cd /etc/init.d; update-rc.d sms-khomp-api defaults 99
        /etc/init.d/sms-khomp-api start
    ;;
    'CENTOS')
        #Add Service
        chkconfig --add sms-khomp-api
        chkconfig --level 2345 sms-khomp-api on
        /etc/init.d/sms-khomp-api start
    ;;
esac
