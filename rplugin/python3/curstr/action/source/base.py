
from abc import ABCMeta, abstractmethod

from neovim import Nvim

from curstr.action import Action
from curstr.action.group import ActionGroup, Nothing
from curstr.custom import ActionSourceOption
from curstr.echoable import Echoable
from curstr.exception import ActionGroupValidationError


class ActionSource(Echoable, metaclass=ABCMeta):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    def create(self, option: ActionSourceOption) -> Action:
        action_group = self._create_action_group(option)
        return Action(action_group, option.action_name)

    @abstractmethod
    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        pass

    def _dispatch(self, *class_and_args) -> ActionGroup:

        def execute(class_and_arg):
            cls = class_and_arg[0]
            arg = class_and_arg[1:]
            try:
                return cls(self._vim, *arg)
            except ActionGroupValidationError:
                return False

        groups = (
            y for y in
            (execute(x) for x in class_and_args)
            if y is not False
        )
        try:
            return next(groups)
        except StopIteration:
            return self._nothing()

    def _nothing(self):
        return Nothing(self._vim)
