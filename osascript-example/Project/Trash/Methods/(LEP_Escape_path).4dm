//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1; $0; $path)

If (Count parameters:C259#0)
	
	$path:=$1
	
	Case of 
		: (Is Windows:C1573)
			
			$path:=LEP_Escape($path)
			
		: (Is macOS:C1572)
			
			$path:=LEP_Escape(Convert path system to POSIX:C1106($path))
			
	End case 
	
End if 

$0:=$path