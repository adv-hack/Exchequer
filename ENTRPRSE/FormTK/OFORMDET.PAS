unit oFormDet;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, MiscFunc, GlobType;

type
  TEFCustomData = class (TAutoIntfObject, IEFCustomData)
  private
    FFileNo      : SmallInt;
    FIndexNo     : SmallInt;
    FSortKey     : ShortString;
    FPosition    : LongInt;
  protected
    // IEFCustomData
    function Get_cdFileNo: Integer; safecall;
    procedure Set_cdFileNo(Value: Integer); safecall;
    function Get_cdIndexNo: Integer; safecall;
    procedure Set_cdIndexNo(Value: Integer); safecall;
    function Get_cdSortKey: WideString; safecall;
    procedure Set_cdSortKey(const Value: WideString); safecall;
    function Get_cdPosition: Integer; safecall;
    procedure Set_cdPosition(Value: Integer); safecall;
  public
    Constructor Create (Const FileNo, IndexNo : SmallInt;
                        Const RecordPos       : LongInt;
                        Const SortKey         : ShortString);
  End; { TPrintJobDataDetails }

  //---------------------------

  TEFPrintFormDetails = class(TAutoIntfObject, IEFPrintFormDetails)
  private
    // Stores a reference to the pfForms (TEFPrintFormsList) object storing
    // the batch details - saved as TObject to avoid circular references.
    FFormsList   : TObject;

    // Interface Type - imGeneral, imAdd, imUpdate, imClone
    FIntfType    : TInterfaceMode;

    // Used to store the details of what to print
    FFormDets    : PrintBatchRecType;
    FSerialPos   : LongInt;

    // List to store CustomDAta objects
    FCustomDataList : TList;
  protected
    // IEFPrintFormDetails
    function Get_fdMode: TEFPrintFormMode; safecall;
    procedure Set_fdMode(Value: TEFPrintFormMode); safecall;
    function Get_fdFormName: WideString; safecall;
    procedure Set_fdFormName(const Value: WideString); safecall;
    function Get_fdMainFileNo: Integer; safecall;
    procedure Set_fdMainFileNo(Value: Integer); safecall;
    function Get_fdMainIndexNo: Integer; safecall;
    procedure Set_fdMainIndexNo(Value: Integer); safecall;
    function Get_fdMainKeyString: WideString; safecall;
    procedure Set_fdMainKeyString(const Value: WideString); safecall;
    function Get_fdTableFileNo: Integer; safecall;
    procedure Set_fdTableFileNo(Value: Integer); safecall;
    function Get_fdTableIndexNo: Integer; safecall;
    procedure Set_fdTableIndexNo(Value: Integer); safecall;
    function Get_fdTableKeyString: WideString; safecall;
    procedure Set_fdTableKeyString(const Value: WideString); safecall;
    function Get_fdLabelCopies: Integer; safecall;
    procedure Set_fdLabelCopies(Value: Integer); safecall;
    function Get_fdDescription: WideString; safecall;
    procedure Set_fdDescription(const Value: WideString); safecall;
    function Save: Integer; safecall;
    function Get_fdSerialPos: Integer; safecall;
    procedure Set_fdSerialPos(Value: Integer); safecall;

    function Get_fdCustomDataCount: Integer; safecall;
    function Get_fdCustomData(Index: Integer): IEFCustomData; safecall;
    function AddCustomData(FileNo: Integer; IndexNo: Integer; RecPosition: Integer;
                           const SortKey: WideString): IEFCustomData; safecall;
    procedure DeleteCustomData(Index: Integer); safecall;
    procedure ClearCustomData; safecall;

    // Local methods
  public
    Property FormDets : PrintBatchRecType Read FFormDets Write FFormDets;
    Property SerialPos : Longint Read FSerialPos Write FSerialPos;

    Constructor Create (Const IType : TInterfaceMode; Const FormsList : TObject);
    Destructor Destroy; override;

    Procedure Assign (Const ExistingDets : TEFPrintFormDetails);
    function  BuildTempDB(Const TempDBNo : SmallInt) : ShortString;
    function  GetSerialPtr : Pointer;
    Procedure Transform(Const IType : TInterfaceMode);
  End; { TEFPrintFormDetails }

