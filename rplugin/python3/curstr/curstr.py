
from typing import Any, Dict, List

from neovim import Nvim

from curstr.echoable import Echoable

from .action import ActionFacade
from .custom import CustomFacade
from .importer import Importer


class Curstr(Echoable):

    def __init__(self, vim: Nvim, importer: Importer) -> None:
        self._vim = vim
        self._custom_facade = CustomFacade(vim)
        self._action_facade = ActionFacade(vim, importer)

    def execute(self, arg_string: str) -> None:
        option_set = self._custom_facade.get_option_set(arg_string)
        self._action_facade.execute(option_set)

    def custom(self, custom_type: str, args_list: List[Dict[str, Any]]):
        for args in args_list:
            self._custom_facade.set(custom_type, args)
