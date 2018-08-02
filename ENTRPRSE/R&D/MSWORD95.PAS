{************************************************************************}
{* Exchequer Enterprise MS Word OLE Module                              *}
{************************************************************************}
unit MSWord95;

interface

Uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ExtCtrls, SBSPanel, ComCtrls, GlobVar, VarConst;

Type
  CustRecPtr = ^CustRec;
  StockRecPtr = ^StockRec;
  InvRecPtr = ^InvRec;

Var
  MSWord: OLEVariant;


Function AddWordLetter (Const LetterIdx  : ShortString;
                        Const LetterName : ShortString;
                        Const SubType    : Char;
                        Const CustR      : CustRecPtr;
                        Const StockR     : StockRecPtr;
                        Const InvR       : InvRecPtr;
                        Const JobR       : JobRecPtr;
                        Const EmpR       : JobMiscPtr) : Byte;

Function ViewWordLetter (Const DocPath : String) : Byte;
Function FullDocPath: String;
Procedure DispLetterError (Const ErrNo : Byte);

implementation

Uses ComObj, //OLEAuto,
     ETDateU,
     ETStrU,
     ETMiscU,
     LettrDlg,
     BtrvU2,
     BtKeys1U,
     BtSupU1,
     ComnUnit,
     Comnu2,
     SysU2,
     VarFPosU;


Function FullDocPath: String;
Var
  Path : String;
