
from typing import Dict, List, Tuple

from neovim.api.nvim import Nvim

from curstr.exception import InvalidCustomException

from .base import Custom


class ExecuteCustom(Custom):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self._options = {
            'use-cache': '1',
            'action': '',
        }

    def set(self, option_name: str, value):
        if option_name in self._options:
            self._options[option_name] = value
            return
        raise InvalidCustomException(
            '{} cannot be customized'.format(option_name)
        )

    def get(self, arg_string: str):
        action_source_names, options = self._parse_arg_string(arg_string)
        merged_options = {**self._options, **options}
        return ExecuteOption(action_source_names, merged_options)

    def _parse_arg_string(
        self, arg_string: str
    ) -> Tuple[List[str], Dict[str, str]]:
        options = {}
        action_source_names = []
        for arg in arg_string.split(' '):
            key_value = arg.split('=')
            key = key_value[0]
            if not key.startswith('-'):
                action_source_names.append(key)
            elif len(key_value) > 1:
                options[key[1:]] = key_value[1]
            else:
                options[key[1:]] = '1'

        return action_source_names, options


class ExecuteOption(object):

    def __init__(self, action_source_names: List[str], options: Dict) -> None:
        self._action_source_names = [
            x for x in action_source_names if len(x) > 0
        ]
        self._action_name = options.get('action', '')
        self._use_cache = bool(options.get('use-cache', True))

    @property
    def action_source_names(self) -> List[str]:
        return self._action_source_names

    @property
    def action_name(self) -> str:
        return self._action_name

    @property
    def use_cache(self) -> bool:
        return self._use_cache
