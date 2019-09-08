from typing import List  # noqa

from curstr.action.group import ActionGroup
from curstr.action.group.togglable import Line
from curstr.action.source.base import Source as Base


class Source(Base):
    def create(self) -> ActionGroup:
        line = self._cursor.get_line()
        lines = self.get_option("lines")
        if line not in lines:
            return self._dispatcher.nothing()

        new_line = lines[(lines.index(line) + 1) % len(lines)]

        return Line(self._vim, new_line)

    def get_options(self):
        return {"lines": []}
