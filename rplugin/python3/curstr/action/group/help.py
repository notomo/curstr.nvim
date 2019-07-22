
import pathlib

from .command import Command


class Help(Command):

    def __init__(self, vim, word: str) -> None:
        super().__init__(vim, 'help {}'.format(word))

    def name(self):
        return pathlib.Path(__file__).stem

    @Command.action()
    def open(self):
        self._open('')
        self._vim.command('only')

    @Command.action()
    def horizontal_open(self):
        self._open('')
