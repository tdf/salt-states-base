.. _rtorrent_service:

Bittorrent seed (rtorrent)
==========================

.. sectionauthor:: Christian Lohmaier <cloph@documentfoundation.org>

Bittorrent is provided by two components - one is the tracker that brings peers
together and the bittorent client that actually provides the files to other
peers.

At TDF we're using a custom build of the bnbt tracker software, and a stock
version of rtorrent. This part describes the client, rtorrent.

Requirements
------------

1) Mirrorbrain/Master-mirror (needs access to all files that are served to the public)
2) Bittorrent tracker (bnbt)
3) Open Port(s) - configurable, at least one, currently uses 58185 (tcp & udp)

Installation
------------

* to install the client/seed (rtorrent)::

    sudo apt-get install rtorrent

* Create directories for it to place it files::

    sudo mkdir -p /srv/rtorrent
    sudo mkdir /srv/rtorrent/{config,download,session,watch}

* Create configuration file::

    sudo echo > /srv/rtorrent/config/rtorrent.rc <<EOF
    ##
    ## basic settings
    ##

    # change working directory of the process(chdir) - already done by initscript
    #cwd = /srv/rtorrent

    # default target-dir (where to save/look for the actual download)
    directory = /srv/rtorrent/download

    # session dir (one per instance!)
    session = /srv/rtorrent/session
    # port to use
    port_range = 58185-58185

    ##
    ## misc features
    ##

    # we use our own tracker, and we want it to be used, so no dht and no peer-exchange
    dht = disable
    peer_exchange = no

    # allow encypted requests, but don't encrypt ourselves unless it fails without
    encryption = allow_incoming,enable_retry,prefer_plaintext

    # Watch a directory for new torrents, and stop those that have been deleted.
    # schedule = id, initial delay, schedule interval, command
    schedule = watch_directory,25,60,"load_start=/srv/rtorrent/watch/*.torrent"
    # watch another directory with different downlaod-directory
    #schedule = watch_another,15,60,"load_start=/srv/rtorrent/watch_extra/*.torrent,d.set_directory=/srv/rtorrent/watch_extra"
    # remove files from the client when the corresponding torrent file was deleted
    schedule = untied_directory,5,60,"remove_untied="
    # Close torrents when diskspace is low.
    #schedule = low_diskspace,5,60,"close_low_diskspace=100M"

    ##
    ## throttle options
    ##

    # old way to throttle by ration (prior to 0.8.4)
    # Stop torrents when reaching upload ratio in percent,
    # when also reaching total upload in bytes, or when
    # reaching final upload ratio in percent.
    # example: stop at ratio 2.0 with at least 200 MB uploaded, or else ratio 20.0
    #schedule = ratio,60,60,"stop_on_ratio=1000,1000M,10000"

    # current method - details http://libtorrent.rakshasa.no/wiki/RTorrentRatioHandling
    # Enable the default ratio group.
    #ratio.enable=

    # Change the limits
    #ratio.min.set=200
    #ratio.upload.set=1000M
    #ratio.max.set=1000

    # Changing the command triggered when the ratio is reached. (default is to close only)
    # system.method.set = group.seeding.ratio.command, d.close=, d.erase=
    # system.method.set = group.seeding.ratio.command, d.stop=

    # upload_rate = KB

    # Maximum and minimum number of peers to connect to per torrent.
    #min_peers = 40
    #max_peers = 100

    # Maximum number of simultaneous uploads per torrent.
    #max_uploads = 30
    # max upload slots for all torrents
    #max_uploads_global = 200


    ##
    ## performance options (handle with care)
    ##

    # sendbuffer, increase may reduse diskaccess, see "cat /proc/sys/net/ipv4/tcp_wmem" for min, default, max
    #send_buffer_size = value named network.send_buffer.size since 0.8.7)
    # 128K, default 16K
    network.send_buffer.size = 131072
    # max memory is limited to ulimit -m or 1GB
    #max_memory_usage = bytes

    # for additional settings see man rtorrent
    EOF

