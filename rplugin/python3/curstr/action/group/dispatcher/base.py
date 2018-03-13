
from neovim import Nvim

from curstr.action.group.base import ActionGroup
from curstr.action.group.nothing import Nothing
from curstr.echoable import Echoable


class Dispatcher(Echoable):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim

    def dispatch(self, class_and_args):

        mapper = {
            str(key): value
            for key, value
            in self._mapper().items()
        }

        def execute(class_and_arg) -> ActionGroup:
            cls = class_and_arg[0]
            arg = class_and_arg[1:]
            validate = mapper[str(cls)]
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

    def dispatch_one(self, cls, *args):
        return self.dispatch(((cls, *args),))

    def nothing(self):
        return Nothing(self._vim)

    def _mapper(self):
        return {}
