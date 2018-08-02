unit ConfigF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, TCustom, EnterToTab, ComCtrls, Enterprise01_TLB;

type
  TfrmSchedulerSettings = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    GroupBox1: TGroupBox;
    gbEmailAddress: TGroupBox;
    edtEmail: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EnterToTab1: TEnterToTab;
    dtStart: TDateTimePicker;
    dtEnd: TDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSchedulerSettings: TfrmSchedulerSettings;

  function UpdateSettings : Boolean;

implementation

{$R *.dfm}
uses
  DataObjs, SchedVar;

function UpdateSettings : Boolean;
var
  Res, ht : Integer;
begin
  with TfrmSchedulerSettings.Create(Application) do
  Try
    if oToolkit.SystemSetup.ssReleaseCodes.rcPaperless = rcDisabled then
    begin
      gbEmailAddress.Visible := False;
      ht := gbEmailAddress.Height;
      Height := Height - ht;
      btnOK.Top := btnOK.Top - ht;
      btnCancel.Top := btnOK.Top;
    end;

    Res := ConfigObject.GetRecord(True);
    if Res in [4, 9] then
    begin
      Res := ConfigObject.SaveRecord(True);
      Res := ConfigObject.GetRecord(True);
    end;

    if Res = 0 then
    begin
{      edtStartPeriod.Text := FormatDateTime('hh:nn', ConfigObject.StartTime);
      edtEndPeriod.Text := FormatDateTime('hh:nn', ConfigObject.EndTime);}
      dtStart.Time := ConfigObject.StartTime;
      dtEnd.Time := ConfigObject.EndTime;
      edtEmail.Text := Trim(ConfigObject.EmailAddress);
      ActiveControl := dtStart;
      ShowModal;
      if ModalResult = mrOk then
      begin
{        ConfigObject.StartTime := StrToDateTime(edtStartPeriod.Text);
        ConfigObject.EndTime := StrToDateTime(edtEndPeriod.Text);}
        ConfigObject.StartTime := dtStart.Time;
        ConfigObject.EndTime := dtEnd.Time;

        ConfigObject.EmailAddress := Trim(edtEmail.Text);
        Res := ConfigObject.SaveRecord;
        if Res <> 0 then
          DoMessage('Unable to store Settings record. Error ' + IntToStr(Res));
      end
      else
        ConfigObject.UnlockRecord;
    end
    else
    if Res in [84, 85] then
      DoMessage('Settings record is locked by another user')
    else
      DoMessage('Unable to load settings record. Btrieve error ' + IntToStr(Res));

  Finally
    Free;
  End;
end;

end.
