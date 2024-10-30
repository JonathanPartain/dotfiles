PAGER="less -r"
selected=$(cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

read -rep "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=$(echo $query | tr ' ' '+')
    tmux neww bash -c "curl -s "cht.sh/$selected/${query//\ /\+}" | $PAGER"
else
    # Allow empty query search
    if [[ -n $query ]]; then
        tmux neww bash -c "curl -s "cht.sh/$selected~$query" | $PAGER"
    else
        tmux neww bash -c "curl -s "cht.sh/$selected" | $PAGER"
    fi
fi
