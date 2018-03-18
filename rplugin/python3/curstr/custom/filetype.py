
from typing import Dict  # noqa
from typing import List

from neovim import Nvim

from curstr.exception import InvalidCustomException

from .base import Custom


class FiletypeCustom(Custom):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self._source_names = {'_': ['file']}
        self._aliases = {}  # type: Dict[str, str]

    def set(self, filetype: str, source_names: List[str]):
        self._source_names[filetype] = source_names

    def set_alias(self, alias: str, filetype: str):
        self._aliases[alias] = filetype

    def get(self, filetype: str):
        aliased_filetype = self._apply_alias(filetype)
        source_names = [
            name for name
            in self._source_names.get(aliased_filetype, [])
        ]
        source_names.extend(self._source_names['_'])
        source_names = sorted(
            set(source_names), key=source_names.index
        )

        return source_names

    def _apply_alias(self, filetype: str) -> str:
        aliased = self._aliases.get(filetype, filetype)
        if aliased == filetype:
            return filetype

        try:
            return self._apply_alias(aliased)
        except RecursionError:
            raise InvalidCustomException(
                'Invalid filetype alias definition: {}'.format(filetype)
            )
