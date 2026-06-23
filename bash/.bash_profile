# ~/.bash_profile

[[ -f "$HOME/.config/bash/profile" ]] && source "$HOME/.config/bash/profile"

# Login shell starts
#         │
#         ▼
# ~/.bash_profile
#         │
#         ▼
# ~/.config/bash/profile
#         │
#         ├── source env
#         ├── login-time setup
#         └── source bashrc
#                   │
#                   ▼
#         ~/.config/bash/bashrc
#                   │
#                   ├── aliases
#                   ├── functions
#                   ├── shell options
#                   ├── prompt
#                   └── local