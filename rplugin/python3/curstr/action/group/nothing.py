import pathlib

from .base import ActionGroup


class Nothing(ActionGroup):
    def is_nothing(self) -> bool:
        return True

    def name(self):
        return pathlib.Path(__file__).stem
