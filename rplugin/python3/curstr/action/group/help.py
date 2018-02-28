

from .command import Command


class Help(Command):

    def __init__(self, vim, word: str) -> None:
        super().__init__(vim, 'help {}'.format(word))

    def action_open(self):
        self._open('')
        self._vim.command('only')

    def action_horizontal_open(self):
        self._open('')
