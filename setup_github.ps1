# setup_github.ps1 — one-time setup для team board на GitHub
# Запускать из папки D:\Projects\Postcard\team

$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
if (-not $here) { $here = Get-Location }
Set-Location $here

Write-Host "=== Postcard Team — GitHub setup ===" -ForegroundColor Cyan
Write-Host ""

# 1. Проверка gh
try {
    $ghVersion = gh --version 2>$null
    if (-not $ghVersion) { throw "gh not found" }
    Write-Host "[OK] gh CLI установлен" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] gh CLI не найден. Установи через: winget install --id GitHub.cli" -ForegroundColor Red
    Write-Host "Закрой PowerShell после установки и открой заново." -ForegroundColor Yellow
    exit 1
}

# 2. Проверка auth
try {
    gh auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "not authed" }
    Write-Host "[OK] Авторизован в GitHub" -ForegroundColor Green
} catch {
    Write-Host "[ACTION] Запускаю gh auth login..." -ForegroundColor Yellow
    gh auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Авторизация не прошла. Попробуй gh auth login вручную." -ForegroundColor Red
        exit 1
    }
}

# 3. Узнаём username
$username = (gh api user --jq .login).Trim()
Write-Host "[INFO] GitHub username: $username" -ForegroundColor Cyan

# 4. Git init если ещё нет
if (-not (Test-Path ".git")) {
    Write-Host "[ACTION] git init..." -ForegroundColor Yellow
    git init -b main | Out-Null
    git config user.name $username
    Write-Host "[OK] git инициализирован" -ForegroundColor Green
} else {
    Write-Host "[OK] git уже инициализирован" -ForegroundColor Green
}

# 5. Создать .gitignore (минимальный)
if (-not (Test-Path ".gitignore")) {
@"
# OS
.DS_Store
Thumbs.db
desktop.ini

# Editor
.vscode/
.idea/
*.swp

# Local-only
private/
*.local.md
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "[OK] .gitignore создан" -ForegroundColor Green
}

# 6. Initial commit если staged ещё нет
git add . | Out-Null
$status = git status --porcelain
if ($status) {
    git commit -m "Initial team board setup" | Out-Null
    Write-Host "[OK] Initial commit сделан" -ForegroundColor Green
} else {
    Write-Host "[OK] Нечего коммитить, уже зафиксировано" -ForegroundColor Green
}

# 7. Создать public repo на GitHub если ещё нет
$repoName = "postcard-team"
$repoExists = $false
try {
    gh repo view "$username/$repoName" 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { $repoExists = $true }
} catch {
    $repoExists = $false
}

if ($repoExists) {
    Write-Host "[OK] Repo $username/$repoName уже существует на GitHub" -ForegroundColor Green
    $remoteUrl = (git remote get-url origin 2>$null)
    if (-not $remoteUrl) {
        Write-Host "[ACTION] Привязываю remote..." -ForegroundColor Yellow
        git remote add origin "https://github.com/$username/$repoName.git"
    }
} else {
    Write-Host "[ACTION] Создаю public repo $username/$repoName..." -ForegroundColor Yellow
    gh repo create $repoName --public --source . --remote origin --description "Postcard from Lesika with love — team communication board" --push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Не удалось создать repo. Возможно имя занято. Попробуй вручную: gh repo create" -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Repo создан и initial push сделан" -ForegroundColor Green
}

# 8. Push (если remote был но push не делался)
git push -u origin main 2>&1 | Out-Null

# 9. Финал
Write-Host ""
Write-Host "=== ГОТОВО ===" -ForegroundColor Green
Write-Host ""
Write-Host "Repo URL:" -ForegroundColor Cyan
Write-Host "  https://github.com/$username/$repoName"
Write-Host ""
Write-Host "Raw URL для board.md (это давать Аэлис и Северу):" -ForegroundColor Cyan
Write-Host "  https://raw.githubusercontent.com/$username/$repoName/main/board.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "Raw URL для PROTOCOL.md (как формат записей):" -ForegroundColor Cyan
Write-Host "  https://raw.githubusercontent.com/$username/$repoName/main/PROTOCOL.md"
Write-Host ""
Write-Host "Web URL repo (если захочется посмотреть в браузере):" -ForegroundColor Cyan
Write-Host "  https://github.com/$username/$repoName"
Write-Host ""
Write-Host "Дальше я буду пушить через .\push.ps1 — тебе ничего не делать." -ForegroundColor Magenta
