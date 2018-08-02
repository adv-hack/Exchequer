unit LabelDlg;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  LblDlg1U, ExtCtrls, GlobType, StdCtrls, bkgroup, TEditVal, SBSPanel;

type
  TBaseLabelDialog1 = class(TBaseLabelDialog)
    btnOK: TButton;
    btnCancel: TButton;
    SBSBackGroup1: TSBSBackGroup;
    SBSGroup1: TSBSGroup;
    ccyNoLbl: TCurrencyEdit;
    Label81: Label8;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;


Function ShowLabelDlg(HedRec : fdHeaderRecType;Var PrnLabel, NoLabels : SmallInt) : Boolean; OverLoad;
//Function ShowLabelDlg(HedRec : fdHeaderRecType;Var PrnLabel : SmallInt) : Boolean; OverLoad;

implementation

{$R *.DFM}

Var
  LocalHed                 : ^fdHeaderRecType;

//Function ShowLabelDlg(HedRec : fdHeaderRecType;Var PrnLabel : SmallInt) : Boolean;
//Begin
//  Result := False;
//End;

{ Display Print Label dialog for Form Designer Print Preview }
Function ShowLabelDlg(HedRec : fdHeaderRecType;Var PrnLabel, NoLabels : SmallInt) : Boolean;
var
  LabelDlg : TBaseLabelDialog1;
Begin
  Result := False;

  { Place header record in local cache so it can be accessed immediately }
  LocalHed^ := HedRec;

  LabelDlg := TBaseLabelDialog1.Create(Application.MainForm);
  Try
    LabelDlg.ShowModal;

    Result := LabelDlg.OK;

    If Result Then Begin
      PrnLabel := LabelDlg.ActiveLabel;
      NoLabels := Round(LabelDlg.ccyNoLbl.Value);
    End; { If }
  Finally
    LabelDlg.Free;
  End;
End;

procedure TBaseLabelDialog1.FormCreate(Sender: TObject);
begin
  inherited;

  HeaderRec := LocalHed^;

  With HeaderRec Do Begin
    { Set default values }
    ccyNoLbl.Value := 1;
    If (fhOrientation = fdoPortrait) Then
      FActiveLabel := 1
    Else
      FActiveLabel := (Pred(fhLblCols) * fhLblRows) + 1;
  End; { With }

  OK := False;
end;

procedure TBaseLabelDialog1.btnOKClick(Sender: TObject);
begin
  inherited;

  If (ccyNoLbl.Value >= 1) Then Begin
    Ok := True;
    Close;
  End { If }
  Else
    MessageDlg ('The number of labels to print must be 1 or more.', mtWarning, [mbOk], 0);
end;

procedure TBaseLabelDialog1.btnCancelClick(Sender: TObject);
begin
  inherited;

  Ok := False;
  Close;
end;

Initialization
  GetMem (LocalHed, SizeOf (LocalHed^));
  FillChar (LocalHed^, SizeOf (LocalHed^), #0);
Finalization
  FreeMem (LocalHed, SizeOf (LocalHed^));
end.
