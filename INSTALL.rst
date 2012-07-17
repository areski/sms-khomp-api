=====================
SMS-Khomp-API Install
=====================

HTTP API Gateway for KHOMP SMS

The initial Author is Arezqui Belaid <areski@gmail.com>



Install
=======

1. Run the install script::

    > cd install
    > bash install.sh

2. Run SMS-Khomp-API Server with Gunicorn::

    > /usr/share/virtualenvs/sms-khomp-api/bin/python /usr/share/virtualenvs/sms-khomp-api/bin/gunicorn sms_khomp_api:app -c /usr/share/sms_khomp_api/gunicorn.conf.py

    * You can configure the number of workers and the port of the server in gunicorn.conf.py

3. Check that is running::
    > ps auxw | grep sms_khomp_api
