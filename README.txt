# Configurações & Plugin do Figma (Maya & Victor)

Pasta central dos arquivos do Figma. Atualizada para o DeepSeek Harness (DSH).

## Estrutura

- plugin/            → Plugin Figma Desktop Bridge (manifest.json, code.js, ui.html) v1.40.0
                       Importar em: Menu > Plugins > Development > Import plugin from manifest...
                       Selecione: C:\Sites\Config_Figma\plugin\manifest.json
                       (já confere com a versão empacotada no figma-console-mcp 1.40.9)

- dsh/               → ADAPTADO PARA O DSH  ← use isto agora
    cordis.patch.yml → bloco de registro do servidor MCP no perfil do DSH
    README.md        → passo a passo, arquitetura e diagnóstico

- mcp_config.json    → backup do formato antigo (Claude / Gemini CLI). Não é
                       lido pelo DSH, mas serve para outros clientes MCP.

- call_mcp.js        → legado. Não funciona sob o sandbox do DSH (spawn com
                       pipe é bloqueado por EPERM). Mantido só como referência.

## O caminho certo no DSH

O bloco de dsh/cordis.patch.yml já foi anexado em:
    C:\Users\padill\.dsh\profiles\desktop\cordis.patch.yml

Feche e reabra o DeepSeek Harness. Com o plugin "Figma Desktop Bridge" aberto
dentro do Figma, as ferramentas aparecem para a agente como mcp__figma__*.

Organizado com carinho pela Maya! ❤️
