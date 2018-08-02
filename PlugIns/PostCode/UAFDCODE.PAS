unit UAFDCODE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, UseDLLU, PostCode, StdCtrls, ComCtrls, ExtCtrls, TEditVal;

type
  TDetailRec = record
    drStreet: string;
    drLocality: string;
    drTown: string;
    drCounty: string;
    drPostCode: string;
    drSTD: string;
  end;

  TfrmPostcodes = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    lvAddresses: TListView;
    bnCancel: TButton;
    bnOK: TButton;
    procedure lvAddressesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

  TAFDPostcode = class
  private
    fEventData: TAbsEnterpriseSystem;
    fCustSuppRec: TAbsCustomer;
    fDetailRecs: array of TDetailRec;
    fRecCount: integer;
    procedure LookupPostCode;
    procedure LoadDetailRec(Details: PostcodeData);
    procedure ProcessResults;
    procedure ReturnDetails(Details: TDetailRec);
  public
    procedure DoPostCode(EventData: TAbsEnterpriseSystem);
  end;

var
  frmPostcodes: TfrmPostcodes;

implementation

{$I DLLDECLS.INC}
{$R *.dfm}

procedure TAFDPostcode.DoPostCode(EventData: TAbsEnterpriseSystem);
begin
  fEventData:= EventData;

  with fEventData do
  begin
    case HandlerID of
      105: fCustSuppRec:= Customer;
      106: fCustSuppRec:= Supplier;
    end;
  end;
  LookupPostCode;
end;

procedure TAFDPostcode.LookupPostCode;
var
Details: PostcodeData;
Res: LongInt;
Flag: integer;
begin
  with fEventData, fCustSuppRec do
  begin
    StrPCopy(Details.Lookup, acPostCode);
    Flag:= 2;

    try
      Res:= GetFirst(Details, Flag);
      while Res >= 0 do
      begin
        inc(fRecCount);
        if fRecCount <= 50 then LoadDetailRec(Details) else Break;
        Res:= GetNext(Details);
      end;

      ProcessResults;
    except
      MessageDlg('The AFD Postcode utility has failed. Please enter the address manually and contact Technical Support.', mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TAFDPostcode.LoadDetailRec(Details: PostcodeData);
begin
  SetLength(fDetailRecs, Length(fDetailRecs) + 1);
  with Details, fDetailRecs[High(fDetailRecs)] do
  begin
    drStreet:= Trim(Street);
    drLocality:= Trim(Locality);
    drTown:= Trim(Town);
    drCounty:= Trim(County);
    drPostCode:= Trim(Postcode);
    drSTD:= Trim(STDCode);
  end;
end;

procedure TAFDPostcode.ProcessResults;
var
DetailsIndex: integer;
begin
  with fCustSuppRec do
  begin
    case fRecCount of
      1: ReturnDetails(fDetailRecs[0]);
      2..50:
      begin
        frmPostCodes:= TfrmPostcodes.Create(Application);
        try
          with frmPostcodes, lvAddresses do
          begin
            Caption:= 'Postcode ' + acPostCode;
            lvAddresses.Color:= Text8PT(Screen.ActiveForm.FindComponent('ACCodeF')).Color;
            lvAddresses.Font.Color:= Text8PT(Screen.ActiveForm.FindComponent('ACCodeF')).Font.Color;

            for DetailsIndex:= Low(fDetailRecs) to High(fDetailRecs) do with fDetailRecs[DetailsIndex], Items.Add do
            begin
              Caption:= drStreet;
              SubItems.Add(drLocality);
              SubItems.Add(drTown);
            end;
            Selected:= Items[0];
            frmPostCodes.ActiveControl:= lvAddresses;

            if ShowModal = mrOK then ReturnDetails(fDetailRecs[ItemIndex]);
          end;
        finally
          FreeAndNil(frmPostCodes);
        end;
      end
      else MessageDlg('The postcode ' + acPostCode + ' returned too many records. Please enter the address manually.', mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TAFDPostcode.ReturnDetails(Details: TDetailRec);
begin
  with Details, fCustSuppRec do
  begin
    acAddress[1]:= drStreet;
    acAddress[2]:= drLocality;
    acAddress[3]:= drTown;
    acAddress[4]:= drCounty;
    acAddress[5]:= drPostCode;
    acPostCode:= drPostCode;
    acPhone:= drSTD;
    acFax:= drSTD;
  end;
end;

procedure TfrmPostcodes.lvAddressesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then ModalResult:= mrOK;
end;

end.


