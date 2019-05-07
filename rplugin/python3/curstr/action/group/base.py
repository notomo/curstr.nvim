
import inspect

from neovim import Nvim

from curstr.echoable import Echoable


class ActionGroup(Echoable):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim
        self._actions = {
            method[1]._action_name: method[1]
            for method
            in inspect.getmembers(self)
            if hasattr(method[1], '_is_action')
        }

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

    def _modifiable(self, action_name: str) -> bool:
        modify = self._actions[action_name]._modify
        if not modify:
            return True
        return modify and self._vim.current.buffer.options['modifiable']
