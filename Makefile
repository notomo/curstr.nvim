
test: python_test vim_test

python_test:
	./curstr_env/bin/pytest

vim_test:
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim nvim -u ./update_remote_plugins.vim -i NONE -n --headless +q
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim themis

lint:
	./curstr_env/bin/vint plugin/
	./curstr_env/bin/vint autoload/
	./curstr_env/bin/flake8 rplugin/python3/
	./curstr_env/bin/mypy --ignore-missing-imports rplugin/python3/

tag:
	ctags --options=.ctags

list:
	./curstr_env/bin/pip list --format=freeze --not-required

update_list:
	./curstr_env/bin/pip list -o --format=freeze

setup_dev:
	python3 -m venv curstr_env
	./curstr_env/bin/pip install -r ./requirements.txt

.PHONY: test
.PHONY: python_test
.PHONY: vim_test
.PHONY: lint
.PHONY: package_list
.PHONY: setup_dev
