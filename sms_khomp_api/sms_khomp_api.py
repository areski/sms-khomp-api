#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gevent import monkey
monkey.patch_all()

from gevent.event import Event
from gevent.wsgi import WSGIServer
from flask import Flask, url_for, request, abort
from time import sleep
import ESL

import os
import sys
import logging
import optparse
from daemon import Daemon

__version__ = 'v1.0'

PORT = 5000

#Event Socket
EVENTSOCKET_HOST = '127.0.0.1'
EVENTSOCKET_PORT = '8021'
EVENTSOCKET_PASSWORD = 'ClueCon'


app = Flask(__name__)

#setup logger
logger = logging.getLogger("sms_khomp_api")
logger.setLevel(logging.DEBUG)

# create file handler which logs even debug messages
fh = logging.FileHandler("sms_khomp_api.log")
fh.setLevel(logging.DEBUG)

# create formatter and add it to the handlers
formatter = logging.Formatter("%(asctime)s [%(levelname)s] %(name)s\t%(message)s", datefmt="%Y-%m-%d %H:%M:%S")
fh.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(fh)


#Add Flask Routes
@app.route("/")
def index():
    return "Welcome to Khomp SMS API " + __version__
    

@app.route("/documentation/")
def documenation():
    return "Documentation<br>------------------<br/>API : Send SMS - Url /v1.0/sendsms"
    
#@app.route('/v1.0/sendsms/<recipient>/<sender>/<message>')
#def sendsms(recipient, sender, message):
#    # show the user profile for that user
#    return 'Send SMS %s / %s / %s' % (recipient, sender, message)
    
@app.route('/v1.0/sendsms', methods=['POST'])
def sendsms():
    if request.method == 'POST':
        if 'recipient' in request.form \
            and 'message' in request.form:
            
            #Send SMS via ESL
            c = ESL.ESLconnection(EVENTSOCKET_HOST, EVENTSOCKET_PORT, EVENTSOCKET_PASSWORD)
            #ev = c.api("khomp", "sms b0 885392 Test over ESL")
            ev = c.api("api", "help")
            print ev.serialize()
            
            from ESL import ESLconnection
            con = ESLconnection("localhost", "8021", "ClueCon")
            e = con.api("show channels")
            return e.getBody()
            
            #return 'Received POST ==> Send SMS %s / %s' % (request.form['recipient'], request.form['message'])
        else:
            abort(404, 'Missing parameters on POST')
    else:
        return 'Send recipient, sender and message via POST'        


class StdErrWrapper:
    def __init__(self):
        self.logger = logging.getLogger("sms_khomp_api.access")

    def write(self, s):
        self.logger.info(s.rstrip())


class MyDaemon(Daemon):
    def run(self):
        #while True:
        self.logger = logging.getLogger("sms_khomp_api")
        self.logger.info("Creating sms_khomp_api")
        #Run WSGIServer
        http = WSGIServer(('', PORT), app.wsgi_app)
        http.serve_forever()
        self.logger.info("Done.")

    
if __name__ == "__main__":
    parser = optparse.OptionParser(usage="usage: %prog -d|c|m|e [options]",
                    version="SMS Khomp API Server " + __version__)
    parser.add_option("-c", "--config", action="store", dest="config",
                    default="configfile.cfg", help="Path to config file",)
    parser.add_option("-d", "--daemon", action="store_true", dest="daemon",
                    default=False, help="Start as daemon",)
    parser.add_option("-e", "--debug", action="store_true", dest="debug",
                    default=False, help="Start in debug mode",)
    parser.add_option("-m", "--master", action="store_true", dest="master",
                    default=False, help="Start master in foreground",)
    parser.add_option("-p", "--pid", action="store", dest="pid",
                    default="/tmp/sms_khomp_api.pid", help="Path to pid file",)

    (options, args) = parser.parse_args()
    if options.daemon:
        daemon = MyDaemon(options.pid)

        if len(args) != 1:
            parser.error("Missing parameters : sms_khomp_api.py -d start|stop|restart")

        if "start" == args[0]:
            daemon.start()
        elif "stop" == args[0]:
            daemon.stop()
        elif "restart" == args[0]:
            daemon.restart()
        else:
            print "Unknown command"
            sys.exit(2)
        sys.exit(0)
        
    elif options.master:
        print "Starting as master (PORT:%d)..." % PORT
        daemon = MyDaemon(options.pid)
        #daemon.load_config(options.config)
        try:
            daemon.run()
        except KeyboardInterrupt:
            print "\nGot Ctrl-C, shutting down..."
        except Exception, e:
            print "Oops...", e
        print "Bye!"
        
    elif options.debug:
        print "Starting in debug mode (PORT:%d)..." % PORT
        app.debug = True
        app.run(host='0.0.0.0', port=PORT)
        
    else:
        parser.print_usage()
        sys.exit(1)
