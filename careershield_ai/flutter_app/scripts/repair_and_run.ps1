#!/usr/bin/env pwsh
# Repair pub cache, remove ephemeral plugin artifacts, clean builds, then run the app with verbose logs.
try {
  $root = Split-Path -Parent $MyInvocation.MyCommand.Definition
  Set-Location $root
} catch {
  # fallback to script cwd
}

Write-Host "=== Repairing pub cache ==="
flutter pub cache repair

Write-Host "=== Cleaning Flutter artifacts ==="
flutter clean

Write-Host "=== Removing ephemeral and tool folders (if present) ==="
$paths = @('.dart_tool', 'build', 'windows\flutter\ephemeral')
foreach ($p in $paths) {
  if (Test-Path $p) {
    Write-Host "Removing $p"
    Remove-Item -Recurse -Force $p -ErrorAction SilentlyContinue
  }
}

Write-Host "=== Getting packages ==="
flutter pub get

Write-Host "=== Cleaning Android Gradle ==="
if (Test-Path "android\gradlew") {
  Push-Location android
  .\gradlew clean
  Pop-Location
} else {
  Write-Host "gradlew not found; skipping Android gradle clean"
}

Write-Host "=== Starting app (verbose). After the app launches, reproduce Google Sign-In and copy terminal logs ==="
flutter run -d 10BE4R0EC200096 -v
