

from .command import Command


class Tag(Command):

    def __init__(self, vim, word: str) -> None:
        super().__init__(vim, 'tag {}'.format(word))

    @Command.action()
    def vertical_open(self):
        self._vim.command('vsplit')
        self._open('')

    @Command.action()
    def horizontal_open(self):
        self._vim.command('split')
        self._open('')
