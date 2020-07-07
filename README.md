# aws-vpc-utilities

## Create-EC2SGRules
##### Background
AWS provides [documentation on using the AWS Tools for Powershell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-ec2-sg.html), which these functions require. These functions were created because the current method AWS provides doesn't feel as friendly or as scalable as it could be. The `Create-EC2SGRules` function is most useful when creating multiple port rules for the same CIDR block.

The `Create-EC2SGRules` function isn't perfect either. In order to create tcp and udp rules, the function must be run twice; once for each protocol. The same limitation applies to creating security group entries for different CIDR blocks.

##### Examples
```
Create-EC2SGRules -Protocol tcp -PortList 666,123,445 -CidrBlock 192.0.2.26/32 -CidrBlockDescription TestRule -GroupId sg-xxxxxxxx
Create-EC2SGRules -Protocol tcp -PortRangeStart 49152 -PortRangeEnd 65535 -CidrBlock 192.0.2.0/24 -CidrBlockDescription TestRule -GroupId sg-xxxxxxxx
```

You can use the AWS PowerShell cmdlet `New-EC2SecurityGroup` to create a new security group, and save the output in a variable for use in `Create-EC2SGRules` in place of GroupId.
```
$SecurityGroup = New-EC2SecurityGroup -Description "Amazon FSx Security Group for vpc-xxxxxxxx" -GroupName "FSx-vpc-xxxxxxxx"
Create-EC2SGRules -Protocol tcp -PortRangeStart 49152 -PortRangeEnd 65535 -CidrBlock 192.0.2.0/24 -CidrBlockDescription TestRule -GroupId $SecurityGroup
```

You may also be interested in this handy one-liner to grab your own public IPv4 address as seen by AWS.
```
[System.Text.Encoding]::ASCII.GetString((Invoke-WebRequest "https://checkip.amazonaws.com" | Select-Object -ExpandProperty Content)).Trim()
```

## Show-EC2SGRules
##### Background
The AWS-provided `Get-EC2SecurityGroup` cmdlet has nested output, which is not easily consumed. The `Show-EC2SGRules` function aims to make visible the most important details of a security group -- the rules themselves.

##### Examples
```
Show-EC2SGRules -GroupId sg-xxxxxxxx | Format-Table
```
##### Expected output
```
PS C:\> Show-EC2SGRules -GroupId sg-06057dcf34302a37e | Format-Table

IpProtocol FromPort ToPort Ipv4CidrIp Ipv4CidrDescription Ipv6CidrIp Ipv6CidrDescription
---------- -------- ------ ---------- ------------------- ---------- -------------------
tcp              80     80 0.0.0.0/0                      ::/0
tcp             443    443 0.0.0.0/0                      ::/0
```
