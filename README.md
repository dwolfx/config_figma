# 🎨 Config_Figma — Ecossistema Figma, Plugins MCP, Figcraft & Protótipos

Repositório central contendo os plugins de ponte do Figma Desktop (**Figma Desktop Bridge** para MCP / Antigravity / DSH), projetos e arquivos **Figcraft** e especificações de componentes do **Porto Bank**.

---

## 📦 Estrutura do Repositório

```text
Config_Figma/
├── plugin/                     # Plugin Figma Desktop Bridge (manifest.json, code.js, ui.html)
├── plugin_antigravity/         # Versão/configuração adaptada do plugin para o Antigravity
├── dsh/                        # Configuração e documentação do servidor MCP para o DeepSeek Harness
├── Figcraft/                   # Arquivos .figcraft de projetos (Consagrado B2C e Reforma Tributária)
├── portobank/                  # Documentação e componentes HTML/CSS extraídos do Figma (Fiança)
│   └── documentacao-fianca/    # Catálogo visual (index.html, figma_components.html, styles.css)
├── mcp_config.json             # Configuração base de referência para clientes MCP
├── call_mcp.js                 # Script utilitário de chamada MCP
└── PROJETOS_INCLUIDOS.md       # Detalhamento de cada módulo e projeto deste repositório
```

---

## 🔌 Como Importar o Plugin no Figma Desktop

1. Abra o **Figma Desktop App**.
2. Acesse **Menu > Plugins > Development > Import plugin from manifest...**
3. Selecione o arquivo:
   - `plugin/manifest.json` (ou `plugin_antigravity/manifest.json`)
4. Mantenha o plugin aberto dentro do arquivo Figma desejado para habilitar a comunicação WebSocket/MCP com o agente.

---

## 📚 Documentação Detalhada

Consulte o arquivo [PROJETOS_INCLUIDOS.md](./PROJETOS_INCLUIDOS.md) para detalhes sobre:
- Os arquivos `.figcraft` na pasta `Figcraft/` (**Consagrado B2C** e **Reforma Tributária**).
- A documentação interativa de fiança locatícia em `portobank/documentacao-fianca/`.
- A configuração dos servidores MCP em `dsh/` e `plugin_antigravity/`.
