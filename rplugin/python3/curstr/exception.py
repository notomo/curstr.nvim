
class LogicException(Exception):
    pass


class InvalidCustomException(Exception):
    pass


class SourceNotFoundException(Exception):

    def __init__(self, source_name: str) -> None:
        self._source_name = source_name

    def __str__(self):
        return 'Source "{}" is not found.'.format(
            self._source_name
        )


class ActionModuleNotFoundException(Exception):

    def __init__(self, action_module_name: str) -> None:
        self._action_module_name = action_module_name

    def __str__(self):
        return '"{}" is not found.'.format(
            self._action_module_name
        )
