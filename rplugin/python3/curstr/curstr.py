
from typing import Any, Dict, List, Optional

from neovim.api.nvim import Nvim

from curstr.echoable import Echoable

from .action import Action
from .custom import CustomFacade, ExecuteOption
from .importer import Importer


class Curstr(Echoable):

    def __init__(self, vim: Nvim, importer: Importer) -> None:
        self._vim = vim
        self._custom = CustomFacade(vim)
        self._importer = importer

        if hasattr(self._vim, 'channel_id'):
            self._vim.vars['curstr#_channel_id'] = self._vim.channel_id

    def execute(self, arg_string: str) -> None:
        execute_option = self._custom.get_execute_option(arg_string)
        action = self._get_action(execute_option)
        if action is not None:
            action.execute()
        else:
            self.echo_message('Not found!')

    def custom(self, custom_type: str, args_list: List[Dict[str, Any]]):
        for args in args_list:
            self._custom.set(custom_type, args)

    def _get_action(self, execute_option: ExecuteOption) -> Optional[Action]:
        source_options = self._custom.get_action_source_options(execute_option)

        use_cache = execute_option.use_cache
        for source_option in source_options:
            action_source = self._importer.get_action_source(
                source_option.name, use_cache
            )
            action = action_source.create(source_option)
            if action.is_executable():
                return action
        return None
