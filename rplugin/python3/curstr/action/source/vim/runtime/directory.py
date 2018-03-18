
from curstr.action.group import ActionGroup, Directory
from curstr.custom import SourceOption

from .base import Source as Base


class Source(Base):

    def create(self, option: SourceOption) -> ActionGroup:
        return self.__create_action_group(Directory)
