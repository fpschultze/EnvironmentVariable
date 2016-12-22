$ModuleRoot = Split-Path -Parent $PSScriptRoot
$ModuleFile = (Split-Path -Leaf $PSCommandPath) -replace '\.tests\.ps1$', '.psm1'
Import-Module "$ModuleRoot\$ModuleFile"

Describe 'Set-EnvironmentVariable, Get-EnvironmentVariable, Remove-EnvironmentVariable' {

  Context 'Get variables' {
    It 'returns all env vars in Process scope' {
      Get-EnvironmentVariable | Should BeOfType Hashtable
    }
    It 'returns all env vars in User scope' {
      Get-EnvironmentVariable -Target User | Should BeOfType Hashtable
    }
    It 'returns all env vars in Machine scope' {
      Get-EnvironmentVariable -Target Machine | Should BeOfType Hashtable
    }
  }

  Context 'User scope: set env var w/o refresh (Default), read, and remove' {
    $param = @{
      Name = ([guid]::NewGuid().Guid)
      Value = 'foo'
    }
    It 'sets the env var' {
      {Set-EnvironmentVariable @param} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target User | Should Be $param.Value
    }
    It 'but not in Process scope' {
      Get-EnvironmentVariable -Name $param.Name | Should BeNullOrEmpty
    }
    It 'removes the env var' {
      {Remove-EnvironmentVariable -Name $param.Name} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target User | Should BeNullOrEmpty
    }
  }

  Context 'User scope: set env var w/ refresh, read, and remove' {
    $param = @{
      Name = ([guid]::NewGuid().Guid)
      Value = 'foo'
    }
    It 'sets the env var and propagates it in the Process scope' {
      {Set-EnvironmentVariable @param -Refresh} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should Be $param.Value
    }
    It 'removes the env var in both User and Process scope' {
      {Remove-EnvironmentVariable -Name $param.Name} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target User | Should BeNullOrEmpty
      {Remove-EnvironmentVariable -Name $param.Name -Target Process} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should BeNullOrEmpty
    }
  }

  Context 'Machine scope: set env var w/o refresh, read, and remove' {
    $param = @{
      Name = ([guid]::NewGuid().Guid)
      Value = 'foo'
      Target = 'Machine'
    }
    It 'sets the env var' {
      {Set-EnvironmentVariable @param} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target $param.Target | Should Be $param.Value
    }
    It 'but not in Process scope' {
      Get-EnvironmentVariable -Name $param.Name | Should BeNullOrEmpty
    }
    It 'removes the env var' {
      {Remove-EnvironmentVariable -Name $param.Name -Target Machine} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target Machine | Should BeNullOrEmpty
    }
  }

  Context 'Machine scope: set env var w/ refresh, read, and remove' {
    $param = @{
      Name = ([guid]::NewGuid().Guid)
      Value = 'foo'
      Target = 'Machine'
    }
    It 'sets the env var and propagates it in the Process scope' {
      {Set-EnvironmentVariable @param -Refresh} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should Be $param.Value
    }
    It 'removes the env var in both Machine and Process scope' {
      {Remove-EnvironmentVariable -Name $param.Name -Target Machine} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name -Target Machine | Should BeNullOrEmpty
      {Remove-EnvironmentVariable -Name $param.Name -Target Process} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should BeNullOrEmpty
    }
  }

  Context 'Process scope: set env var, read, and remove' {
    $param = @{
      Name = ([guid]::NewGuid().Guid)
      Value = 'foo'
      Target = 'Process'
    }
    It 'sets the env var' {
      {Set-EnvironmentVariable @param} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should Be $param.Value
    }
    It 'removes the env var' {
      {Remove-EnvironmentVariable -Name $param.Name -Target Process} | Should Not Throw
      Get-EnvironmentVariable -Name $param.Name | Should BeNullOrEmpty
    }
  }
}
