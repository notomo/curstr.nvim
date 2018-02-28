
import os

from denite.source.base import Base


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'curstr/file'
        self.kind = 'file'

    def gather_candidates(self, context):

        path = context['curstr__path']

        def abspath(f):
            return os.path.join(path, f)

        isdir = os.path.isdir
        return [
            {
                'word': f + ('/' if isdir(abspath(f)) else ''),
                'kind': ('directory' if isdir(abspath(f)) else 'file'),
                'action__path': abspath(f),
            } for f in os.listdir(path)
        ]
