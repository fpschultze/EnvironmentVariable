<#
  .SYNOPSIS
  Get the value of an environment variable.

  .DESCRIPTION
  Get the value of an environment variable in the User, Machine, or Process (Default) scope.

  .EXAMPLE
  Get-EnvironmentVariable TEMP -Target User
  Returns the value of the User environment variable temp.

  .EXAMPLE
  Get-EnvironmentVariable TEMP -Target Machine
  Returns the value of the Machine environment variable temp.

  .EXAMPLE
  Get-EnvironmentVariable
  Gets the values of all Process environment variables.
#>
function Get-EnvironmentVariable
{
  [CmdletBinding()]
  Param
  (
    # Identifies the name of the environment variable
    [Parameter()]
    [System.String]
    $Name,

    # Get the variable value of the Machine, Process (Default), or User scope
    [Parameter()]
    [ValidateSet('Machine', 'Process', 'User')]
    [System.EnvironmentVariableTarget]
    $Target = 'Process'
  )

  if ($PSBoundParameters.ContainsKey('Name'))
  {
    [System.Environment]::GetEnvironmentVariable($Name, $Target)
  }
  else
  {
    [System.Environment]::GetEnvironmentVariables($Target)
  }
}
