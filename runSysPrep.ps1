$sysprep = "C:\Windows\System32\Sysprep\sysprep.exe"
$ar = "/generalize /shutdown /oobe /unattend:C:\Windows\System32\Sysprep\unattend.xml"
Start-Process -FilePath $sysprep -ArgumentList $ar -Wait
Start-Sleep 2
