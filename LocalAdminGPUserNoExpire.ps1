# Get all users in the local Administrators group
$AdminGroup = [ADSI]"WinNT://./Administrators,group"
$AdminMembers = @($AdminGroup.psbase.Invoke("Members")) | ForEach-Object { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) }

# Loop through each user and set password to never expire
foreach ($User in $AdminMembers) {
    try {
        # Check if the user is a local user
        $LocalUser = Get-LocalUser -Name $User -ErrorAction SilentlyContinue
        if ($LocalUser) {
            Set-LocalUser -Name $User -PasswordNeverExpires $true
            Write-Output "Password for user $User set to never expire."
        } else {
            Write-Output "User $User is not a local user."
        }
    } catch {
        Write-Output "Failed to set password for user $User. Error: $_"
    }
}
