
test: python_test vim_test

python_test:
	python3 -m pytest

vim_test:
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim nvim -u ./update_remote_plugins.vim -i NONE -n --headless +q
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim themis

lint:
	vint plugin/
	vint autoload/
	flake8 rplugin/python3/
	mypy --ignore-missing-imports rplugin/python3/

tag:
	ctags --options=.ctags

.PHONY: test
.PHONY: python_test
.PHONY: vim_test
.PHONY: lint

