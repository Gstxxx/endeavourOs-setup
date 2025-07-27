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
║        ██████╗  ██████╗ ██╗  ██╗███████╗██████╗             ║
║       ██╔═══██╗██╔════╝ ██║ ██╔╝██╔════╝██╔══██╗             ║
║       ██║   ██║██║  ███╗█████╔╝ █████╗  ██████╔╝             ║
║       ██║   ██║██║   ██║██╔═██╗ ██╔══╝  ██╔══██╗             ║
║       ╚██████╔╝╚██████╔╝██║  ██╗███████╗██║  ██║             ║
║        ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝             ║
║                                                              ║
║           🐳 Setup Docker - Simples e Rápido 🐳              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
}

# Função para instalar Docker e Docker Compose
install_docker() {
    log_step "Instalando Docker e Docker Compose..."
    
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
    
    log_success "Docker instalado e configurado"
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

# Função para criar arquivo docker-compose de exemplo
create_docker_compose_example() {
    log_step "Criando arquivo docker-compose de exemplo..."
    
    cat > docker-compose-example.yml << 'EOF'
version: "3.8"

services:
  # PostgreSQL
  postgres:
    image: postgres:15-alpine
    container_name: dev_postgres
    environment:
      POSTGRES_DB: development
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev123
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  # Redis
  redis:
    image: redis:7-alpine
    container_name: dev_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

  # MySQL
  mysql:
    image: mysql:8.0
    container_name: dev_mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: development
      MYSQL_USER: dev
      MYSQL_PASSWORD: dev123
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped

  # Adminer (interface web para bancos)
  adminer:
    image: adminer:latest
    container_name: dev_adminer
    ports:
      - "8080:8080"
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
  mysql_data:

networks:
  default:
    name: dev_network
EOF

    log_success "Arquivo docker-compose-example.yml criado"
}

# Função para mostrar instruções finais
show_final_instructions() {
    echo -e "\n${GREEN}🎉 Setup Docker concluído com sucesso!${NC}\n"
    
    echo -e "${CYAN}📋 Próximos passos:${NC}"
    echo "1. Faça logout e login para aplicar as mudanças do Docker"
    echo "2. Teste o Docker: docker --version"
    echo "3. Teste o Docker Compose: docker-compose --version"
    echo "4. Para iniciar o ambiente de exemplo:"
    echo "   docker-compose -f docker-compose-example.yml up -d"
    
    echo -e "\n${YELLOW}🔧 O que foi instalado:${NC}"
    echo "• Docker Engine"
    echo "• Docker Compose"
    echo "• Docker Buildx"
    echo "• Aliases úteis no .zshrc"
    
    echo -e "\n${PURPLE}🐳 Comandos Docker úteis:${NC}"
    echo "• dcup - docker-compose up"
    echo "• dps - docker ps"
    echo "• dex - docker exec -it"
    echo "• docker-status - verificar status"
    echo "• docker-clean-all - limpar tudo"
    
    echo -e "\n${PURPLE}🌐 URLs dos serviços (exemplo):${NC}"
    echo "• Adminer (bancos): http://localhost:8080"
    
    echo -e "\n${PURPLE}📁 Arquivo criado:${NC}"
    echo "• docker-compose-example.yml - Exemplo básico"
    
    echo -e "\n${CYAN}🚀 Para testar:${NC}"
    echo "docker run hello-world"
    echo -e "\n"
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
    
    install_docker
    setup_docker_config
    create_docker_compose_example
    
    show_final_instructions
}

# Executa função principal
main "$@" 