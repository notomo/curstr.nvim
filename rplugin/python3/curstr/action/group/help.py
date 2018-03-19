

from .command import Command


class Help(Command):

    def __init__(self, vim, word: str) -> None:
        super().__init__(vim, 'help {}'.format(word))

    @Command.action()
    def open(self):
        self._open('')
        self._vim.command('only')

    @Command.action()
    def horizontal_open(self):
        self._open('')
