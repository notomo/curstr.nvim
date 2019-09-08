import neovim

from .curstr import Curstr
from .importer import Importer


@neovim.plugin
class CurstrHandler(object):
    def __init__(self, vim: neovim.Nvim) -> None:
        importer = Importer(vim)
        self._curstr = Curstr(vim, importer)

    @neovim.function("_curstr_execute", sync=True)
    def execute(self, args):
        self._curstr.execute(args[0], args[1], args[2])
