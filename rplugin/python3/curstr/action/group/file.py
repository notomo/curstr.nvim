
from os.path import isfile

from .base import ActionGroup


class File(ActionGroup):

    def __init__(self, vim, path) -> None:
        super().__init__(vim)
        if not self._validate(path):
            raise self._validate_error(path)
        self._path = path

    @property
    def path(self):
        return self._path

    def action_open(self):
        self._open('edit')

    def action_tab_open(self):
        self._open('tabedit')

    def action_vertical_open(self):
        self._open('vsplit')

    def action_horizontal_open(self):
        self._open('split')

    def _open(self, opener: str):
        self._vim.command('{} {}'.format(
            opener, self._path
        ))

    def action_default(self):
        self.action_open()

    def _validate(self, path: str) -> bool:
        return isfile(path)
