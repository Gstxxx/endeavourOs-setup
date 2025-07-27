# 🔌 Extensões do Cursor

Lista das extensões instaladas no Cursor com links diretos para instalação.

## 📋 Como usar

Para instalar uma extensão, clique no link ou use o comando:

```bash
cursor --install-extension <nome-da-extensao>
```

## 🎨 Temas

### [Tokyo Night](https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night)

- **ID**: `enkia.tokyo-night`
- **Descrição**: Tema escuro elegante inspirado na cidade de Tóquio
- **Comando**: `cursor --install-extension enkia.tokyo-night`

## 🔧 Desenvolvimento Web

### [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)

- **ID**: `bradlc.vscode-tailwindcss`
- **Descrição**: Autocompletar e linting para Tailwind CSS
- **Comando**: `cursor --install-extension bradlc.vscode-tailwindcss`

### [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

- **ID**: `esbenp.prettier-vscode`
- **Descrição**: Formatador de código automático
- **Comando**: `cursor --install-extension esbenp.prettier-vscode`

### [ES7+ React/Redux/React-Native snippets](https://marketplace.visualstudio.com/items?itemName=dsznajder.es7-react-js-snippets)

- **ID**: `dsznajder.es7-react-js-snippets`
- **Descrição**: Snippets para React, Redux e React Native
- **Comando**: `cursor --install-extension dsznajder.es7-react-js-snippets`

### [Pretty TypeScript Errors](https://marketplace.visualstudio.com/items?itemName=yoavbls.pretty-ts-errors)

- **ID**: `yoavbls.pretty-ts-errors`
- **Descrição**: Exibe erros do TypeScript de forma mais legível
- **Comando**: `cursor --install-extension yoavbls.pretty-ts-errors`

## 🗄️ Banco de Dados

### [Prisma](https://marketplace.visualstudio.com/items?itemName=prisma.prisma)

- **ID**: `prisma.prisma`
- **Descrição**: Suporte para Prisma ORM
- **Comando**: `cursor --install-extension prisma.prisma`

## 🐳 Containers & DevOps

### [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)

- **ID**: `ms-azuretools.vscode-docker`
- **Descrição**: Suporte para Docker
- **Comando**: `cursor --install-extension ms-azuretools.vscode-docker`

### [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers)

- **ID**: `ms-azuretools.vscode-containers`
- **Descrição**: Desenvolvimento em containers
- **Comando**: `cursor --install-extension ms-azuretools.vscode-containers`

## 🔗 Git & Versionamento

### [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

- **ID**: `eamodio.gitlens`
- **Descrição**: Supercarga o Git com informações detalhadas
- **Comando**: `cursor --install-extension eamodio.gitlens`

## 🌐 API & HTTP

### [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

- **ID**: `humao.rest-client`
- **Descrição**: Cliente REST para testar APIs
- **Comando**: `cursor --install-extension humao.rest-client`

### [Dothttp](https://marketplace.visualstudio.com/items?itemName=shivaprasanth.dothttp-code)

- **ID**: `shivaprasanth.dothttp-code`
- **Descrição**: Cliente HTTP alternativo
- **Comando**: `cursor --install-extension shivaprasanth.dothttp-code`

## 🐚 Shell & Scripts

### [Shell Function Outline](https://marketplace.visualstudio.com/items?itemName=jannek-aalto.shell-function-outline)

- **ID**: `jannek-aalto.shell-function-outline`
- **Descrição**: Outline de funções para scripts shell
- **Comando**: `cursor --install-extension jannek-aalto.shell-function-outline`

### [Bash++](https://marketplace.visualstudio.com/items?itemName=rail5.bashpp)

- **ID**: `rail5.bashpp`
- **Descrição**: Melhorias para scripts Bash
- **Comando**: `cursor --install-extension rail5.bashpp`

## 📦 Instalação em Lote

Para instalar todas as extensões de uma vez, use este script:

```bash
#!/bin/bash
extensions=(
    "enkia.tokyo-night"
    "bradlc.vscode-tailwindcss"
    "esbenp.prettier-vscode"
    "dsznajder.es7-react-js-snippets"
    "yoavbls.pretty-ts-errors"
    "prisma.prisma"
    "ms-azuretools.vscode-docker"
    "ms-azuretools.vscode-containers"
    "eamodio.gitlens"
    "humao.rest-client"
    "shivaprasanth.dothttp-code"
    "jannek-aalto.shell-function-outline"
    "rail5.bashpp"
)

for ext in "${extensions[@]}"; do
    echo "Instalando: $ext"
    cursor --install-extension "$ext"
done
```

## 📝 Notas

- Todas as extensões são compatíveis com o Cursor
- Algumas podem precisar de configuração adicional
- Para desinstalar: `cursor --uninstall-extension <nome-da-extensao>`
- Para atualizar: `cursor --update-extensions`

---

_Gerado automaticamente em: $(date)_
