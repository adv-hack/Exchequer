unit Export;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, expman, FieldSel
  , Menus, ShellAPI, StdCtrls, ExtCtrls, BTSupU1, About, ImgList, csvmapst, BtrvU2;
const
  wm_IconMessage = wm_User;

type
  TfrmeBisExport = class(TForm)
    mnuPopUp: TPopupMenu;
    Close1: TMenuItem;
    ExportIcon: TImage;
    About1: TMenuItem;
    ImageList1: TImageList;
    Help1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ExportManager1: TMenuItem;
    SystemSetup1: TMenuItem;
    EditCSVMappings1: TMenuItem;
    CheckForExport: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Close1Click(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ExportManager1Click(Sender: TObject);
    procedure EditCSVMappings1Click(Sender: TObject);
    procedure SystemSetup1Click(Sender: TObject);
    procedure CheckForExportTimer(Sender: TObject);
 private
    nid : TNotifyIconData;
    bOKToShowMenu : boolean;
    frmAbout: TfrmAbout;
    FrmExportManager : TFrmExportManager;
    frmCSVMapStart : TfrmCSVMapStart;
    procedure GreyOptionsInOut;
 public
    bClosing : boolean;
    frmFieldSelect : TfrmFieldSelect;
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure ShowCSVMappings;
 end;

var
  frmeBisExport: TfrmeBisExport;

implementation

uses
  LicRec, LicUtil, eBusUtil, eBusBtrv, ComCtrls, FileUtil, RunExp;

{$R *.DFM}
{uses
  expman;}

//-----------------------------------------------------------------------

procedure TfrmeBisExport.IconTray(var Msg : TMessage);
{This dictates what happens when a mouse event happens on the tray icon}
var
  Pt : TPoint;
begin
  if bOKToShowMenu then begin
    case Msg.lParam of
      {Right Button Click}
      WM_RBUTTONDOWN : begin
        SetForegroundWindow(Handle);
        GetCursorPos(Pt);
        mnuPopup.Popup(Pt.x, Pt.y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;

      {Double Click Click}
      WM_LBUTTONDBLCLK : begin
        if ExportManager1.Enabled then begin
          SetForegroundWindow(Handle);
          ExportManager1Click(nil);
          PostMessage(Handle, WM_NULL, 0, 0);
        end;{if}
      end;
    end;{case}
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmeBisExport.FormCreate(Sender: TObject);
var
  EnhancedSecurity : smallint;
begin
  case GetModuleLicence(modEbus, GetEnterpriseDirectory) of

    luLicenced : begin

      // OK to continue
      bOKToShowMenu := FALSE;
      bClosing := false;

      with nid do begin
        cbSize := sizeof(nid);
        wnd := Handle;
        uID := 1;
        uCallBackMessage := wm_IconMessage;
        hIcon := ExportIcon.Picture.Icon.Handle;
        szTip := 'Exchequer eBis Export Module';
        uFlags := nif_Message or nif_Icon or nif_Tip;
      end;{with}
      Shell_NotifyIcon(NIM_ADD, @nid);

      frmAbout := nil;
      FrmExportManager := nil;
      frmFieldSelect := nil;
      frmCSVMapStart := nil;

      if not Check4BtrvOK then ShowMessage('Check4BtrvOK Error.');

      bOKToShowMenu := TRUE;
      CheckForExportTimer(nil);
    end;

    luNotLicenced : begin
      ShowNotLicencedMessage('eBusiness');
      bClosing := TRUE;
      PostMessage(Self.Handle,WM_Close,0,0);
    end;

    luError : begin
      ShowLicenceErrorMessage('eBusiness');
      bClosing := TRUE;
      PostMessage(Self.Handle,WM_Close,0,0);
    end;

  end;{case}
end;

//-----------------------------------------------------------------------

procedure TfrmeBisExport.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  Application.ProcessMessages;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisExport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bClosing then begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmeBisExport.Close1Click(Sender: TObject);
begin
  bClosing := True;
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisExport.mnuCloseClick(Sender: TObject);
begin
  bClosing := true;
  Close;
end;

procedure TfrmeBisExport.About1Click(Sender: TObject);
begin
  GreyOptionsInOut;
  if frmAbout = nil then begin
    frmAbout := TfrmAbout.Create(Self);
    try
      frmAbout.ShowModal;
    finally
      frmAbout.Release;
      frmAbout := nil;
    end;{try}
  end;{if}
  GreyOptionsInOut;
end;


procedure TfrmeBisExport.Help1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;


procedure TfrmeBisExport.ExportManager1Click(Sender: TObject);
begin
  GreyOptionsInOut;
  if FrmExportManager = nil then begin
    {Show Export Manager}
    FrmExportManager := TFrmExportManager.Create(self);
    try
      FrmExportManager.ShowModal;
    finally
      FrmExportManager.Release;
      FrmExportManager := nil;
    end;{try}
  end;{if}
  GreyOptionsInOut;
end;

procedure TfrmeBisExport.ShowCSVMappings;
var
  bReopen : boolean;
begin
  if frmCSVMapStart = nil then begin
    frmCSVMapStart := TfrmCSVMapStart.Create(self);
    try
      bReopen := FALSE;
      repeat
        frmCSVMapStart.rbOpen.Enabled := not bReopen;
        if not frmCSVMapStart.rbOpen.Enabled then frmCSVMapStart.rbNew.Checked := TRUE;
        if frmCSVMapStart.Showmodal = mrOK then begin
          if frmFieldSelect = nil then begin
            frmFieldSelect := TfrmFieldSelect.Create(self);
            try
              if frmCSVMapStart.rbOpen.Checked then frmFieldSelect.StartMode := smOpen
              else begin
                if frmCSVMapStart.rbCustomer.Checked then frmFieldSelect.StartMode := smNewCust
                else begin
                  if frmCSVMapStart.rbStock.Checked then frmFieldSelect.StartMode := smNewStock
                  else begin
                    if frmCSVMapStart.rbStockGroup.Checked then frmFieldSelect.StartMode := smNewStockGroup
                    else begin
                      if frmCSVMapStart.rbTransaction.Checked then frmFieldSelect.StartMode := smNewTX;
                    end;{if}
                  end;{if}
                end;{if}
              end;{if}
              frmFieldSelect.sMapFileDirectory := frmCSVMapStart.sMapFileDirectory;
              frmFieldSelect.Showmodal;
            finally
              bReopen := (frmFieldSelect.ModalResult = mrRetry);
              frmFieldSelect.Release;
              frmFieldSelect := nil;
            end;{try}
          end;{if}
        end;{if}
        if frmCSVMapStart.ModalResult = mrCancel then bReopen := FALSE;
      Until bReopen = FALSE;
    finally
      frmCSVMapStart.Release;
      frmCSVMapStart := nil;
    end;{try}
  end;{if}
end;

procedure TfrmeBisExport.EditCSVMappings1Click(Sender: TObject);
begin
  GreyOptionsInOut;
  ShowCSVMappings;
  GreyOptionsInOut;
end;

procedure TfrmeBisExport.SystemSetup1Click(Sender: TObject);
begin
  GreyOptionsInOut;
  ShowEBusSetup;
  GreyOptionsInOut;
  if bClosing then Close;
end;

procedure TfrmeBisExport.CheckForExportTimer(Sender: TObject);
var
  bLock, bDoIt : boolean;
  iLockPos, iStatus : integer;
  NextTimeToDoExport, CurrentNow, CurrentTime{, CurrentDate} : TDateTime;
  EBusBtrieveExport : TEBusBtrieveExport;
  rTimerGap : real;
  iDay : shortint;
const
  SecsInADay = 86400;
  MinsInDay = 1440;
begin
  CheckForExport.Enabled := FALSE;
  CurrentTime := Time;
{  CurrentDate := Date;}
  CurrentNow := Now;
  rTimerGap := 1 / (SecsInADay / (CheckForExport.Interval / 1000));
  EBusBtrieveExport := TEBusBtrieveExport.Create(TRUE);
  with EBusBtrieveExport do begin
    OpenFile;
    IndexesInUse := 1; {so that I can see ALL export records}
    bLock := TRUE;
    {PR 14/10/2008 Because SQL Emulator can't lock except on GetEqual or GetDirect, replace FindRecord here and below with
                   call to SafeLockRecord which finds the record (without locking) using the existing search operation, then
                   locks it using GetDirect.}
//    iStatus := FindRecord(bLock, iLockPos, B_GetFirst);
    iStatus := SafeLockRecord(bLock, iLockPos, B_GetFirst);
    while iStatus = 0 do begin
      with ExportSettings do begin
        bDoIt := FALSE;
        iDay := DayOfWeek(CurrentNow) - 2;
        if iDay = -1 then iDay := 6;

        if (ExptActive > 0)
        and DayBitEnabled(ExptDaysOfWeek,TCalDayOfWeek(iDay)) then begin
          Case ExptTimeType of
            {At time 1 only}
            1 : begin
              if (ABS(ExptTime1 - CurrentTime) <= rTimerGap) {The allocated time for this export is within "Timer Gap" of now}
              and ((ExptLastExportAt = 0) or (ABS(CurrentNow - ExptLastExportAt) > (rTimerGap * 2))) {The last time it was done was either never, or more than "Timer Gap * 2" ago}
              then bDoIt := TRUE;
            end;

            {every x minutes}
            2 : begin
              {Calculate the next time to do this export}
              if ExptLastExportAt = 0 then NextTimeToDoExport := CurrentTime
              else NextTimeToDoExport := ExptLastExportAt + (ExptFrequency / MinsInDay);

              if ((CurrentNow - NextTimeToDoExport) > 1) then NextTimeToDoExport := CurrentTime; {if (last time exported was more than a day ago) then do export}

              ReplaceDate(NextTimeToDoExport, 0);

              {.121}
              if (((NextTimeToDoExport - CurrentTime) <= rTimerGap) {The next time to do this export is within "Timer Gap" of now}
              and (ABS(CurrentNow - ExptLastExportAt) > (rTimerGap * 2))) {The last time it was done was more than "Timer Gap" ago}
              or ((Trunc(Date)) - (Trunc(ExptLastExportAt)) <> 0) // day changed
              then bDoIt := TRUE;

//              if ((NextTimeToDoExport - CurrentTime) <= rTimerGap) {The next time to do this export is within "Timer Gap" of now}
//              and (ABS(CurrentNow - ExptLastExportAt) > (rTimerGap * 2)) {The last time it was done was more than "Timer Gap" ago}
//              then bDoIt := TRUE;
            end;

            {every x minutes between 2 times}
            3 : begin
              {Calculate the next time to do this export}
              if (ExptLastExportAt = 0) then NextTimeToDoExport := CurrentTime {if (never exported) then do export}
              else NextTimeToDoExport := ExptLastExportAt + (ExptFrequency / MinsInDay);

              if ((CurrentNow - NextTimeToDoExport) > 1) then NextTimeToDoExport := CurrentTime; {if (last time exported was more than a day ago) then do export}

              ReplaceDate(NextTimeToDoExport, 0); {Convert to just time}

              {.121}
              if ((CurrentTime >= ExptTime1) and (ExptTime2 >= CurrentTime)) then begin {Current Time is between the 2 input times}
                if (((NextTimeToDoExport - CurrentTime) <= rTimerGap) {The next time to do this export is within "Timer Gap" of now}
                and (ABS(CurrentNow - ExptLastExportAt) > (rTimerGap * 2))) {The last time it was done was more than "Timer Gap" ago}
                or ((Trunc(Date)) - (Trunc(ExptLastExportAt)) <> 0) // day changed
                then bDoIt := TRUE;
              end;{if}

//              if ((NextTimeToDoExport - CurrentTime) <= rTimerGap) {The next time to do this export is within "Timer Gap" of now}
//              and (ABS(CurrentNow - ExptLastExportAt) > (rTimerGap * 2)) {The last time it was done was more than "Timer Gap" ago}
//              and ((CurrentTime >= ExptTime1) and (ExptTime2 >= CurrentTime)) {Current Time is between the 2 input times}
//              then bDoIt := TRUE;
            end;
          end;{case}
        end;{if}

        if bDoIt then
          begin
            ExptLastExportAt := CurrentNow;
            UpdateRecord;
            RunExport(CompanyCode, ExportCode, ExportSettings, FALSE);
            UnlockRecord(iLockPos);

            bLock := TRUE;
//            iStatus := FindRecord(bLock, iLockPos, B_GetFirst);
            iStatus := SafeLockRecord(bLock, iLockPos, B_GetFirst);
          end
        else begin
          UnlockRecord(iLockPos);
          bLock := TRUE;
//          iStatus := FindRecord(bLock, iLockPos, B_GetNext);
          iStatus := SafeLockRecord(bLock, iLockPos, B_GetNext);
        end;{if}
      end;{with}
    end;{while}
    CloseFile;
    Free;
  end;{with}
  CheckForExport.Enabled := TRUE;
end;

procedure TfrmeBisExport.GreyOptionsInOut;
begin
  ExportManager1.Enabled := not ExportManager1.Enabled;
  SystemSetup1.Enabled := not SystemSetup1.Enabled;
  EditCSVMappings1.Enabled := not EditCSVMappings1.Enabled;
  About1.Enabled := not About1.Enabled;
end;

end.
