
from typing import Dict, List, Union

from neovim import Nvim

from .exception import LogicException

OptionValue = Union[str, bool]
ExecuteOptions = Dict[str, OptionValue]


class ExecuteInfo(object):

    DEFAULT_OPTIONS = {
        'use-cache': True,
        'action_name': 'default',
        'string': '',
    }  # type: ExecuteOptions

    def __init__(
        self,
        vim: Nvim,
        source_names: List[str],
        options: ExecuteOptions
    ) -> None:
        self._source_names = source_names
        user_options = vim.call('curstr#custom#get_execute_options')
        self._options = {
            **self.DEFAULT_OPTIONS, **user_options, **options
        }

    @classmethod
    def from_arg_string(cls, vim: Nvim, arg_string: str) -> 'ExecuteInfo':
        source_names = []
        options = {}  # type: ExecuteOptions
        for arg in arg_string.split(' '):
            key_value = arg.split('=')
            key = key_value[0]
            if not key.startswith('-'):
                source_names.append(key)
            elif len(key_value) > 1:
                options[key[1:]] = key_value[1]
            else:
                options[key[1:]] = True

        return cls(vim, source_names, options)

    @property
    def use_cache(self) -> bool:
        use_cache = self._options['use-cache']
        if not isinstance(use_cache, bool):
            raise LogicException('use-cache must be bool')
        return use_cache

    @property
    def string(self) -> str:
        string = self._options['string']
        if not isinstance(string, str):
            raise LogicException('string must be str')
        return string

    @property
    def action_name(self) -> str:
        action_name = self._options['action_name']
        if not isinstance(action_name, str):
            raise LogicException('action_name must be str')
        return action_name

    @property
    def source_names(self) -> List[str]:
        return self._source_names
