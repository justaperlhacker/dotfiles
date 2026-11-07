# ~/.bashrc

[[ -f $HOME/.config/bash/bashrc ]] && source $HOME/.config/bash/bashrc


# opencode
export PATH=/home/johnm/.opencode/bin:$PATH
export PATH="$HOME/.local/lib/node_modules/.bin:$PATH"
export PATH="$HOME/.local/go/bin:$PATH"
export GOPATH="$HOME/.local/go"

if [[ -f "$HOME/.secrets/agents.env" && -r "$HOME/.secrets/agents.env" ]]; then
    set -a
    source "$HOME/.secrets/agents.env"
    set +a
fi

# Pi
export PATH="/home/johnm/.pi/agent/bin:$PATH"
