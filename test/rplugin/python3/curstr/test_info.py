
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
    ('', [], {}),
    ('name1', ['name1'], {}),
    ('name1 name2', ['name1', 'name2'], {}),
    ('name1 -option1', ['name1'], {'option1': True}),
    ('name1 -option2=value2', ['name1'], {'option2': 'value2'}),
    ('-option1', [], {'option1': True}),
])
def test_from_arg_string(arg_string, source_names, execute_options):
    vim = Mock(spec=Nvim)
    info = ExecuteInfoMock.from_arg_string(vim, arg_string)
    assert source_names == info.source_names
    assert execute_options == info.execute_options
