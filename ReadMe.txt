# Feras copy the unattend.xml in C:\Windows\System32\Sysprep after booting in Audit mode.

Boot Windows and enter OOBE.

Enter Audit Mode by pressing:

Ctrl + Shift + F3 (if it doesnt work , press fn key)

Run Sysprep from Terminal:

cd C:\Windows\System32\Sysprep
.\sysprep.exe /generalize /oobe /reboot /unattend:C:\Windows\System32\Sysprep\CustomUnattend.xml
