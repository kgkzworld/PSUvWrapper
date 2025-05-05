<#
.SYNOPSIS
    PowerShell wrapper for the UV Python Package Manager.

.DESCRIPTION
    This script provides a PowerShell interface to the UV Python Package Manager, allowing for easy execution of UV commands with PowerShell-style parameters.

.PARAMETER UVPath
    Path to the UV executable. Defaults to ".\source".

.PARAMETER Download
    Command to download and install UV if not found. Defaults to the official installation command.

.PARAMETER DeleteVenv
    Switch to delete the virtual environment after command execution.

.PARAMETER ActivateVenv
    Switch to activate the virtual environment after command execution.

.PARAMETER Command
    Generic command parameter to pass directly to UV.

.PARAMETER Run
    Run a command or script.

.PARAMETER Init
    Create a new project.

.PARAMETER Add
    Add dependencies to the project.

.PARAMETER Remove
    Remove dependencies from the project.

.PARAMETER Sync
    Update the project's environment.

.PARAMETER Lock
    Update the project's lockfile.

.PARAMETER Export
    Export the project's lockfile to an alternate format.

.PARAMETER Tree
    Display the project's dependency tree.

.PARAMETER Tool
    Run and install commands provided by Python packages.

.PARAMETER Python
    Manage Python versions and installations.

.PARAMETER Pip
    Manage Python packages with a pip-compatible interface.

.PARAMETER Venv
    Create a virtual environment.

.PARAMETER Build
    Build Python packages into source distributions and wheels.

.PARAMETER Publish
    Upload distributions to an index.

.PARAMETER Cache
    Manage uv's cache.

.PARAMETER Self
    Manage the uv executable.

.PARAMETER Version
    Display the uv version.

.PARAMETER PSHelp
    Display help documentation for PSUvWrapper.

.PARAMETER UvHelp
    Display help documentation for Uv.

.PARAMETER NoCache
    Avoid reading from or writing to the cache, instead using a temporary directory for the duration of the operation.

.PARAMETER CacheDir
    Path to the cache directory.

.PARAMETER ManagedPython
    Require use of uv-managed Python versions.

.PARAMETER NoManagedPython
    Disable use of uv-managed Python versions.

.PARAMETER NoPythonDownloads
    Disable automatic downloads of Python.

.PARAMETER Quiet
    Use quiet output.

.PARAMETER UvVerbose
    Use verbose output.

.PARAMETER Color
    Control the use of color in output [possible values: auto, always, never].

.PARAMETER NativeTls
    Whether to load TLS certificates from the platform's native certificate store.

.PARAMETER Offline
    Disable network access.

.PARAMETER AllowInsecureHost
    Allow insecure connections to a host.

.PARAMETER NoProgress
    Hide all progress outputs.

.PARAMETER Directory
    Change to the given directory prior to running the command.

.PARAMETER Project
    Run the command within the given project directory.

.PARAMETER ConfigFile
    The path to a `uv.toml` file to use for configuration.

.PARAMETER NoConfig
    Avoid discovering configuration files (`pyproject.toml`, `uv.toml`).

.EXAMPLE
    # Run a Python script
    .\PSUvWrapper.ps1 -Run "script.py"

.EXAMPLE
    # Initialize a new project
    .\PSUvWrapper.ps1 -Init "myproject"

.EXAMPLE
    # Add a package
    .\PSUvWrapper.ps1 -Add "requests"

.EXAMPLE
    # Install Python 3.11
    .\PSUvWrapper.ps1 -Python "3.11"

.EXAMPLE
    # Create a virtual environment
    .\PSUvWrapper.ps1 -Venv "myenv"

.EXAMPLE
    # Build a package
    .\PSUvWrapper.ps1 -Build "."

.EXAMPLE
    # Run with verbose output and custom cache directory
    .\PSUvWrapper.ps1 -Run "script.py" -Verbose -CacheDir "C:\cache"

.EXAMPLE
    # Display help information
    .\PSUvWrapper.ps1 -Help

.NOTES
    Author: Your Name
    Version: 1.0
    Date: $(Get-Date -Format "yyyy-MM-dd")
#>

