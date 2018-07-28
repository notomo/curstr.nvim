
from typing import Tuple

from neovim import Nvim

from curstr.echoable import Echoable
from curstr.info import SourceExecuteInfo


class Cursor(Echoable):

    def __init__(self, vim: Nvim, info: SourceExecuteInfo) -> None:
        self._vim = vim
        self._info = info

    def target_option(func):
        def wrapper(self, *args, **kwargs):
            target_string = self._info.string
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

    def get_word_with_range(self) -> Tuple[str, Tuple[int, int]]:
        current_pos = self._vim.current.window.cursor
        word_range = self._vim.call(
            'matchstrpos',
            self._vim.current.line,
            '\\v\w*%{}v\w+'.format(current_pos[1] + 1)
        )[1:]

        if word_range[0] == -1:
            return ('', (-1, -1))

        word = self.get_word()

        return (word, word_range)

    @target_option
    def get_line(self) -> str:
        line = self._vim.current.line
        return line
