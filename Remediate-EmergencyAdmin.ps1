# Remediation Script for Emergency Admin Account
# Creates local emergency admin account and adds to Administrators group

function New-EmergencyAdmin {
    $Username = "Batman"
    $Password = "Johnnybrugerikkegummist0vler!"  # Replace with your secure known password
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    
    # Check if user exists
    $UserExists = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
    
    if (-not $UserExists) {
        # Create user
        New-LocalUser -Name $Username -Password $SecurePassword -FullName "Emergency Admin" -Description "Break-glass account" -AccountNeverExpires -PasswordNeverExpires -ErrorAction Stop | Out-Null
    }
    
    # Ensure account is enabled
    Enable-LocalUser -Name $Username -ErrorAction Stop
    
    # Check if user is in Administrators group (using SID)
    $User = Get-LocalUser -Name $Username -ErrorAction Stop
    $AdminGroupSID = "S-1-5-32-544"  # Built-in Administrators group SID
    $Members = Get-LocalGroupMember -SID $AdminGroupSID -ErrorAction SilentlyContinue
    $IsAdmin = $Members.SID -contains $User.SID
    
    if (-not $IsAdmin) {
        # Add to Administrators group
        Add-LocalGroupMember -SID $AdminGroupSID -Member $Username -ErrorAction Stop
    }
    
    Write-Output "[OK] Emergency admin account '$Username' successfully remediated"
}

try {
    New-EmergencyAdmin
    exit 0
} catch {
    Write-Error "[ERROR] Failed to configure emergency admin account: $_"
    exit 1
}
