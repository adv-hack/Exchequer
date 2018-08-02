unit oStrList;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB;

type
  // NOTE: Used TEFPrinterDetail for Papers and Bins sub-objects
  TEFStringListReadOnly = class(TAutoIntfObject, IEFStringListReadOnly)
  private
    FStringList : TStringList;
  protected
    // IEFStringListReadOnly
    function Get_Strings(Index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function IndexOf(const SearchText: WideString): Integer; safecall;
  public
    Constructor Create (Const StringList : TStringList);
    Destructor Destroy; override;
  End; { TEFStringListReadOnly }


implementation

uses ComServ;

//-----------------------------------------------------------------------------

Constructor TEFStringListReadOnly.Create (Const StringList : TStringList);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFStringListReadOnly);

  // Copy master string list into local handle
  FStringList := StringList;
End; { Create }

//----------------------------------------

Destructor TEFStringListReadOnly.Destroy;
Begin { Destroy }
  // remove the reference to the master string list - DO NOT DESTROY IT
  FStringList := NIL;

  inherited Destroy;
End; { Destroy }

//----------------------------------------

function TEFStringListReadOnly.Get_Count: Integer;
begin
  If Assigned(FStringList) Then
    Result := FStringList.Count
  Else
    Result := 0;
end;

//----------------------------------------

function TEFStringListReadOnly.Get_Strings(Index: Integer): WideString;
begin
  Result := FStringList[Index - 1];
end;

//----------------------------------------

function TEFStringListReadOnly.IndexOf(const SearchText: WideString): Integer;
Var
  sText       : ShortString;
  I           : SmallInt;
begin
  Result := 0;  // Not found

  // Convert search string to uppercase removing any spaces
  sText := UpperCase(Trim(SearchText));

  If (FStringList.Count > 0) Then
    For I := 0 To Pred(FStringList.Count) Do Begin
      // Check to see if Bin/Paper name starts with the specified text
      If (Pos (sText, UpperCase(FStringList[I])) = 1) Then Begin
        Result := I + 1;
        Break;
      End ; { If (Pos(... }
    End; { For I }
end;

end.
