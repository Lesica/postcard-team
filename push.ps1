# push.ps1 — ежедневная команда, которую запускает Лара
# Не для Алёны.

$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
if (-not $here) { $here = Get-Location }
Set-Location $here

if (-not (Test-Path ".git")) {
    Write-Host "[ERROR] Не git repo. Сначала запусти .\setup_github.ps1" -ForegroundColor Red
    exit 1
}

# Проверка что есть что коммитить
$status = git status --porcelain
if (-not $status) {
    Write-Host "[OK] Нет изменений для push" -ForegroundColor Green
    exit 0
}

# Auto-message с timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$msg = "Update board $timestamp"

# Если есть аргумент — использовать как commit message
if ($args.Count -gt 0) {
    $msg = $args -join " "
}

git add . | Out-Null
git commit -m $msg | Out-Null
git push 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Push сделан: $msg" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Push не прошёл. Проверь gh auth status." -ForegroundColor Red
    exit 1
}
