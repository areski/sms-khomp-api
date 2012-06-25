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

INSTALL_MODE='CLONE'
INSTALL_DIR='/usr/share/sms_khomp_api'
INSTALL_ENV="sms-khomp-api"

#Include general functions
source bash-common-functions.sh

#Identify the OS
func_identify_os



#Fuction to create the virtual env
func_setup_virtualenv() {

    echo ""
    echo ""
    echo "This will install virtualenv & virtualenvwrapper"
    echo "and create a new virtualenv : $INSTALL_ENV"
    
    easy_install virtualenv
    easy_install virtualenvwrapper
    
    # Enable virtualenvwrapper
    chk=`grep "virtualenvwrapper" ~/.bashrc|wc -l`
    if [ $chk -lt 1 ] ; then
        echo "Set Virtualenvwrapper into bash"
        echo "export WORKON_HOME=/usr/share/virtualenvs" >> ~/.bashrc
        echo "source $SCRIPT_VIRTUALENVWRAPPER" >> ~/.bashrc
    fi
    
    # Setup virtualenv
    export WORKON_HOME=/usr/share/virtualenvs
    source $SCRIPT_VIRTUALENVWRAPPER

    mkvirtualenv $INSTALL_ENV
    workon $INSTALL_ENV
    
    echo "Virtualenv $INSTALL_ENV created and activated"
}


#Function to install Frontend
func_install(){

    echo ""
    echo ""
    echo "We will now install SMS-Khomp-API on your server"
	echo "================================================"
    echo ""

    #python setup tools
    echo "Install Dependencies and python modules..."
    case $DIST in
        'DEBIAN')
            apt-get -y install python-setuptools python-dev build-essential libevent-dev libapache2-mod-python libapache2-mod-wsgi git-core mercurial gawk
            easy_install pip
        ;;
        'CENTOS')
            if [ "$INSTALLMODE" = "FULL" ]; then
                yum -y update
            fi
            yum -y install autoconf automake bzip2 cpio curl curl-devel curl-devel expat-devel fileutils gcc-c++ gettext-devel gnutls-devel libjpeg-devel libogg-devel libtiff-devel libtool libvorbis-devel make ncurses-devel nmap openssl openssl-devel openssl-devel perl patch unzip wget zip zlib zlib-devel policycoreutils-python
        
            if [ ! -f /etc/yum.repos.d/rpmforge.repo ];
            	then
                	# Install RPMFORGE Repo
        			if [ $KERNELARCH = "x86_64" ]; then
						rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
					else
						rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
					fi
        	fi
        	
        	yum -y --enablerepo=rpmforge install git-core
        	
            #Install epel repo for pip and mod_python
            if [ $KERNELARCH = "x86_64" ]; then
				rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm
			else
				rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-7.noarch.rpm
			fi
			
            # disable epel repository since by default it is enabled.
            sed -i "s/enabled=1/enable=0/" /etc/yum.repos.d/epel.repo
            yum -y --enablerepo=epel install python-pip mod_python python-setuptools python-tools python-devel mercurial mod_wsgi libevent libevent-devel
        ;;
    esac

    #Create and enable virtualenv
    func_setup_virtualenv
    
    echo "Install sms-khomp-api..."
    cd /usr/src/
    rm -rf sms-khomp-api
    mkdir /var/log/sms-khomp-api

    case $INSTALL_MODE in
        'CLONE')
            git clone git://github.com/areski/sms-khomp-api.git
        ;;
    esac

    # Copy files
    cp -r /usr/src/sms-khomp-api/sms_khomp_api $INSTALL_DIR

    #Install depencencies
    easy_install -U distribute
    echo "Install requirements..."
    for line in $(cat /usr/src/sms-khomp-api/requirements.txt)
    do
        pip install $line
    done
    
    cd $INSTALL_DIR/
    
    #Fix permission on python-egg
    mkdir $INSTALL_DIR/.python-eggs
        
    
    #add service for socketio server
    echo "Add service for sms-khomp-api server..."
    cp /usr/src/sms-khomp-api/init/sms-khomp-api /etc/init.d/sms-khomp-api
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
    
    echo ""
    echo ""
    echo "********************************************************"
    echo "Congratulations, SMS-Khomp-API Server is now installed!"
    echo "********************************************************"
    echo ""
    echo "The Star2Billing Team"
    echo "http://www.star2billing.com"
    echo ""
    echo ""
}

#run Install
func_install
