#!/usr/bin/env python3
import os
import socket

base = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(base, 'hosts', f'{socket.gethostname()}_font.conf')
if os.path.isfile(path):
    print(f'include {path}')
