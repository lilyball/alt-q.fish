set -g __alt_q_stack_line
set -g __alt_q_stack_pos
function __alt_q_push_line --description 'Function used for binding for M-q'
    set -l IFS \n\ \t # ensure IFS is non-empty for commandline splitting
    set -l cmdlines (commandline)
    set -l pos (commandline -C)
    # join multi-line commandlines into a single string
    set -l cmdline "$cmdlines[1]"
    set -e cmdlines[1]
    for line in $cmdlines
        set cmdline $cmdline\n$line
    end
    # push our values onto the stack
    set __alt_q_stack_line $__alt_q_stack_line $cmdline
    set __alt_q_stack_pos $__alt_q_stack_pos $pos
    # empty the commandline
    commandline ''
end

function __alt_g_get_line --description 'Function used for binding for M-g'
    if set -q __alt_q_stack_line[-1]
        commandline -i -- $__alt_q_stack_line[-1]
        set -e __alt_q_stack_line[-1]
        set -e __alt_q_stack_pos[-1]
    else
        # echo a bell so the user knows the stack is empty
        echo -n \a
    end
end

function __alt_q_prompt_function --on-event fish_prompt --description 'Pop the alt-q stack if non-empty'
    # sanity check; make sure we don't already have a commandline
    # I don't know why we would, but we don't want to overwrite it in that case
    set -l IFS \n\ \t # ensure IFS is non-empty for commandline splitting
    set -l cmd (commandline)
    if test -n "$cmd"
        return
    end
    if set -q __alt_q_stack_line[-1]
        commandline -- $__alt_q_stack_line[-1]
        commandline -C -- $__alt_q_stack_pos[-1]
        set -e __alt_q_stack_line[-1]
        set -e __alt_q_stack_pos[-1]
    end
end

bind \eq __alt_q_push_line
bind -M insert \eq __alt_q_push_line
bind \eg __alt_g_get_line
bind -M insert \eg __alt_g_get_line
