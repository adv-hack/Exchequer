unit PerHook;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EntCustom, Enterprise_TLB, PerUtil;

type
  TfrmPeriodHook = class(TForm)
    EntCustom1: TEntCustom;
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Connect(ComCustomisation: ICOMCustomisation);
    procedure EntCustom1Hook(EventData: ICOMEventData);
    procedure EntCustom1Close;
  private
    PeriodCalc : TPeriodCalc;
    procedure SetFocusToEnterprise(Sender : TObject);
  public
  end;

var
  frmPeriodHook: TfrmPeriodHook;

  procedure LocalMessageDlg(sMessage : string);

implementation

{$R *.DFM}

var
  LocalSysFunc : ICOMSysFunc;


procedure TfrmPeriodHook.FormCreate(Sender: TObject);
begin
  EntCustom1.Connect;
end;

//------------------------------------------------------------------------------

procedure TfrmPeriodHook.SetFocusToEnterprise(Sender : TObject);
begin
  // Return the focus to Enterprise
  SetForegroundWindow(EntCustom1.Intf.SysFunc.hWnd);
end;

//------------------------------------------------------------------------------

procedure TfrmPeriodHook.EntCustom1Connect(ComCustomisation: ICOMCustomisation);
begin
  with ComCustomisation do
  begin
    // Transaction header - Period Hooks
    EnableHook(wiTransaction, 8);   // Exit - Period/Year
    EnableHook(wiTransaction, 80);  // Set Period/Year from TransDate
  end;
  PeriodCalc := TPeriodCalc.Create;
  PeriodCalc.AfterPeriodHookError := SetFocusToEnterprise;
  PeriodCalc.EntMessageDlg := LocalMessageDlg;
end; // TfrmPeriodHook.EntCustom1Connect

//------------------------------------------------------------------------------

procedure TfrmPeriodHook.EntCustom1Hook(EventData: ICOMEventData);
var
  pMessage : pChar;
begin
  try
    with EntCustom1, EventData do
      if (WindowId = wiTransaction) and (HandlerId in [8, 80]) then
        with PeriodCalc do
        begin
          EntVersion := IntF.VersionInfo.VersionStr;
          LoggedInUser := IntF.UserName;
          CompanyDirectory := IntF.SystemSetup.ssDataPath;
          TransDate := Transaction.thTransDate;

          LocalSysFunc := IntF.SysFunc;
          if ConvertDateToPeriod then
          begin
            Transaction.thPeriod := Period;
            Transaction.thYear := Year;
          end;
          LocalSysFunc := nil;
        end;
  except
    On Ex:Exception Do begin
      pMessage := StrAlloc(255);
      pMessage := StrPCopy(pMessage, 'An error occured processing the period hook:' + #13#10 + Ex.Message);
      MessageBox(EntCustom1.Intf.SysFunc.hWnd,pMessage,'Exception',MB_OK + MB_ICONERROR + MB_SYSTEMMODAL);
      StrDispose(pMessage);
    end;{on}
  end; // except
end; // TfrmPeriodHook.EntCustom1Hook

//------------------------------------------------------------------------------

procedure TfrmPeriodHook.EntCustom1Close;
begin
  PeriodCalc.Free;
  Application.Terminate;
end;

procedure LocalMessageDlg(sMessage : string);
begin
  LocalSysFunc.EntMessageDlg(emtError, sMessage, embOK);
end;


end.
