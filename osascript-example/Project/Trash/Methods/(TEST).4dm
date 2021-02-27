//%attributes = {}
$command:="/bin/sh"

$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder("scpt")
If (Not:C34($folder.exists))
	$folder.create()
End if 





SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $folder.platformPath)



LAUNCH EXTERNAL PROCESS:C811("osascript "+$posix_path; $stdIn; $stdOut_t; $stdErr)