

from neovim.api.nvim import Nvim

from .file_position import FilePosition


class Position(FilePosition):

    def __init__(self, vim: Nvim, row: int, column: int) -> None:
        path = vim.call('expand', '%:p')
        super().__init__(vim, path, row, column)
