# Detection Script for Emergency Admin Account
# Returns exit code 0 if account exists AND is enabled AND is in Administrators group
# Returns exit code 1 if account needs to be created/fixed

$Username = "Batman"

# Check if user exists
$UserExists = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

# Check if user is enabled
$IsEnabled = $false
if ($UserExists) {
    $IsEnabled = $UserExists.Enabled
}

# Check if user is in Administrators group (using SID)
$IsAdmin = $false
if ($UserExists) {
    $AdminGroupSID = "S-1-5-32-544"  # Built-in Administrators group SID
    $Members = Get-LocalGroupMember -SID $AdminGroupSID -ErrorAction SilentlyContinue
    $IsAdmin = $Members.SID -contains $UserExists.SID
}

# All conditions must be true
if ($UserExists -and $IsEnabled -and $IsAdmin) {
    Write-Output "[OK] Emergency admin account exists, is enabled, and is in Administrators group"
    exit 0
} else {
    Write-Output "[WARNING] Emergency admin account does not exist, is disabled, or is not in Administrators group. Needs remediation."
    exit 1
}
