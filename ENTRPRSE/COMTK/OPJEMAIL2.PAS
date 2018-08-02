unit oPJEmail2;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},// COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     ExceptIntf;

type
  TEmailAddressArray = class;

  TEmailAddress = class (TAutoIntfObjectEx, IEmailAddress)
  private
    // Handle to EmailAddress object within Forms Toolkit
    FFTKEmailDets : IEFEmailAddress;
  protected
    // IEmailAddress
    function Get_emlName: WideString; safecall;
    procedure Set_emlName(const Value: WideString); safecall;
    function Get_emlAddress: WideString; safecall;
    procedure Set_emlAddress(const Value: WideString); safecall;
  public
    Constructor Create (Const FTKEmailDets : IEFEmailAddress);
    Destructor Destroy; override;
  End; { TEmailAddress }

  //--------------------------

  TEmailAddressArray = class(TAutoIntfObjectEx, IEmailAddressArray)
  private
    // Interface to Email Address List within the Form Toolkit object
    FFTKEmailList : IEFEmailAddressArray;

    // Local reference to base PrintJob object within the COM Toolkit
    FCTKPrintJob : TObject;

    // Internal list to store wrapper objects for Form Detail Sub-Objects
    FEmailList : TList;
  protected
    // IEmailAddressArray
    function Get_eaItems(Index: Integer): IEmailAddress; safecall;
    function Get_eaCount: Integer; safecall;
    function AddAddress(const Name: WideString; const Address: WideString): Integer; safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;

    // Local methods
    procedure BuildSubList;
    procedure ClearSubList;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const FTKEmailList : IEFEmailAddressArray);
    Destructor Destroy; override;
  End; { TEmailAddressArray }

implementation

Uses ComServ,
     GlobVar,        // Exchequer Global Const/Type/Var
     MiscFunc,       // Miscellaneous types and routines
     oPrntJob;       // Print Job object (IPrintJob)

Type
  TEmailAddrRecType = Record
    iEmailAddr  : IEmailAddress;
    oEmailAddr  : TEmailAddress;
  End; { TEmailAddrRecType }
  pEmailAddrRecType = ^TEmailAddrRecType;

//------------------------------------------------------------------------

constructor TEmailAddress.Create(const FTKEmailDets: IEFEmailAddress);
begin
  Inherited Create (ComServer.TypeLib, IEmailAddress);

  FFTKEmailDets := FTKEmailDets;
end;

destructor TEmailAddress.Destroy;
begin
  // Remove reference to other objects
  FFTKEmailDets := NIL;

  inherited;
end;

//-----------------------------------------------------------------------------

function TEmailAddress.Get_emlName: WideString;
begin
  Result := FFTKEmailDets.emlName;
end;

procedure TEmailAddress.Set_emlName(const Value: WideString);
begin
  FFTKEmailDets.emlName := Value;
end;

//----------------------------------------

function TEmailAddress.Get_emlAddress: WideString;
begin
  Result := FFTKEmailDets.emlAddress;
end;

procedure TEmailAddress.Set_emlAddress(const Value: WideString);
begin
  FFTKEmailDets.emlAddress := Value;
end;

//-----------------------------------------------------------------------------

Constructor TEmailAddressArray.Create (Const CTKPrintJob : TObject; Const FTKEmailList : IEFEmailAddressArray);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEmailAddressArray);

  FCTKPrintJob := CTKPrintJob;
  FFTKEmailList := FTKEmailList;

  // Create sub-objects for Email Addresses
  FEmailList := TList.Create;
  BuildSubList;
End; { Create }

//----------------------------------------

Destructor TEmailAddressArray.Destroy;
Begin { Destroy }
  FFTKEmailList := NIL;
  FCTKPrintJob := NIL;

  ClearSubList;
  FreeAndNIL(FEmailList);

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEmailAddressArray.BuildSubList;
Var
  AddrDets : pEmailAddrRecType;
  I        : SmallInt;
begin { BuildSubList }
  // Clear out any pre-existing items
  ClearSubList;

  If (FFTKEmailList.eaCount > 0) Then
    For I := 1 To FFTKEmailList.eaCount Do Begin
      New(AddrDets);
      With AddrDets^ Do Begin
        oEmailAddr := TEmailAddress.Create(FFTKEmailList.eaItems[I]);
        iEmailAddr := oEmailAddr;
      End; { With AddrDets^ }

      FEmailList.Add(AddrDets);
    End; { For I }
End; { BuildSubList }

//----------------------------------------

procedure TEmailAddressArray.ClearSubList;
Var
  AddrDets : pEmailAddrRecType;
  I        : SmallInt;
begin { ClearList }
  If Assigned(FEmailList) Then
    While (FEmailList.Count > 0) Do Begin
      // Extract details from list and free all objects/memory
      AddrDets := Pointer(FEmailList.Items[0]);
      AddrDets^.iEmailAddr := NIL;
      Dispose(AddrDets);

      FEmailList.Delete (0);
    End; { While (FEmailList.Count > 0) }
End; { ClearList }

//-----------------------------------------------------------------------------

function TEmailAddressArray.Get_eaItems(Index: Integer): IEmailAddress;
Var
  AddrDets : pEmailAddrRecType;
begin
  If Assigned(FEmailList) Then Begin
    // Check Index is within valid range
    If (Index >= 1) And (Index <= FEmailList.Count) Then Begin
      // Extract form details from list and return interface
      AddrDets := FEmailList.Items[Index - 1];
      Result := AddrDets^.iEmailAddr;
    End { If (Index >= 1) And ... }
    Else
      // Error - Index out of valid range
      Raise EInvalidIndex.Create ('Invalid eaItems Index (' + IntToStr(Index) + ')');
  End; { If Assigned(FEmailList) }
end;

//----------------------------------------

function TEmailAddressArray.Get_eaCount: Integer;
begin
  Result := FFTKEmailList.eaCount;
end;

//----------------------------------------

function TEmailAddressArray.AddAddress(const Name: WideString; const Address: WideString): Integer;
begin
  LastErDesc := '';
  Result := FFTKEmailList.AddAddress(Name, Address);
  If (Result = 0) Then
    BuildSubList
  Else
    LastErDesc := (FCTKPrintJob As TPrintJob).FormsToolkitI.LastErrorString;
end;

//----------------------------------------

procedure TEmailAddressArray.Delete(Index: Integer);
begin
  FFTKEmailList.Delete(Index);
  BuildSubList;
end;

//-----------------------------------------------------------------------------

procedure TEmailAddressArray.Clear;
begin
  FFTKEmailList.Clear;
  BuildSubList;
end;

//-----------------------------------------------------------------------------

end.
