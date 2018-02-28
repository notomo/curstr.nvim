
from curstr.exception import LogicException

from .base import ActionGroup


class Nothing(ActionGroup):

    def action_default(self):
        raise LogicException(
            'Nothing ActionGroup doesn\'t have default action.'
        )
