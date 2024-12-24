Function Test-Credential {
    param(
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential
    )

    Add-Type -Namespace PInvoke -Name NativeMethods -MemberDefinition @'
[DllImport("Advapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
private static extern bool LogonUserW(
    string lpszUsername,
    string lpszDomain,
    IntPtr lpszPassword,
    UInt32 dwLogonType,
    UInt32 dwLogonProvider,
    out Microsoft.Win32.SafeHandles.SafeWaitHandle phToken);

public static Microsoft.Win32.SafeHandles.SafeWaitHandle LogonUser(string username, string domain,
    System.Security.SecureString password, uint logonType, uint logonProvider)
{   
    IntPtr passPtr = Marshal.SecureStringToGlobalAllocUnicode(password);
    try
    {
        Microsoft.Win32.SafeHandles.SafeWaitHandle token;
        if (!LogonUserW(username, domain, passPtr, logonType, logonProvider, out token))
        {
            throw new System.ComponentModel.Win32Exception();
        }
        
        return token;
    }
    finally
    {
        Marshal.ZeroFreeGlobalAllocUnicode(passPtr);
    }
}
'@

    $user = $Credential.UserName
    $domain = $null
    if ($user.Contains('\')) {
        $domain, $user = $user -split '\\', 2
    }

    try {
        $token = [PInvoke.NativeMethods]::LogonUser(
            $user,
            $domain,
            $Credential.Password,
            3, # LOGON32_LOGON_NETWORK
            0  # LOGON32_PROVIDER_DEFAULT
        )
        $token.Dispose()
        return $true
    }
    catch [System.ComponentModel.Win32Exception] {
        # following errors indicate the creds are correct but the user was
        # unable to log on for other reasons, which we don't care about
        $successCodes = @(
            0x0000052F, # ERROR_ACCOUNT_RESTRICTION
            0x00000530, # ERROR_INVALID_LOGON_HOURS
            0x00000531, # ERROR_INVALID_WORKSTATION
            0x00000569  # ERROR_LOGON_TYPE_GRANTED
        )
        $failedCodes = @(
            0x0000052E, # ERROR_LOGON_FAILURE
            0x00000532, # ERROR_PASSWORD_EXPIRED
            0x00000773, # ERROR_PASSWORD_MUST_CHANGE
            0x00000533  # ERROR_ACCOUNT_DISABLED
        )

        if ($_.Exception.NativeErrorCode -in $failedCodes) {
            return $false
        }
        elseif ($_.Exception.NativeErrorCode -in $successCodes) {
            return $true
        }
        else {
            # an unknown failure, reraise exception
            throw $_
        }
    }
}