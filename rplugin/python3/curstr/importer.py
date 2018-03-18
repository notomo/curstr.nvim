
import glob
import importlib
import os
import sys
from importlib.util import spec_from_file_location, spec_from_loader
from modulefinder import Module
from os.path import join
from typing import Dict  # noqa
from typing import List

from curstr.action.source import Source
from curstr.exception import (
    ActionModuleNotFoundException, SourceNotFoundException
)

from .echoable import Echoable


class Importer(Echoable):

    ACTION_MODULE_PATH = 'curstr.action.'

    def __init__(self, vim) -> None:
        self._vim = vim
        sys.meta_path.insert(0, self)

        self._sources = {}  # type: Dict[str, Source]

    def find_spec(self, fullname: str, path: List[str], target=None):
        if fullname.startswith(self.ACTION_MODULE_PATH):
            module_paths = fullname[len(self.ACTION_MODULE_PATH):].split('.')
            return self._get_spec(module_paths)
        return None

    def _get_spec(self, module_paths: List[str]):
        name = '/'.join(module_paths)
        path = self._get_path(name)
        module_path = '.'.join(module_paths)
        if os.path.isdir(path):
            file_path = '{}/__init__.py'.format(path)
        else:
            file_path = path

        if os.path.isfile(file_path):
            spec = spec_from_file_location(
                'curstr.action.{}'.format(module_path), file_path
            )
        else:
            # namespace package
            spec = spec_from_loader(
                'curstr.action.{}'.format(module_path), None
            )
            spec.submodule_search_locations = [path]
        return spec

    def _get_path(self, name: str) -> str:
        file_path = 'rplugin/python3/curstr/action/**/{}*'.format(name)
        expected_file_name = name.split('/')[-1]
        runtime_paths = self._vim.options['runtimepath'].split(',')
        for runtime in runtime_paths:
            for path in glob.iglob(join(runtime, file_path), recursive=True):
                file_name = os.path.splitext(os.path.basename(path))[0]
                if file_name == '__init__':
                    continue
                if file_name != expected_file_name:
                    continue

                return path

        raise ActionModuleNotFoundException(name)

    def get_source(
        self, source_name: str, use_cache: bool
    ) -> Source:
        if use_cache and source_name in self._sources:
            return self._sources[source_name]
        return self._load_source(source_name, use_cache)

    def _load_source(
        self, source_name: str, use_cache: bool
    ) -> Source:
        module_name = 'curstr.action.source.{}'.format(
            '.'.join(source_name.split('/'))
        )
        module = self._import(module_name)
        if hasattr(module, 'Source'):
            cls = module.Source
            dispatcher = self._load_dispatcher(
                cls.DISPATCHER_CLASS, use_cache
            )
            source = cls(self._vim, dispatcher)
            self._sources[source_name] = source
            return source

        raise SourceNotFoundException(source_name)

    def _load_dispatcher(self, cls, use_cache: bool):
        if use_cache:
            return cls(self._vim)
        self._reload_action_group()
        dispatcher_module = self._import(cls.__module__)
        return getattr(dispatcher_module, cls.__name__)(self._vim)

    def _reload_action_group(self):
        group_module = self._import('curstr.action.group')
        groups = [
            (name, cls)
            for name, cls
            in group_module.__dict__.items()
            if (
                isinstance(cls, type) and
                cls.__module__.startswith('curstr.action.group')
            )
        ]
        for name, cls in groups:
            reloaded = self._import(cls.__module__)
            group_module.__dict__[name] = (
                reloaded.__dict__[name]
            )

    def _import(self, module_name: str) -> Module:
        if module_name in sys.modules.keys():
            return importlib.reload(sys.modules[module_name])
        return importlib.import_module(module_name)
