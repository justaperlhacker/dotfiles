# ~/.bashrc

[[ -f $HOME/.config/bash/bashrc ]] && source $HOME/.config/bash/bashrc

# -- START ACTIVESTATE INSTALLATION
export PATH="/home/johnm/.komodoide/12.0/XRE/state/bin:$PATH"
# -- STOP ACTIVESTATE INSTALLATION
# -- START ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT
export PATH="/home/johnm/.cache/activestate/bin:$PATH"
if [[ ! -z "$ACTIVESTATE_ACTIVATED" && -f "$ACTIVESTATE_ACTIVATED/activestate.yaml" ]]; then
  echo "State Tool is operating on project $ACTIVESTATE_ACTIVATED_NAMESPACE, located at $ACTIVESTATE_ACTIVATED"
fi
# -- STOP ACTIVESTATE DEFAULT RUNTIME ENVIRONMENT

# kimi-code
export PATH="/home/johnm/.kimi-code/bin:$PATH"
