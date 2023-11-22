﻿$report = @()

$VMs = (Get-Datastore | Where {$_.Name -like 'VNX_*'} | Get-VM).Name | sort

Foreach ($VM in $VMs){
    $line = Get-VM $VM | Select Name, @{N="vCPU";E={($_).NumCpu}}, @{N="Memory (GB)";E={($_).MemoryGB}}, @{N="Cluster";E={Get-Cluster -VM $_}}, @{N="Folder";E={$_.folder}}, @{N="Network";E={(Get-NetworkAdapter -VM $_).NetworkName}}, @{Expression={if (($_ | Get-HardDisk | Where {$_.DiskType -eq "RawPhysical"}) -eq $Null) {"No"} Else {"Yes"}}; Label="RDMs" }
    $report += $line
}
$report | Export-Csv C:\Users\jdeblois\Documents\BILPHN-local\VNX_Unisphere_VMs.csv -NoTypeInformation -UseCulture