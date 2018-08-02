unit uReportParams;

interface

uses
  SysUtils, Variants, Classes, RpFiler, Contnrs, RpDefine;

{Classes for printing Report parameters.

 TParamsObject stores the name and value of an object
 and is given a callback procedure to print what it knows to the report.

 TReportParameters is a list of TParamsObjects. It sets the tabs on the report
 then prints a header before iterating through its objects calling the print method on each.}


type
  TPrintOnReportProc = Procedure (ThisLine  :  String) of Object;

  TParamsObject = Class
  private
    FName : string;
    FValue : Variant;
    FPrintProc : TPrintOnReportProc;
    function ProcessStringValue(const s : string) : string;
    function GetStringValue : string;
  public
    procedure Print;
    procedure Assign(oParam : TParamsObject);
    property Name : string read FName write FName;
    property Value : Variant read FValue write FValue;
    property PrintProc : TPrintOnReportProc read FPrintProc write FPrintProc;
    property StringValue : string read GetStringValue;
  end;

  TCRLFCallback = Procedure of Object;
  TPrintLeftCallBack = Procedure (Text: string; Pos: double) of Object;

  TReportParameters = Class(TObjectList)
  private
    FPrintParamsProc : TPrintOnReportProc;
    FRepFiler : TReportFiler;
    FFirstColWidth : Integer;
    FHeader : string;

    FOnCRLF : TCRLFCallback;
    FOnPrintLeft : TPrintLeftCallBack;
  protected
    function GetItem(Index: Integer): TParamsObject;
    procedure SetItem(Index: Integer; AParamsObject: TParamsObject);
    procedure CheckWidths;
    function GetHeader : string;
  public
    procedure Print;
    function Add(AParamsObject: TParamsObject): Integer;
    function AddParam : TParamsObject;
    procedure Assign(const oParams : TReportParameters);
    property Items[Index: Integer]: TParamsObject read GetItem write SetItem; default;
    property PrintParamsProc : TPrintOnReportProc read FPrintParamsProc write FPrintParamsProc;
    property ReportFiler : TReportFiler read FRepFiler write FRepFiler;
    property Header : string read GetHeader;

    Property OnCRLF : TCRLFCallback Read FOnCRLF Write FOnCRLF;
    Property OnPrintLeft : TPrintLeftCallBack Read FOnPrintLeft Write FOnPrintLeft;
  end;


implementation

{ TParamsObject }

procedure TParamsObject.Assign(oParam: TParamsObject);
begin
  FName := oParam.Name;
  FValue := oParam.Value;
end;

function TParamsObject.GetStringValue: string;
begin
  Result := ProcessStringValue(VarToStr(FValue));
end;

procedure TParamsObject.Print;
begin
  if Assigned(FPrintProc) then
    FPrintProc(#9 + FName + ':'#9 + GetStringValue);
end;

function TParamsObject.ProcessStringValue(const s: string): string;
begin
  if Trim(s) = '' then
    Result := 'Not Set'
  else
  if UpperCase(s) = 'TRUE' then
    Result := 'Yes'
  else
  if UpperCase(s) = 'FALSE' then
    Result := 'No'
  else
    Result := s;
end;

{ TReportParameters }
function TReportParameters.Add(AParamsObject: TParamsObject): Integer;
begin
  Result := inherited Add(TObject(AParamsObject));
end;

function TReportParameters.AddParam: TParamsObject;
begin
  Result := TParamsObject.Create;
  Add(Result);
end;

procedure TReportParameters.Assign(const oParams: TReportParameters);
var
  i : Integer;
begin
  for i := 0 to oParams.Count - 1 do
    AddParam.Assign(oParams.Items[i]);
end;

procedure TReportParameters.CheckWidths;
//Find the longest Parameter name and use it for setting the first column width
var
  i : Integer;
  iWidth  : Integer;
  dPixelsPerInch, dPixelsPerMM : Double;
begin
  FFirstColWidth := 0;
  for i := 0 to Count - 1 do
  begin
    iWidth := FRepFiler.Canvas.TextWidth(Items[i].Name);
    if iWidth > FFirstColWidth then
      FFirstColWidth := iWidth;
  end;

  //This is a bodge to translate between the pixels which TextWidth returns and the units which TReportFiler expects.
  dPixelsPerInch := FRepFiler.XDPI;
  dPixelsPerMM := dPixelsPerInch / (25.4 * 1.3); //1.3 to allow for space after name
  FFirstColWidth := FFirstColWidth div Trunc(dPixelsPerMM);
end;

function TReportParameters.GetHeader: string;
begin
  Result := FHeader;
  //After the first time, change the returned string
  FHeader := 'Report Parameters (continued):';
end;

function TReportParameters.GetItem(Index: Integer): TParamsObject;
begin
  Result := TParamsObject(inherited Items[Index]);
end;

procedure TReportParameters.Print;
const
  I_BODGE_FACTOR = 2; //when the user zooms out of the report, some of the longer fields in the first column get truncated, so
                      //add this to try to avoid
var
  i : integer;
begin
  if (Count > 0) and Assigned(FPrintParamsProc) then
  begin
    FHeader := 'Report Parameters:';

    //Set report tabs according to longest parameter name
    CheckWidths;
    with FRepFiler do
    begin
      ClearTabs;
      SetTab (MarginLeft, pjLeft, FFirstColWidth + I_BODGE_FACTOR, 4, 0, 0);
      SetTab (NA, pjLeft, 120, 4, 0, 0);
    end;
    //Print Parameter header
    FRepFiler.Bold := True;
    If Assigned(FOnCRLF) Then
      FOnPrintLeft(GetHeader, FRepFiler.MarginLeft)
    Else
      FRepFiler.PrintLeft(GetHeader, FRepFiler.MarginLeft);
    FRepFiler.Bold := False;
    If Assigned(FOnCRLF) Then FOnCRLF Else FRepFiler.CRLF;
    If Assigned(FOnCRLF) Then FOnCRLF Else FRepFiler.CRLF;

    //Print all parameters
    for i := 0 to Count - 1 do
    begin
      Items[i].PrintProc := FPrintParamsProc;
      Items[i].Print;
      If Assigned(FOnCRLF) Then FOnCRLF Else FRepFiler.CRLF;
    end;
    If Assigned(FOnCRLF) Then FOnCRLF Else FRepFiler.CRLF;
  end;
end;

procedure TReportParameters.SetItem(Index: Integer;
  AParamsObject: TParamsObject);
begin
  inherited SetItem(Index, TObject(AParamsObject));
end;



end.
