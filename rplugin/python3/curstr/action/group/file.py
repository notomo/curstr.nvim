
from .base import ActionGroup


class File(ActionGroup):

    def __init__(self, vim, path) -> None:
        super().__init__(vim)
        self._path = path

    @property
    def path(self):
        return self._path

    @ActionGroup.action()
    def open(self):
        self._open('edit')

    @ActionGroup.action()
    def tab_open(self):
        self._open('tabedit')

    @ActionGroup.action()
    def vertical_open(self):
        self._open('vsplit')

    @ActionGroup.action()
    def horizontal_open(self):
        self._open('split')

    def _open(self, opener: str):
        self._vim.command('{} {}'.format(
            opener, self._path
        ))

    @ActionGroup.action()
    def default(self):
        self.open()
