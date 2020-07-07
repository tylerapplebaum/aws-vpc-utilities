Function Show-EC2SGRules {
[CmdletBinding()] 
Param(   
    [Parameter(Mandatory=$True,HelpMessage="Specify the AWS security group ID")]
    [ValidateNotNullOrEmpty()]    
    $GroupId
)
$SecurityGroupIpPermissions = (Get-EC2SecurityGroup -GroupId $GroupId).IpPermissions
$SecurityGroupOutput = New-Object System.Collections.ArrayList
    ForEach ($Entry in $SecurityGroupIpPermissions) {
        $OutputProperties = [ordered]@{
            "IpProtocol" = $Entry.IpProtocol
            "FromPort" = $Entry.FromPort
            "ToPort" = $Entry.ToPort
            "Ipv4CidrIp" = $Entry.Ipv4Ranges.CidrIp
            "Ipv4CidrDescription" = $Entry.Ipv4Ranges.Description
            "Ipv6CidrIp" = $Entry.Ipv6Ranges.CidrIpv6
            "Ipv6CidrDescription" = $Entry.Ipv6Ranges.Description
        }
        $SecurityGroupObject = New-Object PSObject -Property $OutputProperties
        [void]$SecurityGroupOutput.Add($SecurityGroupObject)
    }
Return $SecurityGroupOutput
}
