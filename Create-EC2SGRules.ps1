Function Create-EC2SGRules {
[CmdletBinding(DefaultParameterSetName = 'List')]
Param(   
    [Parameter(HelpMessage="Specify a protocol")]
    [ValidateSet('icmp','udp','tcp')]
    [ValidateNotNullOrEmpty()]
    $Protocol,
    
    [Parameter(ParameterSetName = 'List', HelpMessage="Specify the port(s) in the form of 22,3389,676")]
    [ValidateRange(1,65535)]
    [ValidateNotNullOrEmpty()]
    $PortList = @(),
    
    [Parameter(ParameterSetName = 'Range', HelpMessage="Specify the beginning of the port range")]
    [ValidateRange(1,65535)]
    [ValidateNotNullOrEmpty()]
    $PortRangeStart,
    
    [Parameter(ParameterSetName = 'Range', HelpMessage="Specify the inclusive end of the port range")]
    [ValidateRange(1,65535)]
    [ValidateNotNullOrEmpty()]
    $PortRangeEnd,
    
    [Parameter(HelpMessage="Specify the IPv4 CIDR block in the form of 192.0.2.0/24")]
    [ValidateNotNullOrEmpty()]
    $CidrBlock,
    
    [Parameter(HelpMessage="Specify a description for the CIDR block")]
    $CidrBlockDescription,
    
    [Parameter(Mandatory=$True,HelpMessage="Specify the AWS security group ID")]
    [ValidateNotNullOrEmpty()]    
    $GroupId
)

$RuleList = New-Object System.Collections.ArrayList

If (!(Get-Module AWSPowerShell)) {
    Import-Module AWSPowerShell 4>$Null
}

If ($PortList){
    ForEach ($Port in $PortList) {
        $IPRange = New-Object -TypeName Amazon.EC2.Model.IpRange
        $IPRange.CidrIp = $CidrBlock
        $IPRange.Description = $CidrBlockDescription
        $Rule = New-Object Amazon.EC2.Model.IpPermission 
        $Rule.IpProtocol = $Protocol 
        $Rule.FromPort = $Port #This is the beginning of the port range, not source port.
        $Rule.ToPort = $Port
        $Rule.IPv4Ranges = $IPRange
        [void]$RuleList.Add($Rule)
    }
}
Else {
    $IPRange = New-Object -TypeName Amazon.EC2.Model.IpRange
    $IPRange.CidrIp = $CidrBlock
    $IPRange.Description = $CidrBlockDescription
    $Rule = New-Object Amazon.EC2.Model.IpPermission 
    $Rule.IpProtocol = $Protocol 
    $Rule.FromPort = $PortRangeStart #This is the beginning of the port range, not source port.
    $Rule.ToPort = $PortRangeEnd
    $Rule.IPv4Ranges = $IPRange
    [void]$RuleList.Add($Rule)
}

Grant-EC2SecurityGroupIngress -GroupId $GroupId -IpPermissions $RuleList
} #End Create-EC2SGRules
