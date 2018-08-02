unit Comms;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, AdPacket
  , OoMisc, AdPort, MPComms, NeilProc, VarConst, CardProc, SyncObjs, StrUtil,
  AdStatLt;

type
  TFrmComms = class(TForm)
    MPComms: TMPComms;
    ComPort: TApdComPort;
    DataPacket: TApdDataPacket;
    Timer: TTimer;
    ApdSLController1: TApdSLController;
    procedure MPCommsReceiveData(Command: TCommand);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MPCommsCommsFail(Command: TCommand);
  private
    bTillsOK : boolean;
    iBalance : integer;
    rBalance : real;
    MemSalesRec : TMemSalesRec;
    TotTransRec : TTotTransRec;
    GroupRec : TGroupRec;
    DeptRec : TDeptRec;
    ProductRec : TProductRec;
    MaxRec : TMaximumsRec;
    aPLURecs : TaPLURecs;
    aHourSalesRecs : TaHourSalesRecs;
    aClerkData : TaClerkData;
    aClerkRec : TaClerkRec;
    aTransInfo : TaTransInfo;
    aCashierSales : TaCashierSales;
    CardRec : TCardRec;
{    function ClearSalesData(cType : char) : boolean;}
  public
    bFail : boolean;
    iGoodTill : byte;
    iCurrentCardNo : integer; {yes I know this is a bit nasty but I don't want to break the comms}
    function Till_OnLine(iTillNo : Byte): boolean;
    function WaitForBalance(iTillNo : byte; iTrackNo : integer; var iRetBalance : integer) : boolean;
    function WaitForMemberInfo(iTillNo : byte; iTrackNo : integer; var RetMemSalesRec : TMemSalesRec) : boolean;
    function WaitForTransInfo(iTillNo : byte; iTXTransNo : integer; var RetTotTransRec : TTotTransRec) : boolean;
    procedure SetBalance(iTillNo : byte; iNewBalance : Integer; iTrackNo : Integer; bWait : boolean);
    function SetTransInfo(iTillNo : byte; iTXTransNo : integer; TotTransRec : TTotTransRec; bWait : boolean) : boolean;
    function WaitForGroupInfo(iTillNo : byte; iTitleNo : integer; var RetGroupRec : TGroupRec) : boolean;
    function WaitForDeptInfo(iTillNo : byte; iDeptNo : integer; var RetDeptRec : TDeptRec) : boolean;
    function WaitForProductInfo(iTillNo : byte; iPLUNo : integer; var RetProductRec : TProductRec) : boolean;
    function GetScreenBalance(iTrackNo : integer; bWait : boolean) : boolean;
    function GetTillName(iWordNo : integer; bWait : boolean; iTillNo : integer = 0) : boolean;
    function SetMemberInfo(iTillNo : byte; MemSalesRec : TMemSalesRec; bBlank, bWait : boolean) : boolean;
    function GetBestBalance(iCardNo, iTrackNo : integer; bWait : boolean) : real;
    function GetTillBalance(iTrackNo, iTillNo : integer; bWait : boolean) : Real;
    function CheckBalsSame(iTrackNo : integer) : Boolean;
    function GetMaxGuests(iTillNo : integer; bWait : boolean) : TMaximumsRec;
    function GetPLUSales(iTillNo : integer; bWait : boolean; var aRetPLURec : TaPLURecs) : boolean;
    function GetHourlySales(iTillNo : integer; bWait : boolean; var aRetHourSalesRecs : TaHourSalesRecs) : boolean;
    function GetClerkRec(iTillNo : integer; bWait : boolean; var aRetClerkRec : TaClerkRec) : boolean;
    function GetClerkData(iTillNo : integer; bWait : boolean; var aRetClerkData : TaClerkData) : boolean;
    function GetCashierSales(iTillNo : integer; var aRetCashierSales : TaCashierSales) : boolean;
    function ClearTransactionData(aTransData : array of TaTransInfo) : boolean;
    function ClearHourlyData(iTillNo : byte; aHourSalesRecs : TaHourSalesRecs) : boolean;
    function ClearPLUData(iTillNo : byte; aPLURecs : TaPLURecs) : boolean;
    function ClearClerkData(iTillNo : byte) : boolean;
    function ClearCashierData(iTillNo : byte; aCashierSales : TaCashierSales) : boolean;
    function GetAllTransData(iTillNo : integer; bWait : boolean; var aRetTransInfo : TaTransInfo) : boolean;
    function GetCardInfo(iTillNo : byte; iTrackNo : integer; var RetCardRec : TCardRec) : boolean;
  end;

var
  FrmComms: TFrmComms;

implementation

uses
  {$IFNDEF CARDTK}Cardlist, MainF, Carddet, startup, {$ENDIF} MathUtil;

{$R *.DFM}

procedure TFrmComms.MPCommsReceiveData(Command: TCommand);
{This gets triggered each time the MPComms object sucessfully finishes a command}
var
  iSuccess : integer;
begin
  bFail := FALSE;
  Command.Read := TRUE;
  Case Command.CommandType of
    cmdGetScreenBalance : begin
      with TMemSalesInfo(Command.Data).MemSalesRec do begin
        agBalances[Command.TillNo].Balance := TillStrToInt(NewBalance.Value, NewBalance.Sign);
        if Command.Success then iSuccess := 1
        else iSuccess := -1;

        {$IFNDEF CARDTK}
          if (FrmMain.FrmCardList2 <> nil) and (FrmMain.FrmCardList2.FrmCardDetails <> nil)
          then SendMessage(FrmMain.FrmCardList2.FrmCardDetails.Handle,WM_MPComms,iSuccess,agBalances[BestTill(iCurrentCardNo,StrToInt(TrackNo))].Balance);
        {$ENDIF}
      end;{with}
    end;

    cmdGetBestBalance : begin
      with TMemSalesInfo(Command.Data).MemSalesRec do begin
        agBalances[Command.TillNo].Balance := TillStrToInt(NewBalance.Value, NewBalance.Sign);
        if Command.TillNo = Syss.NoTills then iGoodTill := BestTill(iCurrentCardNo,StrToInt(TrackNo));
        rBalance := agBalances[iGoodTill].Balance / 100;
      end;{with}
    end;

    cmdGetBalance : begin
      with TMemSalesInfo(Command.Data).MemSalesRec do begin
        rBalance := TillStrToReal(NewBalance.Value, NewBalance.Sign);
      end;{with}
    end;

    cmdGetTillName : begin
      {$IFNDEF CARDTK}
        if FrmStartup <> nil then begin
          {update startup form}
          with FrmStartup do begin
            inc(iTillsFound);
            lvTills.Items[Command.TillNo - 1].SubItems[2] := TTXWordInfo(Command.Data).Word;
            if TrimString(psRight,lvTills.Items[Command.TillNo - 1].SubItems[2],' ')
            = TrimString(psRight,lvTills.Items[Command.TillNo - 1].SubItems[1],' ')
            then lvTills.Items[Command.TillNo - 1].Subitems[3] := 'Yes'
            else lvTills.Items[Command.TillNo - 1].Subitems[3] := 'No';
            CheckForLastTill(Command.TillNo);
          end;{with}
        end;{if}
      {$ENDIF}
    end;

    cmdWaitForBalance : begin
      with TMemSalesInfo(Command.Data).MemSalesRec do begin
        agBalances[Command.TillNo].Balance := TillStrToInt(NewBalance.Value, NewBalance.Sign);
        if Command.TillNo = Syss.NoTills then iBalance := agBalances[BestTill(iCurrentCardNo,StrToInt(TrackNo))].Balance
        else iBalance := agBalances[Command.TillNo].Balance; {.032}
      end;{with}
    end;

    cmdWaitForMemberInfo : MemSalesRec := TMemSalesInfo(Command.Data).MemSalesRec;

    cmdWaitForTransInfo : begin
      with TotTransRec do begin
        Qty := Qty + SafeDiv(StrToIntDef(TTransInfo(Command.Data).TransRec.pQty,0),100);
        Amount := Amount + TillStrToReal(TTransInfo(Command.Data).TransRec.pAmount
        , TTransInfo(Command.Data).TransRec.pSign);
      end;{with}
    end;

    cmdWaitForGroupInfo : GroupRec := TGroupInfo(Command.Data).GroupRec;
    cmdWaitForDeptInfo : DeptRec := TDeptInfo(Command.Data).DeptRec;
    cmdWaitForProductInfo : ProductRec := TProductInfo(Command.Data).ProductRec;
    cmdGetMaximums : MaxRec := TMaxInfo(Command.Data).MaxRec;
    cmdGetAllPLUSales : aPLURecs := TPLUSalesInfo(Command.Data).aPLURecs;
    cmdGetAllHourlySales : aHourSalesRecs := TAllHourSalesInfo(Command.Data).aHourSalesRecs;
    cmdGetAllClerkData : aClerkData := TAllClerkData(Command.Data).aClerks;
    cmdGetAllClerkInfo : aClerkRec := TAllClerkRec(Command.Data).aClerkRec;
    cmdGetAllTransInfo : begin
      if Command.Data <> nil then aTransInfo := TAllTransInfo(Command.Data).aTransRec;
    end;

    cmdGetAllCashierSales : aCashierSales := TAllCashierSales(Command.Data).aCashierSales;
    cmdGetCardInfo : CardRec := TCardInfo(Command.Data).CardRec;
  end;{case}
end;

procedure TFrmComms.FormCreate(Sender: TObject);
begin
  {initialise MPComms Object}
{  Showmessage('igBaudRate : ' + IntToStr(igBaudRate) + #13
  + 'igCommsTimeout : ' + IntToStr(igCommsTimeout) + #13
  + 'igComPortNo : ' + IntToStr(igComPortNo) + #13
  + 'igDefaultRetries : ' + IntToStr(igDefaultRetries) + #13
  + 'NoTills : ' + IntToStr(Syss.NoTills) + #13
  + 'bgVerifySends : ' + IntToStr(Ord(bgVerifySends)) + #13
  + 'sEXEDir : ' + sEXEDir + #13
  + 'sgLogFile : ' + sgLogFile + #13
  + 'mplxChar : ' + Syss.mplxChar + #13
  + 'Mux2Char : ' + Syss.Mux2Char + #13
  + 'FourMbEproms : ' + IntToStr(Ord(Syss.FourMbEproms)) + #13
  + 'WincardVersion : ' + WincardVersion);}

  with Syss do MPComms.SetProperties(igBaudRate, igCommsTimeout, igComPortNo, igDefaultRetries
  , NoTills, bgVerifySends, sEXEDir + sgLogFile, mplxChar, Mux2Char, FourMbEproms
  , WincardVersion, sEXEDir, bgDetailedCommsLog, igMuxPause, bgLogBigErrors, AssumeMUXSwitchesOK);
  MPComms.Enabled := Live;
  SetCommsWorking(MPComms.Enabled);
end;

procedure TFrmComms.FormDestroy(Sender: TObject);
begin
  if bgCommsWorking then MPComms.Enabled := FALSE;
end;

procedure TFrmComms.MPCommsCommsFail(Command: TCommand);
{This gets triggered each time the MPComms object fails to finish a command}
var
  iSuccess : integer;
begin
  Command.Read := TRUE;
  bFail := TRUE;
  case Command.CommandType of
    cmdGetTillName : {$IFNDEF CARDTK}if FrmStartup <> nil then FrmStartup.CheckForLastTill(Command.TillNo){$ENDIF};

    cmdWaitForBalance : begin
      agBalances[Command.TillNo].Balance := 0;
      if Command.TillNo = Syss.NoTills then iBalance := agBalances[BestTill(iCurrentCardNo
      ,StrToInt(TMemSalesInfo(Command.Data).MemSalesRec.TrackNo))].Balance;
    end;

    cmdTillOnLine : bTillsOK := FALSE;

    cmdGetScreenBalance : begin
      agBalances[Command.TillNo].Balance := 0;
      if Command.Success then iSuccess := 1
      else iSuccess := -1;
      {$IFNDEF CARDTK}
        if (Command.TillNo = Syss.NoTills) and (FrmMain.FrmCardList2 <> nil) and (FrmMain.FrmCardList2.FrmCardDetails <> nil)
        then SendMessage(FrmMain.FrmCardList2.FrmCardDetails.Handle,WM_MPComms,iSuccess
        ,agBalances[BestTill(iCurrentCardNo
        ,StrToInt(TMemSalesInfo(Command.Data).MemSalesRec.TrackNo))].Balance);
      {$ENDIF}
    end;

    cmdGetBestBalance : begin
      agBalances[Command.TillNo].Balance := 0;
      if Command.TillNo = Syss.NoTills then begin
        {if Command.TillNo = Syss.NoTills
        then }
        if Command.Data <> nil then iGoodTill := BestTill(iCurrentCardNo,StrToInt(TMemSalesInfo(Command.Data).MemSalesRec.TrackNo));
        rBalance := agBalances[iGoodTill].Balance / 100;
      end;{if}
    end;

    cmdGetBalance : rBalance := 0;
  end;{case}
end;

function TFrmComms.WaitForBalance(iTillNo : byte; iTrackNo : integer; var iRetBalance : integer) : boolean;
var
  iPos : byte;
  bResult : boolean;
begin
  iCurrentCardNo := -1;
  if iTillNo = 100 then iTillNo := iGoodTill;
  iBalance := 0;
  if bgCommsWorking then
    begin
      bFail := FALSE;
      For iPos := 1 to Syss.NoTills do agBalances[iPos].Score := 0; {zero scores}
      MPComms.DoCommand(cmdWaitForBalance, iTillNo, iTrackNo, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  iRetBalance := iBalance;
  Result := bResult;
end;

function TFrmComms.Till_OnLine(iTillNo : Byte): boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  bTillsOK := TRUE;
  MPComms.DoCommand(cmdTillOnLine, iTillNo, 59, -1, nil);
  SetCommsWorking(bTillsOK);
  Result := bTillsOK;
end;

procedure TFrmComms.SetBalance(iTillNo : byte; iNewBalance : Integer; iTrackNo : Integer; bWait : boolean);
var
  BalanceInfo : TBalanceInfo;
begin
  if bgCommsWorking then begin
    BalanceInfo := TBalanceInfo.CreateFrom(iNewBalance);
    if bWait then FrmComms.MPComms.DoCommand(cmdSetBalance, iTillNo, iTrackNo, -1, BalanceInfo)
    else FrmComms.MPComms.QCommand(cmdSetBalance, iTillNo, iTrackNo, -1, BalanceInfo);
  end;{if}
end;

function TFrmComms.WaitForMemberInfo(iTillNo : byte; iTrackNo : integer; var RetMemSalesRec : TMemSalesRec) : boolean;
var
  bCommsOK : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  bCommsOK := FALSE;
  while not bCommsOK do begin
    MPComms.DoCommand(cmdWaitForMemberInfo, iTillNo, iTrackNo, -1, nil);
    bCommsOK := not bFail;
  end;{while}

  RetMemSalesRec := MemSalesRec;
  Result := bCommsOK;
end;

function TFrmComms.WaitForTransInfo(iTillNo : byte; iTXTransNo : integer; var RetTotTransRec : TTotTransRec) : boolean;
var
  bResult : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  if bgCommsWorking then
    begin
      bFail := FALSE;
      TotTransRec.Qty := 0;
      TotTransRec.Amount := 0;
      MPComms.DoCommand(cmdWaitForTransInfo, iTillNo, iTXTransNo, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  RetTotTransRec := TotTransRec;
  Result := bResult;
end;

function TFrmComms.SetTransInfo(iTillNo : byte; iTXTransNo : integer; TotTransRec : TTotTransRec; bWait : boolean) : boolean;
var
  TransInfo : TTransInfo;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  if bgCommsWorking then begin

    with TotTransRec do TransInfo := TTransInfo.CreateFrom(RealToTillStr(Qty,6)
    , RealToTillStr(Amount,10), CalcSignBytes(Trunc(Amount * 100)));

    if bWait then FrmComms.MPComms.DoCommand(cmdSetTransInfo, iTillNo, iTXTransNo, -1, TransInfo)
    else FrmComms.MPComms.QCommand(cmdSetTransInfo, iTillNo, iTXTransNo, -1, TransInfo);
  end;{if}
end;

function TFrmComms.WaitForGroupInfo(iTillNo : byte; iTitleNo : integer; var RetGroupRec : TGroupRec) : boolean;
var
  bResult : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdWaitForGroupInfo, iTillNo, iTitleNo, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  RetGroupRec := GroupRec;
  Result := bResult;
end;

function TFrmComms.WaitForDeptInfo(iTillNo : byte; iDeptNo : integer; var RetDeptRec : TDeptRec) : boolean;
var
  bResult : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
{  iBalance := 0;}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdWaitForDeptInfo, iTillNo, iDeptNo, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  RetDeptRec := DeptRec;
  Result := bResult;
end;

function TFrmComms.WaitForProductInfo(iTillNo : byte; iPLUNo : integer; var RetProductRec : TProductRec) : boolean;
var
  bResult : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdWaitForProductInfo, iTillNo, iPLUNo, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  RetProductRec := ProductRec;
  Result := bResult;
end;

function TFrmComms.GetScreenBalance(iTrackNo : integer; bWait : boolean) : boolean;
var
  iPos : integer;
begin
  iCurrentCardNo := -1;
  For iPos := 1 to Syss.NoTills do agBalances[iPos].Score := 0;
  MPComms.CancelTransfersType(cmdGetScreenBalance);
  if bWait then MPComms.DoCommand(cmdGetScreenBalance, 0, iTrackNo, -1, nil)
  else MPComms.QCommand(cmdGetScreenBalance, 0, iTrackNo, -1, nil);
end;

function TFrmComms.GetTillName(iWordNo : integer; bWait : boolean; iTillNo : integer = 0) : boolean;
begin
  if bWait then MPComms.DoCommand(cmdGetTillName, iTillNo, iWordNo, 0, nil)
  else MPComms.QCommand(cmdGetTillName, iTillNo, iWordNo, 0, nil);
end;

function TFrmComms.SetMemberInfo(iTillNo : byte; MemSalesRec : TMemSalesRec; bBlank, bWait : boolean) : boolean;
var
  CommandType : TCommandType;
  MemSalesInfo : TMemSalesInfo;
  CheckMemSalesRec : TMemSalesRec;
  iTries : integer;
begin
  if bBlank then CommandType := cmdBlankMemberInfo
  else CommandType := cmdSetMemberInfo;

  MemSalesInfo := TMemSalesInfo.Create;
  MemSalesInfo.MemSalesRec := MemSalesRec;

  if bWait then
    begin
      iTries := 0;
      Result := FALSE;
      Repeat
        MPComms.DoCommand(CommandType, iTillNo, StrToIntDef(MemSalesRec.TrackNo,0), -1, MemSalesInfo);
        if bBlank and WaitForMemberInfo(iTillNo, StrToIntDef(MemSalesRec.TrackNo,0), CheckMemSalesRec) then begin
          if length(CheckMemSalesRec.Transactions) = 0 then Result := TRUE;
//          Result := TRUE;
        end;{if}
        inc(iTries)
      Until Result or (iTries > 6) or (not bBlank)
    end
  else begin
    MPComms.QCommand(CommandType, iTillNo, StrToIntDef(MemSalesRec.TrackNo,0), -1, MemSalesInfo);
    Result := TRUE;
  end;{if}
end;

function TFrmComms.GetBestBalance(iCardNo, iTrackNo : integer; bWait : boolean) : Real;
var
  iPos : integer;
begin
  iCurrentCardNo := iCardNo;
  For iPos := 1 to Syss.NoTills do agBalances[iPos].Score := 0;
  if bWait then
    begin
      MPComms.DoCommand(cmdGetBestBalance, 0, iTrackNo, -1, nil);
      Result := rBalance;
    end
  else begin
    MPComms.QCommand(cmdGetBestBalance, 0, iTrackNo, -1, nil);
    Result := 0;
  end;{if}
end;

function TFrmComms.CheckBalsSame(iTrackNo : integer) : Boolean;
var
  iPos : integer;
begin
  For iPos := 1 to Syss.NoTills do agBalances[iPos].Balance := 0;
  if Syss.NoTills = 1 then Result := TRUE
  else begin
    MPComms.DoCommand(cmdGetBestBalance, 0, iTrackNo, -1, nil);
    Result := TRUE;
    For iPos := 1 to Syss.NoTills - 1 do begin
      if agBalances[iPos].Balance <> agBalances[iPos + 1].Balance then Result := FALSE;
    end;{for}
  end;{if}
end;

function TFrmComms.GetTillBalance(iTrackNo, iTillNo : integer; bWait : boolean) : Real;
begin
  if (iTillNo > 0) and (iTillNo < 11) then
    begin
      if bWait then
        begin
          MPComms.DoCommand(cmdGetBalance, iTillNo, iTrackNo, -1, nil);
          Result := rBalance;
        end
      else begin
        MPComms.QCommand(cmdGetBalance, iTillNo, iTrackNo, -1, nil);
        Result := 0;
      end;{if}
    end
  else Result := 0;
end;

function TFrmComms.GetMaxGuests(iTillNo : integer; bWait : boolean) : TMaximumsRec;
begin
  if bWait then
    begin
      MPComms.DoCommand(cmdGetMaximums, iTillNo, 0, 01, nil);
      Result := MaxRec;
    end
  else begin
    MPComms.QCommand(cmdGetMaximums, iTillNo, 0, -1, nil);
  end;{if}
end;

function TFrmComms.GetPLUSales(iTillNo : integer; bWait : boolean; var aRetPLURec : TaPLURecs) : boolean;
var
  bResult : boolean;
begin
  FillChar(aPLURecs, SizeOf(aPLURecs), #0); {b000.851}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllPLUSales, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  aRetPLURec := aPLURecs;
  Result := bResult;
end;

function TFrmComms.GetHourlySales(iTillNo : integer; bWait : boolean; var aRetHourSalesRecs : TaHourSalesRecs) : boolean;
var
  bResult : boolean;
begin
  FillChar(aHourSalesRecs, SizeOf(aHourSalesRecs), #0); {b000.851}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllHourlySales, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;

  aRetHourSalesRecs := aHourSalesRecs;
  Result := bResult;
end;

function TFrmComms.GetClerkRec(iTillNo : integer; bWait : boolean; var aRetClerkRec : TaClerkRec) : boolean;
var
  bResult : boolean;
begin
  FillChar(aClerkRec, SizeOf(aClerkRec), #0); {b000.851}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllClerkInfo, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  aRetClerkRec := aClerkRec;
  Result := bResult;
end;

function TFrmComms.GetClerkData(iTillNo : integer; bWait : boolean; var aRetClerkData : TaClerkData) : boolean;
var
  bResult : boolean;
begin
  FillChar(aClerkData, SizeOf(aClerkData), #0); {b000.851}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllClerkData, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  aRetClerkData := aClerkData;
  Result := bResult;
end;

function TFrmComms.GetCashierSales(iTillNo : integer; var aRetCashierSales : TaCashierSales) : boolean;
var
  bResult : boolean;
begin
  FillChar(aCashierSales, SizeOf(aCashierSales), #0); {b000.851}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllCashierSales, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  aRetCashierSales := aCashierSales;
  Result := bResult;
end;

{function TFrmComms.ClearSalesData(cType : char) : boolean;
var
  bResult : boolean;
begin
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdClearSalesData, 0, Ord(cType), -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  Result := bResult;
end;}

function TFrmComms.ClearTransactionData(aTransData : array of TaTransInfo) : boolean;
var
  AllTransInfo : TAllTransInfo;
  iPos, iTries, iTill : integer;
  aTempTotals : array of TaTransInfo;
  bCheckedOK : boolean;
begin
  if bgCommsWorking then
    begin
      Result := TRUE;
      setlength(aTempTotals, Syss.NoTills + 1);

      for iTill := 1 to Syss.NoTills do begin
        iTries := 0;

        Repeat
          bFail := FALSE;

          if MPComms.FourMBTills then AllTransInfo := nil
          else begin
            AllTransInfo := TAllTransInfo.Create;
            AllTransInfo.aTransRec := aTransData[iTill];
          end;{if}

          MPComms.DoCommand(cmdClearSalesData, iTill, Ord(']'), -1, AllTransInfo);
          if bFail then Result := FALSE
          else begin
            // check that transaction data has been cleared
            FrmComms.GetAllTransData(iTill, TRUE, aTempTotals[iTill]);

            // Fake Totalisers not clearing
//            setlength(aTempTotals[iTill],2);
//            aTempTotals[iTill][0].Qty := 1;
//            aTempTotals[iTill][1].Qty := 2;
//            aTempTotals[iTill][0].Amount := 1;
//            aTempTotals[iTill][1].Amount := 2;

            bCheckedOK := TRUE;
            for iPos := 0 to High(aTempTotals[iTill]) do begin
              if (aTempTotals[iTill][iPos].Qty <> 0) or (aTempTotals[iTill][iPos].Amount <> 0) then begin
                // if thermal, or dot matrix and not totaliser 22 (this is always populated)
                if MPComms.FourMBTills or (iPos <> 22) then begin
                  // a value has been found
                  bCheckedOK := FALSE;
                  inc(iTries);
                  if iTries > 6 then begin
                    bFail := TRUE;
                    Result := FALSE;
                  end;{if}
                end;{if}
              end;{if}
            end;{for}

          end;{if}

        until bFail or bCheckedOK

      end;{for}
    end
  else Result := FALSE;
end;

function TFrmComms.ClearHourlyData(iTillNo : byte; aHourSalesRecs : TaHourSalesRecs) : boolean;
var
  AllHourSalesInfo : TAllHourSalesInfo;
begin
  if bgCommsWorking then
    begin
      bFail := FALSE;
      if MPComms.FourMBTills then AllHourSalesInfo := nil
      else begin
        AllHourSalesInfo := TAllHourSalesInfo.Create;
        AllHourSalesInfo.aHourSalesRecs := aHourSalesRecs;
      end;{if}
      MPComms.DoCommand(cmdClearSalesData, iTillNo, Ord('\'), -1, AllHourSalesInfo);
    end
  else Result := not bFail;
end;

function TFrmComms.ClearPLUData(iTillNo : byte; aPLURecs : TaPLURecs) : boolean;
var
  PLUSalesInfo : TPLUSalesInfo;
begin
  if bgCommsWorking then
    begin
      bFail := FALSE;
      if MPComms.FourMBTills then PLUSalesInfo := nil
      else begin
        PLUSalesInfo := TPLUSalesInfo.Create;
        PLUSalesInfo.aPLURecs := aPLURecs;
      end;{if}
      MPComms.DoCommand(cmdClearSalesData, iTillNo, Ord('V'), -1, PLUSalesInfo);
    end
  else Result := not bFail;
end;

function TFrmComms.ClearClerkData(iTillNo : byte) : boolean;
begin
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdClearSalesData, iTillNo, Ord('Y'), -1, nil);
    end
  else Result := not bFail;
end;

function TFrmComms.GetAllTransData(iTillNo : integer; bWait : boolean; var aRetTransInfo : TaTransInfo) : boolean;
var
  bResult : boolean;
begin
  FillChar(aTransInfo, SizeOf(aTransInfo), #0); {b000.850}
  if bgCommsWorking then
    begin
      bFail := FALSE;
      MPComms.DoCommand(cmdGetAllTransInfo, iTillNo, 0, -1, nil);
      bResult := not bFail;
    end
  else bResult := FALSE;
  aRetTransInfo := aTransInfo;
  Result := bResult;
end;

function TFrmComms.GetCardInfo(iTillNo : byte; iTrackNo : integer; var RetCardRec : TCardRec) : boolean;
var
  bCommsOK : boolean;
begin
  if iTillNo = 100 then iTillNo := iGoodTill;
  bCommsOK := FALSE;
  while not bCommsOK do begin
    MPComms.DoCommand(cmdGetCardInfo, iTillNo, iTrackNo, -1, nil);
    bCommsOK := not bFail;
  end;{while}

  RetCardRec := CardRec;
  Result := bCommsOK;
end;

function TFrmComms.ClearCashierData(iTillNo : byte; aCashierSales : TaCashierSales) : boolean;
var
  AllCashierSales : TAllCashierSales;
begin
  if bgCommsWorking then
    begin
      bFail := FALSE;
      AllCashierSales := TAllCashierSales.Create;
      AllCashierSales.aCashierSales := aCashierSales;
      MPComms.DoCommand(cmdClearSalesData, iTillNo, Ord('X'), -1, AllCashierSales);
    end
  else Result := not bFail;
end;

end.
