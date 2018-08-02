Unit EWinDteU;


interface

Uses
  WinTypes,
  Messages,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  Forms;


Procedure SetNTShortDateFmt;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  Registry,
  SysUtils;



{ ==== Function to determine if Winnt is running ==== }

Function IS_WinNTX  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=False;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT);{ And
            (OSVerIRec.dwMajorVersion=4);}

  end;
end;


{ ==== Function to determine if Winnt is running ==== }

Procedure SetNTShortDateFmt;


Var
  CReg    :  TRegistry;

  OldSFmt,
  RegSFmt :  String;


Begin
  OldSFmt:=''; RegSFmt:='';

  If (IS_WinNTX) then
  Begin
    OldSFmt:=ShortDateFormat;

    CReg:=TRegistry.Create;

    try
      With CReg do
      Begin

        try          RootKey:=HKEY_CURRENT_USER;

          If (OpenKey('Control Panel\International',False)) then
          Begin
            RegSFmt:=ReadString('sShortDate');

            If (RegSFmt<>'') then
              ShortDateFormat:=RegSFmt;
          end;

        except
          ShortDateFormat:=OldSFmt;
        end;

      end;

    finally
      CReg.Free;

    end;
  end;
end;


Initialization


end.
