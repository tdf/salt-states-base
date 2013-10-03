# installs vim-package
vim:
	pkg.installed

# change vimrc (vim-configguration) to most common settings
/etc/vim/vimrc:
	file.managed:
		- source: salt://editor/vimrc
		- user: root
		- group: root
		- mode: 0644
		- require:
		- pkg: vim