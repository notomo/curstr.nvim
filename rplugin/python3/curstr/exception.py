
class LogicException(Exception):
    pass


class InvalidCustomException(Exception):
    pass


class ActionSourceNotFoundException(Exception):

    def __init__(self, action_source_name: str) -> None:
        self._action_source_name = action_source_name

    def __str__(self):
        return 'ActionSource "{}" is not found.'.format(
            self._action_source_name
        )


class ActionModuleNotFoundException(Exception):

    def __init__(self, module_type: str, action_module_name: str) -> None:
        self._module_type = module_type
        self._action_module_name = action_module_name

    def __str__(self):
        return 'action {} "{}" is not found.'.format(
            self._module_type,
            self._action_module_name
        )
