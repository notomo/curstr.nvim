let g:python3_host_prog = expand('<sfile>:h') . '/curstr_env/bin/python3'
execute 'set runtimepath+=' . expand('<sfile>:h')
runtime! plugin/rplugin.vim
UpdateRemotePlugins