begin
  Path := SetDrive;
  If (Trim(Path) = '') Then Begin
    { Working from current directory - extract path from exename }
    Path := Application.EXEName;

    While (Path[Length(Path)] <> '\') Do
      Delete (Path, Length(Path), 1);
  End; { If }

  Result := Path + PathDocs;
end;


{************************************************************************}
{* CreateDocFile: Generates a unique filename for the new document and  *}
{*                creates it by copying the specified master document.  *}
{*                                                                      *}
{* Result:   0 - OK                                                     *}
{*           101 - no free number for extension                         *}
{*           102 - Error copying master to actual doc                   *}
{************************************************************************}
Function CreateDOCFile (Const SourceFile : String;
                        Var   DestPath   : String;
                        Var   DestName   : String) : Byte;
Var
  TmpPath, Num : String;
  I            : Integer;
begin
  Result := 0;

  { Find a unique extension for new doc }
  TmpPath := DestPath;
  I := 0;
  Repeat
    Inc (I);

    Num := IntToStr (I);
    DestPath := TmpPath + DestName + '.' + ConstStr('0', (3 - Length(Num))) + Num;
  Until (Not FileExists (DestPath)) Or (I >= 1000);

  If (I < 1000) Then Begin
    DestName := DestName + '.' + ConstStr('0', (3 - Length(Num))) + Num;
//DestName := 'TEST.DOC';  DestPath := TmpPath + DestName;

    If Not CopyFile (PChar(SourceFile), PChar(DestPath), False) Then
      Result := 102;

    If Debug And (Result <> 0) Then
      ShowMessage ('Error On Copy: ' + SourceFile + #13#10 +
                                       DestPath);
  End { If }
  Else
    { Ran out of numbers }
    Result := 101;
end;


{************************************************************************}
{* EditLetter: Edits an existing Word document                          *}
{*                                                                      *}
{* Result:   0 - OK                                                     *}
{*           201 - Document doesn't exist                               *}
{*           202 - Exception while automating Word                      *}
{************************************************************************}
Function EditLetter (Const LetterName   : String;
                     Const Adding       : Boolean;
                     Const CustR        : CustRecPtr;
                     Const StockR       : StockRecPtr;
                     Const InvR         : InvRecPtr;
                     Const JobR         : JobRecPtr;
                     Const EmpR         : JobMiscPtr) : Byte;
Const
  PrefixCust = 'ENTPRS.CUST.';
  PrefixStk  = 'ENTPRS.STOCK.';
  PrefixInv  = 'ENTPRS.TRAN.';
  PrefixLine = 'ENTPRS.LINE.';
  PrefixJob  = 'ENTPRS.JOB.';
  PrefixEmpl = 'ENTPRS.EMP.';

  FNum       = IDetailF;
  KeyPath    = IDFolioK;
Var
  TmpLine      : ^IDetail;
  TmpKPath     : Integer;
  TmpStat      : SmallInt;
  TmpRecIdAddr : LongInt;
  KeyR, KeyS   : Str255;
  TmpField     : ShortString;
  R            : Double;

  Function AD_DiscountStr : ShortString;
  Begin // AD_DiscountStr
    Result := PPR_PamountStr(Id.Discount, Id.DiscountChr) + '/' +
              PPR_PamountStr(Id.Discount2, Id.Discount2Chr) + '/' +
              PPR_PamountStr(Id.Discount3, Id.Discount3Chr);

    if Result = '//' then
      Result := '';
  End; // AD_DiscountStr

begin
  Result := 0;

  If FileExists (LetterName) Then Begin
    try
      MsWord := CreateOleObject('Word.Basic');

      { Open document }
      MSWord.FileOpen (Name := #34 + LetterName + #34, AddToMRU := 1);

      { move to top }
      MSWord.StartOfDocument;

      If Adding Then Begin
        { Set Fields }
        MSWord.EditFindClearFormatting;
        MSWord.EditReplaceClearFormatting;

        If Assigned(CustR) Then Begin
          MSWord.EditReplace (Find := PrefixCust + 'CODE',    Replace := Trim(CustR^.CustCode),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'NAME',    Replace := Trim(CustR^.Company), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'ADDR1',   Replace := Trim(CustR^.Addr[1]), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'ADDR2',   Replace := Trim(CustR^.Addr[2]), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'ADDR3',   Replace := Trim(CustR^.Addr[3]), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'ADDR4',   Replace := Trim(CustR^.Addr[4]), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'ADDR5',   Replace := Trim(CustR^.Addr[5]), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'CONTACT', Replace := Trim(CustR^.Contact), ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'TEL1',    Replace := Trim(CustR^.Phone),   ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'TEL2',    Replace := Trim(CustR^.Phone2),  ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'FAX',     Replace := Trim(CustR^.Fax),     ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'USER1',   Replace := Trim(CustR^.UserDef1),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'USER2',   Replace := Trim(CustR^.UserDef2),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'USER3',   Replace := Trim(CustR^.UserDef3),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'USER4',   Replace := Trim(CustR^.UserDef4),ReplaceAll := True, MatchCase := 1);

          // HM 06/12/01: Added new v5.00 Word Fields
          MSWord.EditReplace (Find := PrefixCust + 'ALTCODE',  Replace := Trim(CustR^.CustCode2),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixCust + 'POSTCODE', Replace := Trim(CustR^.PostCode), ReplaceAll := True, MatchCase := 1);

          // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
          MSWord.EditReplace (Find := PrefixCust + 'COUNTRY', Replace := Trim(CustR^.acCountry), ReplaceAll := True, MatchCase := 1);
        End; { If }

        If Assigned(StockR) Then Begin
          MSWord.EditReplace (Find := PrefixStk + 'CODE',    Replace := Trim(StockR^.StockCode),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC1',   Replace := Trim(StockR^.Desc[1]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC2',   Replace := Trim(StockR^.Desc[2]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC3',   Replace := Trim(StockR^.Desc[3]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC4',   Replace := Trim(StockR^.Desc[4]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC5',   Replace := Trim(StockR^.Desc[5]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'DESC6',   Replace := Trim(StockR^.Desc[6]),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'ALT',     Replace := Trim(StockR^.AltCode),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'BINLOC',  Replace := Trim(StockR^.BinLoc),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'USER1',  Replace := Trim(StockR^.StkUser1),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'USER2',  Replace := Trim(StockR^.StkUser1),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'BARCODE',  Replace := Trim(StockR^.BarCode),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'USER3',  Replace := Trim(StockR^.StkUser3),ReplaceAll := True, MatchCase := 1);
          MSWord.EditReplace (Find := PrefixStk + 'USER4',  Replace := Trim(StockR^.StkUser4),ReplaceAll := True, MatchCase := 1);
        End; { If }

        If Assigned(InvR) Then
          With InvR^ Do Begin
            MSWord.EditReplace (Find := PrefixInv + 'OURREF',  Replace := Trim(OurRef),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'YOURREF',  Replace := Trim(YourRef),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'ALTREF',  Replace := Trim(TransDesc),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'TRANS',  Replace := POutDate(TransDate),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DUE',  Replace := POutDate(DueDate),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'OPID',  Replace := Trim(OpName),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'USER1',  Replace := Trim(DocUser1),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'USER2',  Replace := Trim(DocUser2),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELAD1',  Replace := Trim(DAddr[1]),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELAD2',  Replace := Trim(DAddr[2]),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELAD3',  Replace := Trim(DAddr[3]),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELAD4',  Replace := Trim(DAddr[4]),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELPOSTCODE',  Replace := Trim(thDeliveryPostcode),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'DELAD5',  Replace := Trim(DAddr[5]),ReplaceAll := True, MatchCase := 1);
            // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
            MSWord.EditReplace (Find := PrefixInv + 'DELCOUNTRY', Replace := Trim(thDeliveryCountry), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'USER3',  Replace := Trim(DocUser3),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'USER4',  Replace := Trim(DocUser4),ReplaceAll := True, MatchCase := 1);

            // HM 06/12/01: Added new v5.00 TH Word Fields
            MSWord.EditReplace (Find := PrefixInv + 'JOBCODE',  Replace := Trim(DJobCode),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'ANALCODE',  Replace := Trim(DJobAnal),ReplaceAll := True, MatchCase := 1);

            { Net Goods less discount - unsigned }
            R := InvNetVal - Inv.DiscAmount;
            TmpField:=Form_Real(R,0,2);
            { HM: 24/07/00: Rewrote to support NETGDSB - Blank }
            If (R <> 0) Then
              MSWord.EditReplace (Find := PrefixInv + 'BNETGDS', Replace := Trim(TmpField), ReplaceAll := True, MatchCase := 1)
            Else
              MSWord.EditReplace (Find := PrefixInv + 'BNETGDS', Replace := '', ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'NETGDS', Replace := Trim(TmpField),ReplaceAll := True, MatchCase := 1);

            { Total VAT }
            TmpField:=Form_Real(InvVat,0,2);
            { HM: 24/07/00: Extended to support TOTVATB - Blank }
            If (InvVat <> 0) Then
              MSWord.EditReplace (Find := PrefixInv + 'BTOTVAT', Replace := Trim(TmpField), ReplaceAll := True, MatchCase := 1)
            Else
              MSWord.EditReplace (Find := PrefixInv + 'BTOTVAT', Replace := '', ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'TOTVAT', Replace := Trim(TmpField),ReplaceAll := True, MatchCase := 1);

            { Total - Unsigned }
            R := ITotal(Inv);
            TmpField:=Form_Real(R,0,2);
            { HM: 24/07/00: Extended to support TOTALB - Blank }
            If (R <> 0) Then
              MSWord.EditReplace (Find := PrefixInv + 'BTOTAL', Replace := Trim(TmpField), ReplaceAll := True, MatchCase := 1)
            Else
              MSWord.EditReplace (Find := PrefixInv + 'BTOTAL', Replace := '', ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'TOTAL', Replace := Trim(TmpField),ReplaceAll := True, MatchCase := 1);

            // MH 25/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
            MSWord.EditReplace (Find := PrefixInv + 'PPDPERCENTAGE', Replace := Form_Real(Pcnt2Full(thPPDPercentage),0,2), ReplaceAll := True, MatchCase := 1);
            If (thPPDDays > 0) Then
              MSWord.EditReplace (Find := PrefixInv + 'PPDDATE', Replace := POutDate(CalcDueDate(TransDate, thPPDDays)), ReplaceAll := True, MatchCase := 1)
            Else
              // 0 days implies no expiry date
              MSWord.EditReplace (Find := PrefixInv + 'PPDDATE', Replace := '', ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'PPDGOODS',  Replace := Form_Real(thPPDGoodsValue,0,2), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'PPDVAT',    Replace := Form_Real(thPPDVATValue,0,2), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'PPDTOTAL',  Replace := Form_Real(Round_Up(thPPDGoodsValue + thPPDVATValue,2),0,2), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixInv + 'PPDTAKEN',  Replace := YesNoBo(thPPDTaken <> ptPPDNotTaken), ReplaceAll := True, MatchCase := 1);

            { Check to see if lines are turned on }
            MSWord.StartOfDocument;
            MSWord.EditFind (Find := PrefixLine, Replace := '', Direction := 0, Wrap := 1);
            If MSWord.EditFindFound Then Begin
              { There is at least one line field }

              {* Preserve line posn *}
              New (TmpLine);
              TmpLine^ := Id;
              TmpKPath:=GetPosKey;
              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecIdAddr,BOff,BOff);

              KeyS := FullNomKey(InvR^.FolioNum);
              KeyR := KeyS;

              TmpStat := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
              While (TmpStat = 0) And CheckKey(KeyR, KeyS, Length(KeyR), BOn) Do Begin
                { Got a line - check for fields in the document }
                MSWord.StartOfDocument;
                MSWord.EditFind (Find := PrefixLine, Replace := '', Direction := 0, Wrap := 1);

                If MSWord.EditFindFound Then Begin
                  { Have fields in the document }
                  { Line Description }
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'DESC', Replace := Trim(Id.Desc), ReplaceOne := True, MatchCase := 1);

                  { Stock Code }
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'STKCODE', Replace := Trim(Id.StockCode), ReplaceOne := True, MatchCase := 1);

                  { Quantity }
                  TmpField:=Form_Real(Id.Qty,0,Syss.NoQtyDec);
                  MSWord.StartOfDocument;
                  { HM: 24/07/00: Extended to support QTYB - Blank }
                  If (Id.Qty <> 0) Then
                    MSWord.EditReplace (Find := PrefixLine + 'BQTY', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1)
                  Else
                    MSWord.EditReplace (Find := PrefixLine + 'BQTY', Replace := '', ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'QTY', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1);

                  { Line Disc in % symbol }
                  TmpField:=PPR_PAmountStr(Id.Discount, Id.DiscountChr);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'DISC', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1);

                  { Unit Price }
                  TmpField:=Form_Real(Id.NetValue,0,Syss.NoNetDec);
                  MSWord.StartOfDocument;
                  { HM: 24/07/00: Extended to support UNPRICEB - Blank }
                  If (Id.NetValue <> 0) Then
                    MSWord.EditReplace (Find := PrefixLine + 'BUNPRICE', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1)
                  Else
                    MSWord.EditReplace (Find := PrefixLine + 'BUNPRICE', Replace := '', ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'UNPRICE', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1);

                  { Total }
                  R := DetLTotal(Id,True, False,0.0) * LineCnst(Id.Payment);
                  TmpField:=Form_Real(R,0,2);
                  MSWord.StartOfDocument;
                  { HM: 24/07/00: Extended to support TOTALB - Blank }
                  If (R <> 0) Then
                    MSWord.EditReplace (Find := PrefixLine + 'BTOTAL', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1)
                  Else
                    MSWord.EditReplace (Find := PrefixLine + 'BTOTAL', Replace := '', ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'TOTAL', Replace := Trim(TmpField), ReplaceOne := True, MatchCase := 1);

                  { VAT Code }
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'VATCODE', Replace := Id.VATCode, ReplaceOne := True, MatchCase := 1);

                  { User Defined Fields }
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'USER1', Replace := Id.LineUser1, ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'USER2', Replace := Id.LineUser2, ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'USER3', Replace := Id.LineUser3, ReplaceOne := True, MatchCase := 1);
                  MSWord.StartOfDocument;
                  MSWord.EditReplace (Find := PrefixLine + 'USER4', Replace := Id.LineUser4, ReplaceOne := True, MatchCase := 1);

                  // HM 06/12/01: Added new v5.00 TL Word Fields
                  MSWord.EditReplace (Find := PrefixLine + 'JOBCODE',  Replace := Trim(Id.JobCode), ReplaceOne := True, MatchCase := 1);
                  MSWord.EditReplace (Find := PrefixLine + 'ANALCODE', Replace := Trim(Id.AnalCode), ReplaceOne := True, MatchCase := 1);
                  MSWord.EditReplace (Find := PrefixLine + 'GLCODE',   Replace := IntToStr(Id.NomCode), ReplaceOne := True, MatchCase := 1);

                  // HM 27/05/09: Added new v5.00 TL Word Fields
                  MSWord.EditReplace (Find := PrefixLine + 'MULTIDISC',  Replace := AD_DiscountStr, ReplaceOne := True, MatchCase := 1);

                  { Get next line }
                  TmpStat := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
                End { If }
                Else Begin
                  TmpStat := 4;   { Fake exit from loop }
                  MessageDlg ('There are more lines in the transaction than there are ' +
                              'in the document, the additional lines have not been put ' +
                              'in the document', mtWarning, [mbOk], 0);
                End; { Else }
              End; { While }

              {* Restore Line position *}
              TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecIdAddr,BOn,BOff);
              Id := TmpLine^;
              Dispose (TmpLine);

              { Blank out any remaining line details }
              MSWord.StartOfDocument;
              MSWord.EditFind (Find := PrefixLine, Replace := '', Direction := 0, Wrap := 1);
              If MSWord.EditFindFound Then Begin
                { HM: 24/07/00: Extended to support Blank fields }
                MSWord.EditReplace (Find := PrefixLine + 'BQTY', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'BUNPRICE', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'BTOTAL', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);

                MSWord.EditReplace (Find := PrefixLine + 'DESC', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'STKCODE', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'QTY', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'DISC', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'UNPRICE', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'TOTAL', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'VATCODE', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);

                MSWord.EditReplace (Find := PrefixLine + 'USER1', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'USER2', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'USER3', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'USER4', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);

                // HM 06/12/01: Added new v5.00 TL Word Fields
                MSWord.EditReplace (Find := PrefixLine + 'JOBCODE',  Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'ANALCODE', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
                MSWord.EditReplace (Find := PrefixLine + 'GLCODE',   Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);

                // HM 27/05/09: Added new v5.00 TL Word Fields
                MSWord.EditReplace (Find := PrefixLine + 'MULTIDISC', Replace := '', ReplaceAll := True, MatchCase := 1, Wrap := 1);
              End; { If }
            End; { If }
          End; { With }

        If Assigned(JobR) Then Begin
          With JobR^ Do Begin
            MSWord.EditReplace (Find := PrefixJob + 'CODE',  Replace := Trim(JobCode),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'DESC',  Replace := Trim(JobDesc),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'ALTCODE',  Replace := Trim(JobAltCode),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'CONTACT',  Replace := Trim(Contact),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'MANAGER',  Replace := Trim(JobMan),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'START',  Replace := POutDate(StartDate),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'END',  Replace := POutDate(EndDate),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'REVISED',  Replace := POutDate(RevEDate),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'ORDERREF',  Replace := Trim(SORRef),ReplaceAll := True, MatchCase := 1);

            TmpField:=Form_Real(QuotePrice,0,Syss.NoNetDec);
            MSWord.EditReplace (Find := PrefixJob + 'PRICE',  Replace := Trim(TmpField),ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixJob + 'USER1',  Replace := Trim(UserDef1),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'USER2',  Replace := Trim(UserDef2),ReplaceAll := True, MatchCase := 1);

            // HM 06/12/01: Added new v5.00 Word Fields
            MSWord.EditReplace (Find := PrefixJob + 'USER3',  Replace := Trim(UserDef3),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixJob + 'USER4',  Replace := Trim(UserDef4),ReplaceAll := True, MatchCase := 1);
          End; { With }
        End; { If }

        If Assigned(EmpR) Then Begin
          With EmpR^.EmplRec Do Begin
            { Employee Record - for future use }
            MSWord.EditReplace (Find := PrefixEmpl + 'CODE',  Replace := Trim(EmpCode),ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'NAME',  Replace := Trim(EmpName),ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixEmpl + 'ADDR1',   Replace := Trim(Addr[1]), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'ADDR2',   Replace := Trim(Addr[2]), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'ADDR3',   Replace := Trim(Addr[3]), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'ADDR4',   Replace := Trim(Addr[4]), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'ADDR5',   Replace := Trim(Addr[5]), ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixEmpl + 'SUPPLIER', Replace := Trim(Supplier),ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixEmpl + 'PHONE',    Replace := Trim(Phone), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'FAX',      Replace := Trim(Fax), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'MOBILE',   Replace := Trim(Phone2), ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixEmpl + 'PAYNO',    Replace := Trim(PayNo), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'CERTREF',   Replace := Trim(CertNo), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'CERTEXP',   Replace := POutDate(CertExpiry), ReplaceAll := True, MatchCase := 1);

            MSWord.EditReplace (Find := PrefixEmpl + 'USER1',   Replace := Trim(UserDef1), ReplaceAll := True, MatchCase := 1);
            MSWord.EditReplace (Find := PrefixEmpl + 'USER2',   Replace := Trim(UserDef2), ReplaceAll := True, MatchCase := 1);
         End; { With }
        End; { If }

        MSWord.FileSave; { Save any changes caused by F&R }
      End; { If }

      { make sure word is at front and not minimized }
      MsWord.AppShow;
      MsWord.AppRestore;

      Result := 0;   { will only be executed if all worked ok }
    except
      Result := 202;
      {ShowMessage('Could not start Microsoft Word.');}
      Exit;
    end;
  End { If }
  Else
    Result := 201;
end;


{************************************************************************}
{* AddWordLetter: Creates a new word document                           *}
{*                                                                      *}
{*                                                                      *}
{* Result:   0 - OK                                                     *}
{*           1 - Cancelled Open dialog                                  *}
{*           2 - Cancelled Description Dialog                           *}
{*                                                                      *}
{*           101 - no free number for extension                         *}
{*           102 - Error copying master to actual doc                   *}
{*                                                                      *}
{*           201 - Document doesn't exist                               *}
{*           202 - Exception while automating Word                      *}
{************************************************************************}
Function AddWordLetter (Const LetterIdx    : ShortString;
                        Const LetterName   : ShortString;
                        Const SubType      : Char;
                        Const CustR        : CustRecPtr;
                        Const StockR       : StockRecPtr;
                        Const InvR         : InvRecPtr;
                        Const JobR         : JobRecPtr;
                        Const EmpR         : JobMiscPtr) : Byte;
Var
  OpenDialog                     : TOpenDialog;
  SourceFile, DestFile, DestName : String;
begin
  Result := 0;

  { Create dialog manually as there is no handy form to have it on }
  OpenDialog := TOpenDialog.Create (Application);
  Try
    { initialise the dialog }
    OpenDialog.DefaultExt := 'DOC';
    OpenDialog.FileEditStyle := fsEdit;
    // MH 08/04/2013 v7.0.3 ABSEXCH-14064: Added support for DocX files
    OpenDialog.Filter := 'DOC Files (*.DOC, *.DOCX)|*.DOC;*.DOCX|All Files|*.*';
    OpenDialog.FilterIndex := 1;
    OpenDialog.InitialDir := SetDrive + PathMaster;
    OpenDialog.Title := 'Create Letter';

    OpenDialog.Execute;

    If (OpenDialog.FileName <> '') Then Begin
      { take copy of specified file into Docs directory }
      SourceFile := OpenDialog.FileName;
      DestFile := FullDocPath;
      DestName := Trim(LetterName);
      Result := CreateDOCFile (SourceFile, DestFile, DestName);
    End { If }
    Else
      Result := 1;
  Finally
    OpenDialog.Free;
  End;

  { Get description }
  If (Result = 0) Then
    If Not DescrDialog (LetterIdx, SubType, DestName, DocWord95) Then
      Result := 2;  { Cancelled in dialog }

  If (Result = 0) Then
    Result := EditLetter (DestFile, True, CustR, StockR, InvR, JobR, EmpR);
end;

Function ViewWordLetter (Const DocPath : String) : Byte;
begin
  Result := EditLetter (FullDocPath + DocPath, False, Nil, Nil, Nil, Nil, Nil);
end;

{ Displays the specified error message }
Procedure DispLetterError (Const ErrNo : Byte);
Var
  ErrStr : String;
begin
  ErrStr := '';

  Case ErrNo Of
    1   : ;  { Cancelled Open dialog }
    2   : ;  { Cancelled Description Dialog }
    101 : ErrStr := 'Cannot find a free document number';
    102 : ErrStr := 'An error occured copying the template document';
    201 : ErrStr := 'The specified document doesn''t exist';
    202 : ErrStr := 'An error occured while automating Word';
  End; { Case }

  If (ErrStr <> '') Then Begin
    { Display Error message }
    MessageDlg (ErrStr, mtError, [mbOk], 0);
  End; { If }
end;

end.
