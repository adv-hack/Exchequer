unit SetDateRangeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GENENTU, ExtCtrls, StdCtrls, bkgroup, ComCtrls, TEditVal, Mask;

type
  TSetDateRangeFrm = class(TTestCust)
    TitleLbl: TLabel;
    FromDateTxt: TEditDate;
    ToDateTxt: TEditDate;
    FromDateLbl: Label8;
    ToDateLbl: Label8;
    ErrorLbl: TLabel;
    procedure FromDateTxtChange(Sender: TObject);
    procedure ToDateTxtChange(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
    function IsValid: Boolean;
    procedure ClearError;
    procedure OnError(ErrorMsg: string; Control: TEditDate);
  public
    { Public declarations }
  end;

function Get_DateRange(var FromDate, ToDate: string): Boolean;

var
  SetDateRangeFrm: TSetDateRangeFrm;

implementation

{$R *.dfm}

uses
  ProgU;

// -----------------------------------------------------------------------------

function Get_DateRange(var FromDate, ToDate: string): Boolean;
var
  Dlg: TSetDateRangeFrm;
begin
  Result := False;

  Dlg := TSetDateRangeFrm.Create(nil);

  try
    Result := (Dlg.ShowModal = mrOK);

    if (Result) then
    with Dlg do
    begin
      FromDate := FromDateTxt.DateValue;
      ToDate   := ToDateTxt.DateValue;
    end
    else
    begin
      Write_FixMsgFmt('Special Function has been aborted.', 4);
    end;

  finally
    Dlg.Free;
  end;

end;

// =============================================================================
// TSetDateRangeFrm
// =============================================================================

procedure TSetDateRangeFrm.ClearError;
begin
  ErrorLbl.Caption := '';
end;

// -----------------------------------------------------------------------------

function TSetDateRangeFrm.IsValid: Boolean;
begin
  if (FromDateTxt.DateValue > ToDateTxt.DateValue) then
  begin
    OnError('"To" data cannot be less than "From" date', ToDateTxt);
    Result := False;
  end
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

procedure TSetDateRangeFrm.OnError(ErrorMsg: string; Control: TEditDate);
begin
  ErrorLbl.Caption := ErrorMsg;
  if Control.CanFocus then
    Control.SetFocus;
end;

// -----------------------------------------------------------------------------

procedure TSetDateRangeFrm.FromDateTxtChange(Sender: TObject);
begin
  inherited;
  ClearError;
end;

// -----------------------------------------------------------------------------

procedure TSetDateRangeFrm.ToDateTxtChange(Sender: TObject);
begin
  inherited;
  ClearError;
end;

// -----------------------------------------------------------------------------

procedure TSetDateRangeFrm.OkCP1BtnClick(Sender: TObject);
begin
  if IsValid then
    ModalResult := mrOk;
end;

// -----------------------------------------------------------------------------

end.
