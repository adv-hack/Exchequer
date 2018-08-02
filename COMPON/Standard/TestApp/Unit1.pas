unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls, ExtCtrls, uMultiList, uDBMultiList,
  TEditVal, Mask;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    EnterToTab1: TEnterToTab;
    ext8Pt1: Text8Pt;
    CurrencyEdit1: TCurrencyEdit;
    EditPeriod1: TEditPeriod;
    Edit4: TEdit;
    Memo1: TMemo;
    Edit5: TEdit;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    MultiList1: TMultiList;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  MultiList1.DesignColumns[0].Items.Add ('Zero');
  MultiList1.DesignColumns[0].Items.Add ('One');
  MultiList1.DesignColumns[0].Items.Add ('Two');
  MultiList1.DesignColumns[0].Items.Add ('Three');

  ListBox1.Items.Add ('Zero');
  ListBox1.Items.Add ('One');
  ListBox1.Items.Add ('Two');
  ListBox1.Items.Add ('Three');
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  IsTopLine, IsBottomLine : Boolean;
  CRLFPos, I : Integer;
begin
  With ListBox1.Items Do
  Begin
    Clear;

    CRLFPos := Pos(#13#10, Memo1.Text);
    If (CRLFPos > 0) Then
    Begin
      IsTopLine := (Memo1.SelStart <= CRLFPos);

      // Find position of last CRLF
      CRLFPos := LastDelimiter (#10, Memo1.Text);
      IsBottomLine := (CRLFPos = 0) Or (Memo1.SelStart >= CRLFPos);
    End // If
    Else
    Begin
      // Single line or blank
      IsTopLine := True;
      IsBottomLine := True;
    End; // Else

    Add('SelStart: ' + IntToStr(Memo1.SelStart) + '  (' + IntToStr(Memo1.SelLength) + ')');
    Add('Length(Text): ' + IntToStr(Length(Memo1.Text)));
//    Add('TopLine: ' + BoolToStr(Memo1.SelStart <= Length(Memo1.Lines[0]), True));
//    Add('BottomLine: ' + BoolToStr(Memo1.SelStart >= (Length(Memo1.Text) - Length(Memo1.Lines[Memo1.Lines.Count - 1])), True));
    Add('TopLine: ' + BoolToStr(IsTopLine, True));
    Add('BottomLine: ' + BoolToStr(IsBottomLine, True));

    If (Memo1.Lines.Count > 0) Then
      For I := 0 To (Memo1.Lines.Count - 1) Do
        Add (IntToStr(Length(Memo1.Lines[I])) + ': ' + Memo1.Lines[I]);
  End; // With ListBox1.Items
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  If (Memo1.Width = 513) Then
    Memo1.Width := 256
  Else
    Memo1.Width := 513;
end;

end.
