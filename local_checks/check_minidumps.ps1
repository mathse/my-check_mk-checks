$files = Get-ChildItem 'c:\windows\Minidump' | Sort-Object  CreationTime -Descending
if($files.count -gt 0) {
    "2 Minidumps count=$($files.count) CRIT - $($files.count) Minidumps found - last: $($files[0].CreationTime)"
} else {
    "0 Minidumps count=$($files.count) OK - no Minidumps found"
}
