unit SortViewOptionsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, uMultiList, Menus;

type
  TForm1 = class(TForm)
    MultiList1: TMultiList;
    Panel1: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure MultiList1CellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
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
  With MultiList1 Do
  Begin // With MultiList1
    With DesignColumns[0] Do
    Begin
      Items.Add ('Not Saved');
      Items.Add ('User');
      Items.Add ('User');
      Items.Add ('Global');
    End; // With DesignColumns[0]

    With DesignColumns[1] Do
    Begin
      Items.Add ('Code Order - Southampton Area Only Filter');
      Items.Add ('Code Order - Bournemouth Area Only Filter');
      Items.Add ('Code Order - UDF1 = ELBARTO');
      Items.Add ('Balance Order (Descending)');
    End; // With DesignColumns[1]

    With DesignColumns[2] Do
    Begin
      Items.Add ('');
      Items.Add ('*');
      Items.Add ('');
      Items.Add ('');
    End; // With DesignColumns[2]
  End; // With MultiList1
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MultiList1CellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  If (RowIndex = 0) Then
    TextFont.Style := TextFont.Style + [fsBold];
end;

end.
