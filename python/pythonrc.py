# Python REPL startup configuration
# ~/.config/python/pythonrc.py
# Usage: export PYTHONSTARTUP=~/.config/python/pythonrc.py

import readline
import rlcompleter
import sys
import os

# Tab completion
if hasattr(readline, '__doc__') and 'libedit' not in readline.__doc__:
    readline.parse_and_bind('tab: complete')
    readline.set_completer(rlcompleter.Completer(locals()).complete)
else:
    # macOS での libedit 対応
    readline.parse_and_bind('bind ^I rl_complete')

# History file in XDG
history_dir = os.path.expanduser('~/.local/share/python')
os.makedirs(history_dir, exist_ok=True)
history_file = os.path.join(history_dir, 'history')

if os.path.exists(history_file):
    readline.read_history_file(history_file)

import atexit
atexit.register(readline.write_history_file, history_file)

# Cleanup namespace
del readline, rlcompleter, sys, os, history_file, history_dir, atexit
