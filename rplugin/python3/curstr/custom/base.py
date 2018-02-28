
from neovim.api.nvim import Nvim

from curstr.echoable import Echoable


class Custom(Echoable):

    def __init__(self, vim: Nvim) -> None:
        self._vim = vim
