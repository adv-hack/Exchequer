unit oTmpFile;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, // COM Toolkit Type Library
     EnterpriseForms_TLB,      // Form Printing Toolkit Type Library
     ExceptIntf;

type
  TPrintTempFile = class(TAutoIntfObjectEx, IPrintTempFile)
  private
    // Form printing Toolkit sub-object
    FFormsToolkit : IEFPrintingToolkit;

    // Reference to Forms TK TempFile object that this class wwraps
    FFTKTempFile  : IEFPrintTempFile;
  protected
    // IPrintTempFile
    function Get_pfType: TPrintDestination; safecall;
    function Get_pfFileName: WideString; safecall;
    function DisplayPreviewWindow(PreviewType: TPreviewType): Integer; safecall;
    function SendToDestination: Integer; safecall;
    function Get_pfPages: Integer; safecall;
    function Get_pfStartPage: Integer; safecall;
    procedure Set_pfStartPage(Value: Integer); safecall;
    function Get_pfFinishPage: Integer; safecall;
    procedure Set_pfFinishPage(Value: Integer); safecall;
    function Get_pfCopies: Integer; safecall;
    procedure Set_pfCopies(Value: Integer); safecall;
    function Get_pfStatus: Integer; safecall;
    function SaveAsFile(const FilePath: WideString; FileType: TSaveAsType): Integer; safecall;

    // Local methods
  public
    Constructor Create (Const FormsToolkit : IEFPrintingToolkit; Const FTKTempFile : IEFPrintTempFile);
    Destructor Destroy; override;
  End; { TPrintTempFile }


implementation

uses ComServ,
     GlobVar,        // Exchequer Global Const/Type/Var
     MiscFunc,       // Miscellaneous types and routines
     oToolkit;       // Base COM Toolkit Object  (TToolkit)

//-----------------------------------------------------------------------------

Constructor TPrintTempFile.Create (Const FormsToolkit : IEFPrintingToolkit; Const FTKTempFile : IEFPrintTempFile);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintTempFile);

  FFormsToolkit := FormsToolkit;
  FFTKTempFile := FTKTempFile;
End; { Create }

//----------------------------------------

Destructor TPrintTempFile.Destroy;
Begin { Destroy }
  FFTKTempFile := NIL;
  FFormsToolkit := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TPrintTempFile.Get_pfFileName: WideString;
begin
  Result := FFTKTempFile.pfFileName;
end;

//----------------------------------------

function TPrintTempFile.Get_pfType: TPrintDestination;
begin
  Case FFTKTempFile.pfType Of
    tfdPrinter : Result := pdPrinter;
    tfdEmail   : Result := pdEmail;
    tfdFax     : Result := pdFax;
  Else
    Raise EUnknownValue.Create ('Unknown pfType (' + IntToStr(Ord(FFTKTempFile.pfType)) + ')');
  End; { Case FFTKTempFile.pfType }
end;

//----------------------------------------

function TPrintTempFile.Get_pfPages: Integer;
begin
  Result := FFTKTempFile.pfPages;
end;

//----------------------------------------

function TPrintTempFile.Get_pfStartPage: Integer;
begin
  Result := FFTKTempFile.pfStartPage;
end;

procedure TPrintTempFile.Set_pfStartPage(Value: Integer);
begin
  FFTKTempFile.pfStartPage := Value;
end;

//----------------------------------------

function TPrintTempFile.Get_pfFinishPage: Integer;
begin
  Result := FFTKTempFile.pfFinishPage;
end;

procedure TPrintTempFile.Set_pfFinishPage(Value: Integer);
begin
  FFTKTempFile.pfFinishPage := Value;
end;

//----------------------------------------

function TPrintTempFile.Get_pfCopies: Integer;
begin
  Result := FFTKTempFile.pfCopies;
end;

procedure TPrintTempFile.Set_pfCopies(Value: Integer);
begin
  FFTKTempFile.pfCopies := Value;
end;

//----------------------------------------

function TPrintTempFile.Get_pfStatus: Integer;
begin
  Result := FFTKTempFile.pfStatus;
end;

//-----------------------------------------------------------------------------

function TPrintTempFile.DisplayPreviewWindow(PreviewType: TPreviewType): Integer;
Var
  PrevType: TEFPreviewType;
begin
  Case PreviewType Of
  {$IFNDEF WANTEXE}
    Enterprise01_TLB.ptNonModal  : PrevType := EnterpriseForms_TLB.ptNonModal;
    Enterprise01_TLB.ptEDFReader : PrevType := EnterpriseForms_TLB.ptEDFReader;
  {$ELSE}
    Enterprise04_TLB.ptNonModal  : PrevType := EnterpriseForms_TLB.ptNonModal;
    Enterprise04_TLB.ptEDFReader : PrevType := EnterpriseForms_TLB.ptEDFReader;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown PreviewType (' + IntToStr(Ord(PreviewType)) + ') in IPrintTempFile.DisplayPreviewWindow');
  End; { Case PreviewType }

  Result := FFTKTempFile.DisplayPreviewWindow(PrevType)
end;

//-----------------------------------------------------------------------------

function TPrintTempFile.SendToDestination: Integer;
begin
  LastErDesc := '';
  Result := FFTKTempFile.SendToDestination;
  If (Result <> 0) Then
    LastErDesc := FFormsToolkit.LastErrorString;
end;

//-----------------------------------------------------------------------------

function TPrintTempFile.SaveAsFile(const FilePath: WideString; FileType: TSaveAsType): Integer;
Var
  FType : TEFSaveAsType;
begin
  LastErDesc := '';

  Case FileType Of
    {$IFNDEF WANTEXE}
    Enterprise01_TLB.saEDF : FType := EnterpriseForms_TLB.saEDF;
    Enterprise01_TLB.saEDZ : FType := EnterpriseForms_TLB.saEDZ;
    Enterprise01_TLB.saPDF : FType := EnterpriseForms_TLB.saPDF;
    {$ELSE}
    Enterprise04_TLB.saEDF : FType := EnterpriseForms_TLB.saEDF;
    Enterprise04_TLB.saEDZ : FType := EnterpriseForms_TLB.saEDZ;
    Enterprise04_TLB.saPDF : FType := EnterpriseForms_TLB.saPDF;
    {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown FileType (' + IntToStr(Ord(FileType)) + ') in IPrintTempFile.SaveAsFile');
  End; { Case FileType }

  Result := FFTKTempFile.SaveAsFile(FilePath, FType);
  If (Result <> 0) Then
    LastErDesc := FFormsToolkit.LastErrorString;
end;

//-----------------------------------------------------------------------------

end.
