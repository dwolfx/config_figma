# Projetos e Módulos Incluídos — `Config_Figma`

Este documento detalha cada uma das pastas reunidas neste repositório central de Design & Figma.

---

## 1. Plugins & Integração MCP (`plugin/`, `plugin_antigravity/`, `dsh/`)

* **`plugin/`**:
  * Implementação do **Figma Desktop Bridge** (`v1.40.0`), composta por `manifest.json`, `code.js` e `ui.html`.
  * Permite que agentes de IA inspecionem nós, criem componentes, apliquem variáveis/tokens e leiam estilos diretamente da instância aberta do Figma Desktop.
* **`plugin_antigravity/`**:
  * Variante dedicada para integração direta com o ambiente **Antigravity**.
* **`dsh/`**:
  * Contém `cordis.patch.yml` e guia passo a passo (`README.md`) para registro do servidor `figma-console-mcp` no perfil desktop do DeepSeek Harness.

---

## 2. Arquivos Figcraft (`Figcraft/`)

Diretório que armazena os pacotes de design e estrutura de telas no formato `.figcraft`:

* **`CONSA B2C.figcraft` & `CONSA B2C.v2.figcraft`**:
  * Protótipos e especificações de interface da jornada do cliente (**Consagrado B2C** — comanda digital, cardápio interativo, divisão de conta por item e login).
* **`Reforma Tributária.figcraft`**:
  * Projeto visual e fluxos de tela voltados ao tema de Reforma Tributária.

---

## 3. Porto Bank — Documentação Fiança (`portobank/documentacao-fianca/`)

Projeto de documentação viva e biblioteca de componentes traduzidos do Figma para código web (`HTML5 + CSS3`):

* **`index.html` & `styles.css`**:
  * Página principal da documentação do produto de Fiança do Porto Bank.
* **`figma_components.html` & `figma_components.css`**:
  * Catálogo isolado dos componentes visuais e tokens extraídos do design system no Figma.
* **`assets/`**:
  * Ícones, ilustrações e recursos gráficos utilizados na documentação.
