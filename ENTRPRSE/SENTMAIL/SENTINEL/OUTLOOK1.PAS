unit Outlook1;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleServer, ComCtrls, Outlook8{, Outlook_TLB};

const
  tpEmail = 0;
  tpSMS = 1;
  tpFax = 2;

type

  _ContactItemDisp = Pointer;

  TFrmOutlook = class(TForm)
    LVContacts: TListView;
    Outlook: TOutlookApplication;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    NmeSpace : NameSpace;
    Contactfolder : MapiFolder;
    Contact: {ContactItem;}  ContactItem;
    FListView : TListView;
  protected
    procedure AddContactToListView(Contact : ContactItem; AType : Byte) ;
    function getCurrContact : _ContactItemDisp;
    Procedure SetCurrContact(value : _ContactItemDisp);
    { Private declarations }
  public
    { Public declarations }
    Property CurrContact : _ContactItemDisp read getCurrContact write SetCurrContact;
    procedure AddOutlookContents(AListView : TListView; AType : Byte);
  end;

var
  FrmOutlook: TFrmOutlook;

implementation

{$R *.DFM}


procedure TFrmOutlook.AddContactToListView(Contact : ContactItem; AType : Byte) ;
var
  item : TListItem;
  s : ShortString;
  Wanted : Boolean;
begin
  Wanted := ((AType = tpEmail) and (Trim(Contact.Email1Address) <> '')) or
            ((AType = tpSMS) and (Trim(Contact.MobileTelephoneNumber) <> '')) or
            ((AType = tpFax) and (Trim(Contact.BusinessFaxNumber) <> ''));

  if Wanted then
  begin
    Item := FListView.Items.Add;
    Item.Caption := Contact.fullname;
    with item.subItems do
    begin
      if (AType = tpEmail)  then
        add(Contact.Email1Address)
      else
      begin
        if AType = tpSMS then
          s := Contact.MobileTelephoneNumber
        else
          s := Contact.BusinessFaxNumber;
        if s[1] = '+' then
          System.Delete(s, 1, 1);
{        add('');
        add('');}
        add(s);
      end;
    end;
  end;
end;

procedure TFrmOutlook.FormCreate(Sender: TObject);
var
  i : Integer;

begin
  Outlook.Connect;

  NmeSpace := Outlook.GetNamespace('Mapi');
  Contactfolder := NmeSpace.GetDefaultFolder(olFolderContacts);

end;

Procedure TFrmOutlook.SetCurrContact(value : _ContactItemDisp);
begin
{  if value <> nil then
  begin
    contact := value;
  end;}
end;

function TFrmOutlook.getCurrContact : _ContactItemDisp;
begin
{  if Contact <> nil then
  begin
    result := Contact;
  end;}
end;


procedure TFrmOutlook.FormDestroy(Sender: TObject);
begin
  NmeSpace := nil;
  ContactFolder := nil;
//  contact := nil;
  outlook.Disconnect ;
end;

procedure TFrmOutlook.Button1Click(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to lvContacts.items.Count-1 do
  begin
    if LvContacts.items[i].selected then
    begin
      currcontact := _ContactItemDisp(ContactFolder.Items.Find('[FileAs] = ' + '''' + LVContacts.items[i].caption + ''''));
   //   CurrContact.Display(false);
    end;
  end;
end;



procedure TFrmOutlook.AddOutlookContents(AListView : TListView; AType : Byte);
var
  i : integer;
begin

  FListView := AListView;
  for I:= 1 to contactFolder.items.Count do
  begin
    Contact := ContactItem(ContactFolder.Items.item(i));

    if contact <> nil then
    begin
      AddContactToListView(Contact, AType) ;
    end
  end;

end;

end.
