unit EntInitU;

{ markd6 14:23 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Forms, Dialogs, SysUtils;

Procedure InitCompany (ExeDir, DataDir : String; WantMainSec : Boolean);

implementation

Uses BtrvU2, GlobVar, VarConst, EntRegU;

Procedure InitCompany (ExeDir, DataDir : String; WantMainSec : Boolean);

  { Gets the security and user information from the main system }
  Procedure GetMainSecurity;
  Begin
    { Set Data Path }
    SetDrive := ExeDir;

    { Open System File }
    Status := Open_File(F[SysF], FileNames[SysF], 0);

    If StatusOk Then Begin
      { Get security and User info }


      { Close system file }
      Close_File(F[SysF]);
    End; { If }
  End;

Begin
  ShowMessage ('InitCompany');

  If Check4BtrvOk Then Begin
    { Get existing security from main company }
    If WantMainSec Then
      GetMainSecurity;

    { Set Data Path }
    SetDrive := SystemDir;

    { Open files }





    { Close files }

    { Stop Btrieve }
    Stop_B;
  End; { If }
End;


end.
