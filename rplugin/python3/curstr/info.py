
from itertools import chain
from typing import Any, Dict, List, Union

from neovim import Nvim

from .exception import LogicException

OptionValue = Union[str, bool, int, Any]
# Recursive types not fully supported yet, nested types replaced with "Any"
Options = Dict[str, OptionValue]


class SourceExecuteInfo(object):

    def __init__(
        self,
        source_name: str,
        source_options: Options,
        execute_options: Options
    ) -> None:
        self._source_name = source_name
        self._source_options = source_options
        self._execute_options = execute_options

    @property
    def source_name(self) -> str:
        return self._source_name

    @property
    def source_options(self) -> Options:
        return self._source_options

    @property
    def use_cache(self) -> bool:
        use_cache = self._execute_options['use-cache']
        if not isinstance(use_cache, bool):
            raise LogicException('use-cache must be bool')
        return use_cache

    @property
    def string(self) -> str:
        string = self._execute_options['string']
        if not isinstance(string, str):
            raise LogicException('string must be str')
        return string

    @property
    def action_name(self) -> str:
        action_name = self._execute_options['action']
        if not isinstance(action_name, str):
            raise LogicException('action_name must be str')
        return action_name


class ExecuteInfo(object):

    _DEFAULT_EXECUTE_OPTIONS = {
        'use-cache': True,
        'action': 'default',
        'string': '',
    }  # type: Options

    def __init__(
        self,
        vim: Nvim,
        source_names: List[str],
        execute_options: Options
    ) -> None:
        self._vim = vim

        user_options = vim.call(
            'curstr#custom#get_execute_options', '_'
        )
        default_execute_options = {
            **self._DEFAULT_EXECUTE_OPTIONS, **user_options,
        }

        source_names = sorted(
            set(source_names), key=source_names.index
        )

        self._source_execute_infos = list(chain.from_iterable((
            self._resolve_source_name(
                name, {}, execute_options, default_execute_options
            )
            for name in source_names
        )))

    @classmethod
    def from_arg_string(cls, vim: Nvim, arg_string: str) -> 'ExecuteInfo':
        source_names = []
        options = {}  # type: Options
        for arg in arg_string.split(' '):
            key_value = arg.split('=')
            key = key_value[0]
            if not key.startswith('-'):
                source_names.append(key)
            elif len(key_value) > 1:
                options[key[1:]] = key_value[1]
            else:
                options[key[1:]] = True

        source_names = list(filter(
            lambda x: len(x) != 0, source_names
        ))

        return cls(vim, source_names, options)

    def _resolve_source_name(
        self,
        source_name: str,
        preferred_source_options: Options,
        preferred_execute_options: Options,
        default_execute_options: Options
    ):
        source_options = self._vim.call(
            'curstr#custom#get_source_options', source_name
        )
        source_execute_options = self._vim.call(
            'curstr#custom#get_execute_options', source_name
        )
        aliased_source_name = self._vim.call(
            'curstr#custom#get_source_aliases', source_name
        )

        source_options = {
            **source_options,
            **preferred_source_options
        }
        source_execute_options = {
            **default_execute_options,
            **source_execute_options,
            **preferred_execute_options
        }

        if len(aliased_source_name) == 0:
            return [SourceExecuteInfo(
                source_name,
                source_options,
                source_execute_options
            )]

        infos = (
            self._resolve_source_name(
                name,
                source_options,
                source_execute_options,
                default_execute_options
            )
            for name in aliased_source_name
        )
        return chain.from_iterable(infos)

    @property
    def source_execute_infos(self) -> List[SourceExecuteInfo]:
        return self._source_execute_infos
