'''
Salt returner that report execution results back to sentry. The returner will
inspect the payload to identify errors and flag them as such.

Pillar need something like::

    raven:
      servers:
        - http://192.168.1.1
        - https://sentry.example.com
      public_key: deadbeefdeadbeefdeadbeefdeadbeef
      secret_key: beefdeadbeefdeadbeefdeadbeefdead
      project: 1
      tags:
        - os
        - master
        - saltversion
        - cpuarch

and http://pypi.python.org/pypi/raven installed

The tags list (optional) specifies grains items that will be used as sentry tags, allowing tagging of events
in the sentry ui.
'''

import collections
import logging

try:
    from raven import Client
    has_raven = True
except ImportError:
    has_raven = False

logger = logging.getLogger(__name__)


def __virtual__():
    if not has_raven:
        return False
    return 'sentry'

def returner(ret):
    '''
    Log outcome to sentry. The returner tries to identify errors and report them as such. All other
    messages will be reported at info level.
    '''
    def connect_sentry(result):
        pillar_data = __salt__['pillar.raw']()
        grains = __salt__['grains.items']()
        tags = {}
        if 'tags' in pillar_data['raven']:
            for tag in pillar_data['raven']['tags']:
                tags[tag] = grains[tag]
        global_extra_data = {
            'pillar': pillar_data,
            'grains': grains
        }
        global_data = {
            'platform': 'python',
            'level': 'error'
        }


        servers = []
        try:
            for server in pillar_data['raven']['servers']:
                servers.append(server + '/api/store/')
            client = Client(
                servers=servers,
                public_key=pillar_data['raven']['public_key'],
                secret_key=pillar_data['raven']['secret_key'],
                project=pillar_data['raven']['project'],
            )
        except KeyError as missing_key:
            logger.error("Sentry returner need config '%s' in pillar",
                         missing_key)
        else:
            try:
                if isinstance(result['return'], collections.Mapping):
                    for state, changes in result.get('return', {}).iteritems():
                        if changes.get('result', True):
                            continue
                        data = global_data
                        data['culprit'] = state.replace('_|-',' ')
                        extra_data = global_extra_data
                        extra_data['result'] = changes
                        client.captureMessage(message=changes.get('comment', 'No comment supplied'), data=data, extra=extra_data, tags=tags)
                else:
                    data = global_data
                    data['culprit'] = result['fun']
                    extra_data = global_extra_data
                    extra_data['result'] = result
                    message = "\n".join(result['return'])
                    client.captureMessage(message=message, data=data, extra=extra_data, tags=tags)
            except Exception as err:
                logger.error("Can't send message to sentry: %s", err,
                             exc_info=True)

    try:
        connect_sentry(ret)
    except Exception as err:
        logger.error("Can't run connect_sentry: %s", err, exc_info=True)
