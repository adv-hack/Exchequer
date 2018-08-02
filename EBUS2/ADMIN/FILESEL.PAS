unit FileSel;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls, SBSPanel;

type
  // Whether to encode 00:00 hours or 23:59 hours in the time portion
  // of a TDateTime variable
  TTimeOfDay = (todStart, todEnd);
  TSelectMode = (selDate, selNumber, selAll);

  TfrmFileSelect = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    radDateRange: TBorRadio;
    radLogNumbers: TBorRadio;
    radAll: TBorRadio;
    grpSelection: TSBSGroup;
    grpDateRange: TSBSGroup;
    edtToDate: TEditDate;
    edtFromDate: TEditDate;
    Label5: TLabel;
    Label6: TLabel;
    grpLogNumbers: TSBSGroup;
    Label4: TLabel;
    Label3: TLabel;
    edtToNumber: Text8Pt;
    edtFromNumber: Text8Pt;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure radButtonClick(Sender: TObject);
  private
    InitialWindowSize : TPoint;
    fFromDate,
    fToDate     : TDateTime;
    fFromLogNum,
    fToLogNum   : longint;
    fSelectMode : TSelectMode;
    procedure SetFromDate(Value : TDateTime);
    procedure SetToDate(Value : TDateTime);
    procedure PopulateDateScreen(Field : TEditDate; SetDate : TDateTime);
    function  PopulateDateField(Field : TEditDate; TimeOfDay : TTimeOfDay) : TDateTime;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    function  DatesOK : boolean;
    function  LogNumbersOK : boolean;
    procedure SetSelectMode(Value : TSelectMode);
    procedure SetLogNum(Index : integer; Value : longint);
  public
    property FromDate : TDateTime read fFromDate write SetFromDate;
    property ToDate : TDateTime read fToDate write SetToDate;
    property FromLogNum : longint index 1 read fFromLogNum write SetLogNum;
    property ToLogNum : longint index 2 read fToLogNum write SetLogNum;
    property SelectMode : TSelectMode read fSelectMode write SetSelectMode;
  end;

var
  frmFileSelect: TfrmFileSelect;

implementation

{$R *.DFM}

uses
  BtSupU1, EBusUtil, AdmnUtil;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.SetSelectMode(Value : TSelectMode);
begin
  fSelectMode := Value;
  case Value of
    selDate : radDateRange.Checked := true;
    selNumber : radLogNumbers.Checked := true;
    selAll : radAll.Checked := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.SetLogNum(Index : integer; Value : longint);
begin
  case Index of
    1: begin
         fFromLogNum := Value;
         edtFromNumber.Text := Format('%.6d', [Value]);
       end;
    2: begin
         fToLogNum := Value;
         edtToNumber.Text := Format('%.6d', [Value]);
       end;
  end;
end; // TfrmFileSelect.SetLogNum

//-----------------------------------------------------------------------

procedure TfrmFileSelect.btnOKClick(Sender: TObject);
begin
  if ((SelectMode = selDate) and DatesOK) or
    ((SelectMode = selNumber) and LogNumbersOK) or (SelectMode = selAll) then
    SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, 1);
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.btnCancelClick(Sender: TObject);
begin
  SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.SetFromDate(Value : TDateTime);
begin
  fFromDate := Value;
  PopulateDateScreen(edtFromDate, Value);
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.SetToDate(Value : TDateTime);
begin
  fToDate := Value;
  PopulateDateScreen(edtToDate, Value);
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.PopulateDateScreen(Field : TEditDate; SetDate : TDateTime);
var
  Year, Month, Day : word;
begin
  // Use Decode date as TEditDate uses a fixed format of dd/mm/yyyy
  // DateToStr uses the Windows current date format setting
  DecodeDate(SetDate, Year, Month, Day);
  Field.Text := Format('%.2d',[Day]) + Format('%.2d',[Month]) + IntToStr(Year);
end; // TfrmDateRangeSelect.PopulateDateScreen

//-----------------------------------------------------------------------

function TfrmFileSelect.PopulateDateField(Field : TEditDate;
  TimeOfDay : TTimeOfDay) : TDateTime;
begin
  Result := EncodeDate(StrToInt(copy(Field.Text,5,4)), StrToInt(copy(Field.Text,3,2)),
    StrToInt(copy(Field.Text,1,2)));
  if TimeOfDay = todEnd then
    Result := Result + EncodeTime(23, 59, 59, 99);
end; // TfrmFileSelect.PopulateDateField

//-----------------------------------------------------------------------

procedure TfrmFileSelect.WMSysCommand(var Message : TMessage);
begin
  with Message do
    case WParam of
      SC_Maximize :
        begin
          ClientHeight := InitialWindowSize.X;
          ClientWidth := InitialWindowSize.Y;
          WParam := 0;
        end;
      SC_Close :
        btnCancelClick(self);
    end; // case
  inherited;
end; // TfrmDateRangeSelect.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmFileSelect.FormCreate(Sender: TObject);
begin
  InitialWindowSize.X := ClientHeight;
  InitialWindowSize.Y := ClientWidth;
end;

//-----------------------------------------------------------------------

procedure TfrmFileSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
end;

//-----------------------------------------------------------------------

function TfrmFileSelect.LogNumbersOK : boolean;
begin
  Result := true;
  FromLogNum := StrToInt(Trim(edtFromNumber.Text));
  ToLogNum := StrToInt(Trim(edtToNumber.Text));

  if FromLogNum > ToLogNum then
  begin
    MessageDlg('''From number'' must be less than the ''To number''', mtError, [mbOK], 0);
    Result := false;
  end;
end; // TfrmFileSelect.LogNumbersOK

//-----------------------------------------------------------------------

function TfrmFileSelect.DatesOK : boolean;
begin
  Result := true;
  FromDate := PopulateDateField(edtFromDate, todStart);
  ToDate := PopulateDateField(edtToDate, todEnd);
  if FromDate > ToDate then
  begin
    MessageDlg('''From Date'' must be earlier than the ''To Date''', mtError, [mbOK], 0);
    Result := false;
  end;
end; // TfrmFileSelect.DatesOK

//-----------------------------------------------------------------------

procedure TfrmFileSelect.radButtonClick(Sender: TObject);
begin
  if radDateRange.Checked then
    SelectMode := selDate;
  if radLogNumbers.Checked then
    SelectMode := selNumber;
  if radAll.Checked then
    SelectMode := selAll;

  grpDateRange.Enabled := radDateRange.Checked;
  grpLogNumbers.Enabled := radLogNumbers.Checked;
end;

end.
