
const
  lnkCustomer            = 10;
  lnkSupplier            = 20;
  lnkLineType            = 35;

  lnkSIN                 = 45;
  lnkSINLine             = 60;
  lnkSRC                 = 65;
  lnkSRCLine             = 70;
  lnkSQU                 = 75;
  lnkSQULine             = 80;
  lnkSOR                 = 85;
  lnkSORLine             = 90;

  lnkPIN                 = 100;
  lnkPINLine             = 110;
  lnkPPY                 = 120;
  lnkPPYLine             = 130;
  lnkPQU                 = 135;
  lnkPQULine             = 140;
  lnkPOR                 = 145;
  lnkPORLine             = 150;

  lnkNom                 = 155;
  lnkNomLine             = 157;

  lnkStockRec            = 170;
  lnkADJ                 = 180;
  lnkADJLine             = 190;

  lnkWOR                 = 200;
  lnkWORLine             = 210;

  lnkJobRec              = 280;
  lnkEmployee            = 285;
  lnkTSH                 = 290;
  lnkTSHLine             = 300;

type
{copied from SysSetU}
  tSSTreeGrpRec  =  Record
                      tCaption  :  String;
                      IsChild   :  Byte;
                      CaptionLink
                                :  String;
                      HideLink  :  String;

                      Exclude   :  Boolean;
                    end;

  tSSTreeGrpAry  =  Array[1..300] of tSSTreeGrpRec;
{----}


var
  SSTreeGrpAry : tSSTreeGrpAry;




function  TSystemSetupUserFields.Get_ufADJDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfADJHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufADJEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfADJHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufADJLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfADJLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufADJLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfADJLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufCustDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfCustomer, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufEmployeeDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfEmployee, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufJobDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfJob, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufLineTypeDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfLineTypes, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufNOMDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfNOMHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufNOMEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfNOMHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufNOMLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfNOMLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufNOMLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfNOMLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPINDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPINHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPINEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPINHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPINLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPINLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPINLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPINLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPORDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPORHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPOREnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPORHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPORLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPORLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPORLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfADJHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPPYDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPPYHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPPYEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPPYHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPPYLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPPYLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPPYLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPPYLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPQUDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPQUHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPQUEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPQUHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufPQULineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfPQULine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufPQULineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfPQULine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSINDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSINHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSINEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSINHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSINLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSINLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSINLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSINLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSORDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSORHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSOREnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSORHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSORLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSORLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSORLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSORLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSQUDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSQUHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSQUEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSQUHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSQULineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSQULine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSQULineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSQULine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSRCDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSRCHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSRCEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSRCHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufSRCLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSRCLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSRCLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfSRCLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufStockDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfStock, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufSuppDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfSupplier, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufTSHDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfTSHHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufTSHEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfTSHHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufTSHLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfTSHLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufTSHLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfTSHLine, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufWORDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfWORHeader, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufWOREnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfWORHeader, Index].cfEnabled;
end;

function  TSystemSetupUserFields.Get_ufWORLineDesc(Index: TUserDefinedFieldNo): WideString;
begin
  Result := CustomFields[cfWORLine, Index].cfCaption;
end;

function  TSystemSetupUserFields.Get_ufWORLineEnabled(Index: TUserDefinedFieldNo): WordBool;
begin
  Result := CustomFields[cfWORLine, Index].cfEnabled;
end;

function TSystemSetupUserFields.GetVal(const s : string; Val : integer) : string;
var
  Offset : integer;
begin
  if Length(s) = 0 then
    Result := ''
  else
  begin
    //inc(Val);
    if s[1] = 'X' then
      Offset := 1
    else
      Offset := 0;

    Result := ExtractWords(Val + Offset, 1, s);
  end;
end;

function TSystemSetupUserFields.GetInt(const s : string; WantSet : Boolean) : integer;
begin
  if Length(s) = 0 then
    Result := -1
  else
  begin
    if WantSet then
      Result := StrToInt(Copy(s, 1, 3))
    else
      Result := StrToInt(Copy(s, 4, 3));
  end;
end;

function TSystemSetupUserFields.CapSet(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].CaptionLink, Index), True);
end;

function TSystemSetupUserFields.CapAry(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].CaptionLink, Index), False);
end;

function TSystemSetupUserFields.HidSet(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].HideLink, Index), True);
end;

function TSystemSetupUserFields.HidAry(SetNo, Index : Integer) : Integer;
begin
  Result := GetInt(GetVal(SSTreeGrpAry[SetNo].HideLink, Index), False);
end;

//PR: 23/11/2011 v6.9 Added fields for return transactions & lines.
function TSystemSetupUserFields.Get_ufSRNDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfSRNHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufSRNEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfSRNHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufSRNLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfSRNLine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufSRNLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfSRNLine, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufPRNDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfPRNHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufPRNEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfPRNHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufPRNLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfPRNLine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufPRNLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfPRNLine, Index].cfEnabled;
end;

//PR: 24/02/2012 Added fields for Apps & Vals v6.10 ABSEXCH-12128

function TSystemSetupUserFields.Get_ufJCTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJCTHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJCTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJCTHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJCTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJCTLine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJCTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJCTLine, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJPTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJPTHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJPTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJPTHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJPTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJPTLine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJPTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJPTLine, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJSTDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJSTHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJSTEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJSTHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJSTLineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJSTLine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJSTLineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJSTLine, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJPADesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJPAHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJPAEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJPAHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJPALineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJPALine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJPALineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJPALine, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJSADesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJSAHeader, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJSAEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJSAHeader, Index].cfEnabled;
end;

function TSystemSetupUserFields.Get_ufJSALineDesc(Index: TUserDefinedFieldNo): WideString; safecall;
begin
  Result := CustomFields[cfJSALine, Index].cfCaption;
end;

function TSystemSetupUserFields.Get_ufJSALineEnabled(Index: TUserDefinedFieldNo): WordBool; safecall;
begin
  Result := CustomFields[cfJSALine, Index].cfEnabled;
end;

//-------------------------------------------------------------------------

// MH 02/01/2015 v7.1 ABSEXCH-15948: Extended to support Customer/Supplier Credit Card Fields (11-15)
function TSystemSetupUserFields.Get_ufCustEnabled(Index: TUserDefinedFieldNo): WordBool;
Begin // Get_ufCustEnabled
  Result := CustomFields[cfCustomer, Index].cfEnabled;
End; // Get_ufCustEnabled

function TSystemSetupUserFields.Get_ufSuppEnabled(Index: TUserDefinedFieldNo): WordBool;
Begin // Get_ufSuppEnabled
  Result := CustomFields[cfSupplier, Index].cfEnabled;
End; // Get_ufSuppEnabled

//------------------------------

// MH 02/01/2015 v7.1 ABSEXCH-15855: Added Address Description Fields
function TSystemSetupUserFields.Get_ufAddressDesc(Index: TUserDefinedFieldNo): WideString;
Begin // Get_ufAddressDesc
  Result := CustomFields[cfAddressLabels, Index].cfCaption;
End; // Get_ufAddressDesc

//-------------------------------------------------------------------------


