
from os.path import join

from curstr.action.group import ActionGroup, File, FileDispatcher
from curstr.action.source.base import ActionSource as Base
from curstr.custom import ActionSourceOption


class ActionSource(Base):

    _DISPATCHER_CLASS = FileDispatcher

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = join(self._vim.call('expand', '%:p:h'), path)
        return self._dispatcher.dispatch_one(File, absolute_path)
