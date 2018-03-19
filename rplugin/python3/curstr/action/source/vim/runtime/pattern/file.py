
from curstr.action.group import ActionGroup, FileDispatcher

from .base import BaseSource


class Source(BaseSource):

    def create(self) -> ActionGroup:
        return self._create(FileDispatcher.File)
