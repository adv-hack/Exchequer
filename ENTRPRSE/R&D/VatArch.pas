unit VatArch;

interface

uses
  ReportKU {TVatRReport2},
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, Report8U, Scrtch2U;


type
  TVatArchiveReport = Object(TVatRReport2)
  private
    function GetArchiveFilename : string;
  public
    Procedure Finish;  Virtual;
  end;

  Procedure AddVATArchRep2Thread(LMode    :  Byte;
                                IRepParam:  VATRepPtr;
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
  ExThrd2U;

{ TVatArchiveReport }

procedure TVatArchiveReport.Finish;
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
    DelSwapFile:=True;
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

  //Can't call Inherited Finish since that has too much baggage, so need to duplicate TThreadQueue.Finish here
  BaseObjFinish;

  InMainThread:=BOff;

end;

function TVatArchiveReport.GetArchiveFilename : string;
var
  i : Integer;
begin
//Filename is Period/Year in format ppyyyy
  Result := IntToStr(CRepParam.VPr) + IntToStr(CRepParam.VYr + 1900);
  if Length(Result) = 5 then
    Result := '0' + Result;

//If file already exists then we create a newfile as ppyyyy1, ppyyyy2,...ppyyyyn
  i := 1;
  while FileExists(SetDrive + 'Reports\' + Result + '.pdf') do
  begin
    inc(i);
    Result := Copy(Result, 1, 6) + IntToStr(i);
  end;

  Result := SetDrive + 'Reports\' + Result + '.pdf';

end;

Procedure AddVATArchRep2Thread(LMode    :  Byte;
                             IRepParam:  VATRepPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TVatArchiveReport;

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

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;
          CRepParam^.AutoCloseVAT := False;
        end;

        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
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
