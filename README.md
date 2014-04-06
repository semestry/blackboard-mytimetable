Blackboard Building Block for MyTimetable
======================

This project contains a Building Block for the Blackboard Learn 9 environments.
It presents the upcoming events to the user and provides a link to MyTimetable:

![](https://blog.eveoh.nl/assets/img/mytimetable_blackboard.png)

The block also provides a webservice to get the enrollments for a given user.
This service can be used to import the enrollments from Blackboard Learn into MyTimetable.

Download
--------

Try the GitHub releases page at https://github.com/eveoh/blackboard-mytimetable/releases

Installation
------------

Upload the WAR file, activate it, and accept the necessary permissions.

Configuration
-------------

Various settings can be found under the building block settings page:

* __MyTimetable URL__: URL to your MyTimetable installation, used in the interface to link to the full timetable. Add `?requireLogin=true` to
automatically trigger authentication.
* __MyTimetable link target__: defines if the building block is loaded in a new window (`_blank`) or in the current window (`_top`).
* __Number of events to show__: number of upcoming events shown in the building block module.


* __MyTimetable API URL__: URL to your MyTimetable 2.3+ API. Needs to include the `/api/v0/` part. Multiple URLs can be specified
on separate lines, to support failover in the case of issues with one of the application servers.
* __MyTimetable API key__: a MyTimetable API key, as included in the `api_tokens` table. The key needs to have 'elevated'
permissions (`is_elevated` should be True)
* __Disable SSL certificate CN verification__: Tick this box to disable the strict hostname checks and allow any
hostname in the certificate. Useful when the connection is made using an internal hostname. The SSL certificate
still has to be valid.
* __Timeout settings__: define various timeouts.
* __Maximum number of concurrent API connections__: Maximum number of concurrent connections made to the API. Do not
make this number too high, to prevent MyTimetable server overload.


* __Domain prefix for Blackboard username__: configure this setting if your MyTimetable usernames include a Windows domain name
(`DOMAIN\username`) whereas your Blackboard usernames do not have the domain part (`username`).
* __Postfix for Blackboard username__: configure this setting if your MyTimetable usernames have a postfix which your Blackboard
usernames do not have (e.g., an email domain).


* __Override CSS__: enter custom CSS to be inserted with the building block.

Logging
-------

Logging is done using [Logback](logback.qos.ch). By default 7 days of logs are kept in the Blackboard log folder, under
the name `mytimetable-b2.<date>.log` (logging is done to the relative path `../../../../blackboard/logs/`).

Enrollments service
-------------------

The building block includes a small REST web service that exports the enrollments of a user. Authentication is done
using the API token from the building block settings. A header `apiToken` and a GET parameter `user` have to be included
in the request. The service is available at `<building block base URL>/enrollmentsForUser`. An example conversation
is below:

```
GET /webapps/evh-mytimetable-b2-bb_bb60/enrollmentsForUser?user=dscott1 HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate, compress
Host: localhost
User-Agent: HTTPie/0.7.2
apiToken: MY-API-TOKEN



HTTP/1.1 200 OK
Content-Length: 284
Content-Type: application/json
Date: Mon, 06 Jan 2014 16:06:29 GMT
Server: Apache/1.3.41 (Unix) mod_gzip/1.3.26.1a mod_ssl/2.8.31 OpenSSL/0.9.8n mod_jk/1.2.37
Set-Cookie: JSESSIONID=SID.root; Path=/webapps/evh-mytimetable-b2-bb_bb60; Secure
X-Blackboard-appserver: xxxx.nl
X-Blackboard-product: Blackboard Learn &#8482; 9.1.xxx.0

[
    {
        "course": {
            "available": true,
            "description": "",
            "displayTitle": "CTB1001 Analyse (2013-2014 Q1)",
            "endDate": null,
            "id": "30827-131401",
            "institutionName": "",
            "organization": false,
            "serviceLevel": "FULL",
            "startDate": null,
            "title": "CTB1001 Analyse (2013-2014 Q1)"
        },
        "enrollmentDate": 1389016861000
    }
]
```

Support and more info
---------------------

Visit our website, http://mytimetable.net, open a ticket (PR's welcome), or drop an email at info@eveoh.nl.

License
-------

    Copyright 2013 - 2014 Eveoh

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
