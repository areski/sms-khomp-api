bind = "0.0.0.0:5000"
logfile = "/var/log/sms-khomp-api/gunicorn_sms_khomp_api.log"
workers = 32
daemon = True
debug = False
pidfile = "/tmp/gunicorn-sms.pid"
