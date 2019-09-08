import pathlib
from typing import List

from .base import ActionGroup


class Range(ActionGroup):
    def __init__(self, vim, fist_line: int, last_line: int) -> None:
        super().__init__(vim)
        self._fist_line = fist_line
        self._last_line = last_line

    def name(self):
        return pathlib.Path(__file__).stem

    @ActionGroup.action(modify=True)
    def join(self):
        last_line = self._last_line
        if self._fist_line == self._last_line:
            last_line = self._fist_line + 1

        raw_lines: List[str] = self._vim.call("getline", self._fist_line, last_line)
        first = raw_lines[0]
        others = list(map(lambda line: line.lstrip(), raw_lines[1:]))

        lines = [first]
        lines.extend(filter(lambda x: len(x) != 0, others))

        separator = self.get_option("separator")
        if separator is None:
            separator = self._vim.call("input", "Separator: ")

        self._vim.current.buffer[self._fist_line - 1 : last_line] = [
            separator.join(lines)
        ]

    @ActionGroup.action(modify=True)
    def default(self):
        self.join()

    def get_options(self):
        return {"separator": None}
