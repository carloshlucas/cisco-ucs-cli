###################################################
#                                                 #
#            CISCO INVENTORY VERSION 7            #
#            Developed by Carlos Lucas            #
#                                                 #
###################################################

# GENERATE TECH SUPPORT FOR CISCO UCS BASED ON CSV

$credential = get-credential
foreach ($ucs in Import-Csv D:\CiscoUCS\ucs-domains.csv) {
    $ucs.ip
    Connect-Ucs -Name $ucs.ip -Credential $credential
    Get-UcsTechSupport -PathPattern 'D:\CiscoUCS\${ucs.name}-techsupport.tar' -UcsManager -RemoveFromUcs -TimeoutSec 600 
    Disconnect-Ucs
}
