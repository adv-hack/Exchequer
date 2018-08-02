unit SystemSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, BTUtil, BTConst;

type
  TFrmSystemSetup = class(TForm)
    Bevel1: TBevel;
    cbVAT: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    bVAT : boolean;
  public
    sDataPath : string;
  end;

var
  FrmSystemSetup: TFrmSystemSetup;

implementation
uses
  APIUtil, CCDeptU, inifiles, BTFile;

{$R *.dfm}

procedure TFrmSystemSetup.btnOKClick(Sender: TObject);
var
  bContinue : boolean;

  procedure RemoveAllVATCodes;
  var
    BTRec : TBTRec;
    LCCDeptRec : TCCDeptRec;
  begin{RemoveAllVATCodes}
    BTRec.KeyS := '';
    BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], LCCDeptRec
    , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

    while (BTRec.Status = 0) do
    begin
      // remove vat code, and save record
      LCCDeptRec.cdVATCode := #0;
      BTRec.Status := BTUpdateRecord(aFileVar[CCDeptF], LCCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

      if BTRec.Status <> 0 then
      begin
        // Delete record, as it is a duplicate
        BTRec.Status := BTDeleteRecord(aFileVar[CCDeptF], LCCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
        BTShowError(BTRec.Status, 'BTDeleteRecord', aFileName[CCDeptF]);

        // Go back to the beginning - Yes I know it's not the most efficient way of doing this, but it works, and there will never be very many records in the database, so the time overhead will not be noticable.
        BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], LCCDeptRec
        , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      end else
      begin
        // next record
        BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], LCCDeptRec
        , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      end;{if}
    end;{while}
  end;{RemoveAllVATCodes}

begin
  if cbVAT.Checked <> bVAT then
  begin
    if CombinationsAreStored then
    begin
      if cbVAT.Checked then
      begin
        // switching VAT on
        bContinue := MsgBox('In order to change the mode of the Plug-In, all combinations must be removed for this company.'
        + #13#13'Are you sure you want to do this ?', mtConfirmation, [mbYes, mbNo], mbNo, 'Delete all combinations') = mrYes;
        if bContinue then DeleteAllCombinations;
      end else
      begin
        // switching VAT OFF
        bContinue := MsgBox('In order to change the mode of the Plug-In, all VAT codes will be removed from your combinations for this company.'
        + #13'All duplicate records will also be deleted.'#13#13'Are you sure you want to do this ?'
        , mtConfirmation, [mbYes, mbNo], mbNo, 'Remove all VAT Codes') = mrYes;
        if bContinue then RemoveAllVATCodes;
      end;{if}
    end;{if}

    if bContinue then
    begin
      with TInifile.Create(sDataPath + INI_FILENAME) do
      begin
        WriteBool('Settings', 'UseVAT', cbVAT.Checked);
      end;{with}
      ModalResult := mrOK;
    end;{if}
  end;{if}
end;

procedure TFrmSystemSetup.FormShow(Sender: TObject);
begin
  with TInifile.Create(sDataPath + INI_FILENAME) do
  begin
     bVAT := ReadBool('Settings','UseVAT', FALSE);
     cbVAT.Checked := bVAT;
  end;{with}
end;

procedure TFrmSystemSetup.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
