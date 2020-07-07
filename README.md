# aws-vpc-utilities

## Create-EC2SGRules
Examples:
```
Create-EC2SGRules -Protocol tcp -PortList 666,123,445 -CidrBlock 192.0.2.26/32 -CidrBlockDescription TestRule -GroupId sg-xxxxxxx
Create-EC2SGRules -Protocol tcp -PortRangeStart 49152 -PortRangeEnd 65535 -CidrBlock 192.0.2.0/24 -CidrBlockDescription TestRule -GroupId sg-xxxxxxx
```

## Show-EC2SGRules
Examples
```
Show-EC2SGRules -GroupId sg-xxxxxxx | Format-Table
```
