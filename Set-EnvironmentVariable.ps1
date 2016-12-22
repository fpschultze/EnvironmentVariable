<#
  .SYNOPSIS
  Set an environment variable.

  .DESCRIPTION
  Set an environment variable to the given value in the User (default), Machine or Process scope. If the variable already exists it will be overwritten. In order to set Machine variables you need to run this function with an elevated shell.

  .EXAMPLE
  Set-EnvironmentVariable ScriptPath E:\Scripts
  Sets the User environment variable ScriptPath to E:\Scripts.

  .EXAMPLE
  Set-EnvironmentVariable CommonTools C:\Tools -Target Machine -Refresh
  Sets the Machine environment variable CommonTools to C:\Tools and propagates this change within the Process scope.
#>
function Set-EnvironmentVariable
{
  [CmdletBinding()]
  Param
  (
    # Identifies the name of the environment variable
    [Parameter(Mandatory=$true)]
    [System.String]
    $Name,

    # Identifies the environment variable's value
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [System.String]
    $Value,

    # Set the variable in the Machine, Process, or User scope (Default)
    [Parameter()]
    [ValidateSet('Machine', 'Process', 'User')]
    [System.EnvironmentVariableTarget]
    $Target = 'User',

    # Propagate a new Machine or User variable within the current Process environment
    [Switch]
    $Refresh
  )

  $ErrorActionPreference = 'Stop'
  try
  {
    [System.Environment]::SetEnvironmentVariable($Name, $Value, $Target)
    if ($PSBoundParameters.ContainsKey('Refresh') -and ($Target -ne 'Process'))
    {
      [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Process)
    }
  }
  catch
  {
    Write-Warning 'Most likely, you need to try again but elevated'
  }
}
