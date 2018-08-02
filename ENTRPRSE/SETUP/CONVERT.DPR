program Convert;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Dialogs,
  Filectrl,
  Forms,
  ShellAPI,
  SysUtils,
  windows,
  SetupBas in 'Setupbas.pas' {SetupTemplate},
  Convf in 'Convf.pas' {frmWelcome},
  ConvDirF in 'ConvDirF.pas' {frmConvertDir},
  CompUtil in '\ENTRPRSE\MULTCOMP\Computil.pas',
  ConvRead in 'ConvRead.pas' {frmReady},
  tReg2 in '\ENTRPRSE\MULTCOMP\Treg2.pas';

{$R *.RES}


Procedure ConvertWizard;
Var
  frmWelcome    : TfrmWelcome;
  frmConvertDir : TfrmConvertDir;
  frmReady      : TfrmReady;
  Cancel, Done  : Boolean;
  DlgIdx        : Byte;
  DataPath      : String;

  Drive             : Char;
  DirPart, FilePart : string;

  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  Res                         : LongInt;
Begin { ConvertWizard }
  Cancel := False;
  Done   := False;

  frmWelcome    := Nil;
  frmConvertDir := Nil;
  frmReady      := Nil;

  DlgIdx := 1;
  Repeat
     Case DlgIdx Of
       1 : Begin
             If Not Assigned(frmWelcome) Then Begin
               frmWelcome := TfrmWelcome.Create(Application);
             End; { If }

             With frmWelcome Do Begin
               ShowModal;

               Case ExitCode Of
                 'B'  : ;
                 'N'  : DlgIdx := 2;

                 'X'  : Cancel := True;
                 '?'  : Cancel := True;
               End; { Case }
             End; { With frmWelcome }
           End;

       2 : Begin
             If Not Assigned(frmConvertDir) Then Begin
               frmConvertDir := TfrmConvertDir.Create(Application);
             End; { If }

             With frmConvertDir Do Begin
               ShowModal;

               Case ExitCode Of
                 'B'  : DlgIdx := 1;
                 'N'  : DlgIdx := 3;

                 'X'  : Cancel := True;
                 '?'  : Cancel := True;
               End; { Case }
             End; { With frmConvertDir }
           End;

       3 : Begin
             If Not Assigned(frmReady) Then Begin
               frmReady := TfrmReady.Create(Application);
             End; { If }

             With frmReady Do Begin
               lblCnvDir.Caption := frmConvertDir.DirectoryListBox1.Directory;

               ShowModal;

               Case ExitCode Of
                 'B'  : DlgIdx := 2;
                 'N'  : Done := True;

                 'X'  : Cancel := True;
                 '?'  : Cancel := True;
               End; { Case }
             End; { With frmConvertDir }
           End;
    Else
      DlgIdx := 1;
    End; { case }
  Until Cancel Or Done;

  If Done Then Begin
    { Establish MS-DOS 8.3 format path to conversion directory }
    DataPath := frmConvertDir.DirectoryListBox1.Directory;
    FixPath(DataPath);

    { Run Conversion }
    cmdFile   := StrAlloc(255);
    cmdPath   := StrAlloc(255);
    cmdParams := StrAlloc(255);


    { Params: %1=Drive & Path, %2=Drive, %3 = Directory }
    ProcessPath (DataPath, Drive, DirPart, FilePart);
    StrPCopy (cmdParams, DataPath + ' ' + Drive + ': ' + DirPart);

    StrPCopy (cmdFile,   ExtractFilePath(Application.ExeName) + 'UPVER.BAT');
    StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

    Flags := SW_SHOW; //SW_SHOWMINIMIZED;
    Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);

    StrDispose(cmdFile);
    StrDispose(cmdPath);
    StrDispose(cmdParams);
  End; { If Done }

  If Assigned(frmWelcome) Then frmWelcome.Free;
  If Assigned(frmConvertDir) Then frmConvertDir.Free;
  If Assigned(frmReady) Then frmReady.Free;
End; { ConvertWizard }

begin
  Application.Initialize;
  Application.Run;

  ConvertWizard;
end.
