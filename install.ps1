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
    git -C $QuoteDir pull --ff-only
    & "$QuoteDir\install.ps1" -Update
    exit $LASTEXITCODE
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
    $files = Get-ChildItem (Join-Path $HOME '.quote-me/quotes') -Filter '*.quote' -File
    $quotes = (($files | ForEach-Object { Get-Content $_.FullName -Raw }) -join "`n") -split '(?m)^%\s*$'
    ($quotes | Where-Object { $_.Trim() } | Get-Random).Trim()
}

function Update-QuoteMe {
    git -C (Join-Path $HOME '.quote-me') pull --ff-only
}

function fortune {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)
    $command = if ($Arguments) { $Arguments[0] } else { '' }
    switch ($command) {
        '--update' { Update-QuoteMe }
        '--auto-update' { Set-Content (Join-Path $HOME '.quote-me-auto-update') 'true'; Update-QuoteMe }
        '--no-auto-update' { Remove-Item (Join-Path $HOME '.quote-me-auto-update') -Force -ErrorAction SilentlyContinue }
        default { quote-me }
    }
}

function Test-QuoteMeUpdate {
    $quoteDir = Join-Path $HOME '.quote-me'
    git -C $quoteDir fetch --quiet origin master 2>$null
    if ($LASTEXITCODE -ne 0) { return }
    if ((git -C $quoteDir rev-parse HEAD) -ne (git -C $quoteDir rev-parse origin/master)) {
        if (Test-Path (Join-Path $HOME '.quote-me-auto-update')) {
            fortune --update
        } else {
            Write-Host 'New quotes are available. Run fortune --update, or fortune --auto-update to update automatically.'
        }
    }
}

quote-me
Test-QuoteMeUpdate
# quote-me end
'@
