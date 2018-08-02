unit SetupU;

interface

Uses Classes, Dialogs, SysUtils, Windows;

type
  TDLLSetupPtr = ^TDLLSetupType;
  TDLLSetupType = Record
    suMode   : Byte;                   { Mode. 1=Setup Button, 2=Installing, 3=Removing }
    suEntDir : String[255];            { Enterprise Directory }

    suSpare  : Array [1..767] Of Char; { For Future use }
  End; { TDLLSetupType }

Procedure SetupDialog(Const SetupInfo : TDLLSetupPtr); Export;

implementation

Uses ChainU;


{ Procedure is called by the customisation Setup program at various points }
Procedure SetupDialog(Const SetupInfo : TDLLSetupPtr);
Begin
  ShowMessage (DLLChain.ModuleName + '.SetupDialog ' + IntToStr(SetupInfo^.suMode) + #10#13#10#13 +
               'I''m in ' + SetupInfo^.suEntDir + ', come and get me!');
End;

end.
