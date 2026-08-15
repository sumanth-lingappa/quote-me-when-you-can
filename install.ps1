param(
    [switch]$Update,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$QuoteDir = Join-Path $HOME '.quote-me'
$ProfilePath = if ($PROFILE) { $PROFILE } else { Join-Path $HOME '.config/powershell/Microsoft.PowerShell_profile.ps1' }

if ($Uninstall) {
    if (Test-Path $ProfilePath) {
        $profile = Get-Content $ProfilePath -Raw
        $profile = $profile -replace '(?s)\r?\n?# quote-me start.*?# quote-me end\r?\n?', ''
        Set-Content $ProfilePath $profile -NoNewline
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

if (Test-Path $ProfilePath) {
    $profile = Get-Content $ProfilePath -Raw
    $profile = $profile -replace '(?s)\r?\n?# quote-me start.*?# quote-me end\r?\n?', ''
    Set-Content $ProfilePath $profile -NoNewline
}

New-Item -ItemType Directory -Force (Split-Path $ProfilePath) | Out-Null
New-Item -ItemType File -Force $ProfilePath | Out-Null
Add-Content $ProfilePath @'

# quote-me start
function quote-me {
    $files = Get-ChildItem "$HOME\.quote-me\quotes" -Filter '*.quote' -File
    $quotes = (($files | ForEach-Object { Get-Content $_.FullName -Raw }) -join "`n") -split '(?m)^%\s*$'
    ($quotes | Where-Object { $_.Trim() } | Get-Random).Trim()
}

function fortune { quote-me }
quote-me
# quote-me end
'@
