#AccessRights  AvailableLicenses  Description  ExpirationDate             IssuedLicenses  KeyPackId  KeyPackType  ProductType  ProductVersion                                 ProductVersionID  TotalLicenses  TypeAndModel                
#7             4294967295         A02-5.00-EX  20351231230000.000000-000  0               2          6            3            Windows 2000 Server                            0                 4294967295     Built-in TS Per Device CAL  
#7             20                 C50-6.00-S   20380101010000.000000-000  0               3          2            1            Windows Server 2008 or Windows Server 2008 R2  2                 20             TS or RDS Per User CAL      
#7             9                  C50-6.02-S   20380101010000.000000-000  11              4          2            1            Windows Server 2012                            4                 20             RDS Per User CAL            
#7             0                  C50-6.02-S   20380119031407.000000-000  0               10         7            1            Windows Server 2012                            4                 0              RDS Per User CAL            

foreach($lic in $(get-wmiobject -query "select * from Win32_TSLicenseKeyPack where TotalLicenses != 0")) {
	if($lic.AvailableLicenses -lt 3) {
		$status = 'CRIT'
		$exit = 2
	} else {
		$status = 'OK'
		$exit = 0
	}
	"$exit TSLicense_$($lic.Description) count=$($lic.IssuedLicenses);$($lic.TotalLicenses-3);$($lic.TotalLicenses);; $status - $($lic.IssuedLicenses) of $($lic.TotalLicenses) connections in use ($($lic.TypeAndModel))"	
}
