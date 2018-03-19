
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

    def action(name=None):
        def decorator(func):
            func._is_action = True
            if name:
                func._action_name = name
            else:
                func._action_name = func.__name__
            return func

        return decorator

    def has(self, action_name: str) -> bool:
        return action_name in self._actions

    def call(self, action_name: str):
        return self._actions[action_name]()
