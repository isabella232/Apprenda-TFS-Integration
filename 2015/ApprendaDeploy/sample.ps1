[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation
try {
    # Get Inputs
    [string]$apprendaCloudURL = Get-VstsInput -Name 

    # Set the working directory.
    $cwd = Get-VstsInput -Name cwd -Require
    Assert-VstsPath -LiteralPath $cwd -PathType Container
    Write-Verbose "Setting working directory to '$cwd'."
    Set-Location $cwd

    # Output the message to the log.
    Write-Host (Get-VstsInput -Name msg)
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
