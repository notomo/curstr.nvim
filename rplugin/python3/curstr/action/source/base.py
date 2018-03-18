
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action.group import ActionGroup, Dispatcher
from curstr.custom import SourceOption
from curstr.echoable import Echoable


class Source(Echoable, metaclass=ABCMeta):

    DISPATCHER_CLASS = Dispatcher

    def __init__(self, vim: Nvim, dispatcher: Dispatcher) -> None:
        self._vim = vim
        self._dispatcher = dispatcher

    @abstractmethod
    def create(self, option: SourceOption) -> ActionGroup:
        pass
