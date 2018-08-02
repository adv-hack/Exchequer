unit SComProc;

interface

uses
  SysUtils, VarConst, GlobVar, BtrvU2, StdCtrls, MiscUtil, Dialogs
  , BTUtil, StrUtil;

  function GetNextFolio(iFileNo : integer) : integer;
  procedure FillCurrencyCombo(cmbCurrency : TComboBox);
  Procedure DeletePrintFile(Const PrintFile : String);
  function GetSalesCodeFromFolio(iFolioNo : integer) : TSalesCodeRec;
  function GetSalesCodeTypeFromFolio(iFolioNo : integer) : TSalesCodeTypeRec;

implementation

function GetNextFolio(iFileNo : integer) : integer;
var
  KeyS : Str255;
  SalesCodeTypeRec : TSalesCodeTypeRec;
  SalesCodeRec : TSalesCodeRec;
  CommissionRec : TCommissionRec;
  iStatus, iNextFolio : LongInt;
begin
  // get original record
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;
  case iFileNo of
    SalesCodeTypeF : begin
      iStatus := Find_Rec(B_GetLast, F[iFileNo], iFileNo, SalesCodeTypeRec, sctFolioIdx, KeyS);
      if iStatus = 0 then iNextFolio := SalesCodeTypeRec.sctFolioNo + 1;
    end;

    SalesCodeF : begin
      iStatus := Find_Rec(B_GetLast, F[iFileNo], iFileNo, SalesCodeRec, scFolioIdx, KeyS);
      if iStatus = 0 then iNextFolio := SalesCodeRec.scFolioNo + 1;
    end;

    CommissionF : begin
      iStatus := Find_Rec(B_GetLast, F[iFileNo], iFileNo, CommissionRec, cmFolioIdx, KeyS);
      if iStatus = 0 then iNextFolio := CommissionRec.cmFolioNo + 1;
    end;
  end;{case}

  Result := iNextFolio;

  if not (iStatus in [0,4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[iFileNo]);
end;

procedure FillCurrencyCombo(cmbCurrency : TComboBox);
var
  iPos : integer;
  sCurrChar : string;
begin
  ClearList(cmbCurrency.Items);
//  cmbCurrency.Items.Add('(no currency selected)');
  For iPos := 1 to oToolkit.SystemSetup.ssMaxCurrency do begin
    if Trim(oToolkit.SystemSetup.ssCurrency[iPos].scDesc) <> '' then begin

      // get correct currency char
      sCurrChar := oToolkit.SystemSetup.ssCurrency[iPos].scSymbol;
      if sCurrChar = #156 then sCurrChar := '£';

      cmbCurrency.Items.Add(IntToStr(iPos) + ' - ' + oToolkit.SystemSetup.ssCurrency[iPos].scDesc
      + ' (' + sCurrChar + ')');
    end;
  end;{for}
end;

Procedure DeletePrintFile(Const PrintFile : String);
Begin
  If FileExists(PrintFile) Then Begin
    Try
      DeleteFile(PrintFile);
    Except
      MessageDlg('Error:' + CHR(13) + CHR(13) + 'An error has occurred deleting the temporary file, '''
      + PrintFile + '''.', mtError, [mbOk], 0);
    End;{try}
  End; { If }
End;

function GetSalesCodeFromFolio(iFolioNo : integer) : TSalesCodeRec;
var
  KeyS : str255;
begin
  FillChar(Result,sizeOf(result),#0);

  // get Sales Code record
  KeyS := BTFullNomKey(iFolioNo) + IDX_DUMMY_CHAR;
  Find_Rec(B_GetEq, F[SalesCodeF], SalesCodeF, Result, scFolioIdx, KeyS);
end;

function GetSalesCodeTypeFromFolio(iFolioNo : integer) : TSalesCodeTypeRec;
var
  KeyS : str255;
begin
  FillChar(Result,sizeOf(result),#0);

  // get Sales Code record
  KeyS := BTFullNomKey(iFolioNo) + IDX_DUMMY_CHAR;
  Find_Rec(B_GetEq, F[SalesCodeTypeF], SalesCodeTypeF, Result, sctFolioIdx, KeyS);
end;

end.
