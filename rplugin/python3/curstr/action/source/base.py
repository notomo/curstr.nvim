
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action.cursor import Cursor
from curstr.action.group import ActionGroup, Dispatcher
from curstr.echoable import Echoable
from curstr.exception import LogicException


class Source(Echoable, metaclass=ABCMeta):

    DISPATCHER_CLASS = Dispatcher

    def __init__(
        self,
        vim: Nvim,
        dispatcher: Dispatcher,
        cursor: Cursor
    ) -> None:
        self._vim = vim
        self._dispatcher = dispatcher
        self._cursor = cursor

    @abstractmethod
    def create(self) -> ActionGroup:
        pass

    @property
    def name(self):
        return __file__.split(
            'rplugin/python3/curstr/action/source/'
        )[1].split('.')[0]

    def get_options(self):
        return {}

    def get_option(self, name: str):
        source_options = self._vim.call(
            'curstr#custom#get_source_options', self.name
        )
        options = {**self.get_options(), **source_options}
        if name not in options:
            raise LogicException('Not exist option: {}'.format(name))
        return options[name]
