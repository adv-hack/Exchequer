unit ReportCatDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BTfiles, MiscUtil, BTConst, BTUtil, EnterToTab;

type
  TCatMode = (cmCategory, cmSubCategory);

  TfrmReportCatDetails = class(TForm)
    Label1: TLabel;
    edCode: TEdit;
    Label2: TLabel;
    edDescription: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    FormMode : TFormMode;
    CategoryMode : TCatMode;
    ReportCat : TWEEEReportCatRec;
    ReportSubCat : TWEEEReportSubCatRec;
  end;

var
  frmReportCatDetails: TfrmReportCatDetails;

implementation
uses
  APIUtil, StrUtil, WEEEProc;

{$R *.dfm}

procedure TfrmReportCatDetails.btnOKClick(Sender: TObject);

  function ValidateReportCat : boolean;
  var
    BTRec : TBTRec;
    sError : string;
    LReportCat : TWEEEReportCatRec;
  begin
    sError := '';

    if trim(ReportCat.wrcCode) = '' then sError := 'Blank Code'
    else begin
      if trim(ReportCat.wrcDescription) = '' then sError := 'Blank Description'
      else begin
        case FormMode of
          fmAdd : begin
            BTRec.KeyS := ReportCat.wrcCode;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
            , btBufferSize[WEEEReportCatF], wrcIdxCode, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              sError := 'Duplicate Code';
            end else
            begin
              BTRec.KeyS := ReportCat.wrcDescription;
              BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
              , btBufferSize[WEEEReportCatF], wrcIdxDesc, BTRec.KeyS);
              if BTRec.Status = 0 then
              begin
                sError := 'Duplicate Description';
              end;{if}
            end;{if}
          end;

          fmEdit : begin
            BTRec.KeyS := ReportCat.wrcCode;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
            , btBufferSize[WEEEReportCatF], wrcIdxCode, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              if ReportCat.wrcFolioNo <> LReportCat.wrcFolioNo
              then sError := 'Duplicate Code';
            end else
            begin
              BTRec.KeyS := ReportCat.wrcDescription;
              BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
              , btBufferSize[WEEEReportCatF], wrcIdxDesc, BTRec.KeyS);
              if BTRec.Status = 0 then
              begin
                if ReportCat.wrcFolioNo <> LReportCat.wrcFolioNo
                then sError := 'Duplicate Description';
              end;{if}
            end;{if}
          end;
        end;{case}
      end;{if}
    end;{if}

    if sError <> '' then MsgBox('Validation Error : ' + sError, mtError, [mbOK],mbOk, 'Validation Error');

    Result := sError = '';
  end;{ValidateReportCat}

  function ValidateReportSubCat : boolean;
  var
    BTRec : TBTRec;
    sError : string;
    LReportSubCat : TWEEEReportSubCatRec;
  begin
    sError := '';

    if trim(ReportSubCat.wscCode) = '' then sError := 'Blank Code'
    else begin
      if trim(ReportSubCat.wscDescription) = '' then sError := 'Blank Description'
      else begin
        case FormMode of
          fmAdd : begin
            BTRec.KeyS := BTFullNomKey(ReportCat.wrcFolioNo) + ReportSubCat.wscCode;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
            , btBufferSize[WEEEReportSubCatF], wscIdxCatCode, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              sError := 'Duplicate Code';
            end else
            begin
              BTRec.KeyS := BTFullNomKey(ReportCat.wrcFolioNo) + ReportSubCat.wscDescription;
              BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
              , btBufferSize[WEEEReportSubCatF], wscIdxCatDesc, BTRec.KeyS);
              if BTRec.Status = 0 then
              begin
                sError := 'Duplicate Description';
              end;{if}
            end;{if}
          end;

          fmEdit : begin
            BTRec.KeyS := BTFullNomKey(ReportCat.wrcFolioNo) + ReportSubCat.wscCode;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
            , btBufferSize[WEEEReportSubCatF], wscIdxCatCode, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              if ReportSubCat.wscFolioNo <> LReportSubCat.wscFolioNo
              then sError := 'Duplicate Code';
            end else
            begin
              BTRec.KeyS := BTFullNomKey(ReportCat.wrcFolioNo) + ReportSubCat.wscDescription;
              BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
              , btBufferSize[WEEEReportSubCatF], wscIdxCatDesc, BTRec.KeyS);
              if BTRec.Status = 0 then
              begin
                if ReportSubCat.wscFolioNo <> LReportSubCat.wscFolioNo
                then sError := 'Duplicate Description';
              end;{if}
            end;{if}
          end;
        end;{case}
      end;{if}
    end;{if}

    if sError <> '' then MsgBox('Validation Error : ' + sError, mtError, [mbOK],mbOk, 'Validation Error');

    Result := sError = '';
  end;{ValidateReportSubCat}

