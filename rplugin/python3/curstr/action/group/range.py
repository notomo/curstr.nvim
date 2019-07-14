
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

        raw_lines: List[str] = self._vim.call(
            'getline',
            self._fist_line,
            last_line,
        )
        first = raw_lines[0]
        others = list(map(
            lambda line: line.lstrip(),
            raw_lines[1:]
        ))

        lines = [first]
        lines.extend(filter(lambda x: len(x) != 0, others))

        self._vim.current.buffer[
            self._fist_line - 1:last_line
        ] = [self._separator.join(lines)]

    @ActionGroup.action()
    def default(self):
        self.join()
