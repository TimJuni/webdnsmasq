# webdnsmasq - web interface for dnsmasq
# Copyright (C) 2015 Tim Jungnickel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
import os

# all hosts will be resolved to the stated IP
# please read the dnsmasq man page for /address entry
addresses = {
    'facebook.com': '127.0.0.1'
}

# all hosts will be resolved by the DNS server behind the stated IP 
# pleas read the dnsmasq man page for /server entry
servers = {
    'google.com': '8.8.8.8'
}


addressesDict = dict.fromkeys(addresses, True)
serversDict = dict.fromkeys(servers,True)

@view_config(route_name='home', renderer='home.mako')
def my_view(request):
    return {'project': 'webdnsmasq',
            'addresses': addressesDict,
            'servers': serversDict}

# View for save - no site will be generated      
@view_config(route_name='save')
def save_view(request):
    global addressesDict, serversDict

    file = open("address.conf","w")

    for param in addressesDict:

        if param in request.params:
            addressesDict[param] = True
            file.write("address=/" + param + "/" + addresses[param] + "\n")
        else:
            addressesDict[param] = False

    for param in serversDict:
        if param in request.params:
            serversDict[param] = True
            file.write("server=/" + param + "/" + servers[param] + "\n")
        else:
            serversDict[param] = False 

    file.close()
    #notifyDnsmasq()
    return HTTPFound(location='/') 

def notifyDnsmasq():
    fifo = open("push.fifo","w")
    fifo.write("changed list\n")
    fifo.close()