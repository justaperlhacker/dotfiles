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
# -- START ACTIVESTATE INSTALLATION
export PATH="/home/johnm/.komodoide/12.0/XRE/state/bin:$PATH"
# -- STOP ACTIVESTATE INSTALLATION
# -- START ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT
export PATH="/home/johnm/.cache/activestate/bin:$PATH"
if [[ ! -z "$ACTIVESTATE_ACTIVATED" && -f "$ACTIVESTATE_ACTIVATED/activestate.yaml" ]]; then
  echo "State Tool is operating on project $ACTIVESTATE_ACTIVATED_NAMESPACE, located at $ACTIVESTATE_ACTIVATED"
fi
# -- STOP ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT
