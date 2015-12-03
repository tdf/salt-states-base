
.. index:: pair: service; redmine
.. index:: url; redmine.documentfoundation.org
.. index:: Project Management

Redmine
=======

Redmine is a ticketing system with Bug/Featuretracker, Wiki, Forum, File and Projectmanagement based on Ruby on Rails.

Open questions
--------------

* Check whether files are publicly accessible even when in private ticket
* CalDAV Plugin?
* Default Owner außerhalb von Kategorien, oder Monitoring-Nutzer
* Assignen an Non-Project-Member?
* http://www.redmine.org/projects/redmine/wiki/RedmineRepositories
* http://www.redmine.org/issues/5864
* Logrotate auf http://www.redmine.org/projects/redmine/wiki/RedmineInstall
* Plugins
* gem update / bundle update?


Installation
------------

* install ruby::

    apt-get install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 libopenssl-ruby1.9.1 libssl-dev zlib1g-dev libruby1.9.1 ri1.9.1 ruby1.9.1 ruby1.9.1-dev

* select correct versions with `update-alternatives`::

    update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 --slave /usr/share/man/man1/ruby.1.gz ruby.1.gz /usr/share/man/man1/ruby1.9.1.1.gz --slave /usr/bin/ri ri /usr/bin/ri1.9.1 --slave /usr/bin/irb irb /usr/bin/irb1.9.1 --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

    update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.1 400

* install other dependencies (with mysql and apache-passenger)::

    apt-get -y install libmysqlclient-dev
    gem install bundler mysql2 passenger
    apt-get -y install libopenid-ruby libhmac-ruby1.8 libopenid-ruby libopenid-ruby1.8 ruby-hmac
    apt-get -y install ruby-rmagick
    apt-get -y install apache2-threaded-dev libapr1-dev libaprutil1-dev apache2-threaded-dev libapr1-dev libaprutil1-dev libpcre3-dev libpcrecpp0 libpq-dev libsqlite3-dev uuid-dev

* download and install redmine to :file:`/srv/redmine/`::

    cd /srv
    wget http://www.redmine.org/releases/redmine-2.5.1.tar.gz
    tar xvfz redmine-2.5.1.tar.gz
    rm redmine-2.5.1.tar.gz
    mv /srv/redmine-2.5.1 /srv/redmine
    #ln -s /srv/redmine/public /var/www/sites/redmine.documentfoundation.org


* setup database::

    export REDMINEPASS=$(date | sha256sum | awk {'print $1'})
    echo $REDMINEPASS
    mysql -u root -p -e 'create database redmine character set utf8; create user redmine@localhost identified by "'$REDMINEPASS'"; grant all privileges on redmine.* to redmine@localhost; flush privileges;'

    cat > /srv/redmine/config/database.yml << EOF
    production:
     adapter: mysql2
     database: redmine
     host: localhost
     username: redmine
     password: $REDMINEPASS
     encoding: utf8
    EOF

* install bundles::

    cd /srv/redmine
    bundle install --without development test rmagick

* run initial rake tasks::

    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data

* setup apache configuration::

    cat > /etc/apache2/conf.d/z9999redmine << EOF
    LoadModule passenger_module /var/lib/gems/1.9.1/gems/passenger-4.0.25/buildout/apache2/mod_passenger.so
    PassengerRoot /var/lib/gems/1.9.1/gems/passenger-4.0.25
    PassengerDefaultRuby /usr/bin/ruby1.9.1
    <IfModule mod_passenger.c>
    PassengerDefaultUser www-data
    </IfModule>
    EOF

* setup email send configuration::

    cat > /srv/redmine/config/configuration.yml << EOF
    production:
     email_delivery:
       delivery_method: :sendmail
    EOF

* add to :file:`/etc/apache2/sites-enabled/VHOST`:

  .. code-block:: apache

    RewriteEngine on
    RewriteRule ^(.*) https://%{SERVER_NAME}$1 [NE,L]
    DocumentRoot /srv/redmine/public
    <Directory /srv/redmine/public>
     RailsBaseURI /
     PassengerAppRoot /srv/redmine
     PassengerResolveSymlinksInDocumentRoot on
     Options FollowSymlinks
     Satisfy Any
     Order Allow,Deny
     Allow from all
    </Directory>


* update footer::

    sed -i '/^\s*Powered by/a\    | <a href="http://www.documentfoundation.org/privacy">Privacy Policy</a> | <a href="http://www.documentfoundation.org/imprint">Impressum (Legal Info)</a>' /srv/redmine/app/views/layouts/base.html.erb

* install passeneger as apache module::

    passenger-install-apache2-module

* prepare folders, files and apache::

    mkdir /srv/redmine/public/plugin_assets
    mkdir -p /srv/redmine/tmp/pdf
    chown -R www-data: /srv/redmine
    /etc/init.d/apache2 restart

    chmod ugo+rx /srv/redmine/extra/mail_handler/rdm-mailhandler.rb

* add VHost to /etc/postfix/virtual, setup aliases for redmine::

    export REDMINEPROJECT="generic"

    echo "redmine-$REDMINEPROJECT: \"|/srv/redmine/extra/mail_handler/rdm-mailhandler.rb --url https://redmine.documentfoundation.org --key rJXdConsN50cYXcv2qiQ --no-permission-check --no-check-certificate --unknown-user accept --project $REDMINEPROJECT --status New --tracker Bug --category e-mail --priority Normal --allow-override=project,status,tracker,category,priority,assigned_to,fixed_version,start_date,due_date,estimated_hours,done_ratio\"" >> /etc/aliases

    postalias /etc/aliases

    echo -e "$REDMINEPROJECT@redmine.documentfoundation.org\t\t\tredmine-$REDMINEPROJECT"
    # add to /etc/postfix/virtual
    postmap /etc/postfix/virtual

* Setup gitmike theme::

    cd /srv/redmine/public/themes
    git clone git://github.com/makotokw/redmine-theme-gitmike.git gitmike

* Finalize folder/apache::

    chown -R www-data: /srv/redmine
    /etc/init.d/apache2 restart

* Configure e-mail separators
* Create e-mail category
* Enable APIs
* Set mail sender accordingly
* Disable need for authentication
* Ticket, Gantt, Kalender aktivieren
* Nichtmiglied darf bei Ticket-Verfolgung alles außer privat/öffentlich markieren
* Abgabedatum zufügen bei Ticketauflistung in Konfiguration
* ebendort: Aktuelles Datum nicht als Beginndatum nehmen
* E-Mail als Blindkopie senden
* bei Forks: config/initializers/session_store.rb und :session_path => '/chiliproject/',
* exclude as attachment: smime.p7s, \*.vcf, signature.asc, encrypted.asc, winmail.dat
* Create "Generic" project for incoming tickets, mark it as private, add users


Responsible
-----------

Florian Effenberger
Alexander Werner
