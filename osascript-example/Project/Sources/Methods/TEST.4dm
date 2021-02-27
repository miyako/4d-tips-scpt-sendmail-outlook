//%attributes = {"invisible":true}
/* 

legacy arguments, implicit parameters

*/



vT_userMail:="keisuke.miyako@4D.com"  // email address
xMANachname:="宮古"  // sender last name
<>User:=xMANachname
$OutLookMac_Wait:=False:C215  // option to hold in drafts
$Mail_Subject:="テストだよ"
$Mail_Body:="あああ😷"

ARRAY OBJECT:C1221($Mail_SendToAddress; 1)
ARRAY OBJECT:C1221($Mail_CcAddress; 1)
ARRAY OBJECT:C1221($Mail_BccAddress; 1)
ARRAY TEXT:C222($Mail_AttachmentPath; 1)

$Mail_SendToAddress{1}:=New object:C1471("name"; "宮古"; "address"; "keisuke.miyako@4D.com")
$Mail_CcAddress{1}:=New object:C1471("name"; "宮古"; "address"; "keisuke.miyako@4D.com")
$Mail_BccAddress{1}:=New object:C1471("name"; "宮古"; "address"; "keisuke.miyako@4D.com")
$Mail_AttachmentPath{1}:=File:C1566("/RESOURCES/492X0W.png").platformPath

/* 

parameter mapping

*/

$params:=New object:C1471("message"; New object:C1471)
$params.message.subject:=$Mail_Subject
$params.message.body:=$Mail_Body

If (True:C214)
	//with sender
	$params.sender:=New object:C1471("name"; xMANachname; "address"; vT_userMail)
Else 
	//without sender
	$params.sender:=New object:C1471("address"; "illegal")
End if 

If ($params.sender#Null:C1517)
	If ($params.sender.name=Null:C1517)
		$params.sender.name:=<>User
	End if 
	If (Position:C15("@"; $params.sender.address; *)=0)
		$params.sender:=Null:C1517
	End if 
End if 

$params._OutLookMac_Wait:=$OutLookMac_Wait
$params._DeleteTempfiles:=True:C214

$params.Mail_SendToAddress:=New collection:C1472
$params.Mail_CcAddress:=New collection:C1472
$params.Mail_BccAddress:=New collection:C1472
$params.Mail_AttachmentPath:=New collection:C1472

ARRAY TO COLLECTION:C1563($params.Mail_SendToAddress; $Mail_SendToAddress)
ARRAY TO COLLECTION:C1563($params.Mail_CcAddress; $Mail_CcAddress)
ARRAY TO COLLECTION:C1563($params.Mail_BccAddress; $Mail_BccAddress)
ARRAY TO COLLECTION:C1563($params.Mail_AttachmentPath; $Mail_AttachmentPath)

scpt_sendmail_outlook($params)
