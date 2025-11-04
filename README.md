# Break-Glass Local Admin Solution for Windows 11

## Key Features

- 🚀 Remote deployment via Intune Remediations
- 🔍 Monitoring through Defender for Endpoint  
- 🔄 Complete lifecycle (create, monitor, remove)
- 🌍 Language-independent (SID-based)

## When to Use

- LAPS password won't retrieve
- Domain connectivity breaks
- User accounts are locked/corrupted
- Conditional Access blocks emergency access
- Need local admin access **now**

> **Requirements:** Device online with healthy Intune management

## What's Included

- `Detect-EmergencyAdmin.ps1` - Validates account exists and is enabled
- `Remediate-EmergencyAdmin.ps1` - Creates/repairs the emergency account
- `Detect-EmergencyAdmin-ForRemoval.ps1` - Checks if account needs removal
- `Remove-EmergencyAdmin.ps1` - Removes the account
- Defender KQL queries for monitoring

## Quick Start

1. **Customize scripts**
   - Update username (default: "Batman")
   - Set a strong password
   
2. **Create Intune Remediation**
   - **Devices** > **Scripts and remediations** > **Remediations**
   - Upload detection and remediation scripts
   - Run as **System** in **64-bit PowerShell**

3. **Deploy strategically**
   - Keep unassigned until emergency (recommended)
   - Run on demand

4. **Set up Defender monitoring** (queries included)

## Monitoring (Defender for Endpoint)

**Account Creation:**
```kusto
DeviceEvents
| where ActionType == "UserAccountCreated" and AccountName =~ "Batman"
```

**Account Login:**
```kusto
DeviceLogonEvents
| where ActionType == "LogonSuccess" and AccountName =~ "Batman"
```

**Added to Local Administrators:**
```kusto
DeviceEvents
| where ActionType == "UserAccountAddedToLocalGroup"
| where isnotempty(AdditionalFields)
| extend 
    GroupSid = tostring(parse_json(AdditionalFields).GroupSid),
    GroupName = tostring(parse_json(AdditionalFields).GroupName)
| where GroupSid == "S-1-5-32-544"  // Administrators group
| project Timestamp, DeviceName, AccountName, AccountSid, InitiatingProcessAccountName, GroupName
| order by Timestamp desc
```

Create custom detection rules with appropriate severity and alert frequency.

## Usage

**Emergency:**
1. Deploy remediation to affected devices
2. Login with emergency credentials
3. Fix the issue

**Cleanup:**
1. Deploy removal remediation
2. Verify via Intune reporting
3. Rotate password in script

## Security

⚠️ **Password is embedded in script** - visible to anyone with Intune script access

**Mitigations:**
- Monitor via Defender alerts
- Remove account immediately after use
- Rotate password periodically
- Deploy only when needed

## Best Practices

✅ Deploy only during emergencies  
✅ Remove accounts promptly after use  
✅ Monitor all usage via Defender  
❌ Don't deploy continuously to entire estate  
❌ Don't use for non-emergency scenarios

---

## Links

📝 https://www.imab.dk/building-a-break-glass-local-admin-solution-for-windows-11-using-intune-and-defender-for-endpoint/  

**⚠️ Last resort solution for true emergencies. Use responsibly.**





