#!/bin/bash

set -euo pipefail

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Variáveis globais
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOT_FILES_DIR="$SCRIPT_DIR/dot-files"
readonly KITTY_CONF_DIR="$HOME/.config/kitty"
readonly ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Função para logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${PURPLE}🔧 $1${NC}"
}

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar se um pacote está instalado (pacman)
package_installed() {
    pacman -Q "$1" >/dev/null 2>&1
}

# Função para instalar pacotes com verificação
install_packages() {
    local packages=("$@")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! package_installed "$package"; then
            missing_packages+=("$package")
        fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        log_step "Instalando pacotes: ${missing_packages[*]}"
        sudo pacman -S --noconfirm "${missing_packages[@]}"
        log_success "Pacotes instalados com sucesso"
    else
        log_info "Todos os pacotes já estão instalados"
    fi
}

# Função para exibir o logo
show_logo() {
    cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║        ███████╗███████╗████████╗██╗   ██╗██████╗             ║
║       ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗             ║
║       ███████╗█████╗     ██║   ██║   ██║██████╔╝             ║
║       ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝              ║
║       ███████║███████╗   ██║   ╚██████╔╝██║                  ║
║       ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝                  ║
║                                                              ║
║           🚀 Setup do endeavourOS - Ambiente Dev 🚀          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
}

# Função para atualizar sistema
update_system() {
    log_step "Atualizando sistema..."
    sudo pacman -Syu --noconfirm
    log_success "Sistema atualizado"
}

# Função para instalar dependências básicas
install_basic_dependencies() {
    log_step "Instalando dependências básicas..."
    local basic_packages=(
        "curl"
        "git"
        "zsh"
        "ruby"
        "npm"
        "cmatrix"
        "kitty"
        "ttf-fira-code"
        "xdg-utils"
        "gnome-tweaks"
        "gnome-shell-extension-dash-to-dock"
    )
    
    install_packages "${basic_packages[@]}"
    log_success "Dependências básicas instaladas"
}

# Função para instalar Docker e ferramentas de desenvolvimento
install_development_tools() {
    log_step "Instalando Docker e ferramentas de desenvolvimento..."
    
    # Docker e Docker Compose
    local docker_packages=(
        "docker"
        "docker-compose"
        "docker-buildx"
    )
    
    install_packages "${docker_packages[@]}"
    
    # Configurar Docker
    log_info "Configurando Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker
    
    # Adicionar usuário ao grupo docker
    if ! groups "$USER" | grep -q docker; then
        log_info "Adicionando usuário ao grupo docker..."
        sudo usermod -aG docker "$USER"
    fi
    
    # Ferramentas de desenvolvimento adicionais
    local dev_packages=(
        "nodejs"
        "yarn"
        "python"
        "python-pip"
        "go"
        "rust"
        "jdk-openjdk"
        "maven"
        "gradle"
        "postgresql"
        "redis"
        "nginx"
        "apache"
        "php"
        "composer"
        "ruby-bundler"
        "rbenv"
        "pyenv"
    )
    
    install_packages "${dev_packages[@]}"
    
    # Instalar ferramentas CLI úteis
    local cli_tools=(
        "htop"
        "bat"
        "fd"
        "ripgrep"
        "fzf"
        "jq"
        "yay"
        "httpie"
        "wget"
        "tree"
        "tmux"
        "screen"
        "nano"
        "vim"
        "neovim"
        "micro"
        "lazygit"
        "tldr"
        "glow"
        "exa"
        "lsd"
        "procs"
        "sd"
        "tealdeer"
    )
    
    install_packages "${cli_tools[@]}"
    
    log_success "Ferramentas de desenvolvimento instaladas"
}

# Função para configurar Docker aliases e configurações
setup_docker_config() {
    log_step "Configurando Docker..."
    
    # Criar diretório de configuração do Docker
    mkdir -p "$HOME/.docker"
    
    # Configurar Docker daemon (se não existir)
    if [ ! -f "/etc/docker/daemon.json" ]; then
        log_info "Configurando Docker daemon..."
        sudo mkdir -p /etc/docker
        sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "features": {
    "buildkit": true
  }
}
EOF
        sudo systemctl restart docker
    fi
    
    # Adicionar aliases do Docker ao .zshrc
    if ! grep -q '# Docker aliases' ~/.zshrc; then
        log_info "Adicionando aliases do Docker..."
        cat >> ~/.zshrc << 'EOF'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -f'
alias dclean='docker system prune -a -f'
alias dvolumes='docker volume ls'
alias dnetworks='docker network ls'

