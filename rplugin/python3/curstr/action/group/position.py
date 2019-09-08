import pathlib

from neovim import Nvim

from .file_position import FilePosition


class Position(FilePosition):
    def __init__(self, vim: Nvim, row: int, column: int) -> None:
        path = vim.call("expand", "%:p")
        super().__init__(vim, path, row, column)

    def name(self):
        return pathlib.Path(__file__).stem
