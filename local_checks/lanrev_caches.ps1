# this check checks various cahces in sqlite databases of a lanrev server installation

$databasepath = "C:\Programdata\Pole Position Software\LANrev Server\"
$databases = @("servercommanddatabase.db","SDCaches.db","NotificationQueue.db","AgentRequestCache.db")

#resize window
$pshost = get-host
$pswindow = $pshost.ui.rawui

$newsize = $pswindow.buffersize
$newsize.height = 300
$newsize.width = 350
$pswindow.buffersize = $newsize

#Import the module, create a data source and a table
# https://github.com/RamblingCookieMonster/PSSQLite
Import-Module PSSQLite


$databases | %{ 
	$database = $_
		
	$tables = "SELECT name FROM sqlite_master WHERE type='table';"
	#SQLite will create Names.SQLite for us
	Invoke-SqliteQuery -Query $tables -DataSource "$databasepath$database" | %{
		$table = $_.name
		#$count = "SELECT count(*) FROM $table;"
		$count = (Invoke-SqliteQuery -Query "SELECT count(*) as count FROM $table;" -DataSource "$databasepath$database").count
		"0 lanrev_$table cached=$count OK $count items in $table queue/cache"
	}
}
