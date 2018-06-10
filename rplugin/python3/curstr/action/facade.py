
from neovim import Nvim

from curstr.action.group import ActionGroup
from curstr.echoable import Echoable
from curstr.importer import Importer
from curstr.info import ExecuteInfo


class Action(object):

    def __init__(self, action_group: ActionGroup, action_name: str) -> None:
        self._action_group = action_group
        self._action_name = action_name

    def execute(self):
        self._action_group.call(self._action_name)

    def is_executable(self) -> bool:
        return self._action_group.has(self._action_name)


class ActionFacade(Echoable):

    def __init__(self, vim: Nvim, importer: Importer) -> None:
        self._vim = vim
        self._importer = importer

    def execute(self, info: ExecuteInfo):
        for source in self._importer.get_sources(info):
            group = source.create()
            action = Action(group, info.action_name)
            if action.is_executable():
                return action.execute()
        return None
