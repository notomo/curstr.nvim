
test: python_test vim_test lint

python_test:
	./curstr_env/bin/pytest

vim_test:
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim nvim -u ./update_remote_plugins.vim -i NONE -n --headless +q
	NVIM_RPLUGIN_MANIFEST=$(HOME)/rplugin.vim themis

lint:
	./curstr_env/bin/vint plugin/
	./curstr_env/bin/vint autoload/
	./curstr_env/bin/flake8 rplugin/python3/ --ignore E203,E303,E402,W391,W503,E731 --max-line-length 88
	./curstr_env/bin/mypy --ignore-missing-imports rplugin/python3/
	./curstr_env/bin/black rplugin/python3/ --check

format:
	./curstr_env/bin/black rplugin/python3/

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
.PHONY: format
.PHONY: list
.PHONY: package_list
.PHONY: setup_dev
