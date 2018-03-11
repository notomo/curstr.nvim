
from neovim import Nvim

from curstr.action.group.base import ActionGroup
from curstr.action.group.nothing import Nothing


class Dispatcher(object):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    def dispatch(self, *class_and_args):

        mapper = self._mapper()

        def execute(class_and_args) -> ActionGroup:
            cls = class_and_args[0]
            arg = class_and_args[1:]
            validate = mapper[cls]
            if validate(*arg):
                return cls(self._vim, *arg)
            return None

        groups = (
            y for y in
            (execute(x) for x in class_and_args)
            if y is not None
        )
        try:
            return next(groups)
        except StopIteration:
            return self.nothing()

    def nothing(self):
        return Nothing(self._vim)

    def _mapper(self):
        return {}
