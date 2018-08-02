unit oFormLst;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},         // COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     ExceptIntf;

type
  TPrintFormList = class;

  //---------------------------

  // Private interface used AppendPrintJob routine to extract the details
  // from the PrintJob instance being appended
  IPrivatePrintJobData = Interface
    ['{C44BAC42-79C3-4BE6-B050-837EEA939210}']

    // --- Internal Methods to implement Public Properties ---
    Function GetFormDets : IEFPrintFormDetails;

    // ------------------ Public Properties ------------------
    Property ftkFormDets : IEFPrintFormDetails Read GetFormDets;

    // ------------------- Public Methods --------------------

  End; // IPrivatePrintJobData

  //------------------------------

  TPrintFormDetail = class (TAutoIntfObjectEx, IPrintFormDetail, IPrivatePrintJobData)
  private
    // Local reference to base PrintJob object within the COM Toolkit
    FCTKPrintJob : TObject;

    // Handle to parent Forms List within COM Toolkit
    FCTKFormsList : TPrintFormList;

    // Handle to FormDetails object within Forms Toolkit
    FFTKFormDets : IEFPrintFormDetails;

    FMode : Byte;
  protected
    // IPrintFormDetail
    function Get_fdFormName: WideString; safecall;
    procedure Set_fdFormName(const Value: WideString); safecall;
    function Get_fdDescription: WideString; safecall;
    procedure Set_fdDescription(const Value: WideString); safecall;
    function Get_fdLabelCopies: Integer; safecall;
    procedure Set_fdLabelCopies(Value: Integer); safecall;
    function Save: Integer; safecall;

    // IPrivatePrintJobData
    Function GetFormDets : IEFPrintFormDetails;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const CTKFormsList : TPrintFormList; Const FTKFormDets : IEFPrintFormDetails; Const OpMode : Byte);
    Destructor Destroy; override;
  End; { TPrintFormDetail }

  //---------------------------

  TPrintFormList = class(TAutoIntfObjectEx, IPrintFormList, IPrintFormList2)
  private
    // Handle to parent COM Toolkit Print Job object
    FCTKPrintJob  : TObject;

    // Interface to Forms List within the Form Toolkit object
    FFTKFormsList : IEFPrintFormsList;

    // Internal list to store wrapper objects for Form Detail Sub-Objects
    FFormDetail : TList;
  protected
    // IPrintFormList
    function Get_pfForms(Index: Integer): IPrintFormDetail; safecall;
    function Get_pfCount: Integer; safecall;
    function Add: IPrintFormDetail; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;

    // IPrintFormList2
    function AddForms(const FormsList: IPrintFormList): Integer; safecall;

    // Local methods
    procedure BuildSubList;
    procedure ClearSubList;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const FTKFormsList : IEFPrintFormsList);
    Destructor Destroy; override;
  End; { TPrintFormList }

implementation

Uses ComServ,
     GlobVar,        // Exchequer Global Const/Type/Var
     MiscFunc,       // Miscellaneous types and routines
     oPrntJob;       // Print Job object (IPrintJob)

Type
  TFormDetailRecType = Record
    iFormDetail  : IPrintFormDetail;
    oFormDetail  : TPrintFormDetail;
  End; { TFormDetailRecType }
  pFormDetailRecType = ^TFormDetailRecType;

//------------------------------------------------------------------------

Constructor TPrintFormDetail.Create (Const CTKPrintJob : TObject; Const CTKFormsList : TPrintFormList; Const FTKFormDets : IEFPrintFormDetails; Const OpMode : Byte);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintFormDetail);

  FCTKPrintJob := CTKPrintJob;
  FCTKFormsList := CTKFormsList;
  FFTKFormDets := FTKFormDets;
  FMode := OpMode;
End; { Create }

//----------------------------------------

Destructor TPrintFormDetail.Destroy;
Begin { Destroy }
  // Remove reference to other objects
  FCTKPrintJob := NIL;
  FCTKFormsList := NIL;
  FFTKFormDets := NIL;

  inherited Destroy;
End; { Destroy }

