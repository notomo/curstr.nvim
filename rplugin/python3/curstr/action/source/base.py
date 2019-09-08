from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action.cursor import Cursor
from curstr.action.group import ActionGroup, Dispatcher
from curstr.echoable import Echoable
from curstr.exception import LogicException
from curstr.info import Options  # noqa
from curstr.info import SourceExecuteInfo


class Source(Echoable, metaclass=ABCMeta):

    DISPATCHER_CLASS = Dispatcher

    def __init__(
        self, vim: Nvim, dispatcher: Dispatcher, info: SourceExecuteInfo, cursor: Cursor
    ) -> None:
        self._vim = vim
        self._dispatcher = dispatcher
        self._info = info
        self._cursor = cursor
        self._base_options = {"filetypes": ["_"]}  # type: Options

    @abstractmethod
    def create(self) -> ActionGroup:
        pass

    def get_options(self):
        return {}

    def get_option(self, name: str):
        options = {
            **self._base_options,
            **self.get_options(),
            **self._info.source_options,
        }
        if name not in options:
            raise LogicException("Not exist option: {}".format(name))
        return options[name]

    def enabled(self) -> bool:
        filetypes = self.get_option("filetypes")

        if "_" in filetypes:
            return True

        filetype = self._vim.current.buffer.options["filetype"]
        if filetype in filetypes:
            return True

        filetype_alias = self._vim.call("curstr#custom#get_filetype_aliase", filetype)
        aliased = filetype_alias if len(filetype_alias) != 0 else filetype
        return aliased in filetypes

    @property
    def action_name(self) -> str:
        return self._info.action_name
