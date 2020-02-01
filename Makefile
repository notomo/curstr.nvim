
test:
	CURSTR_ENV=./curstr_env/bin/ $(MAKE) _test

_test:
	$(MAKE) vim_test
	$(MAKE) lint

vim_test:
	NVIM_RPLUGIN_MANIFEST=rplugin.vim nvim -u ./update_remote_plugins.vim -i NONE -n --headless +q
	cat rplugin.vim
	THEMIS_ARGS="-e -s --headless" NVIM_RPLUGIN_MANIFEST=rplugin.vim themis

lint:
	$(CURSTR_ENV)vint plugin/
	$(CURSTR_ENV)vint autoload/
	$(CURSTR_ENV)flake8 rplugin/python3/ --ignore E203,E303,E402,W391,W503,E731 --max-line-length 88
	$(CURSTR_ENV)mypy --ignore-missing-imports rplugin/python3/
	$(CURSTR_ENV)black rplugin/python3/ --check

format:
	./curstr_env/bin/black rplugin/python3/

list:
	./curstr_env/bin/pip list --format=freeze --not-required

update_list:
	./curstr_env/bin/pip list --outdated --format=freeze

setup_dev:
	python3 -m venv curstr_env
	./curstr_env/bin/pip install -r ./requirements.txt

.PHONY: test
.PHONY: python_test
.PHONY: vim_test
.PHONY: lint
.PHONY: format
.PHONY: list
.PHONY: update_list
.PHONY: setup_dev