//------------------------------------------------------------------------

function TPrintFormDetail.Get_fdDescription: WideString;
begin
  Result := FFTKFormDets.fdDescription;
end;

procedure TPrintFormDetail.Set_fdDescription(const Value: WideString);
begin
  FFTKFormDets.fdDescription := Value;
end;

//----------------------------------------

function TPrintFormDetail.Get_fdFormName: WideString;
begin
  Result := FFTKFormDets.fdFormName;
end;

procedure TPrintFormDetail.Set_fdFormName(const Value: WideString);
begin
  FFTKFormDets.fdFormName := Value;
end;

//----------------------------------------

function TPrintFormDetail.Get_fdLabelCopies: Integer;
begin
  Result := FFTKFormDets.fdLabelCopies;
end;

procedure TPrintFormDetail.Set_fdLabelCopies(Value: Integer);
begin
  FFTKFormDets.fdLabelCopies := Value;
end;

//-----------------------------------------------------------------------------

function TPrintFormDetail.Save: Integer;
begin
  LastErDesc := '';

  If (FMode = 1) Then Begin
    // Save details into Form Toolkit Forms List
    Result := FFTKFormDets.Save;
    If (Result <> 0) Then
      LastErDesc := (FCTKPrintJob As TPrintJob).FormsToolkitI.LastErrorString;

    // Update COM Toolkit wrapper around Form Toolkit Forms List
    FCTKFormsList.BuildSubList;
  End { If (FMode = 1) }
  Else
    // No action req'd
    Result := 0;
end;

//-------------------------------------------------------------------------

Function TPrintFormDetail.GetFormDets : IEFPrintFormDetails;
Begin
  Result := FFTKFormDets;
End;

//-----------------------------------------------------------------------------

Constructor TPrintFormList.Create (Const CTKPrintJob : TObject; Const FTKFormsList : IEFPrintFormsList);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintFormList);

  FCTKPrintJob  := CTKPrintJob;
  FFTKFormsList := FTKFormsList;

  // Create sub-objects for Printers/Bins/Papers
  FFormDetail := TList.Create;
  BuildSubList;
End; { Create }

//----------------------------------------

Destructor TPrintFormList.Destroy;
Begin { Destroy }
  FCTKPrintJob  := NIL;
  FFTKFormsList := NIL;

  ClearSubList;
  FreeAndNIL(FFormDetail);

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TPrintFormList.BuildSubList;
Var
  FormDets : pFormDetailRecType;
  I        : SmallInt;
begin { BuildSubList }
  // Clear out any pre-existing items
  ClearSubList;

  If (FFTKFormsList.pfCount > 0) Then
    For I := 1 To FFTKFormsList.pfCount Do Begin
      New(FormDets);
      With FormDets^ Do Begin
        oFormDetail := TPrintFormDetail.Create(FCTKPrintJob, Self, FFTKFormsList.pfForms[I], 0);
        iFormDetail := oFormDetail;
      End; { With FormDets^ }

      FFormDetail.Add(FormDets);
    End; { For I }
End; { BuildSubList }

//----------------------------------------

procedure TPrintFormList.ClearSubList;
Var
  FormDets : pFormDetailRecType;
  I        : SmallInt;
begin { ClearList }
  If Assigned(FFormDetail) Then
    While (FFormDetail.Count > 0) Do Begin
      // Extract details from list and free all objects/memory
      FormDets := Pointer(FFormDetail.Items[0]);
      FormDets^.iFormDetail := NIL;
      Dispose(FormDets);

      FFormDetail.Delete (0);
    End; { While (FFormDetail.Count > 0) }
End; { ClearList }

//-----------------------------------------------------------------------------

function TPrintFormList.Get_pfCount: Integer;
begin
  Result := FFTKFormsList.pfCount;
end;

//----------------------------------------

function TPrintFormList.Get_pfForms(Index: Integer): IPrintFormDetail;
Var
  FormDets : pFormDetailRecType;
