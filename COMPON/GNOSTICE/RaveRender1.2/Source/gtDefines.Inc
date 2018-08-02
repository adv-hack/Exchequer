{**************************************************************************}
{                                                           		   }
{  Determining compiler version                             		   }
{                                                           		   }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited }
{  http://www.gnostice.com                                  		   }
{                                                           		   }
{**************************************************************************}

{$IFDEF VER100}				// Delphi 3 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi3}
	{$DEFINE gtDelphi3Up}
{$ENDIF}

{$IFDEF VER110}				// C++ Builder 3 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtCBuilder3}
	{$DEFINE gtCBuilder3Up}
	{$ObjExportAll On}
{$ENDIF}

{$IFDEF VER120}				// Delphi 4 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi4}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
{$ENDIF}

{$IFDEF VER125}				// C++ Builder 4 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
	{$DEFINE gtCBuilder4}
	{$DEFINE gtCBuilder3Up}
	{$DEFINE gtCBuilder4Up}
	{$ObjExportAll On}
{$ENDIF}

{$IFDEF VER130}				// Delphi 5/C++ Builder 5 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
	{$DEFINE gtDelphi5Up}
	{$IFDEF BCB}				// C++ Builder 5 and up
		{$DEFINE gtCBuilder5}
		{$DEFINE gtCBuilder3Up}
		{$DEFINE gtCBuilder4Up}
		{$DEFINE gtCBuilder5Up}
		{$ObjExportAll On}
	{$ELSE}					// Delphi 5
		{$DEFINE gtDelphi5}
	{$ENDIF}
{$ENDIF}

{$IFDEF VER140}				// Delphi 6 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi6}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
	{$DEFINE gtDelphi5Up}
	{$DEFINE gtDelphi6Up}
	{$IFDEF BCB}				// C++ Builder 6 and up
  	{$DEFINE gtCBuilder6}
		{$DEFINE gtCBuilder3Up}
		{$DEFINE gtCBuilder4Up}
		{$DEFINE gtCBuilder5Up}
		{$DEFINE gtCBuilder6Up}
		{$ObjExportAll On}
	{$ELSE}					// Delphi 6
		{$DEFINE gtDelphi6}
	{$ENDIF}
{$ENDIF}

{$IFDEF VER150}				// Delphi 7 and up
	{$DEFINE gtCF}
	{$DEFINE gtDelphi7}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
	{$DEFINE gtDelphi5Up}
	{$DEFINE gtDelphi6Up}
	{$DEFINE gtDelphi7Up}
{$ENDIF}

// If none of the above assume to be Delphi 7 or later
{$IFNDEF gtCF}
	{$DEFINE gtDelphi3Up}
	{$DEFINE gtDelphi4Up}
	{$DEFINE gtDelphi5Up}
	{$DEFINE gtDelphi6Up}
	{$DEFINE gtDelphi7Up}
{$ENDIF}

// Switch determines whether Registered or Trial Version
{$DEFINE Registered}


