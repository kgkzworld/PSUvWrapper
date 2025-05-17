# PSUvWrapper

A PowerShell wrapper for the [UV](https://github.com/astral-sh/uv) Python package installer and resolver. This wrapper provides a convenient way to use UV's features through PowerShell, with additional functionality for virtual environment management and project setup.

## Features

- Automatic UV installation and management
- Virtual environment creation and activation
- Project initialization and dependency management
- Support for all UV commands and options
- Built-in help system for all commands
- Automatic PATH management
- Verbose logging and error handling

## Installation

1. Clone this repository:
```powershell
git clone https://github.com/kgkzworld/PSUvWrapper.git
cd PSUvWrapper
```

2. The wrapper will automatically download and install UV if it's not already present on your system.

## Usage

### Basic Commands

```powershell
# Initialize a new project
.\PSUvWrapper.ps1 -Init "myproject"

# Add a package
.\PSUvWrapper.ps1 -Add "requests"

# Run a Python script
.\PSUvWrapper.ps1 -Run "script.py"

# Create and activate a virtual environment
.\PSUvWrapper.ps1 -Venv "myenv" -ActivateVenv
```

### Getting Help

```powershell
# Show general help
.\PSUvWrapper.ps1 -PSHelp

# Show UV help
.\PSUvWrapper.ps1 -UvHelp

# Get help for specific commands
.\PSUvWrapper.ps1 -Run "help"
.\PSUvWrapper.ps1 -Add "help"
```

### Advanced Usage

```powershell
# Run with verbose output
.\PSUvWrapper.ps1 -Run "script.py" -Verbose

# Use custom cache directory
.\PSUvWrapper.ps1 -Run "script.py" -CacheDir "C:\cache"

# Create and manage virtual environments
.\PSUvWrapper.ps1 -Venv "myenv" -ActivateVenv
.\PSUvWrapper.ps1 -Venv "myenv" -DeleteVenv
```

## Parameters

The wrapper supports all UV commands and options, including:

- `-Init`: Create a new project
- `-Add`: Add a package
- `-Remove`: Remove a package
- `-Sync`: Sync dependencies
- `-Lock`: Generate lock file
- `-Export`: Export requirements
- `-Tree`: Show dependency tree
- `-Tool`: Manage tools
- `-Python`: Python-specific commands
- `-Pip`: Pip-specific commands
- `-Venv`: Virtual environment management
- `-Build`: Build packages
- `-Publish`: Publish packages
- `-Cache`: Cache management
- `-Self`: Self-update
- `-Version`: Show version
- `-Help`: Show help


## Examples

### Project Setup

```powershell
# Create a new project
.\PSUvWrapper.ps1 -Init "myproject"

# Add dependencies
.\PSUvWrapper.ps1 -Add "requests" "pandas" "numpy"

# Create and activate virtual environment
.\PSUvWrapper.ps1 -Venv "venv" -ActivateVenv
```

### Package Management

```powershell
# Install packages
.\PSUvWrapper.ps1 -Add "requests==2.31.0"

# Remove packages
.\PSUvWrapper.ps1 -Remove "requests"

# Sync dependencies
.\PSUvWrapper.ps1 -Sync
```

### Development Workflow

```powershell
# Run a script
.\PSUvWrapper.ps1 -Run "main.py"

# Build a package
.\PSUvWrapper.ps1 -Build

# Publish a package
.\PSUvWrapper.ps1 -Publish
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [UV](https://github.com/astral-sh/uv) - The Python package installer and resolver that this wrapper is built around
- PowerShell community for best practices and patterns