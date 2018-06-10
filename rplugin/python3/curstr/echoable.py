
import traceback


class Echoable(object):

    def echo_message(self, message):
        self._vim.command(
            'echomsg "{}"'.format(
                self._vim.call('escape', str(message), '\\"')
            )
        )

    def echo_error(self):
        lines = traceback.format_exc().splitlines()
        message = '[curstr] {}\n'.format('\n'.join(lines))
        self._vim.err_write(message)
        if self._vim.call('curstr#is_testing'):
            self._vim.call('themis#log', message)
