unit oB2B;

interface

uses
  ComObj, ActiveX, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, Classes,
  ExceptIntf;

type
  TBackToBackOrder = Class(TAutoIntfObjectEx, IBackToBackOrder)
  private
    FDataRec : TBatchB2BRec;
    FList : TStringList;
    FOurRef : String;
    FToolkit : TObject;
  protected
    function Get_bbMultipleSuppliers: WordBool; safecall;
    procedure Set_bbMultipleSuppliers(Value: WordBool); safecall;
    function Get_bbIncludeNormalLines: WordBool; safecall;
    procedure Set_bbIncludeNormalLines(Value: WordBool); safecall;
    function Get_bbIncludeLabourLines: WordBool; safecall;
    procedure Set_bbIncludeLabourLines(Value: WordBool); safecall;
    function Get_bbIncludeMaterialLines: WordBool; safecall;
    procedure Set_bbIncludeMaterialLines(Value: WordBool); safecall;
    function Get_bbIncludeFreightLines: WordBool; safecall;
    procedure Set_bbIncludeFreightLines(Value: WordBool); safecall;
    function Get_bbIncludeDiscountLines: WordBool; safecall;
    procedure Set_bbIncludeDiscountLines(Value: WordBool); safecall;
    function Get_bbQtyMode: TB2BQtyModeType; safecall;
    procedure Set_bbQtyMode(Value: TB2BQtyModeType); safecall;
    function Get_bbDefaultSupplier: WideString; safecall;
    procedure Set_bbDefaultSupplier(const Value: WideString); safecall;
    function Get_bbAutoPick: WordBool; safecall;
    procedure Set_bbAutoPick(Value: WordBool); safecall;
    function Get_bbPORCount: Integer; safecall;
    function Get_bbPORs(Index: Integer): WideString; safecall;
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean;
    function Execute: Integer; safecall;

    procedure SetOurRef(const s : string);
  public
    LCount : longint;
    SPOpen : Boolean;
    constructor Create;
    destructor Destroy; override;

    property OurRef : string read FOurRef write SetOurRef;
    property Toolkit : TObject read FToolkit write FToolkit;
  end;


implementation

uses
  ComServ, SysUtils, SpDlIntf, GlobVar, SpDllErr, oToolkit, MiscFunc;

constructor TBackToBackOrder.Create;
begin
  inherited Create(ComServer.TypeLib, IBackToBackOrder);
  FillChar(FDataRec, SizeOf(FDataRec), 0);
  FList := TStringList.Create;
  SPOpen := False;
end;

destructor TBackToBackOrder.Destroy;
begin
  FList.Free;
  inherited;
end;


function TBackToBackOrder.Get_bbMultipleSuppliers: WordBool;
begin
  Result := FDataRec.bbMultipleSuppliers;
end;

procedure TBackToBackOrder.Set_bbMultipleSuppliers(Value: WordBool);
begin
  FDataRec.bbMultipleSuppliers := Value;
end;

function TBackToBackOrder.Get_bbIncludeNormalLines: WordBool;
begin
  Result := FDataRec.bbIncludeNormalLines;
end;

procedure TBackToBackOrder.Set_bbIncludeNormalLines(Value: WordBool);
begin
  FDataRec.bbIncludeNormalLines := Value;
end;

function TBackToBackOrder.Get_bbIncludeLabourLines: WordBool;
begin
  Result := FDataRec.bbIncludeLabourLines;
end;

procedure TBackToBackOrder.Set_bbIncludeLabourLines(Value: WordBool);
begin
  FDataRec.bbIncludeLabourLines := Value;
end;

function TBackToBackOrder.Get_bbIncludeMaterialLines: WordBool;
begin
  Result := FDataRec.bbIncludeMaterialLines;
end;

procedure TBackToBackOrder.Set_bbIncludeMaterialLines(Value: WordBool);
begin
  FDataRec.bbIncludeMaterialLines := Value;
end;

function TBackToBackOrder.Get_bbIncludeFreightLines: WordBool;
begin
  Result := FDataRec.bbIncludeFreightLines;
end;

procedure TBackToBackOrder.Set_bbIncludeFreightLines(Value: WordBool);
begin
  FDataRec.bbIncludeFreightLines := Value;
