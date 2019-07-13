
from unittest.mock import Mock

import pytest
from neovim import Nvim

from curstr.info import ExecuteInfo


class ExecuteInfoMock(ExecuteInfo):

    def __init__(
        self, vim, source_names, execute_options
    ) -> None:
        self._source_names = source_names
        self._execute_options = execute_options

    @property
    def source_names(self):
        return self._source_names

    @property
    def execute_options(self):
        return self._execute_options


@pytest.mark.parametrize('arg_string,source_names,execute_options', [
    ('', [], {'_first_line': 1, '_last_line': 1}),
    ('name1', ['name1'], {'_first_line': 1, '_last_line': 1}),
    ('name1 name2', ['name1', 'name2'], {'_first_line': 1, '_last_line': 1}),
    ('name1 -option1', ['name1'],
     {'option1': True, '_first_line': 1, '_last_line': 1}),
    ('name1 -option2=value2',
     ['name1'], {'option2': 'value2', '_first_line': 1, '_last_line': 1}),
    ('-option1', [], {'option1': True, '_first_line': 1, '_last_line': 1}),
])
def test_from_arg_string(arg_string, source_names, execute_options):
    vim = Mock(spec=Nvim)
    info = ExecuteInfoMock.from_arg_string(vim, arg_string, 1, 1)
    assert source_names == info.source_names
    assert execute_options == info.execute_options
