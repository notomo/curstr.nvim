

from unittest.mock import Mock

from neovim import Nvim
from pytest import fixture

from curstr import Curstr
from curstr.action import Action
from curstr.custom import CustomFacade, ExecuteOption
from curstr.importer import Importer


@fixture
def curstr_fixture():
    vim = Mock(spec=Nvim)
    importer = Mock(spec=Importer)
    curstr = Curstr(vim, importer)

    facade = Mock(spec=CustomFacade)
    execute_option = Mock(spec=ExecuteOption)
    facade.get_execute_option.return_value = execute_option
    curstr_fixture._custom = facade

    return curstr


def test_execute_but_none(curstr_fixture):
    _get_action = Mock(return_value=None)
    curstr_fixture._get_action = _get_action
    curstr_fixture.echo_message = Mock()

    curstr_fixture.execute('')

    assert curstr_fixture.echo_message.call_count == 1


def test_execute(curstr_fixture):
    action = Mock(spec=Action)

    _get_action = Mock(return_value=action)
    curstr_fixture._get_action = _get_action

    curstr_fixture.execute('')

    assert action.execute.call_count == 1
