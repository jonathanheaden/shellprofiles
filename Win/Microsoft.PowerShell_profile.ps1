$host.PrivateData.ErrorForegroundColor = "Green"
$host.PrivateData.ErrorBackgroundColor = "DarkMagenta"

new-alias sjd show-structure
new-alias lsjd list-jdstructure
new-alias cjd set-jdlocation
new-alias fjd find-jdref
new-alias mjd make-jdlocation

function prompt {
(get-location).path.split("\")[-1] + ":>"
}

function show-structure {
$rootdrive = "C:\Users\jonathanh\Documents\"
pushd $rootdrive
get-childitem |? {$_.psiscontainer }| ? {$_.name -match "^\d{2}\-\d{2}"} | % {"";$_.name; ("=" * $_.name.length)
get-childitem $_.fullname |% {
	"`n$($_.name)" 
	("-" * $_.name.length)
	gci $_.fullname |% {$_.name}}
	}
popd
}

function show-structure ($branchnum){
push-location $rootdrive
    get-childitem |? {$_.psiscontainer }| ? {$_.name -match "^\d{2}\-\d{2}"} | % {
	"";$_.name; ("=" * $_.name.length)
	get-childitem $_.fullname | ? {$_.name -match "^$branchnum"} |% {
        ""
        $_.name 
        ("-" * $_.name.length)
        (get-childitem $_.fullname |% {$_.name}| sort-object)
        } 
    }    
pop-location
}

function find-jdref ($stringToFind){
    $map = make-jdmap
    $map.keys | ? {$map[$_].split("\")[-1] -match "$stringToFind"} | % { 
        write-host -ForegroundColor darkgreen $_ -nonewline;
        write-host " $($map[$_].split("\")[-1])"
    }
}
    
function list-jdstructure ($param) {
    if ($param -match "^\d{2}$") { 
        show-structure $param
        break
    }
    cjd $param
    get-childitem
    pop-location
}

Function make-jdmap {
    $jdmap = @{}
    $jdtopregex =  "^\d\d\-\d\d"
    $jdregex =  "(?<jdnumber>^\d\d\.\d\d)"
    $topfolders = Get-ChildItem  $rootDrive |? {$_ -match $jdtopregex}
    foreach ($folder in $topfolders) {
	get-childitem $folder.fullname |% {
        $jdmap[$_.name.split()[0]] = $_.fullname
	    get-childitem  $_.fullname |% {
		if ($_.name -match $jdregex) {
		    $jdindex = $matches.jdnumber
		    $jdmap[$jdindex] = $_.fullname
		}
	    }
	}
    }
    return $jdmap
}

Function show-jdbranches {
    $jdtopregex =  "^\d\d\-\d\d" 
     $topfolders = Get-ChildItem  $rootDrive |? {$_ -match $jdtopregex}
     foreach ($folder in $topfolders) { 
         get-childitem $folder.fullname |% { $_.name }
         }
    }

Function make-jdlocation ($parent) {
    while (($parent -notmatch "^\d{2}$") -or (((make-jdmap).keys -match "^$parent").count -eq 0)) { 
        Write-host -foregroundcolor Green 'The following branches exist'
        show-jdbranches 
        $parent = read-host "Enter Two Digit Parent Folder"
        }
    $node = 1 + (($(make-jdmap).keys | ? {$_ -match "^$parent"} | sort -desc)[0].split(".")[1])
    $prefix = "$parent.$($node.tostring().padleft(2,'0'))"  
    $name = read-host "Folder name"
    set-jdlocation $parent
    New-Item "$prefix $name" -type directory
    set-jdlocation $prefix
    make-jdmaillocation $prefix $name
}

function make-jdmaillocation ($prefix, $name) {
    $rootMailFolder = '10-19 ANZ'
    $map = make-jdmap
    $parent = $map[$prefix.split(".")[0]].split("\")[-1]
    Add-type -assembly "Microsoft.Office.Interop.Outlook"
    $Outlook = New-Object -comobject Outlook.Application
    $namespace = $Outlook.GetNameSpace("MAPI")    
    $inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
    $rootfolder = $inbox.folders | ? {$_.name -eq $rootMailFolder}
    if (!$rootfolder) {$rootfolder = $inbox.Folders.Add( $rootMailFolder)}
    $parentfolder = $rootfolder.folders | ? {$_.name -match $parent}
    if (!$parentfolder) {$parentfolder = $rootfolder.folders.Add($parent)}
    $newfolder = $parentfolder.folders | ? {$_.name -eq "$prefix $name"}
    if (!$newfolder) {$parentfolder.folders.Add("$prefix $name")}
}

Function set-jdlocation ([string]$jdref) {
    push-location $(make-jdmap)[$jdref]
    $now = get-date
    add-content "$rootdrive\_meta\activity.txt" ("[" + $now.tostring() + "] $jdref")
}


