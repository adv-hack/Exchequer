unit oFormLst;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, oFormDet, GlobType;

type
  TEFPrintFormsList = class(TAutoIntfObject, IEFPrintFormsList)
  private
    // Handle to parent PrintJob object
    FPrintJob : TObject;

    // List of Forms for current print job
    FForms    : TList;
  protected
    // IEFPrintFormsList
    function Get_pfCount: Integer; safecall;
    function Get_pfForms(Index: Integer): IEFPrintFormDetails; safecall;
    function Add: IEFPrintFormDetails; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;

    // Local methods
    procedure InitObjs;
  public
    Property Count : Integer Read Get_pfCount;
    Property Forms [Index : Integer] : IEFPrintFormDetails Read Get_pfForms;
    Property PrintJob : TObject Read FPrintJob;

    Constructor Create (Const PrintJob : TObject);
    Destructor Destroy; override;

    Procedure AddNewForm (Const FormDets : TEFPrintFormDetails);
    function  BuildTempDB(Const IdxNo, TmpDBNo : SmallInt) : ShortString;
    Function  GetFormDets (Const Idx : Integer) : PrintBatchRecType;
    function  GetSerialPtr(const Idx: Integer): Pointer;
    Procedure Initialise;
  End; { TEFPrintFormsList }

implementation

uses ComServ, oMain, MiscFunc;

Type
  TFormDetailsType = Record
    FormO  : TEFPrintFormDetails;
    FormI  : IEFPrintFormDetails;
  End; { TFormDetailsType }
  pFormDetailsType = ^TFormDetailsType;

//-----------------------------------------------------------------------------

Constructor TEFPrintFormsList.Create (Const PrintJob : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFPrintFormsList);

  InitObjs;

  // Create TList to store the Form Details
  FForms := TList.Create;

  FPrintJob := PrintJob;
End; { Create }

//----------------------------------------

Destructor TEFPrintFormsList.Destroy;
Begin { Destroy }
  InitObjs;

  // Remove any form details in the forms list and destroy the list
  Clear;
  FreeAndNil(FForms);

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEFPrintFormsList.InitObjs;
begin
  FPrintJob := Nil;
end;

//-----------------------------------------------------------------------------

function TEFPrintFormsList.Get_pfCount: Integer;
begin
  Result := FForms.Count;
end;

//----------------------------------------

function TEFPrintFormsList.Get_pfForms(Index: Integer): IEFPrintFormDetails;
Var
  oForm : pFormDetailsType;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FForms.Count) Then Begin
    // Extract form details from list and return interface
    oForm := Pointer(FForms.Items[Index - 1]);
    Result := oForm^.FormI;
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid pfForms Index (' + IntToStr(Index) + ')');
end;

//-----------------------------------------------------------------------------

// Called by TEFPrintJobDetails.Initialise to re-initialise the forms list
Procedure TEFPrintFormsList.Initialise;
Begin { Initialise }
  Clear;
End; { Initialise }

//-----------------------------------------------------------------------------

function TEFPrintFormsList.Add: IEFPrintFormDetails;
Var
  oPrintForm : TEFPrintFormDetails;
begin
  // Create new Print Form Details Line object
  oPrintForm := TEFPrintFormDetails.Create(imAdd, Self);

  // Return reference to interface - will be destroyed if it goes out of scope OR it
  // will be added into FForms by AddNewForm if the user calls the Save method
  Result := oPrintForm;
end;

// Called by the Transaction Line created in .Add to add itself into the list
Procedure TEFPrintFormsList.AddNewForm (Const FormDets : TEFPrintFormDetails);
Var
  oForm : pFormDetailsType;
Begin { AddNewForm }
  // Create and initialise a list object
  New (oForm);
  With oForm^ Do Begin
    FormO := FormDets;
    FormI := FormDets;
  End; { With oForm }

  // Add into Lines List
  FForms.Add(oForm);

  // Transform Line from 'Add' mode to standard mode
  FormDets.Transform(imUpdate);
End; { AddNewForm }

//-----------------------------------------------------------------------------

procedure TEFPrintFormsList.Delete(Index: Integer);
Var
  TmpForm : pFormDetailsType;
begin
  If Assigned(FForms) Then Begin
    // Check the array index is valid (remembering the array is 1 based)
    If (Index >= 1) And (Index <= FForms.Count) Then Begin
      // Get interfaces and destroy them
      TmpForm := FForms.Items[Index - 1];
      TmpForm.FormO := Nil;
      TmpForm.FormI := Nil;
      Dispose(TmpForm);

      // Destroy List Entry
      FForms.Delete(Index - 1);
    End { While (FForms.Count > 0 ) }
    Else
      // Error - Index out of valid range
      Raise EInvalidIndex.Create ('Invalid pfForms Index (' + IntToStr(Index) + ')');
  End; { If Assigned(FForms) }
end;

//-----------------------------------------------------------------------------

procedure TEFPrintFormsList.Clear;
begin
  If Assigned(FForms) Then
    While (FForms.Count > 0 ) Do
      Delete(1);
end;

//-----------------------------------------------------------------------------

// Internal method used to access the Form details when building the batch in the Print method
function TEFPrintFormsList.GetFormDets(const Idx: Integer): PrintBatchRecType;
Var
  oForm : pFormDetailsType;
begin
  // Check Index is within valid range
  If (Idx >= 0) And (Idx < FForms.Count) Then Begin
    // Extract form details from list and return interface
    oForm := Pointer(FForms.Items[Idx]);
    Result := oForm^.FormO.FormDets;
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid pfForms Index (' + IntToStr(Idx) + ')');
end;

//-----------------------------------------------------------------------------

// Internal method used to retrieve a pointer to addition Serial Number info
function TEFPrintFormsList.GetSerialPtr(const Idx: Integer): Pointer;
Var
  oForm : pFormDetailsType;
begin
  // Check Index is within valid range
  If (Idx >= 0) And (Idx < FForms.Count) Then Begin
    // Extract form details from list and return interface
    oForm := Pointer(FForms.Items[Idx]);
    Result := oForm^.FormO.GetSerialPtr;
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid pfForms Index (' + IntToStr(Idx) + ')');
end;

//-----------------------------------------------------------------------------

function TEFPrintFormsList.BuildTempDB(Const IdxNo, TmpDBNo : SmallInt) : ShortString;
Var
  oForm : pFormDetailsType;
Begin { BuildTempDB }
  // Check Index is within valid range
  If (IdxNo >= 0) And (IdxNo < FForms.Count) Then Begin
    // Extract form details from list and return interface
    oForm := Pointer(FForms.Items[IdxNo]);
    Result := oForm^.FormO.BuildTempDB(TmpDBNo);
  End { If (Index >= 1) And ... }
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid pfForms Index (' + IntToStr(IdxNo) + ')');
End; { BuildTempDB }

//-----------------------------------------------------------------------------

end.
