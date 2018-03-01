import sys
from os import path

sys.path.insert(
    0,
    path.join(
        path.dirname(path.dirname(__file__)),
        'rplugin/python3'
    )
)
