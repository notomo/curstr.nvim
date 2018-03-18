
from curstr.action.group import ActionGroup, FileDispatcher
from curstr.custom import SourceOption

from .base import BaseSource


class Source(BaseSource):

    def create(self, option: SourceOption) -> ActionGroup:
        return self._create(FileDispatcher.File)
