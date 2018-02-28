
from .base import ActionGroup


class Command(ActionGroup):

    def __init__(self, vim, command: str) -> None:
        super().__init__(vim)
        self._command = command

    def action_open(self):
        self._open('')

    def action_tab_open(self):
        self._open('tab')

    def action_vertical_open(self):
        self._open('vertical')

    def action_horizontal_open(self):
        self._open('split')

    def _open(self, opener: str):
        self._vim.command('{} {}'.format(
            opener, self._command
        ))

    def action_default(self):
        self.action_open()
