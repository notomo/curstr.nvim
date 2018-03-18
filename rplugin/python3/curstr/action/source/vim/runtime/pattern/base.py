
from glob import iglob
from itertools import chain
from os.path import join

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class BaseSource(Base):

    DISPATCHER_CLASS = FileDispatcher

    def _create(self, action_group_class) -> ActionGroup:
        try:
            self._vim.command('setlocal isfname+={}'.format('*'))
            path_pattern = self._vim.call('expand', '<cfile>')
        finally:
            self._vim.command('setlocal isfname-={}'.format('*'))

        runtime_glob_paths = chain(*[
            iglob(join(runtime_path, path_pattern), recursive=True)
            for runtime_path
            in self._vim.options['runtimepath'].split(',')
        ])

        return self._dispatcher.dispatch((
            (action_group_class, path)
            for path in runtime_glob_paths
        ))
