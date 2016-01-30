#!/usr/bin/env python
import os
def is_docker():
    grains = {'docker': False}
    try:
        if os.path.isfile('/.dockerinit'):
            grains['docker'] = True
    finally:
        return grains
