
test: python_test vim_test

python_test:
	python3 -m pytest

vim_test:
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim nvim -u ./update_remote_plugins.vim -i NONE -n --headless +q
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim themis

.PHONY: test
.PHONY: python_test
.PHONY: vim_test

