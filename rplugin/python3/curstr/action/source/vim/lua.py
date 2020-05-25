import os.path

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        cword = self._cursor.get_word(added_iskeyword="./")
        paths = self._vim.call("luaeval", "package.path").split(";")
        for path in paths:
            file_path = path.replace("?", cword.replace(".", "/"))
            if os.path.isfile(file_path):
                return self._dispatcher.dispatch_one(FileDispatcher.File, file_path)

        return self._dispatcher.nothing()

    def get_options(self):
        return {"filetyps": ["lua"]}
