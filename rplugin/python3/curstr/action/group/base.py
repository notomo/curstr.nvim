import inspect
from abc import ABCMeta, abstractmethod
from typing import Mapping

from neovim import Nvim

from curstr.echoable import Echoable
from curstr.exception import LogicException
from curstr.info import Options  # noqa


class ActionGroup(Echoable, metaclass=ABCMeta):
    def __init__(self, vim: Nvim) -> None:
        self._vim = vim
        self._actions = {
            method[1]._action_name: method[1]
            for method in inspect.getmembers(self)
            if hasattr(method[1], "_is_action")
        }
        self._options: Mapping[str, Options] = {}

    @abstractmethod
    def name(self) -> str:
        pass

    def action(name=None, modify=False):
        def decorator(func):
            func._is_action = True
            func._modify = modify
            if name:
                func._action_name = name
            else:
                func._action_name = func.__name__
            return func

        return decorator

    def has(self, action_name: str) -> bool:
        return action_name in self._actions and self._modifiable(action_name)

    def call(self, action_name: str):
        return self._actions[action_name]()

    def is_nothing(self) -> bool:
        return False

    def apply_options(self, options: Mapping[str, Options]):
        self._options = options

    def get_options(self) -> Options:
        return {}

    def get_option(self, name: str):
        group_options = self._options.get(self.name(), {})
        options = {**self.get_options(), **group_options}

        if name not in options:
            raise LogicException(f"Not exist option: {name}")

        return options[name]

    def _modifiable(self, action_name: str) -> bool:
        modify = self._actions[action_name]._modify
        if not modify:
            return True
        return modify and self._vim.current.buffer.options["modifiable"]
