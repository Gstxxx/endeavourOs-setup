# endeavourOS Setup

## 📋 Descrição

Scripts de automação para configurar um ambiente de desenvolvimento completo no endeavourOS, incluindo terminal personalizado, editor de código e ferramentas essenciais.

## 🛠️ Scripts Disponíveis

### `setup.sh`
Script principal que configura todo o ambiente de desenvolvimento:
- **Terminal**: Instala e configura o Kitty com configuração personalizada (tema Tokyo Night, transparência, atalhos)
- **Shell**: Configura o Zsh com Oh My Zsh e PowerLevel10k
- **Plugins**: Instala plugins essenciais para produtividade
- **Atalhos**: Configura atalhos de teclado para o terminal

### `setup-cursor.sh`
Script específico para instalar o Cursor (editor de código):
- **Download**: Baixa a versão mais recente do Cursor AppImage
- **Instalação**: Instala no diretório local do usuário
- **Ícone**: Adiciona ícone personalizado
- **Menu**: Cria entrada no menu de aplicações



## 🚀 Como Usar

### Setup Completo
```bash
chmod +x setup.sh
./setup.sh
```

### Setup do Terminal
```bash
chsh -s /usr/bin/zsh
```

### Instalar Cursor
```bash
chmod +x setup-cursor.sh
./setup-cursor.sh
```



## 📁 Estrutura do Projeto

```
endeavourOs-setup/
├── setup.sh           # Script principal de setup
├── setup-cursor.sh    # Instalador do Cursor
├── readme.md          # Documentação
└── dot-files/         # Arquivos de configuração
    └── kitty.conf     # Configuração do terminal Kitty
```

## 🎯 Características

- ✅ **Automatizado**: Instalação sem intervenção manual
- ✅ **Personalizado**: Configurações otimizadas para desenvolvimento
- ✅ **Modular**: Scripts independentes para diferentes componentes
- ✅ **Seguro**: Instala apenas no diretório local do usuário
- ✅ **Visual**: Logos ASCII art para melhor experiência

## 🐱 Configuração do Kitty

O script `setup.sh` copia automaticamente o arquivo `dot-files/kitty.conf` para `~/.config/kitty/kitty.conf`, incluindo:

- **Tema Tokyo Night**: Cores modernas e elegantes
- **Transparência**: Fundo com opacidade configurável
- **Desfoque**: Efeito blur no fundo (requer picom)
- **Atalhos**: Ctrl+Shift+T (nova aba), Ctrl+Shift+W (fechar aba)
- **Performance**: Configurações otimizadas para responsividade
- **Fonte**: FiraCode Nerd Font para ícones e símbolos


