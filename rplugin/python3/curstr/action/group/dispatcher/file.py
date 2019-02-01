
import os
from os.path import isdir, isfile

from curstr.action.group.directory import Directory
from curstr.action.group.file import File
from curstr.action.group.file_position import FilePosition
from curstr.action.group.new_file import NewFile
from curstr.action.group.position import Position

from .base import Dispatcher


class FileDispatcher(Dispatcher):

    File = File
    Directory = Directory
    FilePosition = FilePosition
    Position = Position
    NewFile = NewFile

    def _mapper(self):
        return {
            File: self.is_file,
            Directory: self.is_directory,
            FilePosition: self.is_file_position,
            Position: self.is_position,
            NewFile: self.is_creatable,
        }

    def is_file(self, path: str) -> bool:
        return isfile(self._vim.call('expand', path))

    def is_directory(self, path: str) -> bool:
        return isdir(self._vim.call('expand', path))

    def is_position(self, row: int, column: int) -> bool:
        return row > 0 and column > 0

    def is_file_position(self, path: str, row: int, column: int) -> bool:
        return self.is_file(path) and self.is_position(row, column)

    def is_creatable(self, path: str) -> bool:
        dir_path = os.path.split(path)[0]
        if not isdir(dir_path):
            try:
                os.makedirs(dir_path)
            except OSError:
                return False
        return True