[CmdletBinding()]
param (
    [Parameter()]
    [string]$UVPath = ".\source",

    [Parameter()]
    [string]$Download = "Invoke-RestMethod -Uri https://astral.sh/uv/install.ps1 | Invoke-Expression",

    [Parameter()]
    [switch]$DeleteVenv,

    [Parameter()]
    [switch]$ActivateVenv,

    # Command parameters
    [Parameter()]
    [string]$Command,

    [Parameter()]
    [string]$Run,

    [Parameter()]
    [string]$Init,

    [Parameter()]
    [string]$Add,

    [Parameter()]
    [string]$Remove,

    [Parameter()]
    [string]$Sync,

    [Parameter()]
    [string]$Lock,

    [Parameter()]
    [string]$Export,

    [Parameter()]
    [string]$Tree,

    [Parameter()]
    [string]$Tool,

    [Parameter()]
    [string]$Python,

    [Parameter()]
    [string]$Pip,

    [Parameter()]
    [string]$Venv,

    [Parameter()]
    [string]$Build,

    [Parameter()]
    [string]$Publish,

    [Parameter()]
    [string]$Cache,

    [Parameter()]
    [string]$Self,

    [Parameter()]
    [switch]$Version,

    [Parameter()]
    [switch]$PSHelp,

    [Parameter()]
    [switch]$UvHelp,

    # Global options
    [Parameter()]
    [switch]$NoCache,

    [Parameter()]
    [string]$CacheDir,

    [Parameter()]
    [switch]$ManagedPython,

    [Parameter()]
    [switch]$NoManagedPython,

    [Parameter()]
    [switch]$NoPythonDownloads,

    [Parameter()]
    [switch]$Quiet,

    [Parameter()]
    [switch]$UvVerbose,

    [Parameter()]
    [ValidateSet('auto', 'always', 'never')]
    [string]$Color,

    [Parameter()]
    [switch]$NativeTls,

    [Parameter()]
    [switch]$Offline,

    [Parameter()]
    [string]$AllowInsecureHost,

    [Parameter()]
    [switch]$NoProgress,

    [Parameter()]
    [string]$Directory,

    [Parameter()]
    [string]$Project,

    [Parameter()]
    [string]$ConfigFile,

    [Parameter()]
    [switch]$NoConfig
)

