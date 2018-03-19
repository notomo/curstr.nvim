

from abc import abstractmethod

from .base import ActionGroup


class Listable(ActionGroup):

    @abstractmethod
    def list(self):
        pass

    @ActionGroup.action()
    def default(self):
        self.list()