* Change ownership to the user under which ID rtorrent should be running::

    sudo chown -R cloph: /srv/rtorrent/*

* Create the init script to have it launch at boot::

    sudo echo > /etc/init.d/rtorrent <<EOF
    #!/bin/bash
    ### BEGIN INIT INFO
    # Provides:          torrent_client
    # Required-Start:    $network $local_fs $syslog torrent_tracker
    # Required-Stop:     $network $local_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Start the BitTorrent client
    ### END INIT INFO
    #############
    ###<Notes>###
    #############
    # This script depends on screen.
    # For the stop function to work, you must set an
    # explicit session directory using absolute paths (no, ~ is not absolute) in your rtorrent.rc.
    # If you typically just start rtorrent with just "rtorrent" on the
    # command line, all you need to change is the "user" option.
    # Attach to the screen session as your user with
    # "screen -dr rtorrent". Change "rtorrent" with srnname option.
    # Licensed under the GPLv2 by lostnihilist: lostnihilist _at_ gmail _dot_ com
    ##############
    ###</Notes>###
    ##############

    #######################
    ##Start Configuration##
    #######################
    # You can specify your configuration in a different file
    # (so that it is saved with upgrades, saved in your home directory,
    # or whatever reason you want to)
    # by commenting out/deleting the configuration lines and placing them
    # in a text file (say /home/user/.rtorrent.init.conf) exactly as you would
    # have written them here (you can leave the comments if you desire
    # and then uncommenting the following line correcting the path/filename
    # for the one you used. note the space after the ".".
    # . /etc/rtorrent.init.conf


    #Do not put a space on either side of the equal signs e.g.
    # user = user
    # will not work
    # system user to run as (can only use one)
    user="cloph"
    # system user to run as # not implemented, see d_start for beginning implementation
    # group=$(id -ng "$user")

    # the full path to the filename where you store your rtorrent configuration
    # must keep parentheses around the entire statement, quotations around each config file
    #config=("$(su -c 'echo $HOME' $user)/.rtorrent.rc")
    config=("/srv/rtorrent/config/rtorrent.rc")
    # Examples:
    # config=("/home/user/.rtorrent.rc")
    # config=("/home/user/.rtorrent.rc" "/mnt/some/drive/.rtorrent2.rc")
    # config=("/home/user/.rtorrent.rc"
    # "/mnt/some/drive/.rtorrent2.rc"
    # "/mnt/another/drive/.rtorrent3.rc")

    # set of options to run with each instance, separated by a new line
    # must keep parentheses around the entire statement
    #if no special options, specify with: ""
    #options=("")
    options=("-n -o import=/srv/rtorrent/config/rtorrent.rc")
    # Examples:
    # starts one instance, sourcing both .rtorrent.rc and .rtorrent2.rc
    # options=("-o import=~/.rtorrent2.rc")
    # starts two instances, ignoring .rtorrent.rc for both, and using
    # .rtorrent2.rc for the first, and .rtorrent3.rc for the second
    # we do not check for valid options
    # options=("-n -o import=~/.rtorrent2.rc" "-n -o import=~/rtorrent3.rc")

    # default directory for screen, needs to be an absolute path
    #base=$(su -c 'echo $HOME' $user)
    base="/srv/rtorrent"

    # name of screen session
    srnname="rtorrent"

    # file to log to (makes for easier debugging if something goes wrong)
    logfile="/var/log/rtorrentInit.log"

    #######################
    ###END CONFIGURATION###
    #######################

    PATH=/usr/bin:/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin
    DESC="rtorrent"
    NAME=rtorrent
    DAEMON=$NAME
    SCRIPTNAME=/etc/init.d/$NAME

    checkcnfg() {
      exists=0
      for i in `echo "$PATH" | tr ':' '\n'` ; do
        if [ -f $i/$NAME ] ; then
          exists=1
          break
        fi
      done
      if [ $exists -eq 0 ] ; then
        echo "cannot find $NAME binary in PATH: $PATH" | tee -a "$logfile" >&2
        exit 3
      fi
      for (( i=0 ; i < ${#config[@]} ;  i++ )) ; do
        if ! [ -r "${config[i]}" ] ; then
            echo "cannot find readable config ${config[i]}. check that it is there and permissions are appropriate"  | tee -a "$logfile" >&2
            exit 3
        fi
        session=$(getsession "${config[i]}")
        if ! [ -d "${session}" ] ; then
            echo "cannot find readable session directory ${session} from config ${config[i]}. check permissions" | tee -a "$logfile" >&2
            exit 3
        fi
      done
    }
    d_start() {
      [ -d "${base}" ] && cd "${base}"
      stty stop undef && stty start undef
      #su -c "screen -S "${srnname}" -X screen rtorrent ${options} 2>&1 1>/dev/null" ${user} | tee -a "$logfile" >&2
      su -c "screen -ls | grep -sq "\.${srnname}[[:space:]]" " ${user} || su -c "screen -dm -S ${srnname} 2>&1 1>/dev/null" ${user} | tee -a "$logfile" >&2
      # this works for the screen command, but starting rtorrent below adopts screen session gid
      # even if it is not the screen session we started (e.g. running under an undesirable gid
      #su -c "screen -ls | grep -sq "\.${srnname}[[:space:]]" " ${user} || su -c "sg \"$group\" -c \"screen -fn -dm -S ${srnname} 2>&1 1>/dev/null\"" ${user} | tee -a "$logfile" >&2
      for (( i=0 ; i < ${#options[@]} ; i++ )) ;  do
        sleep 3
        su -c "screen -S "${srnname}" -X screen rtorrent ${options[i]} 2>&1 1>/dev/null" ${user} | tee -a "$logfile" >&2
      done
    }

    d_stop() {
      for (( i=0 ; i < ${#config[@]} ; i++ )) ; do
        session=$(getsession "${config[i]}")
        if ! [ -s ${session}/rtorrent.lock ] ; then
            return
        fi
        pid=$(cat ${session}/rtorrent.lock | awk -F: '{print($2)}' | sed "s/[^0-9]//g")
        # make sure the pid doesn't belong to another process
        if ps -A | grep -sq ${pid}.*rtorrent ; then
            kill -s INT ${pid}
        fi
      done
    }

    getsession() {
        session=$(cat "$1" | grep "^[[:space:]]*session[[:space:]]*=" | sed "s/^[[:space:]]*session[[:space:]]*=[[:space:]]*//" )
        #session=${session/#~/`getent passwd ${user}|cut -d: -f6`}
        echo $session
    }

    checkcnfg

    case "$1" in
      start)
        echo -n "Starting $DESC: $NAME"
        d_start
        echo "."
        ;;
      stop)
        echo -n "Stopping $DESC: $NAME"
        d_stop
        echo "."
        ;;
      restart|force-reload)
        echo -n "Restarting $DESC: $NAME"
        d_stop
        sleep 1
        d_start
        echo "."
        ;;
      *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
    esac

    exit 0
    EOF

    sudo chmod +x /etc/init.d/rtorrent

