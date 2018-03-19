
from .base import ActionGroup


class Command(ActionGroup):

    def __init__(self, vim, command: str) -> None:
        super().__init__(vim)
        self._command = command

    @ActionGroup.action()
    def open(self):
        self._open('')

    @ActionGroup.action()
    def tab_open(self):
        self._open('tab')

    @ActionGroup.action()
    def vertical_open(self):
        self._open('vertical')

    @ActionGroup.action()
    def horizontal_open(self):
        self._open('split')

    def _open(self, opener: str):
        self._vim.command('{} {}'.format(
            opener, self._command
        ))

    @ActionGroup.action()
    def default(self):
        self.open()
