unit Comms;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AdPacket, OoMisc, AdPort, MPComms, Procs, VarConst, CardProc, SyncObjs;

const
  mpcGetBalance = 1;
  mpcGetTills = 2;
  mpcWaitForBalance = 3;
  mpcWaitForTillName = 4;

type
  TFrmComms = class(TForm)
    MPComms: TMPComms;
    ComPort: TApdComPort;
    DataPacket: TApdDataPacket;
    Timer: TTimer;
    procedure MPCommsReceiveData(Command: TCommand);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MPCommsCommsFail(Command: TCommand);
  private
    bFail, bTillsOK : boolean;
    iBalance : integer;
    procedure WMMPComms(var Message : TMessage); message WM_MPComms;
  public
    function Till_OnLine(iTillNo : Byte): boolean;
    function WaitForBalance(iTillNo : byte; iTrackNo : integer; var iRetBalance : integer) : boolean;
    procedure SetBalance(iBalance : Integer; iTillNo : Integer; bWait : boolean);
  end;

var
  FrmComms: TFrmComms;

implementation

uses Cardlist, MainF, Carddet, startup;

{$R *.DFM}

procedure TFrmComms.WMMPComms(var Message : TMessage);
{This is what to do when this form receives a message of type WM_MPComms}
begin
  with Message do begin
    case WParam of
      mpcGetBalance : begin
        MPComms.CancelTransfersRef(mpcGetBalance);
        MPComms.QCommand(cmdGetMemberInfo, 0, mpcGetBalance, lParam, 0, nil);
      end;

      mpcGetTills : begin
        MPComms.QCommand(cmdGetTXWordInfo, 0, mpcGetTills, 59, 0, nil)
      end;{if}
    end;{case}
  end;{with}
end;

procedure TFrmComms.MPCommsReceiveData(Command: TCommand);
{This gets triggered each time the MPComms object sucessfully finishes a command}
begin
  Command.Read := TRUE;
  Case Command.Reference of
    mpcGetBalance : begin
      agBalances[Command.TillNo].Balance := StrToInt(TMemSalesInfo(Command.Data).NewBalance.Value) * CalcSign(TMemSalesInfo(Command.Data).NewBalance.Sign);
      if (FrmMain.FrmCardList2 <> nil) and (FrmMain.FrmCardList2.FrmCardDetails <> nil)
      then SendMessage(FrmMain.FrmCardList2.FrmCardDetails.Handle,WM_MPComms,mpcGetBalance,agBalances[BestTill].Balance);
    end;

    mpcGetTills : begin
      if FrmStartup <> nil then begin
        {update startup form}
        with FrmStartup do begin
          inc(iTillsFound);
          lbTills.Items.Add(TTXWordInfo(Command.Data).Word);
          CheckForLastTill(Command.TillNo);
        end;{with}
      end;{if}
    end;

    mpcWaitForBalance : begin
      agBalances[Command.TillNo].Balance := StrToInt(TMemSalesInfo(Command.Data).NewBalance.Value) * CalcSign(TMemSalesInfo(Command.Data).NewBalance.Sign);
      if Command.TillNo = Syss.NoTills then iBalance := agBalances[BestTill].Balance;
    end;
  end;{case}
end;

procedure TFrmComms.FormCreate(Sender: TObject);
begin
  {initialise MPComms Object}
  with Syss do MPComms.SetProperties(igBaudRate, igCommsTimeout, igComPortNo, igDefaultRetries, NoTills
  , bgVerifySends, sgLogFile, mplxChar, Mux2Char);
  MPComms.Enabled := Live;
  bgCommsWorking := MPComms.Enabled;
end;

procedure TFrmComms.FormDestroy(Sender: TObject);
begin
  if bgCommsWorking then MPComms.Enabled := FALSE;
end;

procedure TFrmComms.MPCommsCommsFail(Command: TCommand);
{This gets triggered each time the MPComms object fails to finish a command}
begin
  Command.Read := TRUE;
  bFail := TRUE;
  case Command.Reference of
    mpcGetTills : if {FrmMain.}FrmStartup <> nil then {FrmMain.}FrmStartup.CheckForLastTill(Command.TillNo);

    mpcWaitForBalance : begin
      agBalances[Command.TillNo].Balance := 0;
      if Command.TillNo = Syss.NoTills then iBalance := agBalances[BestTill].Balance;
    end;

    mpcWaitForTillName : bTillsOK := FALSE;
  end;{case}
end;

function TFrmComms.WaitForBalance(iTillNo : byte; iTrackNo : integer; var iRetBalance : integer) : boolean;
var
  iPos : byte;
  bResult : boolean;
begin
  iBalance := 0;
  if bgCommsWorking then
    begin
      bFail := FALSE;
      For iPos := 1 to Syss.NoTills do agBalances[iPos].Score := 0; {zero scores}
      MPComms.DoCommand(cmdGetMemberInfo, iTillNo, mpcWaitForBalance, iTrackNo, 0, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  if not bResult then msgBox('Till Comms Failed,' + CHR(13) + CHR(13)
  + '  Command : WaitForBalance' + CHR(13) + '  TillNo : '
  + IntToStr(iTillNo) + CHR(13) + '  TrackNo : ' + IntToStr(iTrackNo)
  ,mtWarning,[mbOK],mbOK,'Till Comms');
  iRetBalance := iBalance;
  Result := bResult;
end;

function TFrmComms.Till_OnLine(iTillNo : Byte): boolean;
begin
  bTillsOK := bgCommsWorking;
  if bgCommsWorking then MPComms.DoCommand(cmdGetTXWordInfo, iTillNo, mpcWaitForTillName, 59, 0, nil);
  Till_OnLine := bTillsOK;
end;

procedure TFrmComms.SetBalance(iBalance : Integer; iTillNo : Integer; bWait : boolean);
var
  BalanceInfo : TBalanceInfo;
begin
  if bgCommsWorking then begin
    BalanceInfo := TBalanceInfo.Create(iBalance);
    if bWait then FrmComms.MPComms.DoCommand(cmdSendMemberInfo, 0, 0, iTillNo, 0, BalanceInfo)
    else FrmComms.MPComms.QCommand(cmdSendMemberInfo, 0, 0, iTillNo, 0, BalanceInfo);
  end;{if}
end;

end.
