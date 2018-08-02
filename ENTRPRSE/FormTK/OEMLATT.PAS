unit oEmlAtt;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, Enterprise01_TLB, RpDevice;

type
  TEFStringListReadWrite = class(TAutoIntfObject, IEFStringListReadWrite)
  private
    FStrList : TStringList;
    FValidMode : Byte;
    FValidDesc : ShortString;
  protected
    // IEFStringListReadWrite
    function Get_Strings(Index: Integer): WideString; safecall;
    procedure Set_Strings(Index: Integer; const Value: WideString); safecall;
    function Get_Count: Integer; safecall;
    function Add(const AddString: WideString): Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Clear; safecall;

    // Local methods
    Function ValidateString (Const VStr : WideString) : Integer;
  public
    Constructor Create (Const ValidMode : Byte; Const ValidDesc : ShortString);
    Destructor Destroy; override;

    Procedure Initialise;
    Function  ExtractAttachments : ShortString;
  End; { TEFStringListReadWrite }

implementation

Uses ComServ,
     GlobType,         // Global FormDes Const/Type/Var
     MiscFunc;         // Miscellaneous Functions / Types / Constants for the Form TK

//-----------------------------------------------------------------------------

constructor TEFStringListReadWrite.Create (Const ValidMode : Byte; Const ValidDesc : ShortString);
begin
  Inherited Create (ComServer.TypeLib, IEFStringListReadWrite);

  FStrList := TStringList.Create;
  FValidMode := ValidMode;
  FValidDesc := ValidDesc;
end;

//----------------------------------------

destructor TEFStringListReadWrite.Destroy;
begin
  FreeAndNIL(FStrList);

  inherited;
end;

//-----------------------------------------------------------------------------

Procedure TEFStringListReadWrite.Initialise;
begin
  FStrList.Clear;
end;

//-----------------------------------------------------------------------------

Function TEFStringListReadWrite.ExtractAttachments : ShortString;
Var
  I : SmallInt;
begin
  Result := '';

  If (FStrList.Count > 0) Then Begin
    For I := 0 To Pred(FStrList.Count) Do
      Result := Result + FStrList[I] + ';';

    // Remove trailing ';'
    System.Delete (Result, Length(Result), 1);
  End; {  If (FStrList.Count > 0) }
end;

//-----------------------------------------------------------------------------

Function TEFStringListReadWrite.ValidateString (Const VStr : WideString) : Integer;
begin
  Result := 0;

  // Check not blank - not allowed in any mode
  If (Trim(VStr) <> '') Then Begin
    If Not FileExists (VStr) Then Begin
      // File not found
      Result := 1001;
      LastErDesc := 'The specified Attachment File could not found';
    End; { If Not FileExists (VStr) }
  End { If (Trim(VStr) <> '') }
  Else Begin
    // Attachment Filename cannot be blank
    Result := 1000;
    LastErDesc := 'The Attachment Filename cannot be blank';
  End; { Else }
end;

//-----------------------------------------------------------------------------

function TEFStringListReadWrite.Add(const AddString: WideString): Integer;
begin
  LastErDesc := '';

  Result := ValidateString (AddString);
  If (Result = 0) Then
    FStrList.Add (AddString);
end;

//----------------------------------------

procedure TEFStringListReadWrite.Clear;
begin
  FStrList.Clear;
end;

//----------------------------------------

procedure TEFStringListReadWrite.Delete(Index: Integer);
begin
  If (Index > 0) And (Index <= FStrList.Count) Then
    FStrList.Delete(Index - 1)
  Else
    Raise EInvalidIndex.Create ('Invalid Index in IStringArrayRW.Delete');
end;

//-----------------------------------------------------------------------------

function TEFStringListReadWrite.Get_Count: Integer;
begin
  Result := FStrList.Count;
end;

//----------------------------------------

function TEFStringListReadWrite.Get_Strings(Index: Integer): WideString;
begin
  If (Index > 0) And (Index <= FStrList.Count) Then
    Result := FStrList[Index - 1]
  Else
    Raise EInvalidIndex.Create ('Invalid Index in IStringArrayRW.Strings');
end;

procedure TEFStringListReadWrite.Set_Strings(Index: Integer; const Value: WideString);
begin
  If (Index > 0) And (Index <= FStrList.Count) Then Begin
    If (ValidateString (Value)= 0)  Then
      FStrList[Index - 1] := Value
    Else
      Raise EValidation.Create ('Invalid Email Address (' + Value + ')');
  End { If (Index > 0) And (Index <= FStrList.Count) }
  Else
    Raise EInvalidIndex.Create ('Invalid Index in IStringArrayRW.Strings');
end;

//-----------------------------------------------------------------------------

end.