implementation

uses ComServ,
     BtrvU2,          // Btrieve Routines
     GlobVar,         // Exchequer Global Const/Type/Var's
     VarConst,        // Exchequer Global Const/Type/Var's
     Register,        // FormDes routines for accessing EFD Files
     oPrntJob,        // Parent PrintJob Object  (TEFPrintJob)
     oFormLst,        // Parent Forms List object  (TEFPrintFormsList)
     Scrtch1U;        // SCratch File Object

Type
  TDataDetailRecType = Record
    iDataDetail : IEFCustomData;
    oDataDetail : TEFCustomData;
  End; { TDataDetailRecType }
  pDataDetailRecType = ^TDataDetailRecType;

//-----------------------------------------------------------------------------

Constructor TEFCustomData.Create (Const FileNo, IndexNo : SmallInt;
                                  Const RecordPos       : LongInt;
                                  Const SortKey         : ShortString);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFCustomData);

  FFileNo   := FileNo;
  FIndexNo  := IndexNo;
  FSortKey  := SortKey;
  FPosition := RecordPos;
End; { Create }

//-----------------------------------------------------------------------------

function TEFCustomData.Get_cdFileNo: Integer;
begin
  Result := FFileNo;
end;

procedure TEFCustomData.Set_cdFileNo(Value: Integer);
begin
  FFileNo := Value;
end;

//---------------------------

function TEFCustomData.Get_cdIndexNo: Integer;
begin
  Result := FIndexNo;
end;

procedure TEFCustomData.Set_cdIndexNo(Value: Integer);
begin
  FIndexNo := Value;
end;

//---------------------------

function TEFCustomData.Get_cdSortKey: WideString;
begin
  Result := FSortKey;
end;

procedure TEFCustomData.Set_cdSortKey(const Value: WideString);
begin
  FSortKey := Value;
end;

//---------------------------

function TEFCustomData.Get_cdPosition: Integer;
begin
  Result := FPosition;
end;

procedure TEFCustomData.Set_cdPosition(Value: Integer);
begin
  FPosition := Value;
end;

//-----------------------------------------------------------------------------

