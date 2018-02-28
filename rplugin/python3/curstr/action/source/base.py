
from abc import ABCMeta, abstractmethod

from neovim.api.nvim import Nvim

from curstr.action import Action
from curstr.action.group import ActionGroup
from curstr.custom import ActionSourceOption
from curstr.echoable import Echoable


class ActionSource(Echoable, metaclass=ABCMeta):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    def create(self, option: ActionSourceOption) -> Action:
        action_group = self._create_action_group(option)
        return Action(action_group, option.action_name)

    @abstractmethod
    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        pass
