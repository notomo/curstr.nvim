

from unittest.mock import Mock

from neovim.api.nvim import Nvim

from curstr import Curstr
from curstr.action import Action
from curstr.custom import CustomFacade, ExecuteOption
from curstr.importer import Importer


def test_execute():
    vim = Mock(spec=Nvim)
    importer = Mock(spec=Importer)
    curstr = Curstr(vim, importer)

    facade = Mock(spec=CustomFacade)
    execute_option = Mock(spec=ExecuteOption)
    facade.get_execute_option.return_value = execute_option
    curstr._custom = facade

    _get_action = Mock()
    _get_action.return_value = None
    curstr._get_action = _get_action
    curstr.echo_message = Mock()

    curstr.execute('')

    assert curstr.echo_message.call_count == 1

    action = Mock(spec=Action)

    _get_action = Mock()
    _get_action.return_value = action
    curstr._get_action = _get_action

    curstr.execute('')

    assert action.execute.call_count == 1
