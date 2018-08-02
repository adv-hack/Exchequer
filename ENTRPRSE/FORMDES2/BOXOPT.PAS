unit boxopt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, ComCtrls, GlobType, bkgroup;

type
  TForm_BoxOptions = class(TForm)
    Button_Ok: TButton;
    Button_Cancel: TButton;
    SBSPanel2: TSBSPanel;
    Label1: TLabel;
    SBSPanel3: TSBSPanel;
    ColorDialog1: TColorDialog;
    Label82: Label8;
    Button_Colour: TButton;
    CcyEdit_Width: TCurrencyEdit;
    Panel_Colour: TPanel;
    Check_Fill: TCheckBox;
    Check_Left: TCheckBox;
    Check_Top: TCheckBox;
    Check_Bottom: TCheckBox;
    Check_Right: TCheckBox;
    SBSPanel5: TSBSPanel;
    Label_If: Label8;
    Button_If: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    procedure FormCreate(Sender: TObject);
    procedure Button_OkClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Panel_ColourDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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
  Form_BoxOptions: TForm_BoxOptions;

implementation

{$R *.DFM}

Uses DllInt, FormUtil;

procedure TForm_BoxOptions.FormCreate(Sender: TObject);
begin
  Ok := False;
end;

procedure TForm_BoxOptions.Button_OkClick(Sender: TObject);
begin
  If (CcyEdit_Width.Value > 0) Then Begin
    Ok := True;
    Close;
  End { If }
  Else
    MessageDlg ('The pen width must be greater than 0',
                mtError,
                [mbOk],
                0);
end;

procedure TForm_BoxOptions.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TForm_BoxOptions.Panel_ColourDblClick(Sender: TObject);
begin
  ColorDialog1.Color := Panel_Colour.Color;
  ColorDialog1.Execute;
  Panel_Colour.Color := ColorDialog1.Color;
end;

procedure TForm_BoxOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_BoxOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_BoxOptions.Button_IfClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);
  If Assigned (FOnIf) Then FOnIf (DragCont, Label_If);
  RestoreCursor (PrevCur);
end;

end.
