1.0.5
---
 - deploy csv-logger
 - deploy static webserver: /downloads
 - DRY up code

1.0.4
---
 - install nginx
 - install git
 - readd travis
 - install node.js
 - add github to known hosts
 - add forever and deployment of /api

1.0.3
---
 - create /var/www (Webservices)
 - create user node (General)
 - log to /var/log/templogger.log (Temperature Logger)

1.0.2
---
 - let cronjob run every hour
 - let cronjob run as user pi
 - log errors of cronjob to /tmp/node_debug.log

1.0.1
---
 - add basic cronjob for periodical temperature tracking