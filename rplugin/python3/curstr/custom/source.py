
from itertools import chain
from typing import Any  # noqa
from typing import Dict, List, Tuple

from neovim import Nvim

from curstr.exception import InvalidCustomException

from .base import Custom
from .execute import ExecuteOption


class SourceOption(object):

    def __init__(self, name: str, action_name: str, options: Dict) -> None:
        self._name = name
        if action_name:
            self._action_name = action_name
        else:
            self._action_name = options.get('action', 'default')
        self._options = options

    @property
    def name(self) -> str:
        return self._name

    @property
    def action_name(self) -> str:
        return self._action_name

    def get(self, key: str, default=None):
        return self._options.get(key, default)


class SourceCustom(Custom):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self._source_aliases = {
            'vim/function': [
                'vim/autoload_function',
                'vim/script_function',
            ],
            'file': [
                'file/buffer_relative',
                'file/path',
            ],
            'directory': [
                'directory/buffer_relative',
                'directory/path',
            ],
            'vim/runtime': [
                'vim/runtime/pattern/file',
                'vim/runtime/pattern/directory',
                'vim/runtime/file',
                'vim/runtime/directory',
            ],
        }
        self._source_options = {
            '_': {
                'exactly': False,
            }
        }  # type: Dict[str, Dict[str, Any]]

    def set_alias(self, alias: str, source_names: List[str]):
        self._source_aliases[alias] = source_names

    def apply_alias(
        self, source_names: List[str], execute_option: ExecuteOption
    ) -> List[SourceOption]:
        options = [
            (name, self._source_options.get(name, {}))
            for name in source_names
        ]
        aliased = chain.from_iterable(
            map(self._apply_alias, *zip(*options))
        )

        executed_action_name = execute_option.action_name
        return [
            SourceOption(
                name, executed_action_name,
                {**self._source_options['_'], **option}
            )
            for name, option in aliased
        ]

    def _apply_alias(
        self, name: str, option: Dict[str, str]
    ) -> List[Tuple[str, Dict[str, str]]]:
        aliased = self._source_aliases.get(name, name)
        if aliased == name:
            return [(name, option)]

        options = [
            (name, {**self._source_options.get(name, {}), **option})
            for name in aliased
        ]
        try:
            return list(chain.from_iterable(
                map(self._apply_alias, *zip(*options))
            ))
        except RecursionError:
            raise InvalidCustomException(
                'Invalid alias definition: {}'.format(name)
            )

    def set_option(self, source_name: str, option_name: str, value):
        option = self._source_options.get(source_name, {})
        option[option_name] = value
        self._source_options[source_name] = option
