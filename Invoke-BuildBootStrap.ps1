<#
    .SYNOPSIS
        Invoke-BuildBootStrap is a PowerShell script that is used to bootstrap the Invoke-Build module and run the tasks defined in the
        Invoke-Build scriptblock. Invoke-Build is a build and test automation tool which invokes tasks defined in PowerShell scripts.

    .DESCRIPTION
        Invoke-BuildBootStrap is a PowerShell script that is used to bootstrap the Invoke-Build module and run the tasks defined in the
        Invoke-Build scriptblock.

        Invoke-Build is a build and test automation tool which invokes tasks defined in PowerShell scripts. It is similar to psake but arguably
        easier to use and more powerful. It is complete, bug free, well covered by tests.

        In addition to basic task processing the engine supports

        o Incremental tasks with effectively processed inputs and outputs.
        o Persistent builds which can be resumed after interruptions.
        o Parallel builds in separate workspaces with common stats.
        o Batch invocation of tests composed as tasks.
        o Ability to define new classes of tasks.

    .PARAMETER Tasks
        Description: The Tasks parameter is used to define the tasks that will be run by Invoke-Build.  The default value is '.' which will run
            the default task list defined in the Invoke-Build scriptblock.  The Tasks parameter can be used to run a single task or a list of
            tasks.  The Invoke-Build scriptblock can be used to define a default task list or a list of tasks that can be run by the Tasks
            parameter.
        Notes: Current tasks
            o Dependencies - Detect and Install Project Dependencies (1st Task)
            o ImportModules - Import Project Modules (2nd Task)
            o UpdateEnv - Enable support for PWSH and/or Python "No Installation" (3rd Task)
            o Initialize - Initailzie Business Test (4th Task)
            o PesterCheck - Process Project Pester (5th Task)
            o Finalize - Finalize (Last Task)
            o CleanUp - CleanUp (AdHoc Task - Not in the Default Task List)
            o RemoveModules - Remove All Build and Project Modules AdHoc (AdHoc Task - Not in the Default Task List)
            o VerifyModules - Verfiy All Loaded Build and Project Modules (AdHoc Task - Not in the Default Task List)
            o DebugShell - DebugShell will open a System Shell to test the Build Script Process (AdHoc Task - Not in the Default Task List)
        Alias:

    .EXAMPLE
        Command: Invoke-BuildBootStrap
        Description: Run the default task list (Dependencies, ImportModules, UpdateEnv, Initialize, PesterCheck, Finalize)
        Notes:
        Output:
            Build . Invoke-BuildBootStrap.ps1
            Task /./Dependencies
            Done /./Dependencies 00:00:19.6554725
            Task /./ImportModules
            Done /./ImportModules 00:00:02.2526701
            Task /./PesterCheck
            Done /./PesterCheck 00:00:00.0071005
            Task /./?Initialize
            Initialize
            Done /./?Initialize 00:00:00.0322276
            Task /./Finalize
            Finalize
            Done /./Finalize 00:00:00.0126620
            Done /. 00:00:21.9832373
            Build succeeded. 6 tasks, 0 errors, 0 warnings 00:00:22.1559316

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks Dependencies,ImportModules
        Description: Run only the Dependencies and ImportModules tasks
        Notes:  This will only run the Dependencies and ImportModules tasks while installing the required modules from the
            requirements.psd1 file and loading them from the dependencies folder.  For offline use, run this script from a machine online, and
            then copy the project folder to the offline machine.  This will keep all the required modules in the dependencies folder.
        Output:
            Build Dependencies, ImportModules Invoke-BuildBootStrap.ps1
            Task /Dependencies
            Done /Dependencies 00:00:02.3436972
            Task /ImportModules
            Done /ImportModules 00:00:00.2334797
            Build succeeded. 2 tasks, 0 errors, 0 warnings 00:00:02.6921706

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks UpdateEnv -EnablePython
        Description: Run the UpdateEnv task with Python enabled
        Notes: This will enable a Portable version of Python to be used in the project without installing Python on the system.
        Output:
            N/A

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks UpdateEnv -EnablePython -Venv 'C:\PythonVenv'
        Description: Run the UpdateEnv task with Python enabled and a virtual environment created at 'C:\PythonVenv'.
        Notes: This will enable a Portable version of Python to be used in the project without installing Python on the system.  The virtual
            environment will be created at 'C:\PythonVenv'.
        Output:
            N/A

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks UpdateEnv -EnablePython -Venv 'C:\PythonVenv' -PyRequirements 'py_requirements.txt'
        Description: Run the UpdateEnv task with Python enabled and a virtual environment created at 'C:\PythonVenv' with the requirements
            from the 'py_requirements.txt' file installed.
        Notes: This will enable a Portable version of Python to be used in the project without installing Python on the system.  The virtual
            environment will be created at 'C:\PythonVenv' and the requirements from the 'py_requirements.txt' file will be installed.
        Output:
            N/A

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks UpdateEnv -EnablePWSH
        Description: Run the UpdateEnv task with PowerShell Core enabled.
        Notes: This will enable a Portable version of PowerShell Core 7.* to be used in the project without installing PowerShell Core on the
            system.
        Output:
            Pyton Portable Version 3.12.3 enabled

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks VerifyModules
        Description: Run the VerifyModules task (AdHoc Task - Not in the Default Task List)
        Notes: VerifyModules is used to verify that all the required modules are
            loaded and available for use.
        Output:
            Build VerifyModules Invoke-BuildBootStrap.ps1
            Task /VerifyModules

            ModuleType Version    PreRelease Name                                ExportedCommands
            ---------- -------    ---------- ----                                ----------------
            Script     2.0.16                BuildHelpers                        {Add-TestResultToAppveyor, Export-Metadata, Find-NugetPac…
            Script     5.10.1                InvokeBuild                         {Build-Checkpoint, Build-Parallel, Invoke-Build}
            Script     4.10.1                Pester                              {Add-AssertionOperator, AfterAll, AfterEach, AfterEachFea…
            Script     2.2.8                 poshspec                            {AppPool, AuditPolicy, CimObject, DnsHost…}
            Script     0.4.7                 powershell-yaml                     {ConvertFrom-Yaml, ConvertTo-Yaml, cfy, cty}
            Script     2.2.5                 PowerShellGet                       {Find-Command, Find-DscResource, Find-Module, Find-RoleCa…
            Script     0.4.5                 PSDepend2                           {Get-Dependency, Get-PSDependScript, Get-PSDependType, Im…
            Script     1.4.1                 PSPx                                {Get-MarkdownCodeBlock, Invoke-ExecuteMarkdown, Invoke-Sc…
            Script     1.0.1.202…            PSTerraformLike                     {Confirm-PSTerraformLikeActionList, ConvertTo-PSTerraform…
            Script     3.0.0                 PowerShellNotebook                  {ConvertFrom-Notebook, ConvertTo-Notebook, Get-Notebook, …

            Done /VerifyModules 00:00:00.0096319
            Build succeeded. 1 tasks, 0 errors, 0 warnings 00:00:00.1056197

    .EXAMPLE
        Command: Invoke-BuildBootStrap -Tasks CleanUp
        Description: Run the CleanUp task (AdHoc Task - Not in the Default Task List)
        Notes: CleanUp is a custom task that can be used to clean up the project folder or system context.
        Output:
            Build CleanUp Invoke-BuildBootStrap.ps1
            Task /CleanUp
            CleanUp
            Done /CleanUp 00:00:00.0015908
            Build succeeded. 1 tasks, 0 errors, 0 warnings 00:00:00.0998642

    .NOTES
        [Original Author]
            o Michael Arroyo
        [Original Build Version]
            o 1.0.0.20240125 (Major.Minor.Patch.Date<YYYYMMDD>)
        [Latest Author]
            o Michael Arroyo
        [Latest Build Version]
            o 1.1.1.20240513 (Major.Minor.Patch.Date<YYYYMMDD>)
        [Comments]
            o
        [PowerShell Compatibility / Tested On]
            o 5.x
        [Forked Project]
            o
        [Dependencies]
            o PSDepend2 / Version = '0.4.5'
            o InvokeBuild / Version = '5.10.1'

    .LINK
#>

#region Build Notes
    <#
        [Build Version Details]
            o 1.0.0.20240125 -
                [Michael Arroyo] Intial Build
            o 1.0.1.20240126 -
                [Michael Arroyo] Added the DebugShell Task
            o 1.1.0.20240506 -
                [Michael Arroyo] Added the UpdateEnv Task
                [Michael Arroyo] Added the EnablePython Parameter
                [Michael Arroyo] Added the EnablePWSH Parameter
                [Michael Arroyo] Added the Venv Parameter
                [Michael Arroyo] Added the PyRequirements Parameter
                [Michael Arroyo] Updated the Help Information
                [Michael Arroyo] Added a default python requirement file
            o 1.1.1.20240513 -
                [Michael Arroyo] Add dynamic query path for the Python interpreter in the dependencies folder
                [Michael Arroyo] Add dynamic query path for the PowerShell Core interpreter in the dependencies folder
    #>
#endregion Build Notes

[CmdletBinding ()]
#region Script Parameters
    param(
        [Parameter(Position=0)]
        [ValidateSet('.',
                    'Dependencies',
                    'ImportModules',
                    'UpdateEnv',
                    'Initialize',
                    'PesterCheck',
                    'Finalize',
                    'RemoveModules',
                    'VerifyModules',
                    'CleanUp',
                    'DebugShell'
        )]
        [String[]]$Tasks = '.',
        [Switch]$EnablePython,
        [String]$Venv,
        [String]$PyRequirements,
        [Switch]$EnablePWSH
    )
#endregion Script Parameters

#region Change Directory to Working Directory
    Set-Location -Path $PSScriptRoot
#endregion Change Directory to Working Directory

#region Set Core Modules
    $PSModules = @(
        @{
            Name = 'PSDepend2'
            Version = '0.4.5'
        }
        @{
            Name = 'InvokeBuild'
            Version = '5.10.1'
        }
    )
#endregion Set Core Modules

#region Set Dependencies Directory
    $CurModulePath = $('{0}\dependencies' -f $PSScriptRoot)
    If ( -Not $(Test-Path $CurModulePath) ) {
        New-Item -Path $CurModulePath -ItemType Directory -Force | Out-Null
    }
#endregion Set Dependencies Directory

#region Update TLS to 1.2 to allow for PSGallery Access
    If ( -Not ( $PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -ge 1 ) ) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }
#endregion Update TLS to 1.2 to allow for PSGallery Access

#region Check and Install Core Modules
    ForEach ( $Module in $PSModules ) {
        If ( -Not ( Get-Module -name $Module.Name -ListAvailable | Where-Object -Property Version -eq $Module.Version ) ) {
            If ( -Not $(Test-Path -Path $('{0}\{1}\{2}' -f $CurModulePath, $Module.Name, $Module.Version))) {
                Save-Module -Name $Module.Name -RequiredVersion $Module.Version -LiteralPath $CurModulePath -ErrorAction Ignore | Out-Null
                Import-Module $('{0}\{1}' -f $CurModulePath, $Module.Name, $Module.Version) -Force -ErrorAction Ignore | Out-Null
            } Else {
                Import-Module $('{0}\{1}' -f $CurModulePath, $Module.Name, $Module.Version) -Force -ErrorAction Ignore | Out-Null
            }
        } Else {
            Import-Module -Name $Module.Name -RequiredVersion $Module.Version -Force -ErrorAction Ignore | Out-Null
        }
    }
#endregion Check and Install Core Modules

#region BootStrap InvokeBuild to Enable Task Processing
    If ( $MyInvocation.ScriptName -notlike '*Invoke-Build.ps1' ) {
        Invoke-Build -Task $Tasks -File $MyInvocation.MyCommand.Path -Safe @PSBoundParameters
        Return
    }
#endregion BootStrap InvokeBuild to Enable Task Processing

#region Tasks
    #region Default Task List Task
        # Synopsis: Setup project.
        task . Dependencies,?ImportModules,UpdateEnv,?Initialize,PesterCheck,Finalize
    #endregion Default Task List Task

    #region Detect and Install Project Dependencies Task
        task Dependencies {
            Invoke-PSDepend -Force

            Get-ChildItem -path $('{0}\Pester' -f $CurModulePath) -Exclude 4.10.1 -ErrorAction Ignore | `
                ForEach-Object -Process { Remove-Item -Path $_.Fullname -Force -Recurse -ErrorAction Ignore | Out-Null } | Out-Null
        }
    #endregion Detect and Install Project Dependencies Task

    #region Import Project Modules Task
        task ImportModules {
            $CurModules = Get-ChildItem -Path $CurModulePath -Directory | Select-Object -ExpandProperty FullName

            ForEach ( $NewModule in $CurModules ) {
                Import-Module $NewModule -Force -DisableNameChecking -ErrorAction Ignore | Out-Null
            }
        }
    #endregion Import Project Modules Task

    #region UpdateEnv Task
        task UpdateEnv {
            Switch ( $Null ) {
                { $EnablePython } {
                    $PythonPath = Get-ChildItem -Path $CurModulePath -Filter 'python.exe' -File -Recurse |
                        Where-Object -Property Fullname -notmatch 'venv\\scripts\\nt' | Select-Object -ExpandProperty Fullname |
                        Split-Path -Parent
                    $PyScriptsPath = $('{0}\Scripts' -f $PythonPath)

                    if ( $env:Path -notmatch 'PyPortable' ) {
                        $env:Path = $('{0};{1}' -f $PythonPath, $env:Path)
                        $env:Path = $('{0};{1}' -f $PyScriptsPath, $env:Path)
                    }

                    If ( $Venv ) {
                        python -m venv $Venv
                        & "$Venv\Scripts\Activate.ps1"
                    }

                    If ( $PyRequirements ) {
                        pip install -r $PyRequirements
                    }
                }

                { $EnablePWSH } {
                    $PWSHPath = Get-ChildItem -Path $CurModulePath -Filter 'pwsh.exe' -File -Recurse |
                        Select-Object -ExpandProperty Fullname | Split-Path -Parent

                    if ( $env:Path -notmatch 'PSPortable' ) {
                        $env:Path = $('{0};{1}' -f $PWSHPath, $env:Path)
                    }
                }
            }
        }
    #endregion UpdateEnv Task

    #region Initailzie Business Test
        task Initialize {
            #region Set RunBook Directory
                #$CurRunBookPath = $('{0}\RunBooks' -f $PSScriptRoot)
                #Set-Location -Path $CurRunBookPath
            #endregion Set RunBook Directory

            #region Initialize Default RunBook
                Invoke-PSTerraformLikeRunBook .\RunBook.yaml
            #endregion Initialize Default RunBook
        }
    #endregion Initailzie Business Test

    #region Process Project Pester Task
        task PesterCheck {
            #'Testing'
        }
    #endregion Process Project Pester Task

    #region Finalize
        task Finalize {
        }
    #endregion Finalize

    #region CleanUp Task
        task CleanUp {
        }
    #endregion CleanUp Task

    #region Remove All Build and Project Modules AdHoc Task
        task RemoveModules {
            $CurModules = Get-ChildItem -Path $CurModulePath -Directory | Select-Object -ExpandProperty BaseName

            ForEach ( $NewModule in $CurModules ) {
                Remove-Module $NewModule -Force -ErrorAction Ignore | Out-Null
            }
        }
    #endregion Remove All Build and Project Modules AdHoc Task

    #region Verfiy All Loaded Build and Project Modules Task
        task VerifyModules {
            Get-Module
        }
    #endregion Verfiy All Loaded Build and Project Modules Task

    #region DebugShell Task
        task DebugShell {
            If ( -Not $($(Get-Service -Name TrustedInstaller).Status -eq 'Running') ) {
                Start-Service -Name TrustedInstaller
            }

            $ParentProc = Get-NtProcess -ServiceName TrustedInstaller
            $Proc = New-Win32Process 'cmd.exe' -CreationFlags NewConsole -ParentProcess $ParentProc
            $Proc
        }
#endregion Tasks