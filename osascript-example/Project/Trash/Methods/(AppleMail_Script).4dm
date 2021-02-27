//%attributes = {}
C_POINTER:C301($1)
If (Folder separator:K24:12=":")
	If (Count parameters:C259=1)
		If (Not:C34(Is nil pointer:C315($1)))
			C_BLOB:C604($AppleScript_x)
			Case of 
				: (Type:C295($1->)=Is text:K8:3)
					TEXT TO BLOB:C554($1->; $AppleScript_x; UTF8 text without length:K22:17)  //Mac text without length)
				: (Type:C295($1->)=Is BLOB:K8:12)
					$AppleScript_x:=$1->
			End case 
			If (BLOB size:C605($AppleScript_x)#0)
				If (True:C214)  //(Not(Semaphore(Current method name)))
					$file:=String:C10(Milliseconds:C459)+".scpt"
					$AppleScriptPath_t:=Temporary folder:C486+$file
					BLOB TO DOCUMENT:C526($AppleScriptPath_t; $AppleScript_x)
					
					If (Test path name:C476($AppleScriptPath_t)=Is a document:K24:1)
						//copy document($AppleScriptPath_t;get 4d folder(Current Resources Folder)+$file)
						$AppleScriptPath_t:=Replace string:C233($AppleScriptPath_t; ":"; "/")
						$systemFolder_t:=System folder:C487(System:K41:1)
						$CurrentVolume_t:=Substring:C12($systemFolder_t; 1; Position:C15(":"; $systemFolder_t)-1)
						$TargetVolume_t:=Substring:C12($AppleScriptPath_t; 1; Position:C15("/"; $AppleScriptPath_t)-1)
						
						If ($CurrentVolume_t=$TargetVolume_t)  //Is Macintosh HD
							$AppleScriptPath_t:=Substring:C12($AppleScriptPath_t; Position:C15("/"; $AppleScriptPath_t))
						Else 
							$AppleScriptPath_t:="/Volumes/"+$AppleScriptPath_t
						End if 
						
						$AppleScriptPath_t:=Replace string:C233($AppleScriptPath_t; " "; "\\ ")
						
						C_TEXT:C284($stdIn; $stdErr)
						Case of 
							: (Type:C295($1->)=Is text:K8:3)
								C_TEXT:C284($stdOut_t)
								//LAUNCH EXTERNAL PROCESS("osascript "+$AppleScriptPath_t;$stdIn;$stdOut_t;$stdErr)
								// test to use the Keisuke Miyako suggestion, but no success
								LAUNCH EXTERNAL PROCESS:C811("osacompile -o "+Replace string:C233($AppleScriptPath_t; "scpt"; "app")+" "+$AppleScriptPath_t; $stdIn; $stdOut_t; $stdErr)
								LAUNCH EXTERNAL PROCESS:C811("osascript "+Replace string:C233($AppleScriptPath_t; "scpt"; "app"); $stdIn; $stdOut_t; $stdErr)
								If ($stdErr#"")
									SET WINDOW TITLE:C213($stdErr)
									//vT_MsgBody:=$stdErr
								End if 
								$1->:=$stdOut_t
							: (Type:C295($1->)=Is BLOB:K8:12)
								C_BLOB:C604($stdOut_x)
								LAUNCH EXTERNAL PROCESS:C811("osascript "+$AppleScriptPath_t; $stdIn; $stdOut_x; $stdErr)
								$1->:=$stdOut_x
						End case 
						$0:=$stdErr
					End if 
					//CLEAR SEMAPHORE(Current method name)
				End if 
			End if 
		End if 
	End if 
End if 
