
from os.path import join

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class BaseSource(Base):

    DISPATCHER_CLASS = FileDispatcher

    def _create(self, action_group_class) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')

        return self._dispatcher.dispatch((
            (action_group_class, join(runtime_path, path))
            for runtime_path
            in self._vim.options['runtimepath'].split(',')
        ))
