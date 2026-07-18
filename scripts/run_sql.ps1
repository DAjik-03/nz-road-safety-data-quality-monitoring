$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

$duckdbCommand = Get-Command duckdb -ErrorAction SilentlyContinue
$localDuckDB = Join-Path $repoRoot '.tools\duckdb-1.5.4\duckdb.exe'

if ($duckdbCommand) {
    $duckdbExecutable = $duckdbCommand.Source
} elseif (Test-Path -LiteralPath $localDuckDB) {
    $duckdbExecutable = $localDuckDB
} else {
    throw 'DuckDB CLI was not found. Install DuckDB 1.5.x and ensure duckdb is on PATH.'
}

New-Item -ItemType Directory -Force -Path 'outputs\sql' | Out-Null

& $duckdbExecutable 'road_safety.duckdb' '-c' '.read sql/run_all.sql'
if ($LASTEXITCODE -ne 0) {
    throw "DuckDB workflow failed with exit code $LASTEXITCODE."
}
