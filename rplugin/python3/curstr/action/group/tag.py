

from .command import Command


class Tag(Command):

    def __init__(self, vim, word: str) -> None:
        super().__init__(vim, 'tag {}'.format(word))

    def action_vertical_open(self):
        self._vim.command('vsplit')
        self._open('')

    def action_horizontal_open(self):
        self._vim.command('split')
        self._open('')
