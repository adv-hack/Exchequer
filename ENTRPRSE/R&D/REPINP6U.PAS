unit RepInp6U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,BTSupU3,
  Repinp1u, ExtCtrls, SBSPanel, StdCtrls, TEditVal, bkgroup, Animate;

type
  TRepInpMsg6 = class(TRepInpMsg)
    AgeInt: TCurrencyEdit;
    Label85: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    CRepParam  :  PostRepPtr;
    CRepParam2 :  DocRepPtr;

  public
    { Public declarations }
    DocMode    :  Boolean;
  end;


procedure Posting_Report(AOwner  :  TComponent;
                         DocMode :  Boolean);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  SysU1,
  Report2U,
  Report3U,

  {$IFDEF EXSQL}
    SQLUtils,
    SQLRep_Config,
    SQLRep_GLPrePosting,
  {$ENDIF}

  BTSupU2;

{$R *.DFM}

procedure TRepInpMsg6.FormCreate(Sender: TObject);
begin
  inherited;

  ClientHeight:=144;
  ClientWidth:=299;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  New(CRepParam2);

  try
    FillChar(CRepParam2^,Sizeof(CRepParam2^),0);
  except
    Dispose(CRepParam2);
    CRepParam2:=nil;
  end;

  AgeInt.Value:=Pred(GetNextCount(RUN,BOff,BOff,0));

  SetLastValues;
end;

procedure TRepInpMsg6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  If (Assigned(CRepParam2)) then
    Dispose(CRepParam2);

end;



procedure TRepInpMsg6.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      OKCP1Btn.Enabled:=BOff;

      If (DocMode) then
        With CRepParam2^ do
        Begin
          NomToo:=Round(AgeInt.Value);

          AddDocRep2Thread(5,0,CRepParam2,Owner);
        end
      else
        With CRepParam^ do
        Begin
          IsReRun:=(Round(AgeInt.Value)>0);

          {$IFDEF EXSQL}
          if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLGLPrePosting then
            SQLReport_PrintGLPrePosting(Round(AgeInt.Value), 0, Owner, CRepParam^)
          else
          {$ENDIF}
            AddPostRep2Thread(2,Round(AgeInt.Value),0,CRepParam,BOn,Owner);
        end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;




procedure TRepInpMsg6.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg6.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;


procedure Posting_Report(AOwner  :  TComponent;
                         DocMode :  Boolean);



Var
  RepInpMsg1  :  TRepInpMsg6;

Begin
  RepInpMsg1:=TRepInpMsg6.Create(AOwner);

  try
    RepInpMsg1.DocMode:=DocMode;
  except
    RepInpMsg1.Free;
  end;

end;


procedure TRepInpMsg6.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  If (Key = '-') Then
    Key := #0;
end;

end.
