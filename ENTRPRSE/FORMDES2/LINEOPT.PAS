unit lineopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Menus,
  AccelLbl, bkgroup, GlobType;

type
  TForm_LineOptions = class(TForm)
    Button_Ok: TButton;
    Button_Cancel: TButton;
    SBSPanel3: TSBSPanel;
    Label82: Label8;
    Button_Colour: TButton;
    ColorDialog1: TColorDialog;
    CcyEdit_Width: TCurrencyEdit;
    Panel_Colour: TPanel;
    SpButt_Horz: TSpeedButton;
    SpButt_Vert: TSpeedButton;
    SpButt_TLBR: TSpeedButton;
    SpButt_BLTR: TSpeedButton;
    SBSBackGroup1: TSBSBackGroup;
    SBSAccelLabel1: TSBSAccelLabel;
    SBSPanel2: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    Label81: Label8;
    SBSBackGroup2: TSBSBackGroup;
    procedure Panel_ColourDblClick(Sender: TObject);
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDblClick(Sender: TObject);
    procedure SBSAccelLabel1Accel(Sender: TObject; AccChar: Char);
    procedure Button_IfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Ok       : Boolean;
    DragCont : TObject;
    FOnIf    : TIfLabelEvent;
  end;

var
  Form_LineOptions: TForm_LineOptions;

implementation

{$R *.DFM}

Uses DllInt, FormUtil;

procedure TForm_LineOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

procedure TForm_LineOptions.Panel_ColourDblClick(Sender: TObject);
begin
  ColorDialog1.Color := Panel_Colour.Color;
  ColorDialog1.Execute;
  Panel_Colour.Color := ColorDialog1.Color;
end;

procedure TForm_LineOptions.Button_OkClick(Sender: TObject);
begin
  If (CcyEdit_Width.Value > 0) Then Begin
    If SpButt_Horz.Down Or
       SpButt_Vert.Down Or
       SpButt_TLBR.Down Or
       SpButt_BLTR.Down Then Begin
      Ok := True;
      Close;
    End { If }
    Else
      MessageDlg ('The type of line must be set',
                  mtError,
                  [mbOk],
                  0);
  End { If }
  Else
    MessageDlg ('The pen width must be greater than 0',
                mtError,
                [mbOk],
                0);
end;

procedure TForm_LineOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_LineOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_LineOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_LineOptions.FormDblClick(Sender: TObject);
begin
  SpButt_TLBR.Down := True;
end;

procedure TForm_LineOptions.SBSAccelLabel1Accel(Sender: TObject;
  AccChar: Char);
begin
  Case AccChar Of
    '1' : SpButt_Horz.Down := True;
    '2' : SpButt_Vert.Down := True;
    '3' : SpButt_TLBR.Down := True;
    '4' : SpButt_BLTR.Down := True;
  End; { Case }
end;

procedure TForm_LineOptions.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  If Assigned (FOnIf) Then FOnIf (DragCont, Label_If);
  RestoreCursor (PrevCur);
end;

end.
