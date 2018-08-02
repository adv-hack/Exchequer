unit oPJEmail3;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},// COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     ExceptIntf;

type
  TEmailAttachments = class (TAutoIntfObjectEx, IEmailAttachments)
  private
    // Handle to EmailAttachments sub-object within Forms Toolkit
    FFTKEmailAttachments : IEFStringListReadWrite;

    // Local reference to base PrintJob object within the COM Toolkit
    FCTKPrintJob : TObject;
  protected
    // IEmailAddress
    function Get_afFiles(Index: Integer): WideString; safecall;
    procedure Set_afFiles(Index: Integer; const Value: WideString); safecall;
    function Get_afCount: Integer; safecall;
    function Add(const AddString: WideString): Integer; safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const FTKEmailAttachments : IEFStringListReadWrite);
    Destructor Destroy; override;
  End; { TEmailAttachments }

implementation

Uses ComServ,
     GlobVar,        // Exchequer Global Const/Type/Var
     MiscFunc,       // Miscellaneous types and routines
     oPrntJob;       // Print Job object (IPrintJob)

//------------------------------------------------------------------------

constructor TEmailAttachments.Create(Const CTKPrintJob : TObject; const FTKEmailAttachments: IEFStringListReadWrite);
begin
  Inherited Create (ComServer.TypeLib, IEmailAttachments);

  FCTKPrintJob := CTKPrintJob;
  FFTKEmailAttachments := FTKEmailAttachments;
end;

destructor TEmailAttachments.Destroy;
begin
  FCTKPrintJob := NIL;
  FFTKEmailAttachments := NIL;
  inherited;
end;

//------------------------------------------------------------------------

function TEmailAttachments.Get_afFiles(Index: Integer): WideString;
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FFTKEmailAttachments.Count) Then
    Result := FFTKEmailAttachments.Strings[Index]
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid afFiles Index (' + IntToStr(Index) + ')');
end;

procedure TEmailAttachments.Set_afFiles(Index: Integer; const Value: WideString);
begin
  // Check Index is within valid range
  If (Index >= 1) And (Index <= FFTKEmailAttachments.Count) Then
    FFTKEmailAttachments.Strings[Index] := Value
  Else
    // Error - Index out of valid range
    Raise EInvalidIndex.Create ('Invalid afFiles Index (' + IntToStr(Index) + ')');
end;

//----------------------------------------

function TEmailAttachments.Get_afCount: Integer;
begin
  Result := FFTKEmailAttachments.Count;
end;

//------------------------------------------------------------------------

function TEmailAttachments.Add(const AddString: WideString): Integer;
begin
  LastErDesc := '';
  Result := FFTKEmailAttachments.Add (AddString);
  If (Result <> 0) Then
    LastErDesc := (FCTKPrintJob As TPrintJob).FormsToolkitI.LastErrorString;
end;

//------------------------------------------------------------------------

procedure TEmailAttachments.Delete(Index: Integer);
begin
  FFTKEmailAttachments.Delete(Index);
end;

//------------------------------------------------------------------------

procedure TEmailAttachments.Clear;
begin
  FFTKEmailAttachments.Clear;
end;

//------------------------------------------------------------------------

end.
