

from neovim import Nvim

from curstr.echoable import Echoable

from .action import ActionFacade
from .importer import Importer
from .info import ExecuteInfo


class Curstr(Echoable):

    def __init__(self, vim: Nvim, importer: Importer) -> None:
        self._vim = vim
        self._action_facade = ActionFacade(vim, importer)

    def execute(self, arg_string: str) -> None:
        info = ExecuteInfo.from_arg_string(self._vim, arg_string)
        self._action_facade.execute(info)
