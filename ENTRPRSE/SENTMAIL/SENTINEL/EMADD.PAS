unit EmAdd;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmEmailAddForm = class(TForm)
    lvEmContacts: TListView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cbType: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure lvEmContactsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvEmContactsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SortIndex : Byte;
    SortDirections : Array[0..1] of SmallInt;
  public
    { Public declarations }
    ContactName : ShortString;
    ContactAddress : ShortString;
    procedure LoadContacts;
  end;

var
  frmEmailAddForm: TfrmEmailAddForm;

implementation

{$R *.DFM}
uses
  Outlook1;

procedure TfrmEmailAddForm.Button1Click(Sender: TObject);
begin
  if lvEmContacts.Selected <> nil then
  begin
    ContactName := lvEmContacts.Selected.Caption;
    ContactAddress := lvEmContacts.Selected.SubItems[0];
    ModalResult := mrOK;
  end;
end;

procedure TfrmEmailAddForm.LoadContacts;
begin
  lvEmContacts.Items.Clear;
  with TfrmOutlook.Create(nil) do
  Try
    AddOutlookContents(lvEmContacts, tpEmail);
    SortIndex := 0;
    lvEmContacts.AlphaSort;
    SortDirections[0] := -1;
  Finally
    Free;
  End;
end;

procedure TfrmEmailAddForm.lvEmContactsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortIndex := Column.Tag;
  lvEmContacts.AlphaSort;
  SortDirections[SortIndex] := - SortDirections[SortIndex];
end;

procedure TfrmEmailAddForm.lvEmContactsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Case SortIndex of
    0     : Compare := AnsiCompareText(Item1.Caption, Item2.Caption);
    1     : Compare := AnsiCompareText(Item1.SubItems[0],
                                  Item2.SubItems[0]);
  end; //case
  if SortDirections[SortIndex] = -1 then
    Compare := -Compare;
end;

procedure TfrmEmailAddForm.FormCreate(Sender: TObject);
begin
  SortDirections[0] := 1;
  SortDirections[1] := 1;
end;

end.
