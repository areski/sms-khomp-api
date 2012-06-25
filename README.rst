
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