# Docker Compose aliases
alias dcup='docker-compose up'
alias dcupd='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcrestart='docker-compose restart'
alias dclogs='docker-compose logs'
alias dcbuild='docker-compose build'
alias dcpull='docker-compose pull'

# Função para limpar Docker completamente
docker-clean-all() {
    echo "🧹 Limpando Docker completamente..."
    docker system prune -a -f --volumes
    docker builder prune -a -f
    echo "✅ Docker limpo!"
}

# Função para verificar status do Docker
docker-status() {
    echo "🐳 Status do Docker:"
    docker info --format '{{.ServerVersion}}' 2>/dev/null || echo "❌ Docker não está rodando"
    echo "📊 Containers ativos: $(docker ps -q | wc -l)"
    echo "💾 Imagens: $(docker images -q | wc -l)"
    echo "🌐 Volumes: $(docker volume ls -q | wc -l)"
}
EOF
    fi
    
    log_success "Docker configurado"
}

# Função para configurar Kitty
setup_kitty() {
    log_step "Configurando Kitty..."
    
    # Cria diretório de configuração
    mkdir -p "$KITTY_CONF_DIR"
    
    # Copia configuração personalizada ou cria padrão
    if [ -f "$DOT_FILES_DIR/kitty.conf" ]; then
        log_info "Copiando configuração personalizada do Kitty..."
        cp "$DOT_FILES_DIR/kitty.conf" "$KITTY_CONF_DIR/kitty.conf"
    else
        log_warning "Arquivo kitty.conf não encontrado. Criando configuração padrão..."
        cat > "$KITTY_CONF_DIR/kitty.conf" <<EOF
font_family      FiraCode Nerd Font
bold_font        auto
italic_font      auto
font_size        12.0
enable_audio_bell no
background_opacity 0.9
window_padding_width 10
EOF
    fi
    
    # Define Kitty como terminal padrão
    if command_exists xdg-mime; then
        log_info "Definindo Kitty como terminal padrão..."
        xdg-mime default kitty.desktop x-scheme-handler/terminal
    fi
    
    # Cria arquivo .desktop
    mkdir -p "$HOME/.local/share/applications"
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
    
    log_success "Kitty configurado"
}

# Função para configurar Zsh
setup_zsh() {
    log_step "Configurando Zsh..."
    
    # Define Zsh como shell padrão
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Definindo Zsh como shell padrão..."
        chsh -s "$(which zsh)"
    fi
    
    # Instala Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Instalando Oh My Zsh..."
        export RUNZSH=no
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    
    # Instala PowerLevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        log_info "Instalando PowerLevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    fi
    
    log_success "Zsh configurado"
}

# Função para instalar plugins do Zsh
install_zsh_plugins() {
    log_step "Instalando plugins do Zsh..."
    
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
    
    for plugin in "${!plugins_git[@]}"; do
        if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            log_info "Instalando plugin: $plugin"
            git clone "${plugins_git[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
        fi
    done
    
    # Ativa plugins no .zshrc
    local desired_plugins="git zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search you-should-use fast-syntax-highlighting zsh-vi-mode fzf-tab"
    sed -i "s/^plugins=.*/plugins=($desired_plugins)/" ~/.zshrc
    
    log_success "Plugins do Zsh instalados"
}

