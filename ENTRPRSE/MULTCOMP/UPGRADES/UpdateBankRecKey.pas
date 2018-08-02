unit UpdateBankRecKey;

interface

uses
  VarConst, BtrvU2;

type
  //PR: 04/07/2017 ABSEXCH-12358 v2017 R2
  //Class to update the bnkCode3 key in Bank Reconciliation Headers
  //in MLocF. Using the FullNomKey of the bank folio was causing problems
  //searching in that index, so convert the FullNomKey to a hex representation
  TUpdateBankRec = class
  private
    procedure ConvertHeaderKey(var HeaderKey : ShortString; Folio : longint);
  public
    ErrorString : string;
    function Execute : Integer;
    function NeedToUpdate : Boolean;
  end;


  function UpdateBankReconcile(var ErrStr : string) : Integer;


implementation

uses
  SysUtils, GlobVar, VarRec2U, Forms;

{ TUpdateBankRec }

procedure TUpdateBankRec.ConvertHeaderKey(var HeaderKey: ShortString; Folio : longint);
{Old key was: GL Code (4 chars) + UserId (10 chars) + Folio (4 chars) + '!'
 New key  is: GL Code (4 chars) + UserId (10 chars) + Folio as Hex (8 chars)
}
begin
  HeaderKey := Copy(HeaderKey, 1, 14) + IntToHex(Folio, 8) +
     StringOfChar(#0, 9);
end;

function TUpdateBankRec.Execute: Integer;
var
  Res : Integer;
  KeyS : Str255;
begin
  Result := 0;
  Try
    KeyS := 'K1'; //Reconciliation header

    //Iterate through all reconciliation headers
    Res := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);
    while (Res = 0) and (MLocCtrl^.RecPFix = 'K') and (MLocCtrl^.Subtype = '1') do
    begin

      ConvertHeaderKey(MLocCtrl^.BnkRHRec.brBnkCode3, MLocCtrl^.BnkRHRec.brIntRef);

      Res := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, 0);

      Application.ProcessMessages;

      if Res <> 0 then
        ErrorString := 'Error ' + IntToStr(Res) + ' occurred saving reconcilation ' +
          'header ' + QuotedStr(MLocCtrl^.BnkRHRec.brReconRef)
      else
        Res := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);


    end;
  Except
    on E:Exception do
    begin
      ErrorString := E.Message;
      Result := -1;
    end;
  End;

end;

//Find the last bank rec header and see if it has been converted yet
//we can do thia by checking if the last character is '!'
//Use last header record in case of a failed upgrade which converted some records
function TUpdateBankRec.NeedToUpdate: Boolean;
var
  Res : Integer;
  KeyS : Str255;
begin
  Result := False;
  KeyS := 'K2'; //Reconciliation line

  //Find first line record
  Res := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);

  if Res = 0 then
  begin
    //Find last header record
    Res := Find_Rec(B_GetPrev, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);

    if (Res = 0) and (MLocCtrl^.RecPFix = 'K') and (MLocCtrl^.Subtype = '1') then
      with MLocCtrl^.BnkRHRec do
        Result := brBnkCode3[Length(brBnkCode3)] = '!' //still old keystring
  end;
end;

function UpdateBankReconcile(var ErrStr : string) : Integer;
begin
  Result := -1;
  ErrStr := '';
  Open_System(MLocF, MLocF);

  with TUpdateBankRec.Create do
  Try
    if NeedToUpdate then
      Result := Execute
    else
      Result := 0;

    if Result <> 0 then
      ErrStr := ErrorString;
  Finally
    Free;
    Close_Files(True);
  End;

end;


end.
