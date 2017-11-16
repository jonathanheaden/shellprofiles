function make-jdmaillocation ($prefix, $name) {
    $map = make-jdmap
    $parent = $map[$prefix.split(".")[0]].split("\")[-1]
    Add-type -assembly "Microsoft.Office.Interop.Outlook"
    $Outlook = New-Object -comobject Outlook.Application
    $namespace = $Outlook.GetNameSpace("MAPI")
    $rootMailFolder = '10-19 ANZ'
    $inbox = $namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderInbox)
    $rootfolder = $inbox.folders | ? {$_.name -eq $rootMailFolder}
    if (!$rootfolder) {$rootfolder = $inbox.Folders.Add( $rootMailFolder)}
    $parentfolder = $rootfolder.folders | ? {$_.name -match $parent}
    if (!$parentfolder) {$parentfolder = $rootfolder.folders.Add($parent)}
    $newfolder = $parentfolder.folders | ? {$_.name -eq "$prefix $name"}
    if (!$newfolder) {$parentfolder.folders.Add("$prefix $name")}
}
