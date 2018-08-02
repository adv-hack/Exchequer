unit LocalVar;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

interface
Uses
  Classes,
  GlobVar;

{$I ExchDll.Inc}
{$I ExDllBt.Inc}

Const
  BTDEFNames  :  Array[1..8] of Str20 = ('Files','Handles','Locks','Pre v6','CompBuff','OBL','ITL','Share Remote');

  SecCode     =  'SECTESTMODE'; 


Type

  TSystemInfo  =   Record
                     MUVal,
                     SRVOSVal,
                     WSOSVal,
                     ACRecCnt,
                     THRecCnt,
                     ACRecMode,
                     THRecMode,
                     THNomCode,
                     WSNO           :  Integer;

                     THCC,THDep     :  Str5;

                     NOVSRVPAth     :  Str255;
                     ExPathStr      :  Str255;
                     NWAdpKey       :  Str255;

                     ACChkBT,
                     THChkBT,
                     ACUpdateRes,
                     THUpdateRes,
                     ACGreenLight,
                     ACGrpTest,
                     THGrpTest,
                     TRing,
                     BTServer,
                     BTUseRecon,
                     ThisServer,
                     UsePrintList   :  Boolean;

                     TotWS          :  Integer;

                     BTDefs         :  Array[1..8] of Integer;
                     BTSUDefs       :  Array[1..8] of Integer;

                     EntTime        :  Array[1..4,BOff..BOn,1..20] of Double;
                     WSTime         :  Array[1..4,BOff..BOn,1..20] of Double;

                     THBals         :  Array[1..4] of Double;
                   end;

Var
  CompSysInfo  :  ^TSystemInfo;
  CompPrinters :  TStringList;
  MasterAborted:  Boolean;

// HM 23/08/05: Changed sAppName into global constants during rebranding for IRIS Enterprise/Exchequer
//  sAppName : string;
Const
  {$IFDEF WCBuild}
    sAppName = 'Wincard';
    sLongAppName = 'Wincard';
  {$ELSE}
    sAppName = 'Exchequer';
  {$ENDIF}

implementation

Uses
  Untils;

Initialization

  
  New(CompsysInfo);

  FillChar(CompSysInfo^,Sizeof(CompSysInfo^),0);

  With CompSysInfo^ do
  Begin
    MUVal:=0;
    SRVOSVal:=1;

    WSOSVal:=Set_DetectOS;

    WSNo:=1;
    TotWS:=1;
  end;

  {Try
    CompPrinters:=TStringList.Create;

  Except

    CompPrinters.Free;
    CompPrinters:=nil;
  end;

  Finalization
    CompPrinters.Free;
    CompPrinters:=nil;}
end.
