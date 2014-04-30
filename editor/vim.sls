{% from 'editor/map.jinja' import editor with context %}

include:
  - requisites

# installs vim-package
vim:
  pkg:
    - installed
    - name: {{ editor.vim }}

# change vimrc (vim-configguration) to most common settings
/etc/vim/vimrc:
  file.managed:
    - source: salt://editor/vimrc
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: vim

installed-packages-editor-vim:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - {{ editor.vim }}
    - require_in:
      - file: /root/saltdoc/installed_packages.rst