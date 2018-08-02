unit gridopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BorBtns, ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel,
  PageComp, bkgroup;

type
  TForm_GridOptions = class(TForm)
    Button_Ok: TButton;
    Button_Cancel: TButton;
    SBSGrp_PageHed: TSBSGroup;
    Label86: Label8;
    SBSGroup1: TSBSGroup;
    Label81: Label8;
    BorCheck_Display: TBorCheck;
    BorCheck_SnapTo: TBorCheck;
    CcyEdit_Horz: TCurrencyEdit;
    CcyEdit_Vert: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    Label84: Label8;
    Label85: Label8;
    procedure FormCreate(Sender: TObject);
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure CcyEdit_HorzExit(Sender: TObject);
    procedure CcyEdit_VertExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FController : TSBSController;
    pHorz,pVert : Word;
    Function ValidHorz : Boolean;
    Function ValidVert : Boolean;
  public
    { Public declarations }
    OK : Boolean;
    Procedure Setup (FormController : TSBSController);
    Procedure DisplaySettings;
  end;

var
  Form_GridOptions: TForm_GridOptions;

implementation

{$R *.DFM}

Uses FormUtil;

procedure TForm_GridOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

Procedure TForm_GridOptions.Setup (FormController : TSBSController);
begin
  FController := FormController;
  DisplaySettings;
End;

Procedure TForm_GridOptions.DisplaySettings;
begin
  With FController.Grid Do Begin
    BorCheck_Display.Checked := grDisplayGrid;
    BorCheck_SnapTo.Checked := grSnapToGrid;
    CcyEdit_Horz.Value := grXSpacing;
    CcyEdit_Vert.Value := grYSpacing;
    pHorz := grXSpacing;
    pVert := grYSpacing;
  End; { With }
End;

procedure TForm_GridOptions.Button_OkClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  If ValidHorz Then
    If ValidVert Then Begin
      With FController.Grid Do Begin
        grDisplayGrid := BorCheck_Display.Checked;
        grSnapToGrid  := BorCheck_SnapTo.Checked;
        SetXYSpace(pHorz, pVert);
      End; { If }

      Ok := True;
      Close;
    End; { If }

  RestoreCursor (PrevCur);
end;

procedure TForm_GridOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

Function TForm_GridOptions.ValidHorz : Boolean;
begin
  Result := (CcyEdit_Horz.Value > 0);

  If (Not Result) Then Begin
    { must be > 0 }
    If CcyEdit_Horz.CanFocus Then CcyEdit_Horz.SetFocus;
    MessageDlg ('The Horizontal Grid Size must be greater than zero.', mtInformation, [mbOk], 0);
  End { If }
  Else
    pHorz := Round(CcyEdit_Horz.Value)
end;

Function TForm_GridOptions.ValidVert : Boolean;
begin
  Result := (CcyEdit_Vert.Value > 0);

  If (Not Result) Then Begin
    { must be > 0 }
    If CcyEdit_Vert.CanFocus Then CcyEdit_Vert.SetFocus;
    MessageDlg ('The Vertical Grid Size must be greater than zero.', mtInformation, [mbOk], 0);
  End { If }
  Else
    pVert := Round(CcyEdit_Vert.Value)
end;

procedure TForm_GridOptions.CcyEdit_HorzExit(Sender: TObject);
begin
  If (ActiveControl <> Button_Cancel) Then
    ValidHorz;
end;

procedure TForm_GridOptions.CcyEdit_VertExit(Sender: TObject);
begin
  If (ActiveControl <> Button_Cancel) Then
    ValidVert;
end;

procedure TForm_GridOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_GridOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
