function Get-VSCodeExtensions {
    $extensions = code --list-extensions
    return $extensions
}

# Function to display the menu and get user input
function Show-Menu {
    param (
        [array]$extensions,
        [array]$selections,
        [int]$currentIndex
    )
    Clear-Host
    
        Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        Write-Host ""
        Write-Host "                                            Welcome to Visual Studio Code extension uninstaller"
        Write-Host ""
        Write-Host "                                         Below you should see a selection of options to choose from"
        Write-Host "                                        Will be updated frequently to include new/different extensions"
        Write-Host "                                            and will have newer options in the future as well"
        Write-Host ""
        Write-Host "                                                    Script written by: Jason Kay"
        Write-Host "                                                    Script written on: June 17th 2024"
        Write-Host ""
        Write-Host "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        Write-Host ""
        Write-Host ""
        Write-Host "=============================="
        Write-Host "    VS Code Extension Menu    "
        Write-Host "=============================="

    for ($i = 0; $i -lt $extensions.Count; $i++) {
        $status = if ($selections[$i]) { '[X]' } else { '[ ]' }
        if ($i -eq $currentIndex) {
            Write-Host "=> $($i+1). $status $($extensions[$i])"
        } else {
            Write-Host "   $($i+1). $status $($extensions[$i])"
        }
    }
    Write-Host "=============================="
    if ($currentIndex -eq $extensions.Count) {
        Write-Host "=> Confirm selections and uninstall"
    } else {
        Write-Host "   Confirm selections and uninstall"
    }
    if ($currentIndex -eq ($extensions.Count + 1)) {
        Write-Host "=> Exit without uninstalling"
    } else {
        Write-Host "   Exit without uninstalling"
    }
    Write-Host "=============================="
}

# Function to toggle a file selection
function Set-Selection {
    param (
        [int]$index,
        [array]$selections
    )
    if ($index -ge 0 -and $index -lt $selections.Count) {
        $selections[$index] = -not $selections[$index]
    }
}

# Function to uninstall selected extensions
function Uninstall-SelectedExtensions {
    param (
        [array]$extensions,
        [array]$selections
    )
    Write-Host "Confirming selections for uninstallation..."
    for ($i = 0; $i -lt $extensions.Count; $i++) {
        if ($selections[$i]) {
            Write-Host "Uninstalling: $($extensions[$i])"
            code --uninstall-extension $extensions[$i]
        }
    }
    Write-Host "Selected extensions uninstalled successfully."
}

# Get list of VS Code extensions
$extensions = Get-VSCodeExtensions

# Initialize selection array
$selections = @($false) * $extensions.Count

# Initialize current index
$currentIndex = 0

# Main loop
while ($true) {
    Show-Menu -extensions $extensions -selections $selections -currentIndex $currentIndex
    $key = [System.Console]::ReadKey($true).Key

    switch ($key) {
        'UpArrow' {
            if ($currentIndex -gt 0) {
                $currentIndex--
            }
        }
        'DownArrow' {
            if ($currentIndex -lt ($extensions.Count + 1)) {
                $currentIndex++
            }
        }
        'Enter' {
            if ($currentIndex -lt $extensions.Count) {
                Set-Selection -index $currentIndex -selections $selections
            } elseif ($currentIndex -eq $extensions.Count) {
                Uninstall-SelectedExtensions -extensions $extensions -selections $selections
                return
            } elseif ($currentIndex -eq ($extensions.Count + 1)) {
                Write-Host "Exiting without uninstalling extensions."
                return
            }
        }
    }
}

Write-Host "Script has ended."