# Figma no DeepSeek Harness — adaptação DSH

Esta pasta é a versão **adaptada para o DSH** da configuração que estava em
`C:\Sites\Config_Figma` (feita originalmente para o Gemini CLI / Claude).

## Por que precisou adaptar

| Antes (Gemini) | Agora (DSH) |
|---|---|
| `mcp_config.json` com `mcpServers` (formato Claude/Gemini) | entrada Cordis `insert: @deepseek-ai/dsh-mcp-client` |
| `call_mcp.js` chamando `npx` por fora, com `child_process` + pipes | **não funciona mais** — o sandbox do DSH bloqueia `spawn` com stdio em pipe (`EPERM`, errno -4048) |
| duas entradas: `figma` (HTTP :3333) e `figma-writer` (npx) | uma entrada principal `figma` (stdio) + HTTP :3333 opcional |
| token em `X-Figma-Token` (header) | token em `FIGMA_ACCESS_TOKEN` (env do processo) |

O DSH já traz o cliente MCP embutido (`@deepseek-ai/dsh-mcp-client`), então não
precisa de script intermediário: o harness sobe o servidor e expõe as
ferramentas nativamente.

## Como está montado

- **Servidor:** `figma-console-mcp` v1.40.9 (via `npx`), transporte `stdio`.
- **Nome do servidor:** `figma` → ferramentas viram `mcp__figma__*`.
- **Bridge:** o servidor abre um WebSocket em `localhost:9223` (cai para
  9224–9232 se estiver ocupado) e o plugin **Figma Desktop Bridge** conecta nele
  de dentro do Figma.
- **Token:** `FIGMA_ACCESS_TOKEN` no `env` da entrada — só é usado pelas
  ferramentas que batem na API REST do Figma. As ferramentas de bridge (ler e
  escrever no documento aberto) funcionam só com o plugin rodando.

## Ligar / desligar (sob demanda)

O Figma fica **desligado por padrão**. Ele só é ativado quando você for usar:

```powershell
# desligar (padrão)
& 'C:\Sites\Config_Figma\dsh\figma-toggle.ps1' -Action off

# ligar
& 'C:\Sites\Config_Figma\dsh\figma-toggle.ps1' -Action on

# só conferir o estado
& 'C:\Sites\Config_Figma\dsh\figma-toggle.ps1' -Action status
```

O bloco fica entre os marcadores `FIGMA-MCP BEGIN/END` no `cordis.patch.yml`.
Tudo que estiver fora dos marcadores é preservado. A mudança vale em tempo real
(o DSH recarrega o perfil sozinho) — se as ferramentas `mcp__figma__*` não
aparecerem, feche e reabra o DSH.

> **Por que desligar:** as ~120 ferramentas do Figma entram no prompt em toda
> mensagem. Com prompt caching elas saem baratas (cache-hit custa ~50x menos),
> mas ainda assim respondem por uma fatia relevante do gasto. Ligar só quando
> precisa é a forma mais limpa de economizar.

## Passo a passo

1. **Plugin no Figma** — `Menu → Plugins → Development → Figma Desktop Bridge`.
   O `plugin/` desta pasta já está na versão 1.40.0, idêntica à que o
   `figma-console-mcp` empacota (`code.js`, `ui.html` e `manifest.json` com hash
   igual). Não precisa reimportar.
2. **Registrar no DSH** — o bloco de `dsh/cordis.patch.yml` anexado ao final de
   `C:\Users\padill\.dsh\profiles\desktop\cordis.patch.yml`.
3. **Conferir** — as ferramentas `mcp__figma__*` aparecem na lista de tools da
   conversa.

> **O patch NÃO exige reiniciar o DSH.** Verificado em 03/10/2026: ligando e desligando a
> entrada, o harness recarregou o perfil em tempo real — as ferramentas `mcp__figma__*`
> apareceram e sumiram sem fechar o app. Reiniciar só se elas não aparecerem.

## Armadilhas da API do Figma (já encontradas na prática)

O plugin declara `documentAccess: dynamic-page`. Isso muda três coisas:

- **Trocar de página:** `figma.currentPage = page` **lança erro**.
  Use `await figma.setCurrentPageAsync(page)`.
- **Listar páginas:** `await figma.loadAllPagesAsync()` antes de ler `figma.root.children`.
- **Montar frame com auto-layout:** a ordem importa. Definir
  `counterAxisSizingMode = 'FIXED'`, chamar `resize(largura, altura)`, anexar os filhos e
  **só então** `primaryAxisSizingMode = 'AUTO'`. Invertendo, a altura trava no valor do
  `resize()` e o frame não cresce.
- **Texto com largura fixa:** `t.resize(largura, t.height)` antes de `t.characters`; depois
  `textAutoResize = 'HEIGHT'` e `layoutSizingHorizontal = 'FILL'` (o `FILL` só funciona
  depois de anexar a um pai com auto-layout).

## Diagnóstico rápido

- **Não apareceu nenhuma tool `mcp__figma__*`**
  → o `npx` não resolveu. Troque `command` pelo caminho absoluto do Node:
  `C:\Program Files\nodejs\node.exe` e `args: [<caminho>\dist\local.js]`.
- **Ferramentas aparecem, mas dão erro de bridge**
  → o plugin não está aberto no Figma. Abra e veja o badge de servidores
  conectados na UI do plugin.
- **`EADDRINUSE` / porta ocupada**
  → sobrou processo zumbi de uma sessão antiga. Mate os `node.exe` órfãos; o
  servidor re-varre a faixa 9223–9232 sozinho.
- **Erro 403 nas ferramentas de API**
  → token expirado/revogado em `FIGMA_ACCESS_TOKEN`.

## Sobre o `call_mcp.js`

Fica no repositório só como referência histórica. Dentro do DSH ele **não
roda**: o sandbox de arquivos bloqueia processos filhos com stdio em pipe
(`spawn EPERM`). Se um dia precisar de algo assim, o caminho é registrar o
servidor MCP no perfil (como acima), não chamar por fora.
