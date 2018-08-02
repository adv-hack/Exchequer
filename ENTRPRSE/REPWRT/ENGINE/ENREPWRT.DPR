program EnRepwrt;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Dialogs,
  Forms,
  SysUtils,
  GlobVar in '..\R&D\Globvar.pas',
  VarConst in '..\R&D\Varconst.pas',
  RwOpenF in 'RwOpenF.pas',
  rwfuncs in 'rwfuncs.pas',
  RepTree in 'Reptree.pas' {Form_RepTree},
  RepNot in 'RepNot.pas' {FrmNotLine},
  rpinput in 'rpinput.pas' {RepInputs},
  RwListU in 'RwListU.pas',
  RepObjCU in 'Repobjcu.pas',
  RWPrintR in 'RWPrintR.pas',
  VarFPOSU in 'Varfposu.pas',
  Repnom in 'Repnom.pas' {FrmNomLine},
  RepInp in 'Repinp.pas' {FrmInpLine},
  Repdet in 'Repdet.pas' {ReportRec},
  Repline in 'Repline.pas' {FrmRepLine},
  prntprev in 'Prntprev.pas' {Form_PrintPreview},
  ReportO in 'Reporto.pas',
  AboutU in '..\R&D\Aboutu.pas' {AboutFrm},
  overwrit in 'overwrit.pas' {Form_OverWrite},
  RepObjNU in 'Repobjnu.pas',
  RWMain in 'RWMain.pas' {Form_RWMain},
  BTSupU1 in '..\R&D\Btsupu1.pas',
  ExWrap1U in '..\R&D\ExWrap1U.pas',
  ExBtTh1u in '..\R&D\Exbtth1u.pas',
  DicLinkU in '..\FORMDES2\Diclinku.pas',
  DicLnk2U in '..\FORMDES2\Diclnk2u.pas',
  PageDlg in '..\FORMDES2\Pagedlg.pas' {PageSetupDlg},
  layrep in 'layrep.pas',
  RepObj2U in 'Repobj2u.pas',
  mcfuncs in 'mcfuncs.pas',
  CommsInt in '..\ENTCOMMS\Commsint.pas',
  Crypto in '..\MULTCOMP\Crypto.pas',
  PWordDlg in 'Pworddlg.pas' {PasswordDialog},
  Prntdlg2 in 'prntdlg2.pas' {PrintDlg};

{$R *.RES}

{$R Arrows.RES}

{$IFDEF BindingRTLI} {* Include Run time Line Information *}
  {$R *.RLI}
{$ENDIF}


{$I SecCode.Pas}


  Function CheckParamCode : Boolean;
  Var
    I         : SmallInt;
  Begin
    Result := False;

    If (ParamCount > 0) Then
      For I := 1 To ParamCount Do Begin
        If (Not Result) Then
          Result := (UpperCase(Trim(ParamStr(I))) = RWStartCode);
      End; { For }
  End;

begin
  If CheckParamCode Then Begin
    Application.Initialize;
    Application.Title := 'Report Writer - Exchequer Enterprise';
    Application.HelpFile := 'ENREPWRT.HLP';
    Application.CreateForm(TForm_RWMain, Form_RWMain);
  Application.Run;
  End { If }
  Else Begin
    MessageDlg ('Exchequer Enterprise Report Writer ' + CurrVersion_RW +
                 #10#13#10#13 +
                 'This program can only be run from inside Exchequer Enterprise - Program Aborted.', mtError, [mbOk], 0);
    Halt;
  End; { Else }
end.
