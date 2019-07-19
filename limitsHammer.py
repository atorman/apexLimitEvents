# !/usr/bin/python
'''
# Python 2.7.9 script to trigger apex transactions via the limitsTest apex web service

# Pre-requisite: standard library functionality = e.g urrlib2, json, StringIO, random, time

 #/**
 #* Copyright (c) 2012, Salesforce.com, Inc.  All rights reserved.
 #*
 #* Redistribution and use in source and binary forms, with or without
 #* modification, are permitted provided that the following conditions are
 #* met:
 #*
 #*   * Redistributions of source code must retain the above copyright
 #*     notice, this list of conditions and the following disclaimer.
 #*
 #*   * Redistributions in binary form must reproduce the above copyright
 #*     notice, this list of conditions and the following disclaimer in
 #*     the documentation and/or other materials provided with the
 #*     distribution.
 #*
 #*   * Neither the name of Salesforce.com nor the names of its
 #*     contributors may be used to endorse or promote products derived
 #*     from this software without specific prior written permission.
 #*
 #* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 #* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 #* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 #* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 #* HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 #* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 #* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 #* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 #* THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 #* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 #* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #*/
'''
# Configurations - change to fit your org

CLIENT_ID = '<this code won\'t work until you add your salesforce connected app client id here>'
CLIENT_SECRET = '<this code won\'t work until you add your salesforce connected app client secret here>'
USERNAME = '<this code won\'t work until you add your salesforce username here>'
PASSWORD = '<this code won\'t work until you add your salesforce password here>'

#Imports

import urllib2
import json
#import ssl
#import getpass
import time
from random import randint
from time import sleep
import logging

# login function
def login():
    ''' Login to salesforce service using OAuth2 '''

    # create a new salesforce REST API OAuth request
    url = 'https://login.salesforce.com/services/oauth2/token'
    data = '&grant_type=password&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET+'&username='+USERNAME+'&password='+PASSWORD
    headers = {'X-PrettyPrint' : '1'}

    # workaround to ssl issue introduced before version 2.7.9
    #if hasattr(ssl, '_create_unverified_context'):
        #ssl._create_default_https_context = ssl._create_unverified_context

    # call salesforce REST API and pass in OAuth credentials
    req = urllib2.Request(url, data, headers)
    res = urllib2.urlopen(req)

    # load results to dictionary
    res_dict = json.load(res)

    # close connection
    res.close()

    # return OAuth access token necessary for additional REST API calls
    access_token = res_dict['access_token']
    instance_url = res_dict['instance_url']

    return access_token, instance_url

# Trigger limits function
def trigger_limits():
    ''' Query salesforce service using REST API '''
    # login and retrieve access_token and day
    access_token, instance_url = login()

    for i in range(0,10):
        # create a random number between 0 and 2
        random = randint(0,2)
        #print random

        # rotate between three limitsTest endpoints randomly
        if random == 0:
            url = instance_url+'/services/apexrest/limitsTest/tooManyQueries'
            end_point = '/tooManyQueries'
        elif random == 1:
            url = instance_url+'/services/apexrest/limitsTest/tooManySearches'
            end_point = '/tooManySearches'
        else:
            url = instance_url+'/services/apexrest/limitsTest/tooManyDML'
            end_point = '/tooManyDML'

        # add headers and create request
        headers = {'Authorization' : 'Bearer ' + access_token, 'X-PrettyPrint' : '1'}
        req = urllib2.Request(url, None, headers)

        # try to call the limitsTest web service
        #expectation is that there will be a 500 response code if successful
        try:
            res = urllib2.urlopen(req)
            #res_dict = json.load(res)
            # close connection
            res.close
        except urllib2.HTTPError, err:
            if err.code == 500:
                print 'Apex web service end point executed: ' + end_point
            elif err.code == 400:
                print 'Apex web service end point executed: ' + end_point
            else:
                raise
         # begin profiling
        start = time.time()

        # wait for a random amount of time (from 1-10 seconds)
        sleep(randint(1,10))
        # end profiling
        end = time.time()
        secs = end - start

        # msecs = secs * 1000  # millisecs
        # print 'elapsed time: %f ms' % msecs
        #print 'Total wait time between executions: %f seconds\n' % secs

        # log results to limitsHammer log file
        logging.basicConfig(filename='limitsHammer.log', level=logging.INFO, format='%(asctime)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')

        # log endpoint and total time between executions
        logging.info('Apex web service end point executed: ' + end_point +'\n'+'Total wait time between executions: %f seconds\n' % secs)

trigger_limits()
