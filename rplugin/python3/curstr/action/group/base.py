
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.echoable import Echoable


class ActionGroup(Echoable, metaclass=ABCMeta):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    @abstractmethod
    def action_default(self):
        pass
