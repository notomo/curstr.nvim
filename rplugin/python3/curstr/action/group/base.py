
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.echoable import Echoable
from curstr.exception import ActionGroupValidationError


class ActionGroup(Echoable, metaclass=ABCMeta):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    @abstractmethod
    def action_default(self):
        pass

    def _validate_error(self, message=''):
        raise ActionGroupValidationError(message)
