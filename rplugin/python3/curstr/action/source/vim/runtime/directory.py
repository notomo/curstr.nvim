
from curstr.action.group import ActionGroup, Directory
from curstr.custom import ActionSourceOption

from .base import ActionSource as Base


class ActionSource(Base):

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        return self.__create_action_group(Directory)
