{% from 'editor/map.jinja' import editor with context %}

emacs-nox:
  pkg:
    - installed
    - name: {{ editor.emacs_nox }}