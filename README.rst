
SMS-KHOMP-API
=============

HTTP API Gateway for KHOMP SMS

The initial Author is Arezqui Belaid <areski@gmail.com>


Requirements
------------

This Application is build using Flask and Gevent :

* Flask : http://flask.pocoo.org/

* Gevent : http://www.gevent.org/


This application communicate with FreeSWITCH (http://freeswitch.org) in order to send SMS and retrieve their status.

You will need to compile Python ESL, this can be achieved with the following command on your FreeSWITCH box::

    apt-get install python-dev
    cd /usr/src/freeswitch/libs/esl
    make pymod-install


Usage
-----

You can find documentation about the API provided by accessing :
http://0.0.0.0:5000/v1.0/documentation

API Send SMS - http://127.0.0.1:5000/v1.0/sendsms

Parameters::

    @ recipient : Phone Number of the person receving the SMS
    @ message : Message content to be send on the SMS
    @ interface : Set the interface to use to send the SMS, default b0"


Test with CURL::

    curl --dump-header -X POST --data 'recipient=650234300&message="Hello and welcome to my world!&interface=b0' http://0.0.0.0:5000/v1.0/sendsms

    or without interface,

    curl --dump-header -X POST --data 'recipient=650234300&message="Hello' http://0.0.0.0:5000/v1.0/sendsms


Stress Test
-----------

Use ab, the Apache HTTP server benchmarking tool

Usage::

    ab -c 100 -n 1000 -p test/post.txt -T application/x-www-form-urlencoded http://0.0.0.0:5000/v1.0/sendsms


Coding Conventions
------------------

This project is PEP8 compilant and please refer to these sources for the Coding
Conventions :

    - http://www.python.org/dev/peps/pep-0008/


Additional information
-----------------------

Fork the project on GitHub : https://github.com/areski/sms-khomp-api

License : MPL 2.0 (https://raw.github.com/areski/sms-khomp-api/master/COPYING)

Developer Website : http://www.star2billing.com

Khomp Website : http://www.khomp.com.br

