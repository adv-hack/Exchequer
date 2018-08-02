unit coltype;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel;

type
  TForm_FieldType = class(TForm)
    Group_Field: TSBSGroup;
    Label81: Label8;
    Button_Cancel: TButton;
    Group_Formula: TSBSGroup;
    Label82: Label8;
    Label83: Label8;
    Button_AddField: TButton;
    Button_AddFormula: TButton;
    procedure Button_AddFieldClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    Status : Byte;
  end;

var
  Form_FieldType: TForm_FieldType;

implementation

{$R *.DFM}

Uses GlobType, FormUtil;

procedure TForm_FieldType.FormCreate(Sender: TObject);
begin
  Status := 0;
end;

procedure TForm_FieldType.Button_AddFieldClick(Sender: TObject);
begin
  If (Sender = Button_Cancel) Then Status := 0;
  If (Sender = Button_AddField) Then Status := 1;
  If (Sender = Button_AddFormula) Then Status := 2;

  Close;
end;

procedure TForm_FieldType.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_FieldType.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
