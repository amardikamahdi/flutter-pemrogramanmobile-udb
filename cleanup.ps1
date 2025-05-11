$projectPath = "c:\Users\amard\Documents\Universitas Duta Bangsa\Maret 2025 - Agustus 2025\Pemrograman Mobile\src"
$screensPath = Join-Path $projectPath "lib\screens"

# List of files to delete
$filesToDelete = @(
    "home_screen_modernized.dart",
    "home_screen_new.dart",
    "home_screen_fixed.dart"
)

# Delete each file
foreach ($file in $filesToDelete) {
    $filePath = Join-Path $screensPath $file
    if (Test-Path $filePath) {
        Write-Host "Deleting $file..."
        Remove-Item $filePath -Force
        Write-Host "$file deleted successfully."
    } else {
        Write-Host "$file not found."
    }
}

Write-Host "Cleanup complete!"
