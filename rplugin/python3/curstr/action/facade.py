
from neovim import Nvim

from curstr.action.group import ActionGroup, Nothing
from curstr.custom import OptionSet
from curstr.echoable import Echoable
from curstr.importer import Importer


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


class ActionFacade(Echoable):

    def __init__(self, vim: Nvim, importer: Importer) -> None:
        self._vim = vim
        self._importer = importer

    def execute(self, option_set: OptionSet):
        use_cache = option_set.use_cache
        for option in option_set.source_options:
            source = self._importer.get_source(
                option.name, use_cache
            )
            group = source.create(option)
            action = Action(group, option.action_name)
            if action.is_executable():
                return action.execute()
        return None
