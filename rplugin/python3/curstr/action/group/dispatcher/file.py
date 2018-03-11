
from os.path import isdir, isfile

from curstr.action.group.directory import Directory
from curstr.action.group.file import File
from curstr.action.group.file_position import FilePosition
from curstr.action.group.position import Position

from .base import Dispatcher


class FileDispatcher(Dispatcher):

    def _mapper(self):
        return {
            File: isfile,
            Directory: isdir,
            FilePosition: self.is_file_position,
            Position: self.is_position,
        }

    def is_position(self, row: int, column: int) -> bool:
        return row > 0 and column > 0

    def is_file_position(self, path: str, row: int, column: int) -> bool:
        return isfile(path) and self.is_position(row, column)
