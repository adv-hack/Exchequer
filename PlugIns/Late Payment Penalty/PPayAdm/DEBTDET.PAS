unit DebtDet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, TEditVal, uSettings, PPayProc, Menus, StrUtil, APIUtil
  , BTConst, BTFile, BTUtil, MathUtil, Key;

type
  TfrmDebtDetails = class(TForm)
    edValueFrom: TCurrencyEdit;
    Label3: TLabel;
    lTo: TLabel;
    Label2: TLabel;
    edCharge: TCurrencyEdit;
    btnCancel: TButton;
    btnOK: TButton;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edValueFromChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    bRestore : boolean;
    procedure LoadAllSettings;
    procedure SaveAllSettings;
    procedure Form2Record(var PPDebtRec : TPPDebtRec);
    procedure Record2Form(PPDebtRec : TPPDebtRec);
  public
    bAdd, bFirst : boolean;
//    iFolioNo : integer;
//    sLCustCode : string;
    LPPDebtRec : TPPDebtRec;
  end;

var
  frmDebtDetails: TfrmDebtDetails;

implementation
uses
  SQLUtils;

{$R *.dfm}

procedure TfrmDebtDetails.FormCreate(Sender: TObject);
begin
  bRestore := FALSE;
  LoadAllSettings;
  edValueFrom.displayformat := '######0.' + StringOfChar('0', oToolkit.SystemSetup.ssSalesDecimals);
//  edValueTo.displayformat := edValueFrom.displayformat;
  edCharge.displayformat := edValueFrom.displayformat;
end;

procedure TfrmDebtDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edValueFrom);
  oSettings.ColorFieldsFrom(edValueFrom, Self);
end;

procedure TfrmDebtDetails.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(edValueFrom, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmDebtDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edValueFrom) of
    mrOK : oSettings.ColorFieldsFrom(edValueFrom, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmDebtDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmDebtDetails.edValueFromChange(Sender: TObject);
begin
  lTo.Caption := GetToValue(LPPDebtRec.ppdCustCode, StrToFloatDef(edValueFrom.Text, 0), TRUE, bFirst);
end;


procedure TfrmDebtDetails.btnOKClick(Sender: TObject);
var
  PPDebtRec : TPPDebtRec;
  KeyS : TStr255;
  iStatus : integer;
begin
  if bAdd then
  begin
    if UsingSQL then
    begin
      // SQL Only
      KeyS := LPPDebtRec.ppdCustCode + BT_MinDoubleKey;
      iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdValueFrom4SQLIdx, KeyS);
      while (iStatus = 0) and (LPPDebtRec.ppdCustCode = PPDebtRec.ppdCustCode) do begin
        if ZeroFloat(StrToFloatDef(edValueFrom.Text,0) - PPDebtRec.ppdValueFrom )
        then iStatus := -1
        else begin
          iStatus := BTFindRecord(BT_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
          , ppdValueFrom4SQLIdx, KeyS);
        end;{if}
      end;{while}
    end
    else
    begin
      // Btrieve Only
      KeyS := LPPDebtRec.ppdCustCode + BT_MinDoubleKey;
      iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
      , ppdValueFromIdx, KeyS);
      while (iStatus = 0) and (LPPDebtRec.ppdCustCode = PPDebtRec.ppdCustCode) do begin
        if ZeroFloat(StrToFloatDef(edValueFrom.Text,0) - PPDebtRec.ppdValueFrom )
        then iStatus := -1
        else begin
          iStatus := BTFindRecord(BT_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
          , ppdValueFromIdx, KeyS);
        end;{if}
      end;{while}
    end;{if}

    if iStatus = -1 then
    begin
      MsgBox('You are trying to add a duplicate record to the Debt Collection Change Table.'#13#13
      + 'Please select a different value.',mtError, [mbOK], mbOK, 'Duplicate Error');
      ActiveControl := edValueFrom;
    end else
    begin
      Form2Record(PPDebtRec);
      if UsingSQL then
      begin
        // SQL Only
        BTShowError(BTAddRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdValueFrom4SQLIdx)
        , 'BTAddRecord', CompanyRec.Path + ppFileName[ppDebtF]);
      end
      else
      begin
        // Btrieve Only
        BTShowError(BTAddRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdValueFromIdx)
        , 'BTAddRecord', CompanyRec.Path + ppFileName[ppDebtF]);
      end;{if}
      ModalResult := mrOK;
    end;{if}
  end else
  begin
    // Edit
    KeyS := BTFullNomKey(LPPDebtRec.ppdFolioNo) + IDX_DUMMY_CHAR;
    iStatus := BTFindRecord(BT_GetEqual, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
    , ppdFolioNoIdx, KeyS);
    if (iStatus = 0) then
    begin
      PPDebtRec.ppdCharge := StrToFloatDef(edCharge.Text,0);
      iStatus := BTUpdateRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdFolioNoIdx, KeyS);
      BTShowError(iStatus, 'BTUpdateRecord', CompanyRec.Path + ppFileName[ppDebtF]);
      ModalResult := mrOK;
    end;{if}
  end;{if}
end;

procedure TfrmDebtDetails.Record2Form(PPDebtRec : TPPDebtRec);
begin
  edCharge.Value := PPDebtRec.ppdCharge;
  edValueFrom.Value := PPDebtRec.ppdValueFrom;
end;

procedure TfrmDebtDetails.Form2Record(var PPDebtRec : TPPDebtRec);
begin
  FillChar(PPDebtRec,SizeOf(PPDebtRec),#0);
  PPDebtRec.ppdFolioNo := GetNextFolioNo(PPDebtF);
  PPDebtRec.ppdCharge := StrToFloatDef(edCharge.Text,0);
  PPDebtRec.ppdCustCode := LPPDebtRec.ppdCustCode;
  PPDebtRec.ppdDummyChar := IDX_DUMMY_CHAR;
  PPDebtRec.ppdValueFrom := StrToFloatDef(edValueFrom.Text,0);
  PPDebtRec.ppdValueFromStr4SQL := FormatSQLFloatStr(StrToFloatDef(edValueFrom.Text,0));
end;

procedure TfrmDebtDetails.FormShow(Sender: TObject);
begin
  edValueFromChange(edValueFrom);
  edValueFrom.Enabled := bAdd;
  if not bAdd then Record2Form(LPPDebtRec);
end;

procedure TfrmDebtDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmDebtDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

end.
