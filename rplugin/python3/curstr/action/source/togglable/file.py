
from os.path import join
from typing import List, Tuple, Union

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base

Matches = Union[None, List[str]]


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher
    PLACE_HOLDER = '%'

    def create(self) -> ActionGroup:
        pattern_groups = self.get_option('pattern_groups')
        offset = self.get_option('offset')

        path = ''
        buffer_name = self._vim.call('expand', '%:t')
        for patterns in pattern_groups:
            path = self._get_path(patterns, buffer_name, offset)
            if path != '':
                absolute_path = join(
                    self._vim.call('expand', '%:p:h'), path
                )
                return self._dispatcher.dispatch_one(
                    FileDispatcher.File,
                    absolute_path
                )

        path = ''
        buffer_path = self._vim.call('expand', '%:p')
        for patterns in pattern_groups:
            path = self._get_path(patterns, buffer_path, offset)
            if path != '':
                continue

        return self._dispatcher.dispatch_one(
            FileDispatcher.File,
            path
        )

    def get_options(self):
        return {
            'pattern_groups': [],
            'offset': 1,
        }

    def _get_path(self, patterns: List[str], path: str, offset: int) -> str:
        index, matches = self._get_current_pattern_matches(patterns, path)
        if matches is None:
            return ''

        pattern = patterns[(index + offset) % len(patterns)]
        return pattern.replace(self.PLACE_HOLDER, '{}').format(*matches)

    def _get_current_pattern_matches(
        self, patterns: List[str], path: str
    ) -> Tuple[int, Matches]:
        for i, pattern in enumerate(patterns):
            matches = self._find_matches(path, pattern)
            if matches is not None:
                return i, matches

        return -1, None

    def _find_matches(self, path: str, pattern: str) -> Matches:
        pattern_parts = pattern.split(self.PLACE_HOLDER)

        if len(pattern_parts) == 1 and path == pattern:
            return []

        first_part = pattern_parts.pop(0)
        if path.rfind(first_part) == -1:
            return None

        start = len(first_part)
        matches = []
        for p in pattern_parts:
            end = path.rfind(p, start)
            if end == -1:
                return None
            matches.append(path[start:end])
            start = end + len(p)

        return matches if len(matches) != 0 else None
