unit oDataLst;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},         // COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     ExceptIntf;

type
  TPrintJobDataDetails = class (TAutoIntfObjectEx, IPrintJobDataDetails)
  private
    FFileNo      : SmallInt;
    FIndexNo     : SmallInt;
    FSortKey     : WideString;
    FPosition    : Integer;
    FDescription : WideString;
  protected
    // IPrintJobDataDetails
    function Get_ddSortKey: WideString; safecall;
    procedure Set_ddSortKey(const Value: WideString); safecall;
    function Get_ddPosition: Integer; safecall;
    procedure Set_ddPosition(Value: Integer); safecall;
    function Get_ddDescription: WideString; safecall;
    procedure Set_ddDescription(const Value: WideString); safecall;
    function Get_ddFileNo: Integer; safecall;
    function Get_ddIndexNo: Integer; safecall;
  public
    Constructor Create (Const FileNo, IndexNo : SmallInt);
    Destructor Destroy; override;
  End; { TPrintJobDataDetails }

  //---------------------------

  TPrintJobDataList = class (TAutoIntfObjectEx, IPrintJobDataList)
  private
    // Local reference to base PrintJob object within the COM Toolkit
    FCTKPrintJob : TObject;

    // Local List to store Custom Data objects
    FDataList : TList;

    // Print Job Mode
    FPJobMode : TEFPrintFormMode;
  protected
    // IPrintJobDataList
    function Get_dlCount: Integer; safecall;
    function Get_dlData(Index: Integer): IPrintJobDataDetails; safecall;
    procedure Add(const Data: IDispatch; const SortKey: WideString; const Description: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const PJobMode : TEFPrintFormMode);
    Destructor Destroy; override;
  End; { TPrintJobDataList }

implementation

Uses ComServ,
     GlobVar,        // Exchequer Global Const/Type/Var
     VarConst,       // Enterprise Global Const/Type/Var
     MiscFunc,       // Miscellaneous types and routines
     oPrntJob;       // Print Job object (IPrintJob)

Type
  TDataDetailRecType = Record
    iDataDetail : IPrintJobDataDetails;
    oDataDetail : TPrintJobDataDetails;
  End; { TDataDetailRecType }
  pDataDetailRecType = ^TDataDetailRecType;


//------------------------------------------------------------------------

Constructor TPrintJobDataDetails.Create (Const FileNo, IndexNo : SmallInt);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobDataDetails);

  FFileNo      := FileNo;
  FIndexNo     := IndexNo;
  FSortKey     := '';
  FPosition    := 0;
  FDescription := '';
End; { Create }

//----------------------------------------

Destructor TPrintJobDataDetails.Destroy;
Begin { Destroy }
  // Remove reference to other objects

  inherited Destroy;
End; { Destroy }

//------------------------------------------------------------------------

function TPrintJobDataDetails.Get_ddFileNo: Integer;
begin
  Result := FFileNo;
end;

//----------------------------------------

function TPrintJobDataDetails.Get_ddIndexNo: Integer;
begin
  Result := FIndexNo;
end;

//----------------------------------------

function TPrintJobDataDetails.Get_ddSortKey: WideString;
begin
  Result := FSortKey;
end;

procedure TPrintJobDataDetails.Set_ddSortKey(const Value: WideString);
begin
  FSortKey := Value;
end;

//----------------------------------------

function TPrintJobDataDetails.Get_ddPosition: Integer;
begin
  Result := FPosition;
end;

procedure TPrintJobDataDetails.Set_ddPosition(Value: Integer);
begin
  FPosition := Value;
end;

//----------------------------------------

function TPrintJobDataDetails.Get_ddDescription: WideString;
begin
  Result := FDescription;
end;

procedure TPrintJobDataDetails.Set_ddDescription(const Value: WideString);
begin
  FDescription := Value;
end;

//------------------------------------------------------------------------