begin
  If Assigned(FFormDetail) Then Begin
    // Check Index is within valid range
    If (Index >= 1) And (Index <= FFormDetail.Count) Then Begin
      // Extract form details from list and return interface
      FormDets := FFormDetail.Items[Index - 1];
      Result := FormDets^.iFormDetail;
    End { If (Index >= 1) And ... }
    Else
      // Error - Index out of valid range
      Raise EInvalidIndex.Create ('Invalid pjForms Index (' + IntToStr(Index) + ')');
  End; { If Assigned(FFormDetail) }
end;

//-----------------------------------------------------------------------------

function TPrintFormList.Add: IPrintFormDetail;
Var
  FTKFormDets : IEFPrintFormDetails;
begin
  // Create new Form Details object within the Forms TK
  FTKFormDets := FFTKFormsList.Add;
  With FTKFormDets, FCTKPrintJob As TPrintJob Do Begin
    fdMode := FormDefMode;

    fdMainFileNo := MainFileNum;
    fdMainIndexNo := MainKeyPath;
    fdMainKeyString := MainKeyRef;

    fdTableFileNo := TableFileNum;
    fdTableIndexNo := TableKeyPath;
    fdTableKeyString := TableKeyRef;

    fdDescription := 'Enterprise COM Toolkit Print Job';
    fdLabelCopies := 1;
  End; { With FTKFormDets }

  // Create COM Toolkit wrapper object to return to the user
  Result := TPrintFormDetail.Create(FCTKPrintJob, Self, FTKFormDets, 1);
end;

//-----------------------------------------------------------------------------

procedure TPrintFormList.Clear;
begin
  FFTKFormsList.Clear;
  BuildSubList;
end;

//-----------------------------------------------------------------------------

procedure TPrintFormList.Delete(Index: Integer);
begin
  FFTKFormsList.Delete(Index);
  BuildSubList;
end;

//-----------------------------------------------------------------------------

// Extracts the data from the passed print job and adds it into the current Print Job
//
// Return Values:-
//
//   0        AOK
//   1        Warning: No Forms in FormsList
//
function TPrintFormList.AddForms(const FormsList: IPrintFormList): Integer;
Var
  iImportedForm : IEFPrintFormDetails;
  I             : SmallInt;
Begin // AppendForm
  Result := 0;
  LastErDesc := '';

  If (FormsList.pfCount > 0) Then
  Begin
    For I := 1 To FormsList.pfCount Do
    Begin
      // Extract the reference to the Forms Toolkit object behind the COM Toolkit
      // object representing the form
      iImportedForm := (FormsList.pfForms[I] As IPrivatePrintJobData).ftkFormDets;
      Try
        // Create an object within this PrintJob's forms list and copy the details
        // in from the form we are importing from the FormsList parameter
        With FFTKFormsList.Add Do
        Begin
          fdMode           := iImportedForm.fdMode;
          fdFormName       := iImportedForm.fdFormName;
          fdMainFileNo     := iImportedForm.fdMainFileNo;
          fdMainIndexNo    := iImportedForm.fdMainIndexNo;
          fdMainKeyString  := iImportedForm.fdMainKeyString;
          fdTableFileNo    := iImportedForm.fdTableFileNo;
          fdTableIndexNo   := iImportedForm.fdTableIndexNo;
          fdTableKeyString := iImportedForm.fdTableKeyString;
          fdDescription    := iImportedForm.fdDescription;
          fdLabelCopies    := iImportedForm.fdLabelCopies;
          fdSerialPos      := iImportedForm.fdSerialPos;
          Result := Save;
        End; // With FFTKFormsList.Add

        If (Result <> 0) Then
        Begin
          Break;
        End; // If (Result <> 0)
      Finally
        iImportedForm := NIL;
      End; // Try..Finally
    End; // For I

    // MH 25/03/2008: Must refresh the list otherwise the wrapper is out of sync with the Forms Toolkit
    BuildSubList;
  End // If (FormsList.pfCount > 0)
  Else
  Begin
    Result := 1;
    LastErDesc := 'Warning - No forms were present in the imported FormsList';
  End; // Else
End; // AppendForm

//-----------------------------------------------------------------------------

end.

