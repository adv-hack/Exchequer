program formdes;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  D6OnHelpFix,
  conHTMLHelp,
  Dialogs,
  Forms,
  SysUtils,
  Windows,
  formdesn in 'formdesn.pas' {Form_Designer},
  pageoptn in 'pageoptn.pas' {Form_PageOptions},
  boxopt in 'boxopt.pas' {Form_BoxOptions},
  lineopt in 'lineopt.pas' {Form_LineOptions},
  pagnoopt in 'pagnoopt.pas' {Form_PageNoOptions},
  DLLInt in 'DLLInt.pas',
  Globtype in 'Globtype.pas',
  formutil in 'formutil.pas',
  gridopt in 'gridopt.pas' {Form_GridOptions},
  tablfunc in 'tablfunc.pas',
  sbsfuncs in 'sbsfuncs.pas',
  restore in 'Restore.pas' {Form_Restore},
  Zorder2 in 'Zorder2.pas' {Form_ZOrder},
  Techsupp in 'Techsupp.pas' {Form_TechSupp},
  textopt in 'Textopt.pas' {Form_TextOptions},
  mru in 'mru.pas',
  History in 'HISTORY.PAS',
  EntLicence in 'X:\ENTRPRSE\DRILLDN\EntLicence.pas';

{$R *.RES}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

{$I SecCode.Pas}


  Function CheckParamCode : Boolean;
  Var
    I         : SmallInt;
  Begin
    Result := False;

    If (ParamCount > 0) Then
      For I := 1 To ParamCount Do Begin
        If (Not Result) Then
          Result := (UpperCase(Trim(ParamStr(I))) = FDesStartCode);
      End; { For }
  End;

begin
  If CheckParamCode Then Begin
    Application.Initialize;
    Application.Title := 'Form Designer - Exchequer';
  Application.HelpFile := 'formdes.chm';
  Application.CreateForm(TForm_Designer, Form_Designer);
  Application.Run;
  End { If }
  Else Begin
    MessageDlg ('Exchequer Form Designer ' + FormDesVer +
                 #10#13#10#13 +
                 'This program can only be run from inside Exchequer - Program Aborted.', mtError, [mbOk], 0);
    Halt;
  End; { Else }
end.
