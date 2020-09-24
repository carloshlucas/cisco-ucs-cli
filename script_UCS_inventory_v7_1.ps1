###################################################
#                                                 #
#            CISCO INVENTORY VERSION 7            #
#            Adjusted by Carlos Lucas             #
#                                                 #
###################################################


# Import CSV 
$CSV = Import-CSV D:\CiscoUCS\CiscoInventory2\cisco-ucs.csv ### <----- CHANGE THIS LINE ###


#########################################################
#                                                       #
#           DON'T CHANGE ANYTHING BEYOND HERE           #
#                                                       #
#########################################################

#Disconnect all UCS Connection
Disconnect-Ucs

# Getting Credential
$credential = get-credential

# Get current date and time
$Date = Get-Date

#Write output as a log information
Function WriteLog
{
	Param ([string]$logstring)
	Write-Host "[$([DateTime]::Now)] - $logstring"
}

WriteLog "Starting Cisco UCS Manager Inventory Script .."

#Read the files inside the UCS-DOMAIN.CSV - CHANGE THE PATH
foreach ($UCSM in $CSV) {

# Clear Global TMP_Output 
$Global:TMP_OUTPUT  = ""
Function AddToOutput($txt)
{
	$Global:TMP_OUTPUT += $txt, "`n"
}

$UCSM.ip
$UCSM.hostname

# Connect to UCS Manager
Connect-Ucs -Name $UCSM.ip -Credential $credential

# Clear all content in TMP_OUTPUT
Clear-Variable TMP_OUTPUT -Scope Global
   
# Create or empty file
$OutFile = $UCSM.hostname+".html"
New-Item -ItemType file $OutFile -Force | Out-Null    
WriteLog "File $OutFile created"

WriteLog "Connected to: $($UCSM.hostname), starting inventory collection"

#HTML start
	# Output HTML headers and CSS
	AddToOutput -txt "<html>"
	AddToOutput -txt "<html>"
	AddToOutput -txt "<head>"
	AddToOutput -txt "<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	AddToOutput -txt "<title>UCS Inventory Script</title>"
	AddToOutput -txt "<style type='text/css'>"
	AddToOutput -txt "body { font-family: 'Calibri', serif; font-size:14px; }"
	AddToOutput -txt "div.content { border-top: #e3e3e3 solid 3px; clear: left; width: 100%; }"
	AddToOutput -txt "div.content.inactive { display: none; }"
	AddToOutput -text "div.content-sub.inactive { display: none; } "
	AddToOutput -txt "ul { height: 2em; list-style: none; margin: 0; padding: 0; }"
	AddToOutput -txt "ul a { background: #e3e3e3; color: #000000; display: block; float: left; height: 2em; padding-left: 10px; text-decoration: none; font-weight: bold; }" #0099cc
	AddToOutput -txt "ul a:hover { background-color: #e85a05; background-position: 0 -120px; color: #ffffff; }" #0066cc
	AddToOutput -txt "ul a:hover span { background-position: 100% -120px; }"
	AddToOutput -txt "ul li { float: left; margin: 0 1px 0 0; }"
	AddToOutput -txt "ul li.ui-tabs-active a { background-color: #e85a05; background-position: 0 -60px; color: #fff; font-weight: bold; }" #0066cc
	AddToOutput -txt "ul li.ui-tabs-active a span { background-position: 100% -60px; }"
	AddToOutput -txt "ul span { display: block; line-height: 2em; padding-right: 10px; }"
	AddToOutput -txt "table { border: #e3e3e3 2px solid; border-collapse: collapse; min-width: 800px; }"
	AddToOutput -txt "th { padding: 2px; border: #e3e3e3 2px solid; background-color:#e3e3e3; }"
	AddToOutput -txt "td { padding: 2px; border: #e3e3e3 2px solid; }"
	AddToOutput -txt ".ui-tabs-vertical .ui-tabs-nav {  float: left; width: 250px; padding-top: 25px; }"
	AddToOutput -txt ".ui-tabs-vertical .ui-tabs-nav li { height: 30px; }"
	AddToOutput -txt ".ui-tabs-vertical .ui-tabs-nav li a { padding-top: 7px; width: 200px; }"
	AddToOutput -txt ".ui-tabs-vertical .ui-tabs-panel { float: left; width: 1100px; }"
	AddToOutput -txt "</style>"
    # Include jQuery and jQueryUI and define the tabs
	AddToOutput -txt "<script src='http://code.jquery.com/jquery-1.9.1.js'></script>"
	AddToOutput -txt "<script src='http://code.jquery.com/ui/1.10.3/jquery-ui.js'></script>"
	AddToOutput -txt "<script> jQuery(function() {"
	AddToOutput -txt "jQuery('#tabs').tabs();  "
	AddToOutput -txt "jQuery('#equipment-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#equipment-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#server-config-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#server-config-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#lan-config-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#lan-config-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#san-config-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#san-config-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#admin-config-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#admin-config-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#stats-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');"
	AddToOutput -txt "jQuery('#stats-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "jQuery('#recommendations-tabs').tabs().addClass('ui-tabs-vertical ui-helper-clearfix'); "
	AddToOutput -txt "jQuery('#recommendations-tabs li').removeClass('ui-corner-top').addClass('ui-corner-left'); "
	AddToOutput -txt "});</script>"
	AddToOutput -txt "</head>"
	AddToOutput -txt "<body>"
	AddToOutput -txt "<h1>UCS Inventory Script</h1>"
	AddToOutput -txt "Generated: "
	$Global:TMP_OUTPUT += $date
	AddToOutput -txt "<div id='tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#equipment'><span>Hardware Inventory</span></a></li>"
	AddToOutput -txt "<li><a href='#server-config'><span>Service Configuration</span></a></li>"
	AddToOutput -txt "<li><a href='#lan-config'><span>LAN Configuration</span></a></li>"
	AddToOutput -txt "<li><a href='#san-config'><span>SAN Configuration</span></a></li>"
	AddToOutput -txt "<li><a href='#admin-config'><span>Admin Configuration</span></a></li>"
	AddToOutput -txt "<li><a href='#stats'><span>Statistics &amp; Faults</span></a></li>"
	AddToOutput -txt "<li><a href='#recommendations'><span>Recommendations</span></a></li>"
	AddToOutput -txt "</ul>"


	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################    EQUIPMENT OVERVIEW   ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='equipment'>"
	AddToOutput -txt "<div id='equipment-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#equipment-tab-fi'>Fabric Interconnect</a></li>"
	AddToOutput -txt "<li><a href='#equipment-tab-chassis'>Chassis</a></li>"
	AddToOutput -txt "<li><a href='#equipment-tab-servers'>Servers</a></li>"
	AddToOutput -txt "<li><a href='#equipment-tab-psu'>Power Supplies</a></li>"	
	AddToOutput -txt "<li><a href='#equipment-tab-firmware'>Firmware</a></li>"
	
	AddToOutput -txt "</ul>"
	AddToOutput -txt "<div class='content-sub' id='equipment-tab-fi'>"

	# Get Fabric Interconnects
	AddToOutput -txt "<h2>Fabric Interconnects</h2>"
	$Global:TMP_OUTPUT += Get-UcsNetworkElement | Select-Object Ucs,Rn,OobIfIp,OobIfMask,OobIfGw,Operability,Model,Serial | ConvertTo-Html -Fragment

	# Get Fabric Interconnect inventory
	AddToOutput -txt "<h2>Fabric Interconnect Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsFiModule | Sort-Object -Property Dn | Select-Object Dn,Model,Descr,OperState,State,Serial | ConvertTo-Html -Fragment

	# Get Cluster State
	AddToOutput -txt "<h2>Cluster Status</h2>"
	$Global:TMP_OUTPUT += Get-UcsStatus | Select-Object Name,VirtualIpv4Address,HaConfiguration,HaReadiness,HaReady,EthernetState | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsStatus | Select-Object FiALeadership,FiAOobIpv4Address,FiAManagementServicesState | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsStatus | Select-Object FiBLeadership,FiBOobIpv4Address,FiBManagementServicesState | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>"
	AddToOutput -txt "<div class='content-sub' id='equipment-tab-chassis'>"

	# Get Chassis info
	AddToOutput -txt "<h2>Chassis Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsChassis | Sort-Object -Property Rn | Select-Object Rn,AdminState,Model,OperState,LicState,Power,Thermal,Serial | ConvertTo-Html -Fragment

	# Get chassis IOM info
	AddToOutput -txt "<h2>IOM Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsIom | Sort-Object -Property Dn | Select-Object ChassisId,Rn,Model,Discovery,ConfigState,OperState,Side,Thermal,Serial | ConvertTo-Html -Fragment

	# Get Fabric Interconnect to Chassis port mapping
	AddToOutput -txt "<h2>Fabric Interconnect to IOM Connections</h2>"
	$Global:TMP_OUTPUT += Get-UcsEtherSwitchIntFIo | Select-Object ChassisId,Discovery,Model,OperState,SwitchId,PeerSlotId,PeerPortId,SlotId,PortId,XcvrType | ConvertTo-Html -Fragment

	# Get Global chassis discovery policy
	$chassisDiscoveryPolicy = Get-UcsChassisDiscoveryPolicy | Select-Object Rn,LinkAggregationPref,Action
	AddToOutput -txt "<h2>Chassis Discovery Policy</h2>"
	$Global:TMP_OUTPUT += $chassisDiscoveryPolicy | ConvertTo-Html -Fragment

	# Get Global chassis power redundancy policy
	$chassisPowerRedPolicy = Get-UcsPowerControlPolicy
	AddToOutput -txt "<h2>Chassis Power Redundancy Policy</h2>"
	$Global:TMP_OUTPUT += $chassisPowerRedPolicy | Select-Object Rn,Redundancy | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='equipment-tab-servers'>"

	# Get all UCS Blade Servers info
	If (Get-UcsBlade) {
		AddToOutput -txt "<h2>Server Inventory - Blades</h2>"
		$Global:TMP_OUTPUT += Get-UcsBlade | Select-Object Dn,ServerId,Model,AvailableMemory,@{N='CPUs';E={$_.NumOfCpus}},@{N='Cores';E={$_.NumOfCores}},@{N='Adaptors';E={$_.NumOfAdaptors}},@{N='eNICs';E={$_.NumOfEthHostIfs}},@{N='fNICs';E={$_.NumOfFcHostIfs}},@{Name="ConnPath"; Expression = {$_.ConnPath}},@{Name="ConnStatus"; Expression = {$_.ConnStatus}},Discovery,AssignedToDn,OperPower,OperState,Operability,Serial | Sort-Object -Property ChassisID,SlotID | ConvertTo-Html -Fragment
	}
	# Get all UCS Rack Servers info
	If (Get-UcsRackUnit) {
		AddToOutput -txt "<h2>Server Inventory - Rack-mounts</h2>"
		$Global:TMP_OUTPUT += Get-UcsRackUnit | Select-Object Dn,ServerId,Model,AvailableMemory,@{N='CPUs';E={$_.NumOfCpus}},@{N='Cores';E={$_.NumOfCores}},@{N='Adaptors';E={$_.NumOfAdaptors}},@{N='eNICs';E={$_.NumOfEthHostIfs}},@{N='fNICs';E={$_.NumOfFcHostIfs}},@{Name="ConnPath"; Expression = {$_.ConnPath}},@{Name="ConnStatus"; Expression = {$_.ConnStatus}},Discovery,AssignedToDn,OperPower,OperState,Operability,Serial | Sort-Object { [int]$_.ServerId } | ConvertTo-Html -Fragment
	}

    # Get server adaptor (mezzanine card) info
	AddToOutput -txt "<h2>Server Adaptor Inventory</h2>"
    $VICAdaptors = Get-UcsAdaptorUnit | Sort-Object -Property Dn | Select-Object Dn,Rn,Model,Serial
    ForEach ($VICAdaptor in $VICAdaptors){
        If($VICAdaptor.Model -like "UCSB-MLOM-40G-01"){$VICAdaptor.Model="UCSB-MLOM-40G-01 (VIC 1240)"}
        ElseIf($VICAdaptor.Model -like "UCSB-MLOM-40G-02"){$VICAdaptor.Model="UCSB-MLOM-40G-02 (VIC 1340)"}
        ElseIf($VICAdaptor.Model -like "UCSB-MLOM-40G-03"){$VICAdaptor.Model="UCSB-MLOM-40G-03 (VIC 1340)"}
        ElseIf($VICAdaptor.Model -like "UCSB-MLOM-40G-04"){$VICAdaptor.Model="UCSB-MLOM-40G-04 (VIC 1440)"}
        ElseIf($VICAdaptor.Model -like "UCSB-VIC-M84-4P"){$VICAdaptor.Model="UCSB-VIC-M84-4P (VIC 1480)"}
        ElseIf($VICAdaptor.Model -like "UCSB-VIC-M83-8P"){$VICAdaptor.Model="UCSB-VIC-M83-8P (VIC 1380)"}
        ElseIf($VICAdaptor.Model -like "UCS-VIC-M82-8P"){$VICAdaptor.Model="UCS-VIC-M82-8P (VIC 1280)"}
        ElseIf($VICAdaptor.Model -like "UCSB-MEZ-ELX-03"){$VICAdaptor.Model="UCSB-MEZ-ELX-03 (CNA M73KR-E Emulex)"}
        ElseIf($VICAdaptor.Model -like "UCSB-MLOM-PT-01"){$VICAdaptor.Model="UCSB-MLOM-PT-01 (Port Expander Card for VIC)"}
        ElseIf($VICAdaptor.Model -like "UCSC-MLOM-C25Q-04"){$VICAdaptor.Model="UCSC-MLOM-C25Q-04 (VIC 1457)"}
        ElseIf($VICAdaptor.Model -like "UCSC-MLOM-C40Q-03"){$VICAdaptor.Model="UCSC-MLOM-C40Q-03 (VIC 1387)"}
        ElseIf($VICAdaptor.Model -like "UCSC-MLOM-C10T-02"){$VICAdaptor.Model="UCSC-MLOM-C10T-02 (VIC 1227T)"}
        ElseIf($VICAdaptor.Model -like "UCSC-MLOM-CSC-02"){$VICAdaptor.Model="UCSC-MLOM-CSC-02 (VIC 1227)"}
        ElseIf($VICAdaptor.Model -like "UCSC-MLOM-IRJ45"){$VICAdaptor.Model="UCSC-MLOM-IRJ45 (MLOM Intel i350)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-C10T-02"){$VICAdaptor.Model="UCSC-PCIE-C10T-02 (VIC 1225T)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-C40Q-02"){$VICAdaptor.Model="UCSC-PCIE-C40Q-02 (VIC 1285)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-CSC-02"){$VICAdaptor.Model="UCSC-PCIE-CSC-02 (VIC 1225)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-C40Q-03"){$VICAdaptor.Model="UCSC-PCIE-C40Q-03 (VIC 1385)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-C25Q-04"){$VICAdaptor.Model="UCSC-PCIE-C25Q-04 (VIC 1455)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-E14102"){$VICAdaptor.Model="UCSC-PCIE-E14102 (CNA OCe14102-FX Emulex)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-E14102B"){$VICAdaptor.Model="UCSC-PCIE-E14102B (CNA OCe14102B-UX Emulex)"}
        ElseIf($VICAdaptor.Model -like "N2XX-AIPCI01"){$VICAdaptor.Model="N2XX-AIPCI01 (Adapter Intel X520)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-IRJ45"){$VICAdaptor.Model="UCSC-PCIE-IRJ45 (Adapter Intel i350)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-ITG"){$VICAdaptor.Model="UCSC-PCIE-ITG (Adapter Intel X540)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-ID10GC"){$VICAdaptor.Model="UCSC-PCIE-ID10GC (NIC Intel X550-T2)"}
        ElseIf($VICAdaptor.Model -like "UCSC-PCIE-QD25GF"){$VICAdaptor.Model="UCSC-PCIE-QD25GF (NIC Qlogic QL41212H)"}
    }
	$Global:TMP_OUTPUT += $VICAdaptors | ConvertTo-Html -Fragment

	# Get server adaptor port expander info
	AddToOutput -txt "<h2>Servers with Adaptor Port Expanders</h2>"
	$Global:TMP_OUTPUT += Get-UcsAdaptorUnitExtn | Sort-Object -Property Dn | Select-Object Dn,Model,Presence,Serial | ConvertTo-Html -Fragment

	# Get server processor info
	AddToOutput -txt "<h2>Server CPU Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsProcessorUnit | Sort-Object -Property Dn | Select-Object Dn,SocketDesignation,Cores,CoresEnabled,Threads,Speed,OperState,Thermal,Model | Where-Object {$_.OperState -ne "removed"} | ConvertTo-Html -Fragment

	# Get server memory info
	AddToOutput -txt "<h2>Server Memory Inventory</h2>"
    $ServerMemory = Get-UcsMemoryUnit | Sort-Object -Property Dn,Location | Where-Object {$_.Capacity -ne "unspecified"} | Select-Object Dn,Location,Capacity,Clock,Latency,OperState,Model,Vendor
    ForEach ($Memory in $ServerMemory){
        If($Memory.Vendor -like "0x2C00"){$Memory.Vendor="Micron Technology, Inc."}
        ElseIf($Memory.Vendor -like "0x5105"){$Memory.Vendor="Qimonda AG i. In"}
        ElseIf($Memory.Vendor -like "0x802C"){$Memory.Vendor="Micron Technology, Inc."}
        ElseIf($Memory.Vendor -like "0x80AD"){$Memory.Vendor="Hynix Semiconductor Inc."}
        ElseIf($Memory.Vendor -like "0x80CE"){$Memory.Vendor="Samsung Electronics, Inc."}
        ElseIf($Memory.Vendor -like "0x8551"){$Memory.Vendor="Qimonda AG i. In."}
        ElseIf($Memory.Vendor -like "0xAD00"){$Memory.Vendor="Hynix Semiconductor Inc."}
        ElseIf($Memory.Vendor -like "0xCE00"){$Memory.Vendor="Samsung Electronics, Inc."}
    }
    $Global:TMP_OUTPUT += $ServerMemory | ConvertTo-Html -Fragment

	# Get server storage controller info
	AddToOutput -txt "<h2>Server Storage Controller Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsStorageController | Sort-Object -Property Dn | Select-Object Dn,Vendor,Model,RaidSupport,Serial | Where-Object {$_.Model -ne ""} | ConvertTo-Html -Fragment

	# Get server local disk info
	AddToOutput -txt "<h2>Server Local Disk Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsStorageLocalDisk | Sort-Object -Property Dn | Select-Object Dn,Model,Vendor,ConnectionProtocol,DeviceType,LinkSpeed,@{N="SizeMB";E={$_.Size}},Serial | Where-Object {$_.Size -ne "not-applicable"}  | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='equipment-tab-psu'>"

	# Get Power Supplies info
	AddToOutput -txt "<h2>Power Supplies Inventory</h2>"
	$Global:TMP_OUTPUT += Get-UcsPsu | Sort-Object -Property Dn | Select-Object Dn,Model,Serial,OperState,Perf,Power,Thermal,Voltage | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='equipment-tab-firmware'>"

	# Get UCSM firmware version
	AddToOutput -txt "<h2>UCS Manager</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion  | Sort-Object -Property Dn | Where-Object {$_.Type -eq "system"} | ConvertTo-Html -Fragment

	# Get Fabric Interconnect firmware
	AddToOutput -txt "<h2>Fabric Interconnect</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion | Sort-Object -Property Dn | Where-Object {$_.Type -eq "switch-kernel" -OR $_.Type -eq "switch-software"} | ConvertTo-Html -Fragment

	# Get IOM firmware
	AddToOutput -txt "<h2>IOM</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion | Sort-Object -Property Dn | Where-Object {$_.Type -eq "iocard" -and $_.Dn -like "*fw-system"} | Where-Object -FilterScript {$_.Deployment -notlike "boot-loader"} | ConvertTo-Html -Fragment

	# Get Server Adapter firmware
	AddToOutput -txt "<h2>Server Adapters</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion | Sort-Object -Property Dn | Where-Object {$_.Type -eq "adaptor" -and $_.Dn -like "*fw-system"} | Where-Object -FilterScript {$_.Deployment -notlike "boot-loader"} | ConvertTo-Html -Fragment

	# Get Server CIMC firmware
	AddToOutput -txt "<h2>Server CIMC</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion | Sort-Object -Property Dn | Where-Object {$_.Type -eq "blade-controller" -and $_.Dn -like "*fw-system"} | Where-Object -FilterScript {$_.Deployment -notlike "boot-loader"} | ConvertTo-Html -Fragment

	# Get Server BIOS versions
	AddToOutput -txt "<h2>Server BIOS</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareRunning | Select-Object Dn,Type,Version,PackageVersion | Sort-Object -Property Dn | Where-Object {$_.Type -eq "blade-bios"} | ConvertTo-Html -Fragment

	# Get Host Firmware Packages
	AddToOutput -txt "<h2>Host Firmware Packages</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareComputeHostPack | Select-Object Dn,Name,BladeBundleVersion,RackBundleVersion | ConvertTo-Html -Fragment

	# Get Firmware Packages
	AddToOutput -txt "<h2>Firmware Packages</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwarePackage | Select-Object Name,Type,Version | ConvertTo-Html -Fragment

	# Get Catalog Package
	AddToOutput -txt "<h2>Catalog Package</h2>"
	$Global:TMP_OUTPUT += Get-UcsFirmwareCatalogPack | Select-Object CatalogName,CatalogVersion,Descr,Mode,Name | ConvertTo-Html -Fragment


	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs container
	AddToOutput -txt "</div>" # end tab

	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################  SERVICE CONFIGURATION  ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='server-config'>"
	AddToOutput -txt "<div id='server-config-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#server-config-tab-sp'>Service Profiles</a></li>"
	AddToOutput -txt "<li><a href='#server-config-tab-policies'>Policies</a></li>"
	AddToOutput -txt "<li><a href='#server-config-tab-pools'>Pools</a></li>"
	AddToOutput -txt "</ul>"
	AddToOutput -txt "<div class='content-sub' id='server-config-tab-sp'>"

	# Get Service Profile Templates
	AddToOutput -txt "<h2>Service Profile Templates</h2>"
	$Global:TMP_OUTPUT += Get-UcsServiceProfile | Where-object {$_.Type -like "*template"}  | Sort-object -Property Name | Select-Object Dn,Name,Type,BiosProfileName,BootPolicyName,IdentPoolName,HostFwPolicyName,LocalDiskPolicyName,ScrubPolicyName,MaintPolicyName,VconProfileName,PowerPolicyName | ConvertTo-Html -Fragment

	# Get Service Profiles
	AddToOutput -txt "<h2>Service Profiles</h2>"
	$Global:TMP_OUTPUT += Get-UcsServiceProfile | Where-object {$_.Type -eq "instance"}  | Sort-object -Property Name | Select-Object Dn,Name,OperSrcTemplName,AssocState,PnDn,BiosProfileName,IdentPoolName,Uuid,BootPolicyName,HostFwPolicyName,LocalDiskPolicyName,MaintPolicyName,VconProfileName,OperState | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='server-config-tab-policies'>"

	# Get Maintenance Policies
	AddToOutput -txt "<h2>Maintenance Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsMaintenancePolicy | Select-Object Name,Dn,UptimeDisr,Descr | ConvertTo-Html -Fragment

	# Get Boot Policies
	AddToOutput -txt "<h2>Boot Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsBootPolicy | sort-object -Property Dn | Select-Object Dn,Name,Purpose,RebootOnUpdate | ConvertTo-Html -Fragment

	# Get SAN Boot Policies
	AddToOutput -txt "<h2>SAN Boot Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsLsbootSanImagePath | sort-object -Property Dn | Select-Object Dn,Type,Vnicname,Lun,Wwn | Where-Object -FilterScript {$_.Dn -notlike "sys/chassis*"} | ConvertTo-Html -Fragment

	# Get Local Disk Policies
	AddToOutput -txt "<h2>Local Disk Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsLocalDiskConfigPolicy | Select-Object Dn,Name,Mode,Descr | ConvertTo-Html -Fragment

	# Get Scrub Policies
	AddToOutput -txt "<h2>Scrub Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsScrubPolicy | Select-Object Dn,Name,BiosSettingsScrub,DiskScrub | Where-Object {$_.Name -ne "policy"} | ConvertTo-Html -Fragment

	# Get BIOS Policies
	AddToOutput -txt "<h2>BIOS Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"} | Select-Object Dn,Name | ConvertTo-Html -Fragment

	# Get BIOS Policy Settings
	AddToOutput -txt "<h2>BIOS Policy Settings</h2>"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfQuietBoot | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfPOSTErrorPause | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfResumeOnACPowerLoss | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfFrontPanelLockout | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosTurboBoost | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosEnhancedIntelSpeedStep | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosHyperThreading | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfCoreMultiProcessing | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosExecuteDisabledBit | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfIntelVirtualizationTechnology | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfDirectCacheAccess | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfProcessorCState | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfProcessorC1E | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfProcessorC3Report | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfProcessorC6Report | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfProcessorC7Report | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfCPUPerformance | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfMaxVariableMTRRSetting | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosIntelDirectedIO | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfSelectMemoryRASConfiguration | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosNUMA | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosLvDdrMode | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfUSBBootConfig | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfUSBFrontPanelAccessLock | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfUSBSystemIdlePowerOptimizingSetting | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfMaximumMemoryBelow4GB | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfMemoryMappedIOAbove4GB | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfBootOptionRetry | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfIntelEntrySASRAIDModule | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"
	$Global:TMP_OUTPUT += Get-UcsBiosPolicy | Where-Object {$_.Name -ne "SRIOV"}  | Get-UcsBiosVfOSBootWatchdogTimer | Sort-Object Dn | Select-Object Dn,Vp* | ConvertTo-Html -Fragment
	AddToOutput -txt "<br />"

	# Get Service Profiles vNIC/vHBA Assignments
	AddToOutput -txt "<h2>Service Profile vNIC Placements</h2>"
	$Global:TMP_OUTPUT += Get-UcsLsVConAssign -Transport ethernet | Select-Object Dn,Vnicname,Adminvcon,Order | Sort-Object Dn | ConvertTo-Html -Fragment

	# Get Ethernet VLAN to vNIC Mappings #
	AddToOutput -txt "<h2>Ethernet VLAN to vNIC Mappings</h2>"
    $Global:TMP_OUTPUT += Get-UcsAdaptorVlan | sort-object Dn |Select-Object Dn,Name,Id,SwitchId | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='server-config-tab-pools'>"

	# Get UUID Suffix Pools
	AddToOutput -txt "<h2>UUID Pools</h2>"
	$Global:TMP_OUTPUT += Get-UcsUuidSuffixPool | Select-Object Dn,Name,AssignmentOrder,Prefix,Size,Assigned | ConvertTo-Html -Fragment

	# Get UUID Suffix Pool Blocks
	AddToOutput -txt "<h2>UUID Pool Blocks</h2>"
	$Global:TMP_OUTPUT += Get-UcsUuidSuffixBlock | Select-Object Dn,From,To | ConvertTo-Html -Fragment

	# Get UUID UUID Pool Assignments
	AddToOutput -txt "<h2>UUID Pool Assignments</h2>"
	$Global:TMP_OUTPUT += Get-UcsUuidpoolAddr | Where-Object {$_.Assigned -ne "no"} | select-object AssignedToDn,Id | sort-object -property AssignedToDn | ConvertTo-Html -Fragment

	# Get Server Pools
	AddToOutput -txt "<h2>Server Pools</h2>"
	$Global:TMP_OUTPUT += Get-UcsServerPool | Select-Object Dn,Name,Assigned | ConvertTo-Html -Fragment

	# Get Server Pool Assignments
	AddToOutput -txt "<h2>Server Pool Assignments</h2>"
	$Global:TMP_OUTPUT += Get-UcsComputePooledSlot | Select-Object Dn,Rn | ConvertTo-Html -Fragment
	$Global:TMP_OUTPUT += "<br />"
	$Global:TMP_OUTPUT += Get-UcsComputePooledRackUnit | Select-Object Dn,PoolableDn | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs container
	AddToOutput -txt "</div>" # end tab service configuration

	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################    LAN CONFIGURATION    ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='lan-config'>"

	AddToOutput -txt "<div id='lan-config-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#lan-config-tab-lan'>LAN</a></li>"
	AddToOutput -txt "<li><a href='#lan-config-tab-policies'>Policies</a></li>"
	AddToOutput -txt "<li><a href='#lan-config-tab-pools'>Pools</a></li>"
	AddToOutput -txt "</ul>"

	AddToOutput -txt "<div class='content-sub' id='lan-config-tab-lan'>"

	# Get LAN Switching Mode
	AddToOutput -txt "<h2>Fabric Interconnect Ethernet Switching Mode</h2>"
	$Global:TMP_OUTPUT += Get-UcsLanCloud | Select-Object Rn,Mode | ConvertTo-Html -Fragment

	# Get Fabric Interconnect Ethernet port usage and role info
	AddToOutput -txt "<h2>Fabric Interconnect Ethernet Port Configuration</h2>"
	$Global:TMP_OUTPUT += Get-UcsFabricPort | Select-Object Dn,IfRole,LicState,Mode,OperState,OperSpeed,XcvrType | Where-Object {$_.OperState -eq "up"} | ConvertTo-Html -Fragment

	# Get Ethernet LAN Uplink Port Channel info
	AddToOutput -txt "<h2>Fabric Interconnect Ethernet Uplink Port Channels</h2>"
	$Global:TMP_OUTPUT += Get-UcsUplinkPortChannel | Sort-Object -Property Name | Select-Object Dn,Name,OperSpeed,OperState,Transport | ConvertTo-Html -Fragment

	# Get Ethernet LAN Uplink Port Channel port membership info
	AddToOutput -txt "<h2>Fabric Interconnect Ethernet Uplink Port Channel Members</h2>"
	$Global:TMP_OUTPUT += Get-UcsUplinkPortChannelMember | Sort-Object -Property Dn |Select-Object Dn,Membership | ConvertTo-Html -Fragment

	# Get QoS Class Configuration
	AddToOutput -txt "<h2>QoS System Class Configuration</h2>"
	$UcsQosClass = Get-UcsQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu
	$UcsBestEffortQosClass = Get-UcsBestEffortQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu
	$UcsFcQosClass = Get-UcsFcQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu
    $UcsFullClass = @()
    $UcsFullClass += $UcsQosClass
    $UcsFullClass += $UcsBestEffortQosClass
    $UcsFullClass += $UcsFcQosClass
	#$Global:TMP_OUTPUT += Get-UcsQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu | ConvertTo-Html -Fragment
	#$Global:TMP_OUTPUT += Get-UcsBestEffortQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu | ConvertTo-Html -Fragment
	#$Global:TMP_OUTPUT += Get-UcsFcQosClass | Select-Object Priority,AdminState,Cos,Weight,Drop,Mtu | ConvertTo-Html -Fragment
	$Global:TMP_OUTPUT += $UcsFullClass | ConvertTo-Html -Fragment

	# Get vNIC Configuration
	AddToOutput -txt "<h2>vNIC Configuration</h2>"
    $Global:TMP_OUTPUT += Get-UcsVnic | Select-Object DN,Name,OperQosPolicyName,OperNwCtrlPolicyName,OperNwTemplName,EquipmentDn | ConvertTo-Html -Fragment

	# Get Ethernet VLANs
	AddToOutput -txt "<h2>Ethernet VLANs</h2>"
	$Global:TMP_OUTPUT += Get-UcsVlan | Where-Object {$_.IfRole -eq "network"} | Sort-Object -Property Id | Select-Object Id,Name,SwitchId | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='lan-config-tab-policies'>"

	# Get Network Control Policies
	AddToOutput -txt "<h2>Network Control Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsNetworkControlPolicy | Select-Object Dn,Name,Cdp,UplinkFailAction,LldpReceive,LldpTransmit | ConvertTo-Html -Fragment

	# Get QoS Policies
	AddToOutput -txt "<h2>QoS Policies</h2>"
	$Global:TMP_OUTPUT += Get-UcsQosPolicy | Select-Object Dn,Name | ConvertTo-Html -Fragment

	# Get QoS vNIC Egress Policy Map
	AddToOutput -txt "<h2>QoS vNIC Egress Policy Map</h2>"
	$Global:TMP_OUTPUT += Get-UcsVnicEgressPolicy | Sort-Object -Property Prio | Select-Object Dn,Prio,OperPrio,Rate,Burst | ConvertTo-Html -Fragment

	# Get vNIC Templates
	$vnicTemplates = Get-UcsVnicTemplate | Select-Object Dn,Name,Descr,SwitchId,TemplType,IdentPoolName,Mtu,NwCtrlPolicyName,QosPolicyName
	AddToOutput -txt "<h2>vNIC Templates</h2>"
	$Global:TMP_OUTPUT += $vnicTemplates | ConvertTo-Html -Fragment

	# Get Ethernet VLAN to vNIC Mappings #
	AddToOutput -txt "<h2>Ethernet VLAN to vNIC Mappings</h2>"
	$Global:TMP_OUTPUT += Get-UcsAdaptorVlan | sort-object Dn |Select-Object Dn,Rn,Name,Id,SwitchId,Transport,Type | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='lan-config-tab-pools'>"

	# Get IP Pools
	AddToOutput -txt "<h2>IP Pools</h2>"
	$Global:TMP_OUTPUT += Get-UcsIpPool | Select-Object Dn,Name,AssignmentOrder,Size | ConvertTo-Html -Fragment

	# Get IP Pool Blocks
	AddToOutput -txt "<h2>IP Pool Blocks</h2>"
	$Global:TMP_OUTPUT += Get-UcsIpPoolBlock | Select-Object Dn,From,To,Subnet,DefGw | ConvertTo-Html -Fragment

	# Get IP CIMC MGMT Pool Assignments
	AddToOutput -txt "<h2>CIMC IP Pool Assignments</h2>"
	$Global:TMP_OUTPUT += Get-UcsIpPoolAddr | Sort-Object -Property AssignedToDn | Where-Object {$_.Assigned -eq "yes"} | Select-Object AssignedToDn,Id | ConvertTo-Html -Fragment

	# Get MAC Address Pools
	AddToOutput -txt "<h2>MAC Address Pools</h2>"
	$Global:TMP_OUTPUT += Get-UcsMacPool | Select-Object Dn,Name,AssignmentOrder,Size,Assigned | ConvertTo-Html -Fragment

	# Get MAC Address Pool Blocks
	AddToOutput -txt "<h2>MAC Address Pool Blocks</h2>"
	$Global:TMP_OUTPUT += Get-UcsMacMemberBlock | Select-Object Dn,From,To | ConvertTo-Html -Fragment

	# Get MAC Pool Assignments
	AddToOutput -txt "<h2>MAC Address Pool Assignments</h2>"
	$Global:TMP_OUTPUT += Get-UcsVnic | Sort-Object -Property Dn | Select-Object Dn,IdentPoolName,Addr | Where-Object {$_.Addr -ne "derived"} | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs containers
	AddToOutput -txt "</div>" # end tab LAN configuration

	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################    SAN CONFIGURATION    ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='san-config'>"

	AddToOutput -txt "<div id='san-config-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#san-config-tab-san'>SAN</a></li>"
	AddToOutput -txt "<li><a href='#san-config-tab-policies'>Policies</a></li>"
	AddToOutput -txt "<li><a href='#san-config-tab-pools'>Pools</a></li>"
	AddToOutput -txt "</ul>"

	AddToOutput -txt "<div class='content-sub' id='san-config-tab-san'>"

	# Get SAN Switching Mode
	AddToOutput -txt "<h2>Fabric Interconnect Fibre Channel Switching Mode</h2>"
	$Global:TMP_OUTPUT += Get-UcsSanCloud | Select-Object Rn,Mode | ConvertTo-Html -Fragment

	# Get Fabric Interconnect FC Uplink Ports
	AddToOutput -txt "<h2>Fabric Interconnect FC Uplink Ports</h2>"
	$Global:TMP_OUTPUT += Get-UcsFiFcPort | Select-Object EpDn,SwitchId,SlotId,PortId,LicState,Mode,OperSpeed,OperState,wwn | sort-object -descending  | where-object {$_.OperState -ne "sfp-not-present"} | ConvertTo-Html -Fragment

	# Get SAN Fiber Channel Uplink Port Channel info
	AddToOutput -txt "<h2>Fabric Interconnect FC Uplink Port Channels</h2>"
	$Global:TMP_OUTPUT += Get-UcsFcUplinkPortChannel | Select-Object Dn,Name,OperSpeed,OperState,Transport | ConvertTo-Html -Fragment

	# Get Fabric Interconnect FCoE Uplink Ports
	AddToOutput -txt "<h2>Fabric Interconnect FCoE Uplink Ports</h2>"
	$Global:TMP_OUTPUT += Get-UcsFabricPort | Where-Object {$_.IfRole -eq "fcoe-uplink"} | Select-Object IfRole,EpDn,LicState,OperState,OperSpeed | ConvertTo-Html -Fragment

	# Get SAN FCoE Uplink Port Channel info
	AddToOutput -txt "<h2>Fabric Interconnect FCoE Uplink Port Channels</h2>"
	$Global:TMP_OUTPUT += Get-UcsFabricFcoeSanPc | Select-Object Dn,Name,FcoeState,OperState,Transport,Type | ConvertTo-Html -Fragment

	# Get SAN FCoE Uplink Port Channel Members
	AddToOutput -txt "<h2>Fabric Interconnect FCoE Uplink Port Channel Members</h2>"
	$Global:TMP_OUTPUT += Get-UcsFabricFcoeSanPcEp | Select-Object Dn,IfRole,LicState,Membership,OperState,SwitchId,PortId,Type | ConvertTo-Html -Fragment

	# Get FC VSAN info
	AddToOutput -txt "<h2>FC VSANs</h2>"
	$Global:TMP_OUTPUT += Get-UcsVsan | Select-Object Dn,Id,FcoeVlan,DefaultZoning | ConvertTo-Html -Fragment

	# Get FC Port Channel VSAN Mapping
	AddToOutput -txt "<h2>FC VSAN to FC Port Mappings</h2>"
	$Global:TMP_OUTPUT += Get-UcsVsanMemberFcPortChannel | Select-Object EpDn,IfType | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='san-config-tab-policies'>"

	# Get vHBA Templates
	$vhbaTemplates = Get-UcsVhbaTemplate | Select-Object Dn,Name,Descr,SwitchId,TemplType,QosPolicyName
	AddToOutput -txt "<h2>vHBA Templates</h2>"
	$Global:TMP_OUTPUT += $vhbaTemplates | ConvertTo-Html -Fragment

	# Get Service Profiles vNIC/vHBA Assignments
	AddToOutput -txt "<h2>Service Profile vHBA Placements</h2>"
	$Global:TMP_OUTPUT += Get-UcsLsVConAssign -Transport fc | Select-Object Dn,Vnicname,Adminvcon,Order | Sort-Object dn | ConvertTo-Html -Fragment

	# Get vHBA to VSAN Mappings
	AddToOutput -txt "<h2>vHBA to VSAN Mappings</h2>"
	$Global:TMP_OUTPUT += Get-UcsVhbaInterface | Select-Object Dn,OperVnetName,Initiator | Where-Object {$_.Initiator -ne "00:00:00:00:00:00:00:00"} | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='san-config-tab-pools'>"

	# Get WWNN Pools
	AddToOutput -txt "<h2>WWN Pools</h2>"
	$Global:TMP_OUTPUT += Get-UcsWwnPool | Select-Object Dn,Name,AssignmentOrder,Purpose,Size,Assigned | ConvertTo-Html -Fragment

	# Get WWNN/WWPN Pool Assignments
	AddToOutput -txt "<h2>WWN Pool Assignments</h2>"
	$Global:TMP_OUTPUT += Get-UcsVhba | Sort-Object -Property Addr | Select-Object Dn,IdentPoolName,NodeAddr,Addr | Where-Object {$_.NodeAddr -ne "vnic-derived"} | ConvertTo-Html -Fragment

	# Get WWNN/WWPN vHBA and adaptor Assignments
	AddToOutput -txt "<h2>vHBA Details</h2>"
	$Global:TMP_OUTPUT += Get-UcsAdaptorHostFcIf | sort-object -Property VnicDn -Descending | Select-Object VnicDn,Vendor,Model,LinkState,SwitchId,NodeWwn,Wwn | Where-Object {$_.NodeWwn -ne "00:00:00:00:00:00:00:00"} | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs containers
	AddToOutput -txt "</div>" # end tab SAN configuration


	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################   ADMIN CONFIGURATION   ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################


	AddToOutput -txt "<div class='content' id='admin-config'>"

	AddToOutput -txt "<div id='admin-config-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#admin-config-tab-general'>General Settings</a></li>"
	AddToOutput -txt "<li><a href='#admin-config-tab-user'>User Management</a></li>"
	AddToOutput -txt "<li><a href='#admin-config-tab-comm'>Communication Management</a></li>"
	AddToOutput -txt "<li><a href='#admin-config-tab-license'>Licensing</a></li>"
	AddToOutput -txt "</ul>"

	AddToOutput -txt "<div class='content-sub' id='admin-config-tab-general'>"

	# Get Organizations
	AddToOutput -txt "<h2>Organizations</h2>"
	$Global:TMP_OUTPUT += Get-UcsOrg | Select-Object Name,Dn | ConvertTo-Html -Fragment

	# Get Fault Policy
	AddToOutput -txt "<h2>Fault Policy</h2>"
	$Global:TMP_OUTPUT += Get-UcsFaultPolicy | Select-Object Rn,AckAction,ClearAction,ClearInterval,FlapInterval,RetentionInterval,PinningExpirationInterval | ConvertTo-Html -Fragment

	# Get Syslog Remote Destinations
	AddToOutput -txt "<h2>Remote Syslog</h2>"
	$Global:TMP_OUTPUT += Get-UcsSyslogClient | Where-Object {$_.AdminState -ne "disabled"} | Select-Object Rn,Severity,Hostname,ForwardingFacility | ConvertTo-Html -Fragment

	# Get Syslog Sources
	AddToOutput -txt "<h2>Syslog Sources</h2>"
	$Global:TMP_OUTPUT += Get-UcsSyslogSource | Select-Object Rn,Audits,Events,Faults | ConvertTo-Html -Fragment

	# Get Syslog Local File
	AddToOutput -txt "<h2>Syslog Local File</h2>"
	$Global:TMP_OUTPUT += Get-UcsSyslogFile | Select-Object Rn,Name,AdminState,Severity,Size | ConvertTo-Html -Fragment

	# Get Full State Backup Policy
	AddToOutput -txt "<h2>Full State Backup Policy</h2>"
	$Global:TMP_OUTPUT += Get-UcsMgmtBackupPolicy | Select-Object Descr,Host,LastBackup,Proto,Schedule,AdminState | ConvertTo-Html -Fragment

	# Get All Config Backup Policy
	AddToOutput -txt "<h2>All Configuration Backup Policy</h2>"
	$Global:TMP_OUTPUT += Get-UcsMgmtCfgExportPolicy | Select-Object Descr,Host,LastBackup,Proto,Schedule,AdminState | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>"
	AddToOutput -txt "<div class='content-sub' id='admin-config-tab-user'>"

	# Get Native Authentication Source
	AddToOutput -txt "<h2>Native Authentication</h2>"
	$Global:TMP_OUTPUT += Get-UcsNativeAuth | Select-Object Rn,DefLogin,ConLogin,DefRolePolicy | ConvertTo-Html -Fragment

	# Get local users
	AddToOutput -txt "<h2>Local users</h2>"
	$Global:TMP_OUTPUT += Get-UcsLocalUser | Sort-Object Name | Select-Object Name,@{N='Priv';E={$_.Priv}},Email,AccountStatus,Expiration,Expires,PwdLifeTime | ConvertTo-Html -Fragment

	# Get LDAP server info
	AddToOutput -txt "<h2>LDAP Providers</h2>"
	$Global:TMP_OUTPUT += Get-UcsLdapProvider | Select-Object Name,Rootdn,Basedn,Attribute | ConvertTo-Html -Fragment

	# Get LDAP group mappings
	AddToOutput -txt "<h2>LDAP Group Mappings</h2>"
	$Global:TMP_OUTPUT += Get-UcsLdapGroupMap | Select-Object Name | ConvertTo-Html -Fragment

	# Get user and LDAP group roles
	AddToOutput -txt "<h2>User Roles</h2>"
	$Global:TMP_OUTPUT += Get-UcsUserRole | Select-Object Name,Dn | ConvertTo-Html -Fragment

	# Get tacacs providers
	AddToOutput -txt "<h2>TACACS+ Providers</h2>"
	$Global:TMP_OUTPUT += Get-UcsTacacsProvider | Sort-Object -Property Order,Name | Select-Object Order,Name,Port,KeySet,Retries,Timeout | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>"
	AddToOutput -txt "<div class='content-sub' id='admin-config-tab-comm'>"

	# Get Call Home config
	$callHome = Get-UcsCallhome
	AddToOutput -txt "<h2>Call Home Configuration</h2>"
	$Global:TMP_OUTPUT += $callHome | Sort-Object -Property Ucs | Select-Object AdminState | ConvertTo-Html -Fragment

	# Get Call Home SMTP Server
	AddToOutput -txt "<h2>Call Home SMTP Server</h2>"
	$Global:TMP_OUTPUT += Get-UcsCallhomeSmtp | Sort-Object -Property Ucs | Select-Object Host | ConvertTo-Html -Fragment

	# Get Call Home Recipients
	AddToOutput -txt "<h2>Call Home Recipients</h2>"
	$Global:TMP_OUTPUT += Get-UcsCallhomeRecipient | Sort-Object -Property Ucs | Select-Object Dn,Email | ConvertTo-Html -Fragment

	# Get SNMP Configuration
	AddToOutput -txt "<h2>SNMP Configuration</h2>"
	$Global:TMP_OUTPUT += Get-UcsSnmp | Sort-Object -Property Ucs | Select-Object AdminState,Community,SysContact,SysLocation | ConvertTo-Html -Fragment

	# Get DNS Servers
	$dnsServers = Get-UcsDnsServer | Select-Object Name
	AddToOutput -txt "<h2>DNS Servers</h2>"
	$Global:TMP_OUTPUT += $dnsServers | ConvertTo-Html -Fragment

	# Get Timezone
	AddToOutput -txt "<h2>Timezone</h2>"
	$Global:TMP_OUTPUT += Get-UcsTimezone | Select-Object Timezone | ConvertTo-Html -Fragment

	# Get NTP Servers
	$ntpServers = Get-UcsNtpServer | Select-Object Name
	AddToOutput -txt "<h2>NTP Servers</h2>"
	$Global:TMP_OUTPUT += $ntpServers | ConvertTo-Html -Fragment

	# Get Cluster Configuration and State
	AddToOutput -txt "<h2>Cluster Configuration</h2>"
	$Global:TMP_OUTPUT += Get-UcsStatus | Select-Object Name,VirtualIpv4Address,HaConfiguration,HaReadiness,HaReady,FiALeadership,FiAOobIpv4Address,FiAOobIpv4DefaultGateway,FiAManagementServicesState,FiBLeadership,FiBOobIpv4Address,FiBOobIpv4DefaultGateway,FiBManagementServicesState | ConvertTo-Html -Fragment

	# Get Management Interface Monitoring Policy
	AddToOutput -txt "<h2>Management Interface Monitoring Policy</h2>"
	$Global:TMP_OUTPUT += Get-UcsMgmtInterfaceMonitorPolicy | Select-Object AdminState,EnableHAFailover,MonitorMechanism | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>"
	AddToOutput -txt "<div class='content-sub' id='admin-config-tab-license'>"

	# Get host-id information
	AddToOutput -txt "<h2>Fabric Interconnect HostIDs</h2>"
	$Global:TMP_OUTPUT += Get-UcsLicenseServerHostId | Sort-Object -Property Scope | Select-Object Scope,HostId | ConvertTo-Html -Fragment

	# Get installed license information
	$ucsLicenses = Get-UcsLicense
	AddToOutput -txt "<h2>Installed Licenses</h2>"
	$Global:TMP_OUTPUT += $ucsLicenses | Sort-Object -Property Scope,Feature | Select-Object Scope,Feature,Sku,AbsQuant,UsedQuant,GracePeriodUsed,OperState,PeerStatus | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs containers
	AddToOutput -txt "</div>" # end tab SAN configuration

	##########################################################################################################################################################
	##########################################################################################################################################################
	###################################################        STATISTICS       ##############################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='stats'>"
	AddToOutput -txt "<div id='stats-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#stats-tab-faults'>Faults</a></li>"
	AddToOutput -txt "<li><a href='#stats-tab-equip'>Equipment</a></li>"
	AddToOutput -txt "<li><a href='#stats-tab-eth'>Ethernet</a></li>"
	AddToOutput -txt "<li><a href='#stats-tab-fc'>Fiberchannel</a></li>"
	AddToOutput -txt "</ul>"
	AddToOutput -txt "<div class='content-sub' id='stats-tab-faults'>"

	# Get all UCS Faults sorted by severity
	AddToOutput -txt "<h2>Faults</h2>"
	$Global:TMP_OUTPUT += Get-UcsFault | Sort-Object -Property Severity,Created -Descending | Select-Object Severity,Created,Descr,dn | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='stats-tab-equip'>"

	# Get chassis power usage stats
	AddToOutput -txt "<br /><small>* Temperatures are in Celcius</small>"
	AddToOutput -txt "<h2>Chassis Power</h2>"
	$Global:TMP_OUTPUT += Get-UcsChassisStats | Select-Object Dn,InputPower,InputPowerAvg,InputPowerMax,InputPowerMin,OutputPower,OutputPowerAvg,OutputPowerMax,OutputPowerMin,Suspect | ConvertTo-Html -Fragment

	# Get chassis and FI power status
	AddToOutput -txt "<h2>Chassis and Fabric Interconnect Power Supply Status</h2>"
	$Global:TMP_OUTPUT += Get-UcsPsu | Sort-Object -Property Dn | Select-Object Dn,OperState,Perf,Power,Thermal,Voltage | ConvertTo-Html -Fragment

	# Get chassis PSU stats
	AddToOutput -txt "<h2>Chassis Power Supplies</h2>"
	$Global:TMP_OUTPUT += Get-UcsPsuStats | Sort-Object -Property Dn | Select-Object Dn,AmbientTemp,AmbientTempAvg,Input210v,Input210vAvg,Output12v,Output12vAvg,OutputCurrentAvg,OutputPowerAvg,Suspect | ConvertTo-Html -Fragment

	# Get chassis and FI fan stats
	AddToOutput -txt "<h2>Chassis and Fabric Interconnect Fan</h2>"
	$Global:TMP_OUTPUT += Get-UcsFan | Sort-Object -Property Dn | Select-Object Dn,Module,Id,Perf,Power,OperState,Thermal | ConvertTo-Html -Fragment

	# Get chassis IOM temp stats
	AddToOutput -txt "<h2>Chassis IOM Temperatures</h2>"
	$Global:TMP_OUTPUT += Get-UcsEquipmentIOCardStats | Sort-Object -Property Dn | Select-Object Dn,AmbientTemp,AmbientTempAvg,Temp,TempAvg,Suspect | ConvertTo-Html -Fragment

	# Get blade power usage
	AddToOutput -txt "<h2>Server Power</h2>"
	$Global:TMP_OUTPUT += Get-UcsComputeMbPowerStats | Sort-Object -Property Dn | Select-Object Dn,ConsumedPower,ConsumedPowerAvg,ConsumedPowerMax,InputCurrent,InputCurrentAvg,InputVoltage,InputVoltageAvg,Suspect | ConvertTo-Html -Fragment

	# Get blade temperatures
	AddToOutput -txt "<h2>Server Temperatures</h2>"
	$Global:TMP_OUTPUT += Get-UcsComputeMbTempStats | Sort-Object -Property Dn | Select-Object Dn,FmTempSenIo,FmTempSenIoAvg,FmTempSenIoMax,FmTempSenRear,FmTempSenRearAvg,FmTempSenRearMax,Suspect | ConvertTo-Html -Fragment

	# Get Memory temperatures
	AddToOutput -txt "<h2>Memory Temperatures</h2>"
	$Global:TMP_OUTPUT += Get-UcsMemoryUnitEnvStats | Sort-Object -Property Dn | Select-Object Dn,Temperature,TemperatureAvg,TemperatureMax,Suspect | ConvertTo-Html -Fragment

	# Get CPU power and temperatures
	AddToOutput -txt "<h2>CPU Power and Temperatures</h2>"
	$Global:TMP_OUTPUT += Get-UcsProcessorEnvStats | Sort-Object -Property Dn | Select-Object Dn,InputCurrent,InputCurrentAvg,InputCurrentMax,Temperature,TemperatureAvg,TemperatureMax,Suspect | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='stats-tab-eth'>"

	# Get LAN Uplink Port Channel Loss Stats
	AddToOutput -txt "<h2>LAN Uplink Port Channel Loss</h2>"
	$Global:TMP_OUTPUT += Get-UcsUplinkPortChannel | Get-UcsEtherLossStats | Sort-Object -Property Dn | Select-Object Dn,ExcessCollision,ExcessCollisionDeltaAvg,LateCollision,LateCollisionDeltaAvg,MultiCollision,MultiCollisionDeltaAvg,SingleCollision,SingleCollisionDeltaAvg | ConvertTo-Html -Fragment

	# Get LAN Uplink Port Channel Receive Stats
	AddToOutput -txt "<h2>LAN Uplink Port Channel Receive</h2>"
	$Global:TMP_OUTPUT += Get-UcsUplinkPortChannel | Get-UcsEtherRxStats | Sort-Object -Property Dn | Select-Object Dn,BroadcastPackets,BroadcastPacketsDeltaAvg,JumboPackets,JumboPacketsDeltaAvg,MulticastPackets,MulticastPacketsDeltaAvg,TotalBytes,TotalBytesDeltaAvg,TotalPackets,TotalPacketsDeltaAvg,Suspect | ConvertTo-Html -Fragment

	# Get LAN Uplink Port Channel Transmit Stats
	AddToOutput -txt "<h2>LAN Uplink Port Channel Transmit</h2>"
	$Global:TMP_OUTPUT += Get-UcsUplinkPortChannel | Get-UcsEtherTxStats | Sort-Object -Property Dn | Select-Object Dn,BroadcastPackets,BroadcastPacketsDeltaAvg,JumboPackets,JumboPacketsDeltaAvg,MulticastPackets,MulticastPacketsDeltaAvg,TotalBytes,TotalBytesDeltaAvg,TotalPackets,TotalPacketsDeltaAvg,Suspect | ConvertTo-Html -Fragment

	# Get vNIC Stats
	AddToOutput -txt "<h2>vNICs</h2>"
	$Global:TMP_OUTPUT += Get-UcsAdaptorVnicStats | Sort-Object -Property Dn | Select-Object Dn,BytesRx,BytesRxDeltaAvg,BytesTx,BytesTxDeltaAvg,PacketsRx,PacketsRxDeltaAvg,PacketsTx,PacketsTxDeltaAvg,DroppedRx,DroppedRxDeltaAvg,DroppedTx,DroppedTxDeltaAvg,ErrorsTx,ErrorsTxDeltaAvg,Suspect | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "<div class='content-sub' id='stats-tab-fc'>"

	# Get FC Uplink Port Channel Loss Stats
	AddToOutput -txt "<h2>FC Uplink Ports</h2>"
	$Global:TMP_OUTPUT += Get-UcsFcErrStats | Sort-Object -Property Dn | Select-Object Dn,CrcRx,CrcRxDeltaAvg,DiscardRx,DiscardRxDeltaAvg,DiscardTx,DiscardTxDeltaAvg,LinkFailures,SignalLosses,Suspect | ConvertTo-Html -Fragment

	# Get FCoE Uplink Port Channel Stats
	AddToOutput -txt "<h2>FCoE Uplink Port Channels</h2>"
	$Global:TMP_OUTPUT += Get-UcsEtherFcoeInterfaceStats | Select-Object DN,BytesRx,BytesTx,DroppedRx,DroppedTx,ErrorsRx,ErrorsTx | ConvertTo-Html -Fragment

	AddToOutput -txt "</div>" # end subtab
	AddToOutput -txt "</div>" # end subtabs containers
	AddToOutput -txt "</div>" # end tab SAN configuration


	##########################################################################################################################################################
	##########################################################################################################################################################
	#################################################        RECOMMENDATIONS       ###########################################################################
	##########################################################################################################################################################
	##########################################################################################################################################################

	AddToOutput -txt "<div class='content' id='recommendations'>"
	AddToOutput -txt "<div id='recommendations-tabs'>"
	AddToOutput -txt "<ul>"
	AddToOutput -txt "<li><a href='#recommendations-tab'>Recommendations</a></li>"
	AddToOutput -txt "</ul>"
	AddToOutput -txt "<div class='content-sub' id='recommendations-tab'>"

	AddToOutput -txt "<h2>Recommendations</h2>"

	AddToOutput -txt "<table>"
	AddToOutput -txt "<tr><th>Recommendation</th><th>Status</th></tr>"



	# DNS servers defined?
	$recommendationText = "Are there DNS server(s) configured?"
	if($dnsServers.count -eq 0) {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}

	# NTP servers defined?
	$recommendationText = "Are there NTP server(s) configured?"
	if($ntpServers.count -eq 0) {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}

	# Telnet disabled?
	$recommendationText = "Is telnet disabled?"
	$telnet = Get-UcsTelnet
	if($telnet.AdminState -eq "enabled") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}

	# call home configured?
	$recommendationText = "Call Home configured?"
	if($callHome.AdminState -eq "off") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}

	# License check
	$licenseFabricA_Abs  = 0
	$licenseFabricB_Abs  = 0
	$licenseFabricA_Used = 0
	$licenseFabricB_Used = 0

	foreach ($lic in $ucsLicenses) {
		if($lic.Scope -eq "A") {
			$licenseFabricA_Abs += $lic.AbsQuant
			$licenseFabricA_Used += $lic.UsedQuant
		}
		if($lic.Scope -eq "B") {
			$licenseFabricB_Abs += $lic.AbsQuant
			$licenseFabricB_Used += $lic.UsedQuant
		}
	}

	$recommendationText = "Port licenses on Fabric A are sufficient?"
	if($licenseFabricA_Abs -ge $licenseFabricA_Used) {
		$licenseFabricA_Abs -= $licenseFabricA_Used
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes ($licenseFabricA_Abs left)</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}

	$recommendationText = "Port licenses on Fabric B are sufficient?"
	if($licenseFabricB_Abs -ge $licenseFabricB_Used) {
		$licenseFabricB_Abs -= $licenseFabricB_Used
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes ($licenseFabricB_Abs left)</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}

	# Discovery policy = port-channel?
	$recommendationText = "Configure server (fabric) links as port-channels"
	if($chassisDiscoveryPolicy.LinkAggregationPref -eq "port-channel") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}

	# Uplink port-channels present?
	$portchannelFabricA = "false"
	$portchannelFabricB = "false"
	$uplinkPortChannels = Get-UcsUplinkPortChannel
	foreach($pc in $uplinkPortChannels)
	{
		if($pc.SwitchId -eq "A") {
			$portchannelFabricA = "true"
		}
		if($pc.SwitchId -eq "B") {
			$portchannelFabricB = "true"
		}
	}

	$recommendationText = "Configure network uplinks as port-channels (Fabric A)"
	if($portchannelFabricA -eq "false") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}
	$recommendationText = "Configure network uplinks as port-channels (Fabric B)"
	if($portchannelFabricB -eq "false") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}

	# chassis redundancy policy
	$recommendationText = "Chassis power redundancy?"
	$chred = $chassisPowerRedPolicy.Redundancy
	if($chassisPowerRedPolicy.Redundancy -eq "non-redundant") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes ($chred)</td></tr>"
	}

	# Maintenance policy check
	$maintProfilesImmediate = [System.Collections.ArrayList]@()
	$maintProfiles = Get-UcsMaintenancePolicy | Where-Object {$_.UptimeDisr -eq "immediate"} | Select-Object Name
	foreach($prof in $maintProfiles) {
		$maintProfilesImmediate += $prof.Name
	}

	$totalSPsImmediate = 0
	$totalSPsImmediateProfiles = [System.Collections.ArrayList]@()
	$maintServiceProfiles = Get-UcsServiceProfile | Where-Object {$_.AssocState -eq "associated"} | Select-Object Rn, MaintPolicyName
	foreach($profile in $maintServiceProfiles)
	{
		if($maintProfilesImmediate -contains $profile.MaintPolicyName) {
			$totalSPsImmediate++
			$totalSPsImmediateProfiles += $profile.Rn
		}
	}
	$recommendationText = "Configure the maintenance policies to 'User Acknowledge'"
	if($totalSPsImmediate -eq 0) {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No ($totalSPsImmediateProfiles)</td></tr>"
	}

	# Check for vNIC Templates which are not updating templates
	$nonUpdatingvNICs = [System.Collections.ArrayList]@()
	$nonUpdatingFound = "false"
	foreach($vnictmpl in $vnicTemplates)
	{
		if($vnictmpl.TemplType -ne "updating-template") {
			$nonUpdatingFound = "true"
			$nonUpdatingvNICs += $vnictmpl.Name
		}
	}
	$recommendationText = "Configure vNIC templates as 'Updating'"
	if($nonUpdatingFound -eq "false") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No ($nonUpdatingvNICs)</td></tr>"
	}

	# Check for vHBA Templates which are not updating templates
	$nonUpdatingvHBAs = [System.Collections.ArrayList]@()
	$nonUpdatingFound = "false"
	foreach($vhbatmpl in $vhbaTemplates)
	{
		if($vhbatmpl.TemplType -ne "updating-template") {
			$nonUpdatingFound = "true"
			$nonUpdatingvHBAs += $vhbatmpl.Name
		}
	}
	$recommendationText = "Configure vHBA templates as 'Updating'"
	if($nonUpdatingFound -eq "false") {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: green'>Yes</td></tr>"
	}
	else {
		AddToOutput -txt "<tr><td>$recommendationText</td><td style='background-color: red'>No ($nonUpdatingvHBAs)</td></tr>"
	}


	AddToOutput -txt "</table>" # end recommendations table

	AddToOutput -txt "</div>" # end subtabs
	AddToOutput -txt "</div>" # end subtabs container
	AddToOutput -txt "</div>" # end recommendations tab


	AddToOutput -txt "</body>"
	AddToOutput -txt "</html>"
#HTML ends

#Disconnect UCS
Disconnect-UCS

WriteLog "Exporting information into $OutFile"
WriteLog "Done generating report for $($UCSM.hostname)"
$Global:TMP_OUTPUT | Out-File $OutFile
}
