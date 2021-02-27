//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($1; $params)
C_TEXT:C284($AppleScript_t)

$params:=$1

$OutLookMac_Wait:=$params._OutLookMac_Wait
$DeleteTempfiles:=$params._DeleteTempfiles

ARRAY OBJECT:C1221($Mail_SendToAddress; 0)
ARRAY OBJECT:C1221($Mail_CcAddress; 0)
ARRAY OBJECT:C1221($Mail_BccAddress; 0)
ARRAY TEXT:C222($Mail_AttachmentPath; 0)

COLLECTION TO ARRAY:C1562($params.Mail_SendToAddress; $Mail_SendToAddress)
COLLECTION TO ARRAY:C1562($params.Mail_CcAddress; $Mail_CcAddress)
COLLECTION TO ARRAY:C1562($params.Mail_BccAddress; $Mail_BccAddress)
COLLECTION TO ARRAY:C1562($params.Mail_AttachmentPath; $Mail_AttachmentPath)

$AppleScript_t:=""
$AppleScript_t:=$AppleScript_t+"With timeout of 60 seconds"+Char:C90(Line feed:K15:40)
$AppleScript_t:=$AppleScript_t+"tell application \"Microsoft Outlook\""+Char:C90(Line feed:K15:40)


If ($OutLookMac_Wait)
	$AppleScript_t:=$AppleScript_t+"tell drafts"+Char:C90(Line feed:K15:40)
End if 

If ($params.sender#Null:C1517)
	// build the sender to adress the outlook account to use
	$vt_Sender:="sender:{name:\""+$params.sender.name+"\", address:\""+$params.sender.address+"\"}, "
Else 
	$vt_Sender:=""
End if 

$contentFile:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".temp")
$contentFile.setText($params.message.body; "utf-16le")

$AppleScript_t:=$AppleScript_t+"set theContent to read file \""+$contentFile.platformPath+"\" as Unicode text"+Char:C90(Line feed:K15:40)
$AppleScript_t:=$AppleScript_t+"set theMessage to make new outgoing message with properties {"+$vt_Sender+"subject:\""+$params.message.subject+"\", content:theContent}"+Char:C90(Line feed:K15:40)

If ($OutLookMac_Wait)  // if option set to hold in drafts
	$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
End if 

//Send To
For ($i; 1; Size of array:C274($Mail_SendToAddress))
	$AppleScript_t:=$AppleScript_t+"tell theMessage"+Char:C90(Line feed:K15:40)
	$AppleScript_t:=$AppleScript_t+"make new to recipient with properties "
	$AppleScript_t:=$AppleScript_t+"{email address:{name:\""+$Mail_SendToAddress{$i}.name+"\", address:\""+$Mail_SendToAddress{$i}.address+"\"}}"+Char:C90(Line feed:K15:40)
	$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
End for 

//Carbon Copy To
If (Size of array:C274($Mail_CcAddress)>0)
	For ($i; 1; Size of array:C274($Mail_CcAddress))
		$AppleScript_t:=$AppleScript_t+"tell theMessage"+Char:C90(Line feed:K15:40)
		$AppleScript_t:=$AppleScript_t+"make new cc recipient with properties "
		$AppleScript_t:=$AppleScript_t+"{email address:{name:\""+$Mail_CcAddress{$i}.name+"\", address:\""+$Mail_CcAddress{$i}.address+"\"}}"+Char:C90(Line feed:K15:40)
		$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
	End for 
End if 

//Blind Carbon Copy To
If (Size of array:C274($Mail_BccAddress)>0)
	For ($i; 1; Size of array:C274($Mail_BccAddress))
		$AppleScript_t:=$AppleScript_t+"tell theMessage"+Char:C90(Line feed:K15:40)
		$AppleScript_t:=$AppleScript_t+"make new bcc recipient with properties "
		$AppleScript_t:=$AppleScript_t+"{email address:{name:\""+$Mail_BccAddress{$i}.name+"\", address:\""+$Mail_BccAddress{$i}.address+"\"}}"+Char:C90(Line feed:K15:40)
		$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
	End for 
End if 

For ($i; 1; Size of array:C274($Mail_AttachmentPath))
	$AppleScript_t:=$AppleScript_t+"set theAttachment to POSIX path of file \""+$Mail_AttachmentPath{$i}+"\" as POSIX file"+Char:C90(Line feed:K15:40)
	$AppleScript_t:=$AppleScript_t+"tell theMessage"+Char:C90(Line feed:K15:40)
	$AppleScript_t:=$AppleScript_t+"make new attachment with properties"
	$AppleScript_t:=$AppleScript_t+"{file:theAttachment}"+Char:C90(Line feed:K15:40)
	$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
End for 

//send the message or hold in drafts
If (True:C214)
	If ($OutLookMac_Wait)
		$AppleScript_t:=$AppleScript_t+"save"+Char:C90(Line feed:K15:40)
	Else 
		$AppleScript_t:=$AppleScript_t+"send theMessage"+Char:C90(Line feed:K15:40)
	End if 
End if 

$AppleScript_t:=$AppleScript_t+"end tell"+Char:C90(Line feed:K15:40)
$AppleScript_t:=$AppleScript_t+"end timeout"

$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder("scpt")
$tempFolder.create()

$tempFile:=$tempFolder.file(Generate UUID:C1066+".scpt")
$tempFile.setText($AppleScript_t)

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $tempFile.parent.platformPath)
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
LAUNCH EXTERNAL PROCESS:C811("chmod 555 "+$tempFile.name+$tempFile.extension)

$command:="osascript "+$tempFile.name+$tempFile.extension

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $tempFile.parent.platformPath)
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")

C_BLOB:C604($stdIn; $stdOut; $stdErr)
LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr)

If ($DeleteTempfiles)
	
	//cleanup
	$contentFile.delete()
	$tempFile.delete()
	
End if 