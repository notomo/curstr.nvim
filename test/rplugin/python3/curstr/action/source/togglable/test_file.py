
from unittest.mock import Mock

import pytest
from neovim import Nvim

from curstr.action.cursor import Cursor
from curstr.action.group import Dispatcher
from curstr.action.source.togglable.file import Source
from curstr.info import SourceExecuteInfo


def get_source():
    vim = Mock(spec=Nvim)
    dispatcher = Mock(spec=Dispatcher)
    info = Mock(spec=SourceExecuteInfo)
    cursor = Mock(spec=Cursor)
    return Source(vim, dispatcher, info, cursor)


@pytest.mark.parametrize('expected,path,pattern', [
    ([], '', ''),
    (['path'], 'path', '%'),
    (['~/hoge', 'test'], '~/hoge/test.py', '%/%.py'),
    (None, 'test.py', '%/%.py'),
    (['~/test', 'o', 'hoge'], '~/test/foo/test_hoge.py', '%/fo%/test_%.py'),
    (None, 'test.py', 'foo%.py'),
])
def test_find_matches(expected, path, pattern):
    source = get_source()
    result = source._find_matches(path, pattern)
    assert expected == result


@pytest.mark.parametrize('expected,patterns,path', [
    ((0, ['test']), ['%.py'], 'test.py'),
    ((1, ['test']), ['%.py', '%.vim'], 'test.vim'),
    ((-1, None), [], ''),
])
def test_get_current_pattern_matches(expected, patterns, path):
    source = get_source()
    result = source._get_current_pattern_matches(patterns, path)
    assert expected == result