# Função para instalar ferramentas adicionais
install_additional_tools() {
    log_step "Instalando ferramentas adicionais..."
    
    # colorls
    if ! command_exists colorls; then
        log_info "Instalando colorls..."
        sudo gem install colorls
    fi
    
    # eza
    if ! command_exists eza; then
        log_info "Instalando eza..."
        sudo pacman -S --noconfirm eza
    fi
    
    # secman
    if ! command_exists secman; then
        log_info "Instalando secman..."
        if command_exists npm; then
            sudo npm install -g secman || curl -fsSL https://cli.secman.dev | bash
        else
            curl -fsSL https://cli.secman.dev | bash
        fi
    fi
    
    # tran
    if ! command_exists tran; then
        log_info "Instalando tran..."
        curl -sL https://cutt.ly/tran-cli | bash
    fi
    
    # Instalar ferramentas de desenvolvimento adicionais via npm/yarn
    if command_exists npm; then
        log_info "Instalando ferramentas globais do Node.js..."
        npm install -g @vue/cli create-react-app typescript ts-node nodemon pm2 concurrently
    fi
    
    # Instalar ferramentas Python
    if command_exists pip; then
        log_info "Instalando ferramentas Python..."
        pip install --user black flake8 mypy pytest ipython jupyter
    fi
    
    # Instalar ferramentas Go
    if command_exists go; then
        log_info "Instalando ferramentas Go..."
        go install github.com/cosmtrek/air@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
        go install golang.org/x/tools/gopls@latest
    fi
    
    # Instalar ferramentas Rust
    if command_exists cargo; then
        log_info "Instalando ferramentas Rust..."
        cargo install cargo-watch cargo-edit cargo-audit
    fi
    
    # Instalar ferramentas adicionais que não estão no pacman
    if ! command_exists neofetch; then
        log_info "Instalando neofetch..."
        if command_exists yay; then
            yay -S --noconfirm neofetch
        elif command_exists paru; then
            paru -S --noconfirm neofetch
        else
            log_warning "Instale yay ou paru para instalar neofetch: yay -S neofetch"
        fi
    fi
    
    if ! command_exists cheat; then
        log_info "Instalando cheat..."
        if command_exists yay; then
            yay -S --noconfirm cheat
        elif command_exists paru; then
            paru -S --noconfirm cheat
        else
            log_warning "Instale yay ou paru para instalar cheat: yay -S cheat"
        fi
    fi
    
    if ! command_exists yq; then
        log_info "Instalando yq..."
        if command_exists yay; then
            yay -S --noconfirm yq
        elif command_exists paru; then
            paru -S --noconfirm yq
        else
            log_warning "Instale yay ou paru para instalar yq: yay -S yq"
        fi
    fi
    
    log_success "Ferramentas adicionais instaladas"
}

# Função para configurar aliases
setup_aliases() {
    log_step "Configurando aliases..."
    
    # Adiciona alias para terminal
    if ! grep -q 'alias terminal=' ~/.zshrc; then
        echo '
# Definindo kitty como terminal padrão
alias terminal="kitty"
' >> ~/.zshrc
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
    
    log_success "Aliases configurados"
}

# Função para mostrar instruções finais
show_final_instructions() {
    echo -e "\n${GREEN}🎉 Setup concluído com sucesso!${NC}\n"
    
    echo -e "${CYAN}📋 Próximos passos:${NC}"
    echo "1. Reinicie o terminal ou execute 'zsh'"
    echo "2. Configure o PowerLevel10k executando 'p10k configure'"
    echo "3. Para usar Alt+Enter como atalho, adicione ao seu WM:"
    echo "   - i3: bindsym Mod1+Return exec kitty"
    echo "   - sxhkd: alt + Return → kitty"
    echo "4. Ative o Dash to Dock: gnome-extensions enable dash-to-dock@micxgx.gmail.com"
    echo "5. Faça logout e login para aplicar as mudanças do Docker"
    
    echo -e "\n${YELLOW}🔧 Ferramentas instaladas:${NC}"
    echo "• Kitty (terminal)"
    echo "• Oh My Zsh + PowerLevel10k"
    echo "• Plugins: syntax-highlighting, autosuggestions, completions, etc."
    echo "• colorls/eza (ls colorido)"
    echo "• secman (gerenciador de segredos)"
    echo "• tran (tradutor CLI)"
    echo "• Docker + Docker Compose"
    echo "• Node.js, Python, Go, Rust, Java"
    echo "• PostgreSQL, Redis, MongoDB"
    echo "• Ferramentas CLI: bat, fd, ripgrep, fzf, etc."
    echo "• Dash to Dock (GNOME)"
    
    echo -e "\n${PURPLE}🐳 Comandos Docker úteis:${NC}"
    echo "• dcup - docker-compose up"
    echo "• dps - docker ps"
    echo "• dex - docker exec -it"
    echo "• docker-status - verificar status"
    echo "• docker-clean-all - limpar tudo"
    
    echo -e "\n${PURPLE}✨ Use Alt + Enter no seu WM para abrir o Kitty!${NC}\n"
}

# Função principal
main() {
    show_logo
    echo ""
    
    # Verifica se está rodando como root
    if [ "$EUID" -eq 0 ]; then
        log_error "Não execute este script como root!"
        exit 1
    fi
    
    # Verifica se está no endeavourOS/Arch
    if ! command_exists pacman; then
        log_error "Este script é específico para sistemas baseados em Arch Linux"
        exit 1
    fi
    
    update_system
    install_basic_dependencies
    setup_kitty
    setup_zsh
    install_zsh_plugins
    install_development_tools
    setup_docker_config
    install_additional_tools
    setup_aliases
    
    show_final_instructions
}

# Executa função principal
main "$@"
