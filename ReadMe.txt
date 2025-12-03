# Feras copy the unattend.xml in C:\Windows\System32\Sysprep\Panther after booting in Audit mode.

Boot Windows and enter OOBE.

Enter Audit Mode by pressing:

Ctrl + Shift + F3 (if it doesnt work , press fn key)

Run Sysprep from CMD:

cd %windir%\system32\sysprep
sysprep /generalize /oobe /shutdown /unattend:C:\Windows\System32\Sysprep\Panther\CustomUnattend.xml
