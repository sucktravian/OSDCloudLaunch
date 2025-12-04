# Feras copy the unattend.xml in C:\Windows\System32\Sysprep after booting in Audit mode.

-Boot Windows and enter OOBE.

-Enter Audit Mode by pressing:

Ctrl + Shift + F3 (if it doesnt work , press fn key)

-Run Sysprep from Terminal:

cd C:\Windows\System32\Sysprep
.\sysprep.exe /generalize /oobe /reboot /unattend:C:\Windows\System32\Sysprep\CustomUnattend.xml

-If it throws any error , open setuperr(C:\Windows\System32\Sysprep\Panther\setuperr.txt) and if you see something like "Package ***** was installed for user , but not provisioned .."
 just copy the package full name and in Terminal(powershell) type : Remove-AppxPackage -Package [PackageFullName] -AllUsers.
 Run sysprep command again and if u get another error, just redo the same thing (delete the package) until sysprep run successfully.
