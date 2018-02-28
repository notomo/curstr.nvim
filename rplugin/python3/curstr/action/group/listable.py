

from abc import abstractmethod

from .base import ActionGroup


class Listable(ActionGroup):

    @abstractmethod
    def action_list(self):
        pass

    def action_default(self):
        self.action_list()
