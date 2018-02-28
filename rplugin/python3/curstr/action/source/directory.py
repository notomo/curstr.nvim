
import os.path

from curstr.action.group import ActionGroup, Directory, Nothing
from curstr.custom import ActionSourceOption

from .base import ActionSource as Base


class ActionSource(Base):

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        return self._get_action_group(path)

    def _get_action_group(self, path: str) -> ActionGroup:
        absolute_path = self._vim.call('fnamemodify', path, ':p')
        if not os.path.isdir(absolute_path):
            return Nothing(self._vim)
        return Directory(self._vim, absolute_path)
