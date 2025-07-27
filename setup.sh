#!/bin/bash

set -e

echo "🔧 Atualizando pacotes..."
sudo pacman -Syu --noconfirm

echo "📦 Instalando dependências básicas..."
sudo pacman -S --noconfirm curl git zsh ruby npm cmatrix kitty ttf-fira-code xdg-utils gnome-tweaks

# Instalação da fonte Fira Code já incluída acima
echo "🔤 Fonte Fira Code instalada com sucesso."

# 🐱 Define Kitty como terminal padrão
if ! grep -q 'alias terminal=' ~/.zshrc; then
    echo "🐱 Adicionando alias para abrir o terminal kitty com Alt+Enter..."
    echo '
# Definindo kitty como terminal padrão
alias terminal="kitty"
' >> ~/.zshrc
fi

# Define kitty como terminal padrão para o ambiente gráfico
if command -v xdg-mime >/dev/null 2>&1; then
    echo "🔧 Definindo Kitty como terminal padrão do sistema..."
    xdg-mime default kitty.desktop x-scheme-handler/terminal
fi

# 🔠 Configura o Kitty com fonte Fira Code
KITTY_CONF_DIR="$HOME/.config/kitty"
mkdir -p "$KITTY_CONF_DIR"

cat > "$KITTY_CONF_DIR/kitty.conf" <<EOF
font_family      FiraCode Nerd Font
bold_font        auto
italic_font      auto
font_size        12.0
enable_audio_bell no
EOF

# ⌨️ Atalho ALT+Enter para abrir o kitty
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat > "$HOME/.local/share/applications/kitty.desktop" <<EOF
[Desktop Entry]
Name=Kitty
Comment=Fast, feature-rich, GPU based terminal
Exec=kitty
Icon=kitty
Type=Application
Categories=System;TerminalEmulator;
StartupWMClass=kitty
EOF

# 🔥 Atalho personalizado no i3 ou sxhkd (opcional)
# Para quem usa i3/sxhkd: adiciona manualmente
echo -e "\n⚠️ Para usar Alt+Enter como atalho, adicione isso ao seu WM:\n"
echo "Para i3:"
echo 'bindsym Mod1+Return exec kitty'
echo "Para sxhkd:"
echo 'alt + Return\n    kitty'

# 🐚 Define o Zsh como shell padrão
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

# Instalação do Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💡 Instalando Oh My Zsh..."
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# PowerLevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "🎨 Instalando PowerLevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi

# Plugins
declare -A plugins_git=(
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
    [zsh-completions]="https://github.com/zsh-users/zsh-completions.git"
    [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search.git"
    [you-should-use]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
    [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    [zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode.git"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
)

echo "🔌 Instalando plugins..."
for plugin in "${!plugins_git[@]}"; do
    [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ] && git clone "${plugins_git[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
done

# Ativa plugins no .zshrc
desired_plugins="git zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search you-should-use fast-syntax-highlighting zsh-vi-mode fzf-tab"
sed -i "s/^plugins=.*/plugins=($desired_plugins)/" ~/.zshrc

# colorls
if ! command -v colorls &>/dev/null; then
    echo "🌈 Instalando colorls..."
    sudo gem install colorls
fi

# eza
if ! command -v eza &>/dev/null; then
    sudo pacman -S --noconfirm eza
fi

# secman
if ! command -v secman &>/dev/null; then
    sudo npm install -g secman || curl -fsSL https://cli.secman.dev | bash
fi

# tran
if ! command -v tran &>/dev/null; then
    curl -sL https://cutt.ly/tran-cli | bash
fi

# Adiciona aliases de ls
if ! grep -q 'alias ls=' ~/.zshrc; then
    echo '
# Aliases para colorls ou eza
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
elif [ -x "$(command -v eza)" ]; then
    alias ls="eza"
    alias la="eza --long --all --group"
fi
' >> ~/.zshrc
fi

if [ "$SHELL" = "$(which zsh)" ]; then
    echo "♻️ Recarregando ~/.zshrc"
    source ~/.zshrc
else
    echo "⚠️ Para aplicar as mudanças, execute 'zsh' ou reinicie o terminal."
fi

echo -e "\n🎉 Terminal pronto com Kitty, PowerLevel10k, Fira Code e GNOME Tweaks! Use \033[1mAlt + Enter\033[0m no seu WM para abrir o Kitty.\n"
