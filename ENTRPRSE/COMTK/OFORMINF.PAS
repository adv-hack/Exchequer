unit oFormInf;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},         // COM Toolkit Type Library
     EnterpriseForms_TLB,      // Forms Toolkit Type Library
     ExceptIntf;

Type
  TFormDetails = class(TAutoIntfObjectEx, IFormDetails)
  private
    FFTKFFormDets : IEFFormDefInfo;
  protected
    // IFormDetails
    function Get_fiBinIndex: Integer; safecall;
    function Get_fiContinuation: WideString; safecall;
    function Get_fiCopies: Integer; safecall;
    function Get_fiDescription: WideString; safecall;
    function Get_fiLabelHeight: Integer; safecall;
    function Get_fiLabelInterColGap: Integer; safecall;
    function Get_fiLabelInterRowGap: Integer; safecall;
    function Get_fiLabelLeft: Integer; safecall;
    function Get_fiLabelNoCols: Integer; safecall;
    function Get_fiLabelNoRows: Integer; safecall;
    function Get_fiLabelTop: Integer; safecall;
    function Get_fiLabelWidth: Integer; safecall;
    function Get_fiPaperHeight: Integer; safecall;
    function Get_fiPaperIndex: Integer; safecall;
    function Get_fiPaperWidth: Integer; safecall;
    function Get_fiPortrait: WordBool; safecall;
    function Get_fiPrinterIndex: Integer; safecall;
    function Get_fiType: TFormType; safecall;
  public
    Constructor Create (Const FTKFFormDets : IEFFormDefInfo);
    Destructor Destroy; override;
  End; { TFormDetails }

implementation

uses ComServ,
     Miscfunc;     // Miscellaneous Types and routines for COMTK

//-----------------------------------------------------------------------------

Constructor TFormDetails.Create (Const FTKFFormDets : IEFFormDefInfo);
Begin { Create }
  Inherited Create(ComServer.TypeLib, IFormDetails);

  FFTKFFormDets := FTKFFormDets;
End; { Create }

//----------------------------------------

Destructor TFormDetails.Destroy;
Begin { Destroy }
  FFTKFFormDets := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TFormDetails.Get_fiBinIndex: Integer;
begin
  Result := FFTKFFormDets.fiBinIndex;
end;

//----------------------------------------

function TFormDetails.Get_fiContinuation: WideString;
begin
  Result := FFTKFFormDets.fiContinuation;
end;

//----------------------------------------

function TFormDetails.Get_fiCopies: Integer;
begin
  Result := FFTKFFormDets.fiCopies;
end;

//----------------------------------------

function TFormDetails.Get_fiDescription: WideString;
begin
  Result := FFTKFFormDets.fiDescription;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelHeight: Integer;
begin
  Result := FFTKFFormDets.fiLabelHeight;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelInterColGap: Integer;
begin
  Result := FFTKFFormDets.fiLabelInterColGap;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelInterRowGap: Integer;
begin
  Result := FFTKFFormDets.fiLabelInterRowGap;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelLeft: Integer;
begin
  Result := FFTKFFormDets.fiLabelLeft;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelNoCols: Integer;
begin
  Result := FFTKFFormDets.fiLabelNoCols;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelNoRows: Integer;
begin
  Result := FFTKFFormDets.fiLabelNoRows;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelTop: Integer;
begin
  Result := FFTKFFormDets.fiLabelTop;
end;

//----------------------------------------

function TFormDetails.Get_fiLabelWidth: Integer;
begin
  Result := FFTKFFormDets.fiLabelWidth;
end;

//----------------------------------------

function TFormDetails.Get_fiPaperHeight: Integer;
begin
  Result := FFTKFFormDets.fiPaperHeight;
end;

//----------------------------------------

function TFormDetails.Get_fiPaperIndex: Integer;
begin
  Result := FFTKFFormDets.fiPaperIndex;
end;

//----------------------------------------

function TFormDetails.Get_fiPaperWidth: Integer;
begin
  Result := FFTKFFormDets.fiPaperWidth;
end;

//----------------------------------------

function TFormDetails.Get_fiPortrait: WordBool;
begin
  Result := FFTKFFormDets.fiPortrait;
end;

//----------------------------------------

function TFormDetails.Get_fiPrinterIndex: Integer;
begin
  Result := FFTKFFormDets.fiPrinterIndex;
end;

//----------------------------------------

function TFormDetails.Get_fiType: TFormType;
begin
  Case FFTKFFormDets.fiType Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.ftPCC      : Result := Enterprise01_TLB.ftPCC;
    EnterpriseForms_TLB.ftEFDForm  : Result := Enterprise01_TLB.ftEFDForm;
    EnterpriseForms_TLB.ftEFDLabel : Result := Enterprise01_TLB.ftEFDLabel;
  {$ELSE}
    EnterpriseForms_TLB.ftPCC      : Result := Enterprise04_TLB.ftPCC;
    EnterpriseForms_TLB.ftEFDForm  : Result := Enterprise04_TLB.ftEFDForm;
    EnterpriseForms_TLB.ftEFDLabel : Result := Enterprise04_TLB.ftEFDLabel;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Form Type (' + IntToStr(Ord(FFTKFFormDets.fiType)) + ')');
  End; { Case FFTKFFormDets.fiType }
end;

//-----------------------------------------------------------------------------

end.
