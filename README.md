# webdnsmasq

Small Python web interface for dnsmasq to create a config file for all /address and /server settings of dnsmasq. I used the [pyramid framework](http://www.pylonsproject.org/) for site generation and [bootstrap](http://getbootstrap.com/) for fancy mobile-first layouts. 

This application will create a webinterface so that you can enable and disable predefined addresses and servers for your dnsmasq. More concrete: the output is an address.conf file that can be included in your dnsmasq configuration. This can be useful if you want to disable specific sites on demand, for example if you want to block all communication to facebook.com. Some extra (and use-case specific) configuration in necessary to run this tool. Feel free to ask if something is unclear.

![alt text](https://raw.github.com/TimJuni/webdnsmasq/master/Screenshot.png "webdnsmasq preview")

## Requirements

For a successful installation you need:
* a working dnsmasq on your system

## Installation Notes

I'll provide a guide to install webdnsmasq based on the tutorial from the [pyramid framework](http://docs.pylonsproject.org/projects/pyramid/en/1.4-branch/narr/install.html) to install webdnsmasq in a seperate python environment, so that your systems python environment is not effected.

1. Make sure that your dnsmasq is working. 

2. Install python (if not already on your system) and setuptools:
  * for example: `sudo apt-get install python python-setuptools`

3. Create a virtual environment for python (sudo not required and not recommended):
  * `mkdir ~/Development` (Or another directory)
  * `cd ~/Development`
  * `pyvenv env`
  * `cd env`

4. Install webdnsmasq
  * `git clone https://github.com/TimJuni/webdnsmasq.git`
  * `cd webdnsmasq`
  * `../bin/python setup.py develop`

5. Run webdnsmasq
  * `../bin/pserve development.ini`
  * surf `http://localhost:6543`

## Example Configurations

### Add your own addresses or servers you want to modify with webdnsmasq
If you want to add more addresses or servers to webdnsmasq, you can do so by editing the `/webdnsmasq/views.py`. The addresses and servers can be edited in the very beginning of the file.

### Automatically restart dnsmasq on edit
Typically dnsmasq is started with root rights. That is why we cannot restart the dnsmasq directly from the webinterface, unless webdnsmasq runns as root, which i clearly dont recommend. One easy way to achive an automatic restart is to use a filesystem FIFO to notify a root process to restart dnsmasq. You can do so by:

1. Create a FIFO file (writeable for webdnsmasq, so do not use sudo etc.)
  * mkfifo push.fifo

2. Uncomment the line `notifyDnsmasq()` in `def save_view(request)` in `views.py`

3. Write a small script that restarts dnsmasq as root
```
import os
import sys
from subprocess import call

while True:
  fifo = open("<path to your push.fifo>","r")
  for line in fifo:
    print "Received: " + line,
  call(["killall","dnsmasq"])
  call(["dnsmasq"])
  fifo.close()
``` 

4. Start that script as root and put it in the backgroud for example with `screen`.

### Running webdnsmasq over ssh
If you run webdnsmasq over ssh, you cannot quit your ssh session, because the webdnsmasq process will be killed. One easy way to start webdnsmasq (and let it run even when you are logged off) is to use `screen`:

1. Install screen
  * `sudo apt-get install screen`
2. Create a new screen
  * `screen -S webdns`
3. Start webdnsmasq
  * `../bin/pserve development.ini`
4. Detatch the screen
  * simply hit ctrl + a + d 

At this point you can quit your ssh session and webdnsmasq will continue serving files. If you later want stop webdnsmasq, you can attach to the screen by: `screen -r webdns`

### Running webdnsmasq behind a Reverse Proxy (with Authentification)
If you want to use to webdnsmasq on a public available server, you can set up an apache reverse proxy to restrict the access to the application (wich i totally recommend). 

1. Install Apache Web Server
    * `sudo apt-get install apache2`
2. Enable Apache Proxy Mod
    * `sudo a2enmod proxy_http`
3. Disable Default Site
    * `sudo a2dissite default`
4. Create a new Virtualhost
    * `sudo nano /etc/apache2/sites-available/webdnsmasq` and add the following content:
    
   
```
<VirtualHost *:80>
  ServerName mydomain.org
 
  <Location />
    AuthType Basic
    AuthName "webdnsmasq Login"
    AuthUserFile /usr/local/passwd/passwords
    Require user guest
  </Location>

  ProxyPreserveHost On
  ProxyRequests off
  ProxyPass / http://localhost:6543/
  ProxyPassReverse / http://localhost:6543/
 
</VirtualHost>
``` 

5. Create a password file
    * `sudo mkdir /usr/local/passwd`
    * `sudo htpasswd -c /usr/local/passwd/passwords guest`
    * Enter a password
    
6. Enable the Virtualhost and restart the Webserver
    * `sudo a2ensite webdnsmasq`
    * `sudo /etc/init.d/apache2 restart`
    
When you surf `http://<adress of your server>` you should be asked for a username (guest) and a password (see step 5). 
