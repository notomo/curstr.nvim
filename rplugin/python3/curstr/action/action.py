
from curstr.action.group import ActionGroup, Nothing


class Action(object):

    def __init__(self, action_group: ActionGroup, action_name: str) -> None:
        self._action_group = action_group
        self._action_name = action_name

    def execute(self):
        getattr(self._action_group, self._get_method_name())()

    def is_executable(self) -> bool:
        return (
            hasattr(self._action_group, self._get_method_name()) and
            not isinstance(self._action_group, Nothing)
        )

    def _get_method_name(self) -> str:
        return 'action_{}'.format(self._action_name)
