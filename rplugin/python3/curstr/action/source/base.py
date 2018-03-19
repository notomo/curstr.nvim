
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action.cursor import Cursor
from curstr.action.group import ActionGroup, Dispatcher
from curstr.custom import SourceOption
from curstr.echoable import Echoable


class Source(Echoable, metaclass=ABCMeta):

    DISPATCHER_CLASS = Dispatcher

    def __init__(
        self,
        vim: Nvim,
        dispatcher: Dispatcher,
        option: SourceOption
    ) -> None:
        self._vim = vim
        self._dispatcher = dispatcher
        self._option = option
        self._cursor = Cursor(vim, option)

    @abstractmethod
    def create(self) -> ActionGroup:
        pass