Constructor TPrintJobDataList.Create (Const CTKPrintJob : TObject; Const PJobMode : TEFPrintFormMode);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobDataList);

  FCTKPrintJob := CTKPrintJob;

  FDataList := TList.Create;

  FPJobMode := PJobMode;
End; { Create }

//----------------------------------------

Destructor TPrintJobDataList.Destroy;
Begin { Destroy }
  // Empty and Destroy the Data List
  Clear;
  FreeAndNIL(FDataList);

  // Remove reference to other objects
  FCTKPrintJob := NIL;

  inherited Destroy;
End; { Destroy }

//------------------------------------------------------------------------

procedure TPrintJobDataList.Add(const Data: IDispatch;
                                const SortKey, Description: WideString);
Var
  pDataRec   : pDataDetailRecType;
  OK         : Boolean;
  FNo, IdxNo : SmallInt;
  RecPos     : LongInt;
begin
  OK := False;
  FNo := 0;
  IdxNo := 0;
  RecPos := 0;
  // Identify the passed data - Check for supported interfaces by Print Job Mode
  Case FPJobMode Of
    // Custom / Consolidated Picking List - takes Transaction Lines
    fmPickListConsolidated  : If Supports(Data, IID_ITransactionLine) And Supports(Data, IID_IRecordPosition) Then
                              Begin
                                FNo    := IDetailF;
                                IdxNo  := IdFolioK;
                                RecPos := (Data As IRecordPosition).RecordPosition;
                                OK := True;
                              End; { If Supports... }

    // HM 23/02/04: Custom Trading History - takes Transactions
    fmCustomTradeHistory    : If Supports(Data, IID_ITransaction) And Supports(Data, IID_IRecordPosition) Then
                              Begin
                                FNo    := InvF;
                                IdxNo  := InvOurRefK;
                                RecPos := (Data As IRecordPosition).RecordPosition;
                                OK := True;
                              End; { If Supports... }
  Else
    OK := False;
  End; // Case FPJobMode

  If OK Then Begin
    // Create and setup a new list entry
    New (pDataRec);
    With pDataRec^ Do Begin
      oDataDetail := TPrintJobDataDetails.Create (FNo, IdxNo);
      iDataDetail := oDataDetail;

      With iDataDetail Do Begin
        ddSortKey     := SortKey;
        ddPosition    := RecPos;
        ddDescription := Description;
      End; { With iDataDetail }
    End; { With pDataRec }

    // Add it into the internal list of data items
    FDataList.Add (pDataRec);
  End { If OK }
  Else
    Raise EUnknownValue.Create('The Data could not be identified or is not valid for the type of print job');
end;

//------------------------------------------------------------------------

procedure TPrintJobDataList.Clear;
begin
  While (FDataList.Count > 0) Do
    Delete (1);
end;

//------------------------------------------------------------------------

procedure TPrintJobDataList.Delete(Index: Integer);
Var
  pDataRec : pDataDetailRecType;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FDataList.Count) Then Begin
    // Extract data details from list and de-allocate interfaces/memory
    pDataRec := FDataList.Items[Index - 1];
    With pDataRec^ Do Begin
      oDataDetail := NIL;
      iDataDetail := NIL;
    End; { With pDataRec^ }
    Dispose(pDataRec);

    // Remove from list
    FDataList.Delete (IndeX - 1);
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid dlData Index (' + IntToStr(Index) + ')');
end;

//------------------------------------------------------------------------

function TPrintJobDataList.Get_dlCount: Integer;
begin
  Result := FDataList.Count;
end;

function TPrintJobDataList.Get_dlData(Index: Integer): IPrintJobDataDetails;
Var
  pDataRec : pDataDetailRecType;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FDataList.Count) Then Begin
    // Extract data details from list and return interface
    pDataRec := FDataList.Items[Index - 1];
    Result := pDataRec^.iDataDetail;
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid dlData Index (' + IntToStr(Index) + ')');
end;

//------------------------------------------------------------------------




end.
