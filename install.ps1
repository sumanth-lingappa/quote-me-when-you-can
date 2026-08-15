param(
    [switch]$Update,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$QuoteDir = Join-Path $HOME '.quote-me'

if ($Uninstall) {
    if (Test-Path $PROFILE) {
        $profile = Get-Content $PROFILE -Raw
        $profile = $profile -replace '(?s)\r?\n?# quote-me start.*?# quote-me end\r?\n?', ''
        Set-Content $PROFILE $profile -NoNewline
    }
    exit
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Install Git first: winget install --id Git.Git -e'
}

if ($Update) {
    git -C $QuoteDir pull --ff-only
} elseif (Test-Path $QuoteDir) {
    throw 'Already installed. Run: & "$HOME\.quote-me\install.ps1" -Update'
} else {
    git clone https://github.com/sumanth-lingappa/quote-me-when-you-can.git $QuoteDir
}

if (-not $Update) {
    New-Item -ItemType Directory -Force (Split-Path $PROFILE) | Out-Null
    New-Item -ItemType File -Force $PROFILE | Out-Null
    Add-Content $PROFILE @'

# quote-me start
function quote-me {
    $files = Get-ChildItem "$HOME\.quote-me\quotes" -Filter '*.quote' -File
    $quotes = (($files | ForEach-Object { Get-Content $_.FullName -Raw }) -join "`n") -split '(?m)^%\s*$'
    ($quotes | Where-Object { $_.Trim() } | Get-Random).Trim()
}

$quoteDateFile = Join-Path $HOME '.quote-me-last-shown'
if (-not (Test-Path $quoteDateFile) -or (Get-Content $quoteDateFile -Raw).Trim() -ne (Get-Date -Format 'yyyy-MM-dd')) {
    quote-me
    Set-Content $quoteDateFile (Get-Date -Format 'yyyy-MM-dd')
}
# quote-me end
'@
}