end;

function TBackToBackOrder.Get_bbIncludeDiscountLines: WordBool;
begin
  Result := FDataRec.bbIncludeDiscountLines;
end;

procedure TBackToBackOrder.Set_bbIncludeDiscountLines(Value: WordBool);
begin
  FDataRec.bbIncludeDiscountLines := Value;
end;

function TBackToBackOrder.Get_bbQtyMode: TB2BQtyModeType;
begin
  Result := TB2BQtyModeType(FDataRec.bbQtyMode);
end;

procedure TBackToBackOrder.Set_bbQtyMode(Value: TB2BQtyModeType);
begin
  FDataRec.bbQtyMode := Ord(Value);
end;

function TBackToBackOrder.Get_bbDefaultSupplier: WideString;
begin
  Result := Trim(FDataRec.bbSuppCode);
end;

procedure TBackToBackOrder.Set_bbDefaultSupplier(const Value: WideString);
begin
  FDataRec.bbSuppCode := Trim(Value);
end;

function TBackToBackOrder.Get_bbAutoPick: WordBool;
begin
  Result := FDataRec.bbAutoPick;
end;

procedure TBackToBackOrder.Set_bbAutoPick(Value: WordBool);
begin
  FDataRec.bbAutoPick := Value;
end;

function TBackToBackOrder.Get_bbPORCount: Integer;
begin
  Result := FList.Count;
end;

function TBackToBackOrder.Get_bbPORs(Index: Integer): WideString;
begin
  if (Index <= FList.Count) and (Index > 0) then
    Result := FList[Index - 1]
  else
    raise ERangeError.Create(IntToStr(Index) + ' is not a valid entry in the current list.');
end;

procedure TBackToBackOrder.SetOurRef(const s : string);
begin
  if UpperCase(Copy(s, 1, 3)) = 'SOR' then
    FOurRef := UpperCase(s)
  else
    raise Exception.Create('Transaction type must be SOR');
end;

function TBackToBackOrder.Execute: Integer;
var
  TH : TBatchTHRec;
  OutP : Pointer;
  OutCount : longint;
  OurRefSize, i : integer;
  s : ShortString;
  KeyS : PChar;
  Path : PChar;
  sPath : string;
  si : SmallInt;
  MC : WordBool;
begin
  AuthoriseFunction(201, 'Execute');
  if LCount > 0 then
  begin
    LastErDesc := '';
    OutCount := LCount;

    OurRefSize := SizeOf(TH.OurRef) - 1;
    GetMem(OutP, OutCount * OurRefSize);
    KeyS := StrAlloc(255);

    Try
      StrPCopy(KeyS, FOurRef);

      Path := StrAlloc(255);
      with FToolkit as TToolkit do
      begin
        sPath := ConfigI.DataDirectory;
        si := EnterpriseI.enCurrencyVersion;
      end;

      if si in [1, 2] then
        MC := True
      else
        MC := False;

      StrPCopy(Path, sPath);
      if not SPOpen then
      begin
        Result := SP_INITDLLPATH(Path, MC);

        if Result = 0 then
          Result := SP_INITDLL;
      end
      else
        Result := 0;

      if Result = 0 then
      begin
        Try
          Result := SP_BACKTOBACKORDER(@FDataRec, OutP, SizeOf(FDataRec),
                                    LCount, KeyS);

          if Result = 0 then
          begin
            s := StringOfChar(' ', OurRefSize);
            for i := 0 to LCount - 1 do
            begin
              Move(Pointer(Longint(OutP) + (i * OurRefSize))^, s[1], OurRefSize);
              FList.Add(s);
            end;
          end;
        Finally
          if not SPOpen then
            SP_CLOSEDLL;
        End;
      end;
    Finally
      StrDispose(KeyS);
      FreeMem(OutP, OutCount * OurRefSize);
      If (Result <> 0) Then
        LastErDesc := SP_ERRORMESSAGE(2, Result);

    End;
  end
  else
    Raise Exception.Create('Line count must be > 0');
end;



function TBackToBackOrder.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo of
    //Execute
    201  : Result := Trim(FOurRef) <> '';
    else
      Result := False;
  end;

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }

end;


end.
