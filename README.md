# alt-q.fish

Plugin for [fisherman][] that adds two key bindings:

* **alt-q**: Pushes the current command-line onto a private stack and clears the
  command-line. The next time the prompt is displayed, if there's anything on
  the stack, the latest entry is popped from the stack and restored to the
  commandline.
* **alt-g**: Pops the latest entry from the stack and appends it to the
  command-line.

[fisherman]: https://github.com/fisherman/fisherman
