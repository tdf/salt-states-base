vim:
  pkg.installed

/etc/vim/vimrc:
    file.managed:
     - source: salt://core/vimrc
     - user: root
     - group: root
     - mode: 0440
     - require:
       - pkg: vim
