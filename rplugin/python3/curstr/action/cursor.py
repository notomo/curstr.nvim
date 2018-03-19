
from neovim import Nvim

from curstr.custom import SourceOption
from curstr.echoable import Echoable


class Cursor(Echoable):

    def __init__(self, vim: Nvim, option: SourceOption) -> None:
        self._vim = vim
        self._option = option

    def target_option(func):
        def wrapper(self, *args, **kwargs):
            target_string = self._option.get('str')
            if target_string:
                return target_string
            return func(self, *args, **kwargs)

        return wrapper

    @target_option
    def get_word(self, added_iskeyword='') -> str:
        if added_iskeyword == '':
            return self._vim.call('expand', '<cword>')

        added = ','.join(added_iskeyword)
        try:
            self._vim.command('setlocal iskeyword+={}'.format(added))
            word = self._vim.call('expand', '<cword>')
        finally:
            self._vim.command('setlocal iskeyword-={}'.format(added))

        return word

    @target_option
    def get_file_path(self, added_isfname='') -> str:
        if added_isfname == '':
            return self._vim.call('expand', '<cfile>')

        added = ','.join(added_isfname)
        try:
            self._vim.command('setlocal isfname+={}'.format(added))
            file_path = self._vim.call('expand', '<cfile>')
        finally:
            self._vim.command('setlocal isfname-={}'.format(added))

        return file_path
