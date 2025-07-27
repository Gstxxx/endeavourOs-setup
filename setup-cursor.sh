#!/bin/bash

# Logo do projeto
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗        ║
║   ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗       ║
║   ██║     ██║   ██║██████╔╝█████╗  ██║   ██║██████╔╝       ║
║   ██║     ██║   ██║██╔══██╗██╔══╝  ██║   ██║██╔══██╗       ║
║   ╚██████╗╚██████╔╝██║  ██║███████╗╚██████╔╝██║  ██║       ║
║    ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝       ║
║                                                              ║
║           🚀 Instalador do Cursor para endeavourOS 🚀       ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF

echo ""

APP_NAME="Cursor"
APPIMAGE_NAME="Cursor-1.2.4-x86_64.AppImage"
APPIMAGE_URL="https://downloads.cursor.com/production/a8e95743c5268be73767c46944a71f4465d05c90/linux/x64/$APPIMAGE_NAME"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME,,}.desktop"
ICON_DIR="$HOME/.local/share/icons"
ICON_PATH="$ICON_DIR/${APP_NAME,,}.png"

echo "⬇️ Baixando AppImage do $APP_NAME..."
mkdir -p "$INSTALL_DIR"
curl -L -o "$INSTALL_DIR/cursor" "$APPIMAGE_URL"
chmod +x "$INSTALL_DIR/cursor"

echo "🎨 Baixando ícone..."
mkdir -p "$ICON_DIR"
curl -L -o "$ICON_PATH" "https://raw.githubusercontent.com/madladj97/cursor-icon/main/icon.png"

echo "📝 Criando atalho de menu..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$INSTALL_DIR/cursor
Icon=$ICON_PATH
Type=Application
Categories=Development;Utility;
Terminal=false
EOF

echo "🔄 Atualizando cache de atalhos..."
update-desktop-database "$HOME/.local/share/applications/"

echo "✅ $APP_NAME instalado com sucesso! Ícone incluído. Abra pelo menu do sistema."
