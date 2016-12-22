<#
  .SYNOPSIS
  Remove an environment variable.

  .DESCRIPTION
  Removes an environment variable in the User (default), Machine or Process scope. In order to remove Machine variables you need to run this function with an elevated shell.

  .EXAMPLE
  Remove-EnvironmentVariable foo
  Removes the User environment variable foo

  .EXAMPLE
  Remove-EnvironmentVariable bar -Targe Machine
  Removes the Machine environment variable bar
#>
function Remove-EnvironmentVariable
{
  [CmdletBinding()]
  Param
  (
    # Identifies the name of the environment variable
    [Parameter(Mandatory=$true)]
    [System.String]
    $Name,

    # Remove the variable in the Machine, Process, or User scope (Default)
    [Parameter()]
    [ValidateSet('Machine', 'Process', 'User')]
    [System.EnvironmentVariableTarget]
    $Target = 'User'
  )

  $ErrorActionPreference = 'Stop'
  try
  {
    [System.Environment]::SetEnvironmentVariable($Name, $null, $Target)
  }
  catch
  {
    Write-Warning 'Most likely, you need to try again but elevated'
  }
}
