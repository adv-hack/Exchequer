unit t2xWrite;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XmlTrans, XmlOrd, XmlInv, Classes;

{$IFNDEF StandAlone}
  This must be compiled with the 'StandAlone' conditional
{$ENDIF}

const
  STATUS_NOT_IMPLEMENTED = -1;
  STATUS_OK = 0;
  STATUS_INVALID_OUTPUT_DIR = 1;
  STATUS_INVALID_TRANS_TYPE = 2;
  STATUS_TOOLKIT_ERROR = 3;
  STATUS_INVALID_OUTPUT_FILE = 4;
  STATUS_NO_TRANSACTIONS = 5;

  STATUS_INVALID_HEADER_SIZE = 6;
  STATUS_INVALID_LINES_SIZE = 7;
  STATUS_INVALID_AUX_SIZE = 8;
  STATUS_INVALID_AUXLINES_SIZE = 9;
  STATUS_INVALID_NARRATIVE_SIZE = 10;
  STATUS_INVALID_SERIAL_SIZE = 11;

  SizeErr : Array[6..11] of string = ('Header','Lines','AuxRec','AuxLines','Narrative','Serial Batch');

function WriteXmlTransactionFile(P : Pointer;
                                 PL : Pointer;
                                 PSize, PLSize : longint;
                                 A : Pointer;
                                 AL : Pointer;
                                 ASize, ALSize : longint;
                                 N : Pointer;
                                 NSize : longInt;
                                 SB : Pointer;
                                 SBSize : longint) : Integer; stdcall; export;


implementation

uses
  SysUtils, FileCtrl, Dialogs, LogFile, XMLConst;





function WriteXmlTransactionFile(P : Pointer;
                                 PL : Pointer;
                                 PSize, PLSize : longint;
                                 A : Pointer;
                                 AL : Pointer;
                                 ASize, ALSize : longint;
                                 N : Pointer;
                                 NSize : longInt;
                                 SB : Pointer;
                                 SBSize : longint) : Integer;
var
  XmlTrans : TWriteXMLTransaction;
  TransType : string[3];
  i, j : integer;
  THRec : ^TBatchTHREc;
  THLines : ^TBatchLinesRec;
  AuxRec : ^t2xAuxHeadRec;
  AuxLinesRec : ^t2xAuxLines;
  NarrRec : TXmlNarrativeRec;
  SerialRec : TXmlSerialBatchDetailRec;
  RecPos : longint;
  NCount, SBCount : integer;


  function CheckParams : integer;
  const
    MAX_VALID_TRANS = 5;
    VALID_TRANS : array[1..MAX_VALID_TRANS] of string = ('POR', 'SIN', 'SOR', 'PIN', 'SCR');
    NarrativeSize = SizeOf(TXmlNarrativeRec);
    SerialSize = SizeOf(TXmlSerialBatchDetailRec);
  var
    Found : boolean;
    i : integer;
  begin
    begin
      Result := STATUS_OK;
      if Trim(AuxRec.SaveDir) <> '' then
      begin // Blank save directory OK i.e. current directory
        AuxRec.SaveDir := ExtractFilePath(IncludeTrailingBackSlash(AuxRec.SaveDir));
        // Check output directory exists
        if not DirectoryExists(AuxRec.SaveDir) then
          Result := STATUS_INVALID_OUTPUT_DIR;
      end;

      if Result = STATUS_OK then
      begin // Check valid transaction type
        Found := false;
        i := 1;
        while (i <= MAX_VALID_TRANS) and not Found do
        begin
          Found := Found or (TransType = VALID_TRANS[i]);
          inc(i);
        end;
        if not Found then
          Result := STATUS_INVALID_TRANS_TYPE;

        if Result = STATUS_OK then
        begin
          if PSize <> SizeOf(THRec^) then
            Result := STATUS_INVALID_HEADER_SIZE else
          if PlSize <> SizeOf(THLines^) then
            Result := STATUS_INVALID_LINES_SIZE else
          if ASize <> SizeOF(AuxRec^) then
            Result := STATUS_INVALID_AUX_SIZE else
          if ALSize <> SizeOf(AuxLinesRec^) then
            Result := STATUS_INVALID_AUXLINES_SIZE;

          if (NSize div NarrativeSize) * NarrativeSize <> NSize then
            Result := STATUS_INVALID_NARRATIVE_SIZE;

          if (SBSize div SerialSize) * SerialSize <> SBSize then
            Result := STATUS_INVALID_SERIAL_SIZE;

        end;
      end;
    end;
  end;

