.. _bnbt_service:

Bittorrent tracker (bnbt)
=========================

.. sectionauthor:: Christian Lohmaier <cloph@documentfoundation.org>

Bittorrent is provided by two components - one is the tracker that brings peers
together and the bittorent client that actually provides the files to other
peers.

At TDF we're using a custom build of the bnbt tracker software, and a stock
version of rtorrent. This part describes the tracker, bnbt.

Requirements
------------

1) Open Port - 6969/tcp

Installation
------------

* As the tracker is using a customized version of bnbt (the user-management stuff removed), you need to compile the source if you want to install from scratch. This needs a c compiler

    .. todo:: upload the tracker's sourcecode to some resonable place
    
    1) Checkout the source
    2) cd <sourcedir>; make 

* Create working directory for the tracker::

    sudo mkdir -p /srv/tracker
    sudo mkdir /srv/tracker/{allowed_torrents,archived_torrents,cbtt,torrents_sync}

* Copy bnbt binary::

    sudo cp <sourcedir>/bnbt /srv/tracker/cbtt/

* Create configuration file::

    sudo echo > /srv/tracker/cbtt/bnbt.cfg <<EOF
    allowed_dir = /srv/tracker/allowed_torrents
    announce_interval = 1800
    bind = 
    bnbt_access_log_dir = 
    bnbt_access_log_file_pattern = %Y-%m-%d.log
    bnbt_allow_comments = 0
    bnbt_allow_info_link = 0
    bnbt_allow_scrape = 1
    bnbt_allow_scrape_global = 0
    bnbt_allow_search = 1
    bnbt_allow_sort = 1
    bnbt_allow_torrent_downloads = 1
    bnbt_archive_dir = /srv/tracker/archived_torrents
    bnbt_charset = utf-8
    bnbt_comment_length = 800
    bnbt_comments_file = 
    bnbt_compression_level = 6
    bnbt_count_unique_peers = 1
    bnbt_debug = 0
    bnbt_delete_invalid = 0
    bnbt_delete_own_torrents = 1
    bnbt_disable_html = 0
    bnbt_dump_xml_file = 
    bnbt_dump_xml_interval = 600
    bnbt_dump_xml_peers = 1
    bnbt_error_log_dir = 
    bnbt_error_log_file_pattern = %Y-%m-%de.log
    bnbt_external_torrent_dir = 
    bnbt_file_dir = 
    bnbt_file_expires = 180
    bnbt_flush_interval = 100
    bnbt_force_announce_on_download = 1
    bnbt_force_announce_url = http://tracker.documentfoundation.org:6969/announce
    bnbt_guest_access = 67
    bnbt_max_conns = 64
    bnbt_max_peers_display = 500
    bnbt_max_recv_size = 524288
    bnbt_max_torrents = 0
    bnbt_member_access = 79
    bnbt_name_length = 32
    bnbt_parse_on_upload = 1
    bnbt_per_page = 50
    bnbt_private_tracker_flag = 0
    bnbt_realm = TDFo
    bnbt_refresh_fast_cache_interval = 30
    bnbt_refresh_static_interval = 10
    bnbt_require_announce_key = 0
    bnbt_robots_txt = 
    bnbt_rss_channel_copyright = LGPLv2+
    bnbt_rss_channel_description = BitTorrent RSS Feed for The Document Foundation
    bnbt_rss_channel_image_height = 0
    bnbt_rss_channel_image_url = 
    bnbt_rss_channel_image_width = 0
    bnbt_rss_channel_language = en-us
    bnbt_rss_channel_link = http://tracker.documentfoundation.org:6969/
    bnbt_rss_channel_title = LibreOffice Torrents
    bnbt_rss_channel_ttl = 60
    bnbt_rss_file = 
    bnbt_rss_file_mode = 0
    bnbt_rss_interval = 30
    bnbt_rss_limit = 25
    bnbt_rss_online_dir = 
    bnbt_rss_online_url = 
    bnbt_show_added = 0
    bnbt_show_average_dl_rate = 1
    bnbt_show_average_left = 1
    bnbt_show_average_ul_rate = 0
    bnbt_show_completed = 1
    bnbt_show_file_comment = 1
    bnbt_show_file_contents = 1
    bnbt_show_gen_time = 0
    bnbt_show_info_hash = 0
    bnbt_show_left_as_progress = 1
    bnbt_show_max_left = 0
    bnbt_show_min_left = 0
    bnbt_show_num_files = 0
    bnbt_show_share_ratios = 1
    bnbt_show_size = 1
    bnbt_show_stats = 1
    bnbt_show_transferred = 1
    bnbt_show_uploader = 0
    bnbt_static_footer = footer.html
    bnbt_static_header = header.html
    bnbt_style_sheet = http://prooo-box.org/tracker.css
    bnbt_swap_torrent_link = 1
    bnbt_tag_file = tags.bnbt
    bnbt_tlink_bind = 
    bnbt_tlink_connect = 
    bnbt_tlink_password = 
    bnbt_tlink_port = 5204
    bnbt_tlink_server = 0
    bnbt_tracker_title = 
    bnbt_upload_dir = 
    bnbt_use_announce_key = 1
    bnbt_users_file = users.bnbt
    bnbt_users_per_page = 50
    cbtt_abuse_detection = 0
    cbtt_abuse_hammer_limit = 10
    cbtt_abuse_limit = 5
    cbtt_ban_file = clientbans.bnbt
    cbtt_ban_mode = 0
    cbtt_blacklist_below_1024 = 0
    cbtt_blacklist_common_p2p_ports = 0
    cbtt_block_private_ip = 0
    cbtt_dont_compress_torrents = 0
    cbtt_download_link_image = 
    cbtt_hide_login_links = 0
    cbtt_ip_ban_mode = 0
    cbtt_ipban_file = bans.bnbt
    cbtt_page_number_count = 3
    cbtt_require_compact = 0
    cbtt_require_no_peer_id = 0
    cbtt_restrict_overflow = 0
    cbtt_restrict_overflow_limit = 1099511627776
    cbtt_restricted_peer_spoofing = 0
    cbtt_scrape_file = 
    cbtt_scrape_save_interval = 0
    cbtt_service_name = BNBT Service
    cbtt_stats_link_image = 
    dfile = dstate.bnbt
    downloader_timeout_interval = 2700
    favicon = 
    image_bar_fill = 
    image_bar_trans = 
    keep_dead = 1
    max_give = 200
    min_announce_interval = 1500
    min_request_interval = 18000
    mysql_cbtt_ttrader_support = 0
    mysql_database = bnbt
    mysql_host = 
    mysql_override_dstate = 0
    mysql_password = 
    mysql_port = 0
    mysql_refresh_allowed_interval = 0
    mysql_refresh_stats_interval = 600
    mysql_user = 
    only_local_override_ip = 0
    parse_allowed_interval = 5
    port = 6969
    response_size = 50
    save_dfile_interval = 300
    show_names = 1
    socket_timeout = 15
    EOF

