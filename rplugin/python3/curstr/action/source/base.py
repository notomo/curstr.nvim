
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action import Action
from curstr.action.group import ActionGroup, Dispatcher
from curstr.custom import ActionSourceOption
from curstr.echoable import Echoable


class ActionSource(Echoable, metaclass=ABCMeta):

    _DISPATCHER_CLASS = Dispatcher

    def __init__(self, vim: Nvim, dispatcher: Dispatcher) -> None:
        self._vim = vim
        self._dispatcher = dispatcher

    def create(self, option: ActionSourceOption) -> Action:
        action_group = self._create_action_group(option)
        return Action(action_group, option.action_name)

    @abstractmethod
    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        pass