begin
  THRec := P;
  THLines := PL;
  AuxRec := A;
  AuxLinesRec := AL;

  //Change to check doctype rather than ourRef - allows non-standard doc nos
  TransType := {UpperCase(copy(THRec.OurRef,1,3))}THRec^.TransDocHed;
  Result := CheckParams;
  if Result <> STATUS_OK then exit;

  if (TransType  = 'POR') or (TransType = 'SOR') then
  begin
    XmlTrans := TWriteXMLOrder.Create;
    // To have hard coded style sheets uncomment following line
    //XMLTrans.XSLLocation := 'xml-stylesheet type="text/xsl" href="excheqr.xsl"';
  end
  else
  begin
    XmlTrans := TWriteXMLInvoice.Create;
    // To have hard coded style sheets uncomment following line
    //XMLTrans.XSLLocation := 'xml-stylesheet type="text/xsl" href="excheqr.xsl"';
  end;

  with XMlTrans do
    try
      try
        // To have hard coded style sheets comment following line
         if AuxRec.XSLLocation <> '' then
           XSLLocation := 'xml-stylesheet type="text/xsl" href="' +
                               AuxRec.XSLLocation + '"';
        //DataPath := CompanyDataPath;
        TransHeader := THRec^;
        TransLines  := THLines^;

        with CustSupp^, auxRec^ do
        begin
         for j := 1 to 5 do
          Addr[j] := CustSuppAdd[j];
          Company := CustSuppName;
          Contact := ContactName;
          Phone := ContactPhone;
          Fax   := ContactFax;
          RefNo := TheirCodeForUs;
        end;

        with SysInfo^ do
        begin
         for j := 1 to 5 do
          UserAddr[j] := AuxRec.OurAdd[j];
          UserName := AuxRec.OurName;
          UserVatReg := AuxRec.OurVatReg;
          CCDepts := AuxRec.UseCCDept;
          CostDP := AuxRec.CostDP;
          PriceDP := AuxRec.PriceDP;
          QuantityDP := AuxRec.QuantityDP;
          UseCrLimitChk := AuxRec.TransferMode = tfrReplication;
        end;

        CurrencyName := AuxRec.CurrName;
        CurrencyCode := AuxRec.CurrCode;
        CalcLineTotals := {Auxrec.CalcLineTotals}False;
        
        AuxLines := AuxLinesRec^;

        if N <> nil then
        begin
          NCount := NSize div SizeOf(TXmlNarrativeRec);
          SetNarrative(NCount);
          NarrativeCount := NCount;
          for i := 0 to NCount - 1 do
          begin
            RecPos:=LongInt(N)+( i* SizeOf(NarrRec));
            Move(Pointer(RecPos)^,NarrRec,SizeOf(NarrRec));

            Narrative[i] := NarrRec;
          end;
        end;

        if SB <> nil then
        begin
          SBCount := SBSize div SizeOf(TXmlSerialBatchDetailRec);
          SetSerial(SBCount);
          SerialCount := SBCount;
          for i := 0 to SBCount - 1 do
          begin
            RecPos:=LongInt(SB)+( i* SizeOf(SerialRec));
            Move(Pointer(RecPos)^,SerialRec,SizeOf(SerialRec));

            SerialArray[i] := SerialRec;
          end;
        end;

        CreateXML(THRec.OurRef);

        //if the user specified a filename then it will be in AuxRec.SaveFileName else
        //we use the standard protocol:-
        // e.g. POR001234 -> PO001234.XML i.e. 8.3 file name
        if AuxRec.SaveFileName <> '' then
          AuxRec.SaveDir := AuxRec.SaveDir + AuxRec.SaveFileName + '.XML'
        else
          AuxRec.SaveDir := AuxRec.SaveDir + copy(THRec.OurRef,1,2) + copy(THRec.OurRef,4,6) + '.XML';
        SaveToFile(AuxRec.SaveDir, true);
      except
        on E:Exception do
          begin
            ShowMessage(E.Message);
            Result := STATUS_TOOLKIT_ERROR;
          end;
      end;
    finally
      Free;
    end;
end;


end.
