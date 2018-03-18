
from typing import Any, Dict, List

from neovim import Nvim

from curstr.echoable import Echoable
from curstr.exception import LogicException

from .source import SourceCustom, SourceOption
from .execute import ExecuteCustom, ExecuteOption
from .filetype import FiletypeCustom


class OptionSet(Echoable):

    def __init__(
        self,
        vim: Nvim,
        source_options: List[SourceOption],
        execute_option: ExecuteOption
    ) -> None:
        self._vim = vim
        self._source_options = source_options
        self._execute_option = execute_option

    def get(self, name: str):
        pass

    @property
    def source_options(self):
        return self._source_options

    @property
    def source_names(self) -> List[str]:
        return self._execute_option._source_names

    @property
    def action_name(self) -> str:
        return self._execute_option._action_name

    @property
    def use_cache(self) -> bool:
        return self._execute_option._use_cache


class CustomFacade(Echoable):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim
        self._filetype_custom = FiletypeCustom(vim)
        self._source_custom = SourceCustom(vim)
        self._execute_custom = ExecuteCustom(vim)

    def set(self, custom_type: str, args: Dict[str, Any]):
        if custom_type == 'filetype_source':
            return self._filetype_custom.set(
                args['filetype'], args['source_names']
            )
        if custom_type == 'filetype_alias':
            return self._filetype_custom.set_alias(
                args['alias'], args['filetype']
            )
        if custom_type == 'source_alias':
            return self._source_custom.set_alias(
                args['alias'], args['source_names']
            )
        if custom_type == 'source_option':
            return self._source_custom.set_option(
                args['source_name'], args['option_name'], args['value']
            )
        if custom_type == 'execute_option':
            return self._execute_custom.set(
                args['option_name'], args['value']
            )

        raise LogicException('Invalid custom_type: {}'.format(custom_type))

    def get_option_set(self, arg_string: str) -> OptionSet:
        execute_option = self._execute_custom.get(arg_string)
        if execute_option.source_names:
            source_names = execute_option.source_names
        else:
            source_names = self._filetype_custom.get(
                self._vim.current.buffer.options['filetype']
            )
        source_options = self._source_custom.apply_alias(
            source_names, execute_option
        )
        return OptionSet(self._vim, source_options, execute_option)
