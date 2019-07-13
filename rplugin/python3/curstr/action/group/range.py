
from typing import List

from .base import ActionGroup


class Range(ActionGroup):

    def __init__(
        self, vim, fist_line: int, last_line: int, separator: str
    ) -> None:
        super().__init__(vim)
        self._fist_line = fist_line
        self._last_line = last_line
        self._separator = separator

    @ActionGroup.action()
    def join(self):
        last_line = self._last_line
        if self._fist_line == self._last_line:
            last_line = self._fist_line + 1

        lines: List[str] = self._vim.call(
            'getline',
            self._fist_line,
            last_line,
        )
        line = self._separator.join(map(
            lambda line: line.lstrip(),
            lines
        ))

        self._vim.current.buffer[
            self._fist_line - 1:last_line
        ] = [line]

    @ActionGroup.action()
    def default(self):
        self.join()
