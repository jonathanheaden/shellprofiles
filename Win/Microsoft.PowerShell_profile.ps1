$host.PrivateData.ErrorForegroundColor = "Green"
$host.PrivateData.ErrorBackgroundColor = "DarkMagenta"

function prompt {
(get-location).path.split("\")[-1] + ":>"
}

function show-structure {
$rootdrive = "C:\Users\jonathanh\Documents\"
pushd $rootdrive
gci |? {$_.psiscontainer }| ? {$_.name -match "^\d{2}\-\d{2}"} | % {"";$_.name; ("=" * $_.name.length)
gci $_.fullname |% {"";$_.name; ("-" * $_.name.length);gci $_.fullname |% {$_.name}}}
popd
}

Function make-jdmap {
    $jdmap = @{}
    $jdtopregex =  "^\d\d\-\d\d"
    $jdregex =  "(?<jdnumber>^\d\d\.\d\d)"
    $rootdrive = "C:\Users\jonathanh\Documents\"
    $topfolders = Get-ChildItem  $rootDrive |? {$_ -match $jdtopregex}
    foreach ($folder in $topfolders) {
	get-childitem $folder.fullname |% {
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

Function cjd ([string]$jdref) {
    $jdmap = make-jdmap
    push-location $jdmap[$jdref]
}

