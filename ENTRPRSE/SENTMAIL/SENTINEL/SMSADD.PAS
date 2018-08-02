unit SMSAdd;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmSMSAdd = class(TForm)
    lvSMSContacts: TListView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure lvSMSContactsColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvSMSContactsCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SortIndex : Byte;
    SortDirections : Array[0..1] of SmallInt;
  public
    { Public declarations }
    ContactName, ContactCountry, ContactCode, ContactNumber : ShortString;
    procedure LoadContacts(IsSMS : Boolean = True);

  end;

var
  frmSMSAdd: TfrmSMSAdd;

implementation

{$R *.DFM}
uses
  Outlook1;

procedure TfrmSMSAdd.Button1Click(Sender: TObject);
begin
  if lvSMSContacts.Selected <> nil then
  begin
    ContactName := lvSMSContacts.Selected.Caption;
{    ContactCountry := lvSMSContacts.Selected.SubItems[0];
    ContactCode := lvSMSContacts.Selected.SubItems[1];}
    ContactNumber := lvSMSContacts.Selected.SubItems[0];
    ModalResult := mrOK;
  end;

end;

procedure TfrmSMSAdd.LoadContacts(IsSMS : Boolean = True);
var
  TP : Byte;
begin
  lvSMSContacts.Items.Clear;
  if IsSMS then
    TP := tpSMS
  else
    TP := tpFax;
  with TfrmOutlook.Create(nil) do
  Try
    AddOutlookContents(lvSMSContacts, TP);
    SortIndex := 0;
    lvSMSContacts.AlphaSort;
    SortDirections[0] := -1;
  Finally
    Free;
  End;
end;


procedure TfrmSMSAdd.lvSMSContactsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortIndex := Column.Tag;
  lvSMSContacts.AlphaSort;
  SortDirections[SortIndex] := - SortDirections[SortIndex];
end;

procedure TfrmSMSAdd.lvSMSContactsCompare(Sender: TObject; Item1,
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

procedure TfrmSMSAdd.FormCreate(Sender: TObject);
begin
  SortDirections[0] := 1;
  SortDirections[1] := 1;
end;

end.
