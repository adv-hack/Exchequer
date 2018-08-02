unit RevalueArchive;

interface

uses
  ReportRV {Revaluation report},
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, {$IFNDEF SCHEDULER} Report8U, {$ENDIF}Scrtch2U;


type

  //PR: 08/10/2009 Descendant of Currency Revaluation report which prints to a pdf file in the Reports folder.
  TRVArchiveReport = Object(TRVReport)
  private
    function GetArchiveFilename : string;
  public
    Procedure Finish;  Virtual;
    constructor Create(AOwner  :  TObject);
  end;

  Procedure AddRVArchRep2Thread(LMode    :  Byte;
                                IRepParam:  TPrintParamPtr;
                                RVLog    :  tReValueLog;
                                AOwner   :  TObject);


implementation

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  MiscU,
  {DocSupU1,}
  SalTxl1U,

  {$IFDEF VAT}
    SetVATU,
  {$ENDIF}

  RpDefine,
  Report9U,

  IntMU,
  ExThrd2U,
  SQLUtils;

{ TRVArchiveReport }

constructor TRVArchiveReport.Create(AOwner  :  TObject);
begin
  inherited Create(AOwner);
  FDestroyLog := False;
end;

procedure TRVArchiveReport.Finish;
Var
  PParam   :  ^TPrintParam;

Begin


  New(PParam);
  FillChar(PParam^,Sizeof(PParam^),0);

  ShowStatus(2,'Printing Report.');

  With PParam^ do
  Begin
    PDevRec:=RDevRec;

    with PDevRec do
    begin
//      DevIdx := RpDev.DeviceIndex; //Default printer
      FormNo := 0;
      FormName := '';
      BinNo := 0;
      BinName := '';
      Preview := False;     { True = Preview, False = Print }
      NoCopies := 1;                             { Copies of form to print }
      pbLabel1 := 1;                    { N/A }  { Start of Label 1 Pos }
      TestMode := False;                { N/A }  { Indicates test mode }
      LabelMode := False;               { N/A }  { Tells PrntFrm Label Mode }
      ChequeMode := False;              { N/A }  { Enables Cheque No processing fields }
      fePrintMethod := 4;                        { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML } {*en431 XML}
      feBatch := False;
      feEmailZIP    := 0;
      feEmailAtType := 2;
      feOutputFilename := GetArchiveFilename;
    end;

    {ToPrinter:=RToPrinter;
    PrinterNo:=RPrinterNo;}
    FileName:=RepFiler1.FileName;
    RepCaption:=RepTitle;

    {If (Copies<1) then
      Copies:=1;

    Copies:=RCopies;}

    PBatch:=False;
    DelSwapFile:=False;
    SwapFileName:=TmpSwapFileName;





    With MTExLocal^ do
    Begin
      If (Assigned(LThPrintJob)) and (Not ThreadRec^.ThAbortPrint) then {* Call back to Synchronise method *}
      Begin
        ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to DLL *}
        LThPrintJob(nil,LongInt(@PParam^),0);
      end
      else
        If (ThreadRec^.ThAbortPrint) then
        Begin
          RepFiler1.Abort;
          DelSwpFile;


          {$IFDEF FRM}
            If (Assigned(PParam)) then {* When DBD is removed, this line needs to be outside FRM}
              Dispose(PParam);

            If (Assigned(eCommFrmList)) then
              eCommFrmList.Destroy;
          {$ENDIF}

        end;
    end; {else..}


    If (Assigned(ThreadRec)) then
      UpdateProgress(ThreadRec^.PTotal);



  end; {With..}

  InPrint:=BOff;

  InMainThread:=BOff;
end;

function TRVArchiveReport.GetArchiveFilename : string;
var
  i : Integer;
begin
  Result := 'Currency Revaluation ' + FormatDateTime('yyyymmdd', Sysutils.Date) + '-';

//If file already exists then we create a new file
  i := 1;
  while FileExists(SetDrive + 'Reports\' + Result +  IntToStr(i) + '.pdf') do
    inc(i);

  Result := SetDrive + 'Reports\' + Result + IntToStr(i) + '.pdf';

end;

  Procedure AddRVArchRep2Thread(LMode    :  Byte;
                                IRepParam:  TPrintParamPtr;
                                RVLog    :  tReValueLog;
                                AOwner   :  TObject);

Var
  EntTest  :  ^TRVArchiveReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;
        //Set these to avoid DrillDown info being written into the file
        RDevRec.fePrintMethod := 7;
//        RDevRec.feEmailAtType := 2;
        NoDeviceP := True;

        ReValueLog:=RVLog;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;
        end;

        ROrient := poLandscape;


        If (Create_BackThread) and (Start) then
        Begin
           if not Assigned(ReValueLog.MTExLocal) then
              ReValueLog.MTExLocal:=EntTest.MTExLocal;

          With BackThread do
            AddTask(EntTest,ThTitle + ' (Archive)');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;


end.