var
  BTRec : TBTRec;
  LReportCat : TWEEEReportCatRec;
  LReportSubCat : TWEEEReportSubCatRec;

begin
  case CategoryMode of
    cmCategory : begin
      if FormMode = fmAdd then
      begin
        ReportCat.wrcFolioNo := GetNextFolio(WEEEReportCatF);
        ReportCat.wrcDummyChar := IDX_DUMMY_CHAR;
      end;{if}

      ReportCat.wrcCode := PadString(psRight, edCode.Text, ' ', 10);
      ReportCat.wrcDescription := PadString(psRight, edDescription.Text, ' ', 100);

      if ValidateReportCat then
      begin
        case FormMode of
          fmAdd : begin
            BTRec.Status := BTAddRecord(btFileVar[WEEEReportCatF], ReportCat
            , btBufferSize[WEEEReportCatF], 0);
            BTShowError(BTRec.Status, 'BTAddRecord', CompanyRec.Path + btFileName[WEEEReportCatF]);
          end;

          fmEdit : begin
            BTRec.KeyS := BTFullNomKey(ReportCat.wrcFolioNo) + ReportCat.wrcDummyChar;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
            , btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              BTRec.Status := BTUpdateRecord(btFileVar[WEEEReportCatF], ReportCat, btBufferSize[WEEEReportCatF], wrcIdxFolio, BTRec.KeyS);
              BTShowError(BTRec.Status, 'BTUpdateRecord', CompanyRec.Path + btFileName[WEEEReportCatF]);
            end;{if}
          end;
        end;{case}
        ModalResult := mrOK;
      end;{if}
    end;

    cmSubCategory : begin
      if FormMode = fmAdd then
      begin
        ReportSubCat.wscFolioNo := GetNextFolio(WEEEReportSubCatF);
        ReportSubCat.wscDummyChar := IDX_DUMMY_CHAR;
      end;{if}

      ReportSubCat.wscCatFolioNo := ReportCat.wrcFolioNo;
      ReportSubCat.wscCode := PadString(psRight, edCode.Text, ' ', 10);
      ReportSubCat.wscDescription := PadString(psRight, edDescription.Text, ' ', 100);

      if ValidateReportSubCat then
      begin
        case FormMode of
          fmAdd : begin
            BTRec.Status := BTAddRecord(btFileVar[WEEEReportSubCatF], ReportSubCat
            , btBufferSize[WEEEReportSubCatF], 0);
            BTShowError(BTRec.Status, 'BTAddRecord', CompanyRec.Path + btFileName[WEEEReportSubCatF]);
          end;

          fmEdit : begin
            BTRec.KeyS := BTFullNomKey(ReportSubCat.wscFolioNo) + ReportSubCat.wscDummyChar;
            BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
            , btBufferSize[WEEEReportSubCatF], wscIdxFolio, BTRec.KeyS);
            if BTRec.Status = 0 then
            begin
              BTRec.Status := BTUpdateRecord(btFileVar[WEEEReportSubCatF], ReportSubCat, btBufferSize[WEEEReportSubCatF], wrcIdxFolio, BTRec.KeyS);
              BTShowError(BTRec.Status, 'BTUpdateRecord', CompanyRec.Path + btFileName[WEEEReportSubCatF]);
            end;{if}
          end;
        end;{case}
        ModalResult := mrOK;
      end;{if}
    end;
  end;{case}
end;

procedure TfrmReportCatDetails.FormShow(Sender: TObject);
begin
  case CategoryMode of
    cmCategory : begin
      Caption := 'Report Category Details';
      if FormMode = fmEdit then
      begin
        edCode.text := Trim(ReportCat.wrcCode);
        edDescription.text := Trim(ReportCat.wrcDescription);
      end;{if}
    end;

    cmSubCategory : begin
      Caption := 'Sub Category Details';
      if FormMode = fmEdit then
      begin
        edCode.text := Trim(ReportSubCat.wscCode);
        edDescription.text := Trim(ReportSubCat.wscDescription);
      end;{if}
    end;
  end;{case}
end;

end.