* Enable the initscript::

    sudo update-rc.d rtorrent defaults

* Add hooks to the :file:`/usr/local/bin/stage2pub` script to add the torrents & symlink the files::

    # Torrent section - if anyone goes wrong here, blame cloph
    echo "setting up symlinks for rtorrent"
    su - cloph -c "find /srv/active/pub/libreoffice/ -type f -not -name \*md5 -not -name \*asc  -not -name \*log -print0 | xargs -r -0 ln -sf --target-directory=/srv/rtorrent/download/"

    echo "updating torrents for the client"
    su - cloph -c "rsync -r --delete --include=\*torrent /srv/tracker/torrents_sync/ /srv/rtorrent/watch"

* Add cronjob to remove the dangling symlinks that remain::

    sudo echo > /etc/cron.d/rtorrent-cleanup <<EOF
    # torrent download files are symlinked to preserve space
    # but while the obsolete "*.torrent" files are delted when updating the mirrors
    # (in the stage2pub script), the symlinks for the downloads remain.
    # This cleans up weekly (-L = follow symlinks, -type l -> the target still is a symlink,
    # thus it doesn't point to a file, in other words: find all links no longer pointing to a file)
    #
    # the second find statement is a sanity check - all files rtorrent seeds should be symlinks,
    # otherwise space is wasted
    #
    # m h dom mon dow       user    command
    43  4   *  *  Sun       cloph   find -L /srv/rtorrent/download -type l -print0 | xargs -r -0 rm ; find /srv/rtorrent/download -type f
    EOF

Start
-----

::

  sudo /etc/init.d/rtorrent start



Stop
----

.. note::
    stopping and restarting is not advised, as on start it hashes the files to
    check whether it has "donwloaded" all files and whether they are intact.
    This causes both IO as well as CPU cycles.
    If you temporarily have rtorrent cease its activity, either throttle it or
    start/stop the torrents using the interactive interface (connect to the
    screen session).
    To stop all torrents at once, see http://libtorrent.rakshasa.no/wiki/RTorrentCommonTasks#Startorstopalltorrents

::

  sudo /etc/init.d/rtorrent stop



Disable
-------

::

  sudo update-rc.d rtorrent disable



Enable
------

::

  sudo update-rc.d rtorrent enable



Responsible
-----------

If something wrong or fishy, contact cloph.
