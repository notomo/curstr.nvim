
from typing import Any, Dict, List

from neovim.api.nvim import Nvim

from curstr.echoable import Echoable
from curstr.exception import LogicException

from .action_source import ActionSourceCustom, ActionSourceOption
from .execute import ExecuteCustom, ExecuteOption
from .filetype import FiletypeCustom


class CustomFacade(Echoable):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim
        self._filetype_custom = FiletypeCustom(vim)
        self._action_source_custom = ActionSourceCustom(vim)
        self._execute_custom = ExecuteCustom(vim)

    def set(self, custom_type: str, args: Dict[str, Any]):
        if custom_type == 'filetype_action_source':
            return self._filetype_custom.set(
                args['filetype'], args['action_source_names']
            )
        if custom_type == 'filetype_alias':
            return self._filetype_custom.set_alias(
                args['alias'], args['filetype']
            )
        if custom_type == 'action_source_alias':
            return self._action_source_custom.set_alias(
                args['alias'], args['action_source_names']
            )
        if custom_type == 'action_source_option':
            return self._action_source_custom.set_option(
                args['action_source_name'], args['option_name'], args['value']
            )
        if custom_type == 'execute_option':
            return self._execute_custom.set(
                args['option_name'], args['value']
            )

        raise LogicException('Invalid custom_type: {}'.format(custom_type))

    def get_execute_option(self, arg_string: str) -> ExecuteOption:
        return self._execute_custom.get(arg_string)

    def get_action_source_options(
        self, execute_option: ExecuteOption
    ) -> List[ActionSourceOption]:
        if execute_option.action_source_names:
            action_source_names = execute_option.action_source_names
        else:
            action_source_names = self._filetype_custom.get(
                self._vim.current.buffer.options['filetype']
            )
        return self._action_source_custom.apply_alias(
            action_source_names, execute_option
        )
