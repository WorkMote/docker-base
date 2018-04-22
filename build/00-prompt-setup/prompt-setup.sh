#!/bin/bash

# Enable colored prompts for root and every future user created.
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' `eval echo "~$USERNAME"`/.bashrc
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Prompt changes to better identify this environments.
IFS='' read -r -d '' NewPrompt <<'EOF'
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\][\w]\[\033[00m\]\$ '
EOF

# Escape chars in new prompt var to use it later in replacement.
NewPrompt=`echo $(printf %q "$NewPrompt")`

# Above command does its job but creates an ANSI-C quoted version of the string ($'...'), that in turn
# becomes problematic when tried later in replacement commands. At least, format of string is something
# predictable, so extra chars added by quoting handling are removed.
NewPrompt=`echo "${NewPrompt:2:${#NewPrompt}-3}"`

# Perform prompt actual replacements.
sed -i '/if \[ "$color_prompt" = yes \]; then/{n;d;}' `eval echo "~$USERNAME"`/.bashrc
sed -i "/if \[ \"\$color_prompt\" = yes \]; then/a \ \ ${NewPrompt}" `eval echo "~$USERNAME"`/.bashrc
sed -i '/if \[ "$color_prompt" = yes \]; then/{n;d;}' /etc/skel/.bashrc
sed -i "/if \[ \"\$color_prompt\" = yes \]; then/a \ \ ${NewPrompt}" /etc/skel/.bashrc
