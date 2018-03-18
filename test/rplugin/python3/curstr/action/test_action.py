

from unittest.mock import Mock

from pytest import fixture

from curstr.action.facade import Action
from curstr.action.group import ActionGroup


@fixture
def action_group_fixture():
    action_group = Mock(spec=ActionGroup)
    action_open = Mock()
    action_group.action_open = action_open
    return action_group


def test_execute(action_group_fixture):
    action_name = 'open'
    action = Action(action_group_fixture, action_name)
    action.execute()

    assert action_group_fixture.action_open.call_count == 1


def test_is_executable(action_group_fixture):
    action_name = 'open'
    action = Action(action_group_fixture, action_name)
    is_executable = action.is_executable()

    assert is_executable


def test_is_not_executable(action_group_fixture):
    action_name = 'tabopen'
    action = Action(action_group_fixture, action_name)
    is_executable = action.is_executable()

    assert not is_executable