* Create custom header and footer html-snippets::

    echo > /srv/tracker/cbtt/header.html <<EOF
    <h2 align=center>Welcome to the BitTorrent tracker hosted at <a href="http://www.documentfoundation.org">The Document Foundation</a></h2>
    <p>If you're looking for regular (non-bittorrent like http/ftp) downloads, you should visit <a href="http://www.documentfoundation.org/download/">http://www.documentfoundation.org/download/</a> instead.</p>
    <p><small>In case your download doesn't start despite the main seed being available: make sure that the IP (178.63.91.70) is not blocked by your client</small></p>
    EOF

    echo > /srv/tracker/cbtt/footer.html <<EOF
    <p><strong>Contribute by sharing your bandwidth - don't close the download immediately</strong></p>
    EOF

* Change ownership to the user under which ID the tracker should be running::

    sudo chown -R cloph: /srv/tracker/*

* Create the init script to have it launch at boot::

    sudo echo > /etc/init.d/tracker <<EOF
    #!/bin/bash
    ### BEGIN INIT INFO
    # Provides:          torrent_tracker
    # Required-Start:    $network $local_fs $syslog
    # Required-Stop:     $network $local_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Start the BitTorrent tracker
    ### END INIT INFO
    #######################
    ##Start Configuration##
    #######################
    #Do not put a space on either side of the equal signs e.g.
    # user = user 
    # will not work
    # system user to run as (can only use one)
    user="cloph"
    
    # default directory for screen, needs to be an absolute path
    #base=$(su -c 'echo $HOME' $user)
    base="/srv/tracker/cbtt"
    
    # name of screen session
    srnname="tracker"
    
    # file to log to (makes for easier debugging if something goes wrong)
    logfile="/var/log/trackerInit.log"
    #######################
    ###END CONFIGURATION###
    #######################
    
    DESC="cbtt tracker"
    NAME=bnbt
    DAEMON=$NAME
    SCRIPTNAME=/etc/init.d/tracker
    
    d_start() {
      [ -d "${base}" ] && cd "${base}"
      stty stop undef && stty start undef
      su -c "screen -ls | grep -sq "\.${srnname}[[:space:]]" " ${user} || su -c "screen -dm -S ${srnname} 2>&1" ${user} | tee -a "$logfile" >&2
      su -c "screen -S "${srnname}" -X screen ./bnbt" ${user} | tee -a "$logfile" >&2
    }
    
    d_stop() {
      if pgrep -u ${user} -x bnbt >/dev/null ; then
            pkill -u ${user} -x bnbt
      else
            echo -n " - not running"
      fi
    }
    
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

    sudo update-rc.d tracker defaults

* Add hooks to the :file:`/usr/local/bin/stage2pub` script to add the torrents to the tracker::

    # Torrent section - if anyone goes wrong here, blame cloph
    echo "downloading torrents from mirrorbrain"
    rm -f /srv/tracker/torrents_sync/*.torrent*
    su - cloph -c "cd /srv/active/pub && find libreoffice -type f -not -name \*md5 -not -name \*asc -not -name \*log -print0 | xargs -r -0 -I{path} wget -q --directory-prefix=/srv/tracker/torrents_sync http://download.documentfoundation.org/{path}.torrent"

    echo "updating torrents for the tracker"
    su - cloph -c "rsync -br --backup-dir=/srv/tracker/archived_torrents --delete --include=\*torrent /srv/tracker/torrents_sync/ /srv/tracker/allowed_torrents"
    su - cloph -c "cd /srv/tracker/allowed_torrents && cp -a /srv/rtorrent/watch_images/*.torrent ." # consider box torrents as well



Start
-----

::

  sudo /etc/init.d/tracker start



Stop
----

::

  sudo /etc/init.d/tracker stop



Disable
-------

::

  sudo update-rc.d tracker disable



Enable
------

::

  sudo update-rc.d enable enable



Responsible
-----------

If something wrong or fishy, contact cloph.
