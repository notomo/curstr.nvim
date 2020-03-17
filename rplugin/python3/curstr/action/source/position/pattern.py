from typing import Tuple

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        word = self._cursor.get_word()

        source_patttern = self.get_option("source_pattern")
        search_pattern = self.get_option("search_pattern")
        replace_all = "g" if self.get_option("replace_all") else ""
        search = self._vim.call(
            "substitute", word, source_patttern, search_pattern, replace_all
        )

        position = self.__search_position(search, search_pattern)

        return self._dispatcher.dispatch_one(FileDispatcher.Position, *position)

    def __search_position(self, search: str, search_pattern: str) -> Tuple[int, int]:
        if search_pattern == "":
            return (0, 0)

        return self._vim.call("searchpos", search, "nw")

    def get_options(self):
        return {"source_pattern": "", "search_pattern": "", "replace_all": False}
