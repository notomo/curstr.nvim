
from unittest.mock import Mock

from neovim import Nvim

from curstr import Curstr
from curstr.action import ActionFacade
from curstr.custom import CustomFacade
from curstr.importer import Importer


def test_execute():
    vim = Mock(spec=Nvim)
    importer = Mock(spec=Importer)
    curstr = Curstr(vim, importer)

    custom_facade = Mock(spec=CustomFacade)
    curstr._custom_facade = custom_facade

    action_facade = Mock(spec=ActionFacade)
    curstr._action_facade = action_facade

    curstr.execute('')

    assert action_facade.execute.call_count == 1