begin {
    # Set the UV executable path
    $uvExe = Join-Path -Path $UVPath -ChildPath "uv.exe"

    # First check if UV is installed system-wide
    try {
        $uvVersion = & uv.exe --version 2>$null
        if ($uvVersion) {
            Write-Verbose "UV is installed system-wide: $uvVersion"
            $uvExe = "uv.exe"
        }
    } catch {
        Write-Verbose "UV not found system-wide, checking source directory..."
        # Check for zip file in UVPath
        $zipFile = Get-ChildItem -Path $UVPath -Filter "uv*.zip" | Select-Object -First 1
        if ($zipFile) {
            Write-Verbose "Found UV zip file: $($zipFile.Name)"
            if (-not (Test-Path -Path $UVPath)) {
                New-Item -Path $UVPath -ItemType Directory -Force | Out-Null
            }
            Write-Verbose "Extracting UV zip file to $UVPath..."
            Expand-Archive -Path $zipFile.FullName -DestinationPath $UVPath -Force

            # Verify extraction
            if (Test-Path -Path $uvExe) {
                $uvVersion = & $uvExe --version 2>$null
                if ($uvVersion) {
                    Write-Verbose "UV successfully extracted: $uvVersion"
                } else {
                    Write-Verbose "UV extraction failed - version check failed"
                    $zipFile = $null
                }
            } else {
                Write-Verbose "UV extraction failed - binary not found"
                $zipFile = $null
            }
        }

        # If no zip file or extraction failed, proceed with download
        if (-not $zipFile) {
            Write-Verbose "UV not found in source directory. Installing..."
            Invoke-Expression -Command $Download
            $env:Path = "$($env:UserProfile)\.local\bin;$env:Path"

            # Validate UV installation
            try {
                $localBinPath = Join-Path -Path $env:UserProfile -ChildPath ".local\bin"
                $localUvExe = Join-Path -Path $localBinPath -ChildPath "uv.exe"
                if (Test-Path -Path $localUvExe) {
                    $uvVersion = & $localUvExe --version 2>$null
                    if (-not $uvVersion) {
                        throw "UV installation failed - version check failed"
                    }
                    Write-Verbose "UV successfully installed: $uvVersion"
                    $uvExe = $localUvExe
                } else {
                    throw "UV installation failed - binary not found in $localBinPath"
                }
            } catch {
                Write-Error "Failed to install UV. Please install it manually using: $Download"
                exit 1
            }
        }
    }

    # Build the command string
    $commandArgs = @()

    # Function to check for help request
    function Test-HelpRequest {
        param (
            [string]$CommandString
        )
        return $CommandString -match '^\s*help\s*$'
    }

    # Handle command parameters
    if ($Command) {
        if (Test-HelpRequest $Command) {
            if (-not $Quiet) {
                Write-Host "Executing: $uvExe help"
            }
            & $uvExe help
            return
        }
        $commandArgs = $Command -split '\s+'
    } else {
        # Handle primary command
        if ($Run) {
            if (Test-HelpRequest $Run -or $Run -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help run"
                }
                & $uvExe help run
                return
            }
            $commandArgs += "run"
            $commandArgs += ($Run -split '\s+')
        } elseif ($Init) {
            if (Test-HelpRequest $Init -or $Init -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help init"
                }
                & $uvExe help init
                return
            }
            $commandArgs += "init"
            $commandArgs += ($Init -split '\s+')
        } elseif ($Add) {
            if (Test-HelpRequest $Add -or $Add -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help add"
                }
                & $uvExe help add
                return
            }
            $commandArgs += "add"
            $commandArgs += ($Add -split '\s+')
        } elseif ($Remove) {
            if (Test-HelpRequest $Remove -or $Remove -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help remove"
                }
                & $uvExe help remove
                return
            }
            $commandArgs += "remove"
            $commandArgs += ($Remove -split '\s+')
        } elseif ($Sync) {
            if (Test-HelpRequest $Sync -or $Sync -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help sync"
                }
                & $uvExe help sync
                return
            }
            $commandArgs += "sync"
            $commandArgs += ($Sync -split '\s+')
        } elseif ($Lock) {
            if (Test-HelpRequest $Lock -or $Lock -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help lock"
                }
                & $uvExe help lock
                return
            }
            $commandArgs += "lock"
            $commandArgs += ($Lock -split '\s+')
        } elseif ($Export) {
            if (Test-HelpRequest $Export -or $Export -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help export"
                }
                & $uvExe help export
                return
            }
            $commandArgs += "export"
            $commandArgs += ($Export -split '\s+')
        } elseif ($Tree) {
            if (Test-HelpRequest $Tree -or $Tree -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help tree"
                }
                & $uvExe help tree
                return
            }
            $commandArgs += "tree"
            $commandArgs += ($Tree -split '\s+')
        } elseif ($Tool) {
            if (Test-HelpRequest $Tool -or $Tool -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help tool"
                }
                & $uvExe help tool
                return
            }
            $commandArgs += "tool"
            $commandArgs += ($Tool -split '\s+')
        } elseif ($Pip) {
            if (Test-HelpRequest $Pip -or $Pip -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help pip"
                }
                & $uvExe help pip
                return
            }
            $commandArgs += "pip"
            $commandArgs += ($Pip -split '\s+')
        } elseif ($Build) {
            if (Test-HelpRequest $Build -or $Build -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help build"
                }
                & $uvExe help build
                return
            }
            $commandArgs += "build"
            $commandArgs += ($Build -split '\s+')
        } elseif ($Publish) {
            if (Test-HelpRequest $Publish -or $Publish -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help publish"
                }
                & $uvExe help publish
                return
            }
            $commandArgs += "publish"
            $commandArgs += ($Publish -split '\s+')
        } elseif ($Cache) {
            if (Test-HelpRequest $Cache -or $Cache -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help cache"
                }
                & $uvExe help cache
                return
            }
            $commandArgs += "cache"
            $commandArgs += ($Cache -split '\s+')
        } elseif ($Self) {
            if (Test-HelpRequest $Self -or $Self -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help self"
                }
                & $uvExe help self
                return
            }
            $commandArgs += "self"
            $commandArgs += ($Self -split '\s+')
        } elseif ($Version) {
            $commandArgs += "--version"
        } elseif ($PSHelp) {
            if (-not $Quiet) {
                Write-Host "Executing: Get-Help -Name .\PSUvWrapper.ps1 -Full"
            }
            Get-Help -Name .\PSUvWrapper.ps1 -Full
            return
        } elseif ($UvHelp) {
            if (-not $Quiet) {
                Write-Host "Executing: $uvExe --help"
            }
            & $uvExe "--help"
            return
        }

        # Handle secondary commands and options
        if ($Venv) {
            if (Test-HelpRequest $Venv -or $Venv -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help venv"
                }
                & $uvExe help venv
                return
            }
            $commandArgs += "venv"
            $commandArgs += ($Venv -split '\s+')
        }

        if ($Python) {
            if (Test-HelpRequest $Python -or $Python -match '--help') {
                if (-not $Quiet) {
                    Write-Host "Executing: $uvExe help python"
                }
                & $uvExe help python
                return
            }
            $pythonValue = $Python -split '\s+' | Select-Object -First 1
            if ($pythonValue -as [float]) {
                $commandArgs += "--python"
                $commandArgs += $pythonValue
            } else {
                $commandArgs += "python"
                $commandArgs += ($Python -split '\s+')
            }
        }
    }

    # Add global options
    if ($NoCache) { $commandArgs += "--no-cache" }
    if ($CacheDir) { $commandArgs += "--cache-dir"; $commandArgs += ($CacheDir -split '\s+') }
    if ($ManagedPython) { $commandArgs += "--managed-python" }
    if ($NoManagedPython) { $commandArgs += "--no-managed-python" }
    if ($NoPythonDownloads) { $commandArgs += "--no-python-downloads" }
    if ($Quiet) { $commandArgs += "--quiet" }
    if ($UvVerbose) { $commandArgs += "--verbose" }
    if ($Color) { $commandArgs += "--color"; $commandArgs += ($Color -split '\s+') }
    if ($NativeTls) { $commandArgs += "--native-tls" }
    if ($Offline) { $commandArgs += "--offline" }
    if ($AllowInsecureHost) { $commandArgs += "--allow-insecure-host"; $commandArgs += ($AllowInsecureHost -split '\s+') }
    if ($NoProgress) { $commandArgs += "--no-progress" }
    if ($Directory) { $commandArgs += "--directory"; $commandArgs += ($Directory -split '\s+') }
    if ($Project) { $commandArgs += "--project"; $commandArgs += ($Project -split '\s+') }
    if ($ConfigFile) { $commandArgs += "--config-file"; $commandArgs += ($ConfigFile -split '\s+') }
    if ($NoConfig) { $commandArgs += "--no-config" }

    # Execute the UV command
    if ($commandArgs.Count -gt 0) {
        if (-not $Quiet) {
            Write-Host "Executing: $uvExe $($commandArgs -join ' ')"
        }
        & $uvExe $commandArgs
    } else {
        Write-Verbose "No command arguments provided, skipping UV execution"
    }
}

end {
    # Clean up virtual environment if requested
    if ($DeleteVenv) {
        $venvPath = Join-Path -Path $PWD -ChildPath "venv"
        if (Test-Path -Path $venvPath) {
            Remove-Item -Path $venvPath -Recurse -Force
        }
    }

    # Activate virtual environment if requested
    if ($ActivateVenv -and $Venv) {
        $venvPath = if ($Venv -match '^[\\/]') { $Venv } else { Join-Path -Path $PWD -ChildPath $Venv }
        $activateScript = Join-Path -Path $venvPath -ChildPath "Scripts\activate.ps1"
        if (Test-Path -Path $activateScript) {
            Write-Verbose "Activating virtual environment: $venvPath"
            & $activateScript
        } else {
            Write-Warning "Virtual environment activation script not found at: $activateScript"
        }
    }
}