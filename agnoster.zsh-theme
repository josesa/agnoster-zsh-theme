# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segments of the prompt, default order declaration

typeset -aHg AGNOSTER_PROMPT_SEGMENTS=(
    prompt_status_emoji
    prompt_context
    prompt_dir
    prompt_git
    prompt_end
)

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
  PRIMARY_FG=black
fi

# Characters
SEGMENT_SEPARATOR="\ue0b0"
SEGMENT_R_SEPARATOR=$'\uE0B2'
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

PROMPT_EMOJI=(🐶 🐱 🐭 🐹 🐰 🐻 🐼 🐨 🐯 🦁 🐮 🐷 🐽 🐵 🙈 🙉 🙊 🐒 🐔 🐧 \
🐦 🐤 🐣 🐥 🐺 🐗 🐴 🦄 🐝 🐛 🐌 🐜 🦂 🐠 🐟 🐡 🐬 🐳 🐋 🐆 🐅 🐃 🐂 🚪 \
🐄 🐪 🐫 🐘 🐐 🐏 🐑 🐎 🐖 🐀 🐁 🐓 🦃 🐕 🐩 🐈 🐇 🎋 🍂 🌾 🛁 🔑 🛌 🏯 \
🌻 🌷 🌼 🌸 💐 🌰 🎃 🐚 🚕 🚙 🚌 🚎 🚓 🚑 🚐 🚚 🚜 🚲 🚔 🚍 🚖 🔖 🚿 🏰 \
🚡 🚟 🚃 🚋 🚅 🚈 🚞 🚆 🚇 🚊 🚉 🚁 🛫 🛬 ⛵️ 🚤 🚀 💺 🚧 🔮 📿 💈 🔭 🔬 \
😀 😬 😁 😃 😄 😅 😆 😇 😉 😊 🙂 🙃 😋 😌 😍 😘 😗 😙 😚 😜 😝 😛 🤑 🤓 \
😎 🤗 😏 😶 😐 😑 😒 🙄 🤔 😳 😞 😟 😠 😔 😕 🙁 😣 😖 😯 😦 😧 😵 😲 🤐 \
😷 🤒 🤕 😴 💤 💀 👽 🤖 😺 😸 😻 😼 😽 😾 ⚽️ 🏀 🏈 🏐 🏉 🎱 🏸 🏒 🏑 💳 \
🏏 🏹 🎣 🚣 🏊 🏄 🛀 🚴 🚵 🏆 🎽 🏅 🎫 💎 🔧 🔩 🔫 💣 🔪 💵 💴 💶 💷 💰 \
🎭 🎨 🎤 🎧 🎼 🎹 🎷 🎺 🎸 🎻 🎬 🎮 🎲 🎰 🎳 🍐 🍊 🍋 🍌 🍉 🍇 🍈 🍍 🍆 \
🌽 🍠 🍯 🍞 🧀 🍗 🍖 🍤 🍳 🍔 🌭 🍕 🍝 🌮 🌯 🍜 🍲 🍥 🍱 🍛 🍙 🍚 🍘 🍢 \
🍡 🍧 🍨 🍦 🍰 🎂 🍮 🍬 🍭 🍫 🍩 🍪 🍺 🍻 🍸 🍹 🍾 🍶 🍵 🍼 🍴 🌎 🌍 💡 \
🌏 🚏 🚦 🚥 🏁 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌚 🌝 🌛 🌜 🌞 🌙 ⭐️ 🌟 💫 ✨ 🔦 \
⛅️ ⛄️ 💨 💧 💦 🌊 👦 👧 👨 👩 👴 👵 👶 👱 👮 👲 👳 👷 👸 💂 💸 📻 ⏳ ⌛️ \
🎅 👼 💆 💇 👰 🙍 🙎 🙅 🙆 💁 🙋 🙇 🙌 🙏 🚶 🏃 💪 👈 👉 👆 👇 🖖 🤘 📡 \
✊ ✋ 👊 👌 👍 👋 👏 👐 💅 👂 👃 🚣 🛀 🏄 🏇 🏊 🙌 👈 👉 🤘 💅 📥 📤 📜 \
👅 👂 👃 👀 👤 👶 👦 👧 👨 👩 👱 👴 👵 👲 👳 👮 👷 💂 🎅 👼 👸 📭 📦 📯 \
👰 👯 👫 👬 👭 🙇 💁 🙅 🙆 🙋 🙎 🙍 💇 💆 💑 👪 👚 👕 👖 👔 👗 👙 👘 👡 \
👢 👞 👟 🎩 🎓 👑 👝 👛 👜 💼 👓 💍 🌂 📱 📲 💻 🗿 🎏 🎀 🎁 🎊 🎉 🎎 📫 \
📬 💽 💾 💿 📀 📼 📷 📸 📹 📟 📠 📺 🏤 🏥 🏦 🏨 🏪 🏫 🅿️ 🗽 🏠 🏡 🏢 🏣 \
🎐 🎌 📩 📨 📧 💌 📪 🎑 🗻 ⛺️ 🌈 🎡 🎢 🎠 🌁 🗼 🏭 🀄️ ⛲️ ⛪ ⛲ ⛺ ⛵ ⛅ \
📃 📑 📊 📈 📉 📄 📅 📆 📇 📋 📁 📂 📰 📓 📘 📙 📔 ⛄ ⚽ 🎿 💊 💉 🚄 🚢 \
📒 📖 🔗 📎 📐 📏 🔐 🔒 🔓 🔏 📝 🔍 🔎 💛 💙 💜 💕 💞 ⌛ ⌚ 🀄 ⭐ 📣 📢 \
💓 💗 💖 💘 💝 💟 🔯 🕎 🛐 ⛎ 🆔 📴 📳 🆚 ❕ ❔ 🔅 🔆 🔱 🚸 💠 🌀 ➿ 🔕 \
🌐 🏧 🛂 🛃 🛄 🛅 🚭 🚾 🚰 🚹 🚺 🚼 🚻 🚮 🎦 📶 🈁 🆖 🆗 🆙 🆒 🆕 🆓 🔟 \
🔔 🃏 💭 💬 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 🕜 🕝 🕞 🕟 🕠 🕡 🕣 🕤 \
🕥 🕦 🕧 
)

ERROR_EMOJI=(🔥 🚽 👎 💩 🚒 🚨 ⛽ 🔴 🆘 ⛔️ 📛 🚫 ❌ ⭕️ 💢 🚷 🚯 🚳 🚱 🔞 \
📵 ❗️ ❓ 💔 📕 📮 👹 👺 🔻 🔺 🏮 😡 
)

prompt_status_emoji() {
  local symbols
  if [[ $RETVAL -ne 0 ]]; then
    symbols="$ERROR_EMOJI[$RANDOM%$#ERROR_EMOJI+1]"
  else
    symbols="$PROMPT_EMOJI[$RANDOM%$#PROMPT_EMOJI+1]"
  fi
  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default "$symbols "
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment $PRIMARY_FG default " %(!.%{%F{yellow}%}.)$user@%m "
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  has_untracked() {
    test -n "$(git ls-files --other --exclude-standard)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    color=green
    if is_dirty; then
      color=yellow
      if has_untracked; then
        ref="${ref}%{%F{red}%}$PLUSMINUS%f"
      fi
    fi
    ref="${ref} "
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -n " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %~ '
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  for prompt_segment in "${AGNOSTER_PROMPT_SEGMENTS[@]}"; do
    [[ -n $prompt_segment ]] && $prompt_segment
  done
}

prompt_agnoster_precmd() {
  vcs_info
  local a=$RANDOM
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) '
  RPROMPT="%f "'%*'" "
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr "%{%F{085}%}●%f"
  zstyle ':vcs_info:*' unstagedstr "%{%F{red}%}●%f"
  zstyle ':vcs_info:git*' formats '%b %u%c'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"