Constructor TEFPrintFormDetails.Create (Const IType : TInterfaceMode; Const FormsList : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFPrintFormDetails);

  FCustomDataList := TList.Create;

  FillChar (FFormDets, SizeOf (FFormDets), #0);

  FIntfType  := IType;
  FFormsList := FormsList;
End; { Create }

//----------------------------------------

Destructor TEFPrintFormDetails.Destroy;
Begin { Destroy }
  // Empty and ddestroy the Custom Data List
  ClearCustomData;
  FreeAndNIL(FCustomDataList);

  // Remove reference to pfForms object
  FFormsList := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdMode: TEFPrintFormMode;
begin
  Case FFormDets.pbDefMode Of
    GlobType.fmAllDocs       : Result := EnterpriseForms_TLB.fmNormalDocs;
    GlobType.fmRemitAdv      : Result := EnterpriseForms_TLB.fmRemittanceAdvice;
  //GlobType.fmDebtChaseL    : Result := EnterpriseForms_TLB.fmDebtChaseLetters;
    GlobType.fmBatchDoc      : Result := EnterpriseForms_TLB.fmBatchDocs;
    GlobType.fmNomTxfr       : Result := EnterpriseForms_TLB.fmNomTransfer;
    GlobType.fmStockAdj      : Result := EnterpriseForms_TLB.fmStockAdjustment;
    GlobType.fmPickLstCons   : Result := EnterpriseForms_TLB.fmPickListConsolidated;
    GlobType.fmPickLstSngl   : Result := EnterpriseForms_TLB.fmPickListSingle;
    GlobType.fmConsignNote   : Result := EnterpriseForms_TLB.fmConsignmentNote;
  //GlobType.fmStateAgeMnth  : Result := EnterpriseForms_TLB.fmAgedStatement;
    GlobType.fmTimeSheet     : Result := EnterpriseForms_TLB.fmTimeSheet;
    GlobType.fmJCBackingSh   : Result := EnterpriseForms_TLB.fmJobBackingSheet;
  //GlobType.fmJCRec         : Result := EnterpriseForms_TLB.fmJobDetails;
    GlobType.fmLabel         : Result := EnterpriseForms_TLB.fmLabel;
    GlobType.fmSerialLabel   : Result := EnterpriseForms_TLB.fmSerialLabel;
    GlobType.fmTransNotes    : Result := EnterpriseForms_TLB.fmTransNotes;
    GlobType.fmJCRec         : Result := EnterpriseForms_TLB.fmJobDetails;

    // HM 23/02/04: Added Stock Forms
    GlobType.fmStockRec      : Result := EnterpriseForms_TLB.fmStockDetails;
    GlobType.fmStockNote     : Result := EnterpriseForms_TLB.fmStockNotes;

    // HM 23/02/04: Added Account Forms
    GlobType.fmAccDets              : Result := EnterpriseForms_TLB.fmAccountDetails;
    GlobType.fmTradeHist            : Result := EnterpriseForms_TLB.fmTradeHistory;
    GlobType.fmStatemLay            : Result := EnterpriseForms_TLB.fmStatement;
    GlobType.fmCustomTradingHistory : Result := EnterpriseForms_TLB.fmCustomTradeHistory;

    // MH 17/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
    GlobType.fmOrdPayVATReceipt     : Result := EnterpriseForms_TLB.fmOrderPaymentsVATReceipt;
  Else
    Raise Exception.Create ('TEFPrintFormDetails.fdMode: Unhandled Mode (' + IntToStr(FFormDets.pbDefMode) + ')');
  End; { Case PrintJobSetupInfo.feEmailPriority }
end;

procedure TEFPrintFormDetails.Set_fdMode(Value: TEFPrintFormMode);
begin
  Case Value Of
    EnterpriseForms_TLB.fmNormalDocs           : FFormDets.pbDefMode := GlobType.fmAllDocs;
    EnterpriseForms_TLB.fmRemittanceAdvice     : FFormDets.pbDefMode := GlobType.fmRemitAdv;
  //EnterpriseForms_TLB.fmDebtChaseLetters     : FFormDets.pbDefMode := GlobType.fmDebtChaseL;
    EnterpriseForms_TLB.fmBatchDocs            : FFormDets.pbDefMode := GlobType.fmBatchDoc;
    EnterpriseForms_TLB.fmNomTransfer          : FFormDets.pbDefMode := GlobType.fmNomTxfr;
    EnterpriseForms_TLB.fmStockAdjustment      : FFormDets.pbDefMode := GlobType.fmStockAdj;
    EnterpriseForms_TLB.fmPickListConsolidated : FFormDets.pbDefMode := GlobType.fmPickLstCons;
    EnterpriseForms_TLB.fmPickListSingle       : FFormDets.pbDefMode := GlobType.fmPickLstSngl;
    EnterpriseForms_TLB.fmConsignmentNote      : FFormDets.pbDefMode := GlobType.fmConsignNote;
  //EnterpriseForms_TLB.fmAgedStatement        : FFormDets.pbDefMode := GlobType.fmStateAgeMnth;
    EnterpriseForms_TLB.fmTimeSheet            : FFormDets.pbDefMode := GlobType.fmTimeSheet;
    EnterpriseForms_TLB.fmJobBackingSheet      : FFormDets.pbDefMode := GlobType.fmJCBackingSh;
  //EnterpriseForms_TLB.fmJobDetails           : FFormDets.pbDefMode := GlobType.fmJCRec;
    EnterpriseForms_TLB.fmLabel                : FFormDets.pbDefMode := GlobType.fmLabel;
    EnterpriseForms_TLB.fmSerialLabel          : FFormDets.pbDefMode := GlobType.fmSerialLabel;
    EnterpriseForms_TLB.fmTransNotes           : FFormDets.pbDefMode := GlobType.fmTransNotes;
    EnterpriseForms_TLB.fmJobDetails           : FFormDets.pbDefMode := GlobType.fmJCRec;

    // HM 23/02/04: Added Stock Forms
    EnterpriseForms_TLB.fmStockDetails         : FFormDets.pbDefMode := GlobType.fmStockRec;
    EnterpriseForms_TLB.fmStockNotes           : FFormDets.pbDefMode := GlobType.fmStockNote;

    // HM 23/02/04: Added Account Forms
    EnterpriseForms_TLB.fmAccountDetails       : FFormDets.pbDefMode := GlobType.fmAccDets;
    EnterpriseForms_TLB.fmTradeHistory         : FFormDets.pbDefMode := GlobType.fmTradeHist;
    EnterpriseForms_TLB.fmStatement            : FFormDets.pbDefMode := GlobType.fmStatemLay;
    EnterpriseForms_TLB.fmCustomTradeHistory   : FFormDets.pbDefMode := GlobType.fmCustomTradingHistory;

    // MH 17/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
    EnterpriseForms_TLB.fmOrderPaymentsVATReceipt : FFormDets.pbDefMode := GlobType.fmOrdPayVATReceipt;
  Else
    Raise EValidation.Create ('TEFPrintFormDetails.fdMode: Unhandled Mode (' + IntToStr(Value) + ')');
  End; { Case PrintJobSetupInfo.feEmailPriority }
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdFormName: WideString;
begin
  Result := FFormDets.pbEFDName;
end;

procedure TEFPrintFormDetails.Set_fdFormName(const Value: WideString);
begin
  // Check for a valid EFD file or PCC .DEF/.LST combo
  If FileExists (SystemInfo.ExDataPath + FormsPath + Trim(Value) + DefDotExtension) Then
    // Valid Exchequer EFD
    FFormDets.pbEFDName := Value
  Else
    // No EFD check for .Def/.Lst files for a PCC form
    If FileExists (SystemInfo.ExDataPath + FormsPath + Trim(Value) + '.DEF') And
       FileExists (SystemInfo.ExDataPath + FormsPath + Trim(Value) + '.LST') Then
      // Valid Exchequer PCC Form
      FFormDets.pbEFDName := Value
    Else
      // Invalid FormName
      Raise EInvalidForm.Create ('The FormName ' + QuotedStr(Trim(Value)) + ' is invalid');
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdMainFileNo: Integer;
begin
  Result := FFormDets.pbMainFNum;
end;

procedure TEFPrintFormDetails.Set_fdMainFileNo(Value: Integer);
begin
  FFormDets.pbMainFNum := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdMainIndexNo: Integer;
begin
  Result := FFormDets.pbMainKPath;
end;

procedure TEFPrintFormDetails.Set_fdMainIndexNo(Value: Integer);
begin
  FFormDets.pbMainKPath := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdMainKeyString: WideString;
begin
  Result := FFormDets.pbMainKRef;
end;

procedure TEFPrintFormDetails.Set_fdMainKeyString(const Value: WideString);
begin
  FFormDets.pbMainKRef := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdTableFileNo: Integer;
begin
  Result := FFormDets.pbTablFNum;
end;

procedure TEFPrintFormDetails.Set_fdTableFileNo(Value: Integer);
begin
  FFormDets.pbTablFNum := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdTableIndexNo: Integer;
begin
  Result := FFormDets.pbTablKPath;
end;

procedure TEFPrintFormDetails.Set_fdTableIndexNo(Value: Integer);
begin
  FFormDets.pbTablKPath := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdTableKeyString: WideString;
begin
  Result := FFormDets.pbTablKRef;
end;

procedure TEFPrintFormDetails.Set_fdTableKeyString(const Value: WideString);
begin
  FFormDets.pbTablKRef := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdLabelCopies: Integer;
begin
  Result := FFormDets.pbLbCopies;
end;

procedure TEFPrintFormDetails.Set_fdLabelCopies(Value: Integer);
begin
  FFormDets.pbLbCopies := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdDescription: WideString;
begin
  Result := FFormDets.pbDescr;
end;

procedure TEFPrintFormDetails.Set_fdDescription(const Value: WideString);
begin
  FFormDets.pbDescr := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdSerialPos: Integer;
begin
  Result := FSerialPos;
end;

procedure TEFPrintFormDetails.Set_fdSerialPos(Value: Integer);
begin
  FSerialPos := Value;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Save: Integer;
Var
  FormInfo : FormInfoType;
  FormType : Byte;
begin
  Result := 0;
  LastErDesc := '';

  If (FIntfType = imAdd) Then Begin
    // Validate FormName and LabelCopies (where applicable)
    With FFormsList As TEFPrintFormsList, PrintJob As TEFPrintJob Do Begin
      { Returns a number indicating the form type: 0-Virtual, 1=EFD, 2=PCC }
      FormType := GetFormType (FFormDets.pbEFDName);
      If (FormType = 0) Then Begin
        // Invalid Form
        Result := 1000;
        LastErDesc := QuotedStr (FFormDets.pbEFDName) + ' is not a valid FormName';
      End; { If (FormType = 0) }

      If (Result = 0) Then Begin
        // Check for PCC Form used as a Label - bad karma
        If IsLabel And (FormType = 2) Then Begin
          // Error - PCC Labels not supported
          Result := 1001;
          LastErDesc := 'PCC Forms cannot be used to print labels within the Toolkit';
        End; { If IsLabel And (FormType = 2) }
      End; { If (Result = 0) }

      If (Result = 0) Then Begin
        // Get Form Information
        FormInfo := GetFormInfo (FFormDets.pbEFDName);

        // Check the form type is correct
        If IsLabel And (FormInfo.FormHeader.fhFormType <> GlobType.ftLabel) Then Begin
          // Error - Label Required
          Result := 1002;
          LastErDesc := 'A Label Type form is required for Label Print Jobs';
        End { If IsLabel And ...}
        Else
          If (Not IsLabel) And (FormInfo.FormHeader.fhFormType = GlobType.ftLabel) Then Begin
            // Error - Form Required
            Result := 1003;
            LastErDesc := 'A Label Type form cannot be used for a non-label Print Job';
          End; { If (Not IsLabel) And ... }
      End; { If (Result = 0) }

      If (Result = 0) Then
        // Check the Form Type matches the type of other forms in the
        // batch - first check to see if there are any other forms
        If (Count > 0) Then Begin
          If (GetFormType (FFormDets.pbEFDName) <> GetFormType (Forms[1].fdFormName)) Then Begin
            // Error - Forms of different types cannot be included within the same print job
            Result := 1005;
            LastErDesc := 'Forms of different types cannot be included within the same print job';
          End; { If (GetFormType ... }
        End; { If (Count > 0) }

      If (Result = 0) And IsLabel Then Begin
        // Check the Label Copies is correct
        If (FFormDets.pbLbCopies <= 0) Or (FFormDets.pbLbCopies >= 255) Then Begin
          // The number of label copies is invalid
          Result := 1004;
          LastErDesc := 'The number of label copies is invalid';
        End; { If (GetFormType ... }
      End; { If (Result = 0) ... }

      If (Result = 0) Then
        // Add into batch
        AddNewForm (Self)
    End; { With FFormsList ... }
  End { If (FIntfType = imAdd) }
  Else
    Raise EInvalidMethod.Create ('The ITransactionLine.Save method is not available');
end;

//-----------------------------------------------------------------------------

procedure TEFPrintFormDetails.Transform(const IType: TInterfaceMode);
begin
  FIntfType := IType;
end;

//-----------------------------------------------------------------------------

Procedure TEFPrintFormDetails.Assign (Const ExistingDets : TEFPrintFormDetails);
begin
  FFormDets := ExistingDets.FormDets;
  FSerialPos := ExistingDets.SerialPos;
end;

//-----------------------------------------------------------------------------

// Internal method used to retrieve a pointer to addition Serial Number info
function TEFPrintFormDetails.GetSerialPtr : Pointer;
Var
  SNoData : pBatchRepSNoInfoType;
begin
  New(SNoData);
  FillChar (SNoData^, SizeOf(SNoData^), #0);
  With SNoData^ Do Begin
    RecSize    := SizeOf(SNoData^);
    SNoRecAddr := FSerialPos;
  End; { With SNoData^ }
  Result := SNoData;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.Get_fdCustomDataCount: Integer;
begin
  Result := FCustomDataList.Count;
end;

function TEFPrintFormDetails.Get_fdCustomData(Index: Integer): IEFCustomData;
Var
  pDataRec : pDataDetailRecType;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FCustomDataList.Count) Then Begin
    // Extract data details from list and return interface
    pDataRec := FCustomDataList.Items[Index - 1];
    Result := pDataRec^.iDataDetail;
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid fdCustomData Index (' + IntToStr(Index) + ')');
end;

//-----------------------------------------------------------------------------

function TEFPrintFormDetails.AddCustomData(      FileNo: Integer;
                                                 IndexNo: Integer;
                                                 RecPosition: Integer;
                                           const SortKey: WideString): IEFCustomData;
Var
  pDataRec   : pDataDetailRecType;
  OK         : Boolean;
  FNo, IdxNo : SmallInt;
  RecPos     : LongInt;
begin
  // Create and setup a new list entry
  New (pDataRec);
  With pDataRec^ Do Begin
    oDataDetail := TEFCustomData.Create (FileNo, IndexNo, RecPosition, SortKey);
    iDataDetail := oDataDetail;
  End; { With pDataRec }

  // Add it into the internal list of data items
  FCustomDataList.Add (pDataRec);
end;

//-----------------------------------------------------------------------------

procedure TEFPrintFormDetails.DeleteCustomData(Index: Integer);
Var
  pDataRec : pDataDetailRecType;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FCustomDataList.Count) Then Begin
    // Extract data details from list and de-allocate interfaces/memory
    pDataRec := FCustomDataList.Items[Index - 1];
    With pDataRec^ Do Begin
      oDataDetail := NIL;
      iDataDetail := NIL;
    End; { With pDataRec^ }
    Dispose(pDataRec);

    // Remove from list
    FCustomDataList.Delete (IndeX - 1);
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid fdCustomData Index (' + IntToStr(Index) + ')');
end;

//-----------------------------------------------------------------------------

procedure TEFPrintFormDetails.ClearCustomData;
begin
  While (FCustomDataList.Count > 0) Do
    DeleteCustomData (1);
end;

//-----------------------------------------------------------------------------

// Builds a Temporary Database containing the CustomData for the printing routines
function TEFPrintFormDetails.BuildTempDB(Const TempDBNo : SmallInt) : ShortString;
Var
  ScratchO : ^ScratchFile;
  I        : SmallInt;
Begin { BuildTempDB }
  // Create a new Scratch File object for the appropriate Id Number
  New(ScratchO, Init(TempDBNo));
  ScratchO.KeepFile := True;

  // Return filename of temp file
  Result := FileNames[ReportF];

  // Run through the internal list of CustomData items adding into the scratch file
  If (FCustomDataList.Count > 0) Then
    For I := 0 To Pred(FCustomDataList.Count) Do
      With Get_fdCustomData(I + 1) Do
        ScratchO.Add_Scratch(cdFileNo, cdIndexNo, cdPosition, cdSortKey, '');

  // Get rid of the Scratch File object
  Dispose (ScratchO, Done);
End; { BuildTempDB }

//-----------------------------------------------------------------------------

end.


