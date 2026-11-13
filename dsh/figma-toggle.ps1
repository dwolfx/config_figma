# Liga/desliga o servidor MCP do Figma no perfil do DSH.
#
#   figma-toggle.ps1 -Action off     desliga (padrao recomendado)
#   figma-toggle.ps1 -Action on      liga
#   figma-toggle.ps1 -Action status  so mostra o estado
#
# O bloco fica entre os marcadores FIGMA-MCP BEGIN/END no cordis.patch.yml.
# Tudo que estiver FORA dos marcadores e preservado.

param(
    [ValidateSet('on', 'off', 'status')]
    [string]$Action = 'status'
)

$ErrorActionPreference = 'Stop'

$profile   = Join-Path $env:USERPROFILE '.dsh\profiles\desktop\cordis.patch.yml'
$blockFile = Join-Path $PSScriptRoot 'mcp-figma.block.yml'

$beginMark = '# >>> FIGMA-MCP BEGIN'
$endMark   = '# <<< FIGMA-MCP END'

if (-not (Test-Path $profile))   { throw "Perfil nao encontrado: $profile" }
if (-not (Test-Path $blockFile)) { throw "Bloco nao encontrado: $blockFile" }

function Remove-FigmaBlock([string]$text) {
    if ($text.Contains($beginMark)) {
        $pattern = '(?s)\r?\n?' + [regex]::Escape($beginMark) + '.*?' + [regex]::Escape($endMark) + '\r?\n?'
        return [regex]::Replace($text, $pattern, "`r`n")
    }
    # migracao: bloco antigo, escrito antes de existirem os marcadores
    $lines = $text -split "`r?`n"
    $hit = $lines | Select-String -SimpleMatch 'Figma Desktop Bridge para o DeepSeek Harness'
    if ($hit) {
        $idx = $hit[0].LineNumber - 1
        if ($idx -gt 0 -and $lines[$idx - 1] -match '^#\s*\u2500+') { $idx = $idx - 1 }
        return ((($lines[0..($idx - 1)]) -join "`r`n").TrimEnd() + "`r`n")
    }
    return $text
}

function Write-Utf8NoBom([string]$path, [string]$content) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $content, $enc)
}

$raw = Get-Content $profile -Raw
$on  = $raw.Contains($beginMark)

switch ($Action) {
    'status' {
        if ($on) { "FIGMA-MCP: LIGADO" } else { "FIGMA-MCP: DESLIGADO" }
    }
    'off' {
        $clean = (Remove-FigmaBlock $raw).TrimEnd() + "`r`n"
        Write-Utf8NoBom $profile $clean
        "FIGMA-MCP: desligado."
        "Perfil: $profile"
        "Para religar: & '$PSCommandPath' -Action on"
    }
    'on' {
        $base  = Remove-FigmaBlock $raw
        $block = (Get-Content $blockFile -Raw).TrimEnd()
        Write-Utf8NoBom $profile ($base.TrimEnd() + "`r`n`r`n" + $block + "`r`n")
        "FIGMA-MCP: ligado."
        "Perfil: $profile"
        "Fechar/reabrir o DSH se as ferramentas mcp__figma__* nao aparecerem."
    }
}
