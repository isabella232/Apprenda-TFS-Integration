param(
    [Parameter(Mandatory = $true)][string]  $SolutionPath,
    [Parameter(Mandatory = $true)][string]  $OutputPath,
    [Parameter(Mandatory = $false)][string] $Build = "false",
    [Parameter(Mandatory = $false)][string] $Configuration = "Release",
    [Parameter(Mandatory = $false)][string] $PrivateUI,
    [Parameter(Mandatory = $false)][string] $PublicUI,
    [Parameter(Mandatory = $false)][string] $PrivateRoot,
    [Parameter(Mandatory = $false)][string] $PublicRoot,
    [Parameter(Mandatory = $false)][string] $WcfService,
    [Parameter(Mandatory = $false)][string] $WindowsService,
    [string] $additionalParams
)

try{
  Write-Verbose "Collecting VSO Variables."
  $SolutionPath = Get-VstsInput -Name SolutionPath -Require
  $OutputPath = Get-VstsInput -Name OutputPath -Require
  $Build = Get-VstsInput -Name Build -Require
  $Configuration = Get-VstsInput -Name Configuration -Require
  $PrivateUI = Get-VstsInput -Name PrivateUI -Require
  $PublicUI = Get-VstsInput -Name PublicUI -Require
  $PrivateRoot = Get-VstsInput -Name PrivateRoot -Require
  $PublicRoot = Get-VstsInput -Name PublicRoot -Require
  $WcfService = Get-VstsInput -Name WcfService -Require
  $WindowsService = Get-VstsInput -Name WindowsService -Require
}

$cmd = @"
& "$PSScriptRoot\acs\acs.exe" NewPackage -Sln "$SolutionPath" -O "$OutputPath" -Config "$Configuration"
"@

if([System.Convert]::ToBoolean($Build)) {
    $cmd += " -b"
}

if(-not [System.String]::IsNullOrEmpty($PrivateUI))
{

    $cmd += @"
 -I "$PrivateUI"
"@
}

if(-not [System.String]::IsNullOrEmpty($PublicUI))
{
    $cmd += @"
 -PI "$PublicUI"
"@
}

if(-not [System.String]::IsNullOrEmpty($PrivateRoot))
{
    $cmd += @"
 -PrivateRoot "$PrivateRoot"
"@
}

if(-not [System.String]::IsNullOrEmpty($PublicRoot))
{
    $cmd += @"
 -PublicRoot "$PublicRoot"
"@
}

if(-not [System.String]::IsNullOrEmpty($WcfService))
{
	$cmd += @"
 -S "$WcfService"
"@
}

if(-not [System.String]::IsNullOrEmpty($WindowsService))
{
    $cmd += @"
 -WS "$WindowsService"
"@
}

Write-Host "Executing Command: $cmd"

iex $cmd
