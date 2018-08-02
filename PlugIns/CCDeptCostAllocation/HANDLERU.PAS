unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  ADODB, Classes, CustWinU, CustAbsU, DataModule, SQLUtils;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;
  CustHookId     : LongInt = 0;
  CustBtnId      : LongInt = 0;
  ACOnHold       : Boolean;
  AllocList      : TList;


implementation

Uses Dialogs, SysUtils, ChainU, PISecure, PIMisc, APIUtil, Enterprise01_TLB, ComObj, SecCodes,
     AllcBase, Select, EtMiscU, AllocVar, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  ReceiptCode = 2147483647;

  BEFORE_SAVE_TX = 1;
  BEFORE_SAVE_TX_LINE = 10;

Type
  PAllRec = ^TAllRec;
  TAllRec = Record
    AllocName : string[20];
    AbsLineNo : longint;
  end;


procedure SetCurrentCo(const DataPath : string);
var
  i : integer;
begin
  CurrentCo := '';
  with oToolkit.Company do
  begin
    for i := 1 to cmCount do
    begin
      //NF: 23/04/2008 ExtractShortPathName added to support long filenames
      if ExtractShortPathName(UpperCase(Trim(cmCompany[i].coPath)))
      = ExtractShortPathName(UpperCase(Trim(DataPath)))
      then CurrentCo := cmCompany[i].coCode;
    end;{for}
  end;{with}
end;

procedure ProcessTrans(const EventData : TAbsEnterpriseSystem);
var
  Res, i, j, k : longint;
  KeyS, KeyChk : ShortString;
  ARec : TAllRec;
  ThisPerc, TotalPerc : Double;
  AllCount : Integer;
  NomCode : longint;
  LCount : longint;
  ThisNet, ThisCost, ThisVat, ThisQty, ThisDisc, ThisDisc2, ThisDisc3 : Double;
  LineNet, LineCost, LineVat, LineDisc, LineDisc2, LineDisc3 : Double;
  ECServiceStartDate, ECServiceEndDate, Desc, ThisCC, ThisDep, DiscFlag, Disc, DiscFlag2, DiscFlag3 : string;
  DiscType3 : Byte;
  VatCode : Char;
  bContinue, ECService : boolean;
  qRecords : TADOQuery;

  // CA 16/04/2013 v7.0.3  ABSEXGENERIC-288: CC/Dept Cost Allocation plug-in not respecting currency
  Currency  : Byte;
  CompRate  : Real48;
  DailyRate : Real48;
begin
  if AllocList.Count > 0 then
  begin

{    if oToolkit.Status = tkClosed then
    begin
      oToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
      Res := oToolkit.OpenToolkit;

      if Res <> 0 then
      begin
        ShowMessage('Unable to Open COM Toolkit: ' + #10#10 + oToolkit.LastErrorString);
        bPlugInEnabled := False;
      end;
    end;}
    if bPlugInEnabled then
    with EventData.Transaction do
    begin
      SetCurrentCo(EventData.Setup.ssDataPath);
      for i := 0 to AllocList.Count - 1 do
      begin
        TotalPerc := 0;
        ThisNet := 0;
        ThisCost := 0;
        ThisVat := 0;
        ThisDisc := 0.0;
        ThisDisc2 := 0.0;
        ThisDisc3 := 0.0;
        LCount := 1;
        ARec := pAllRec(AllocList[i])^;
        j := 1;
        while (j <= thLines.thLineCount) and (thLines.thLine[j].tlLineNo <> ARec.AbsLineNo) do
          inc(j);
        if (thLines.thLine[j].tlLineNo = ARec.AbsLineNo) then
        begin
          //Find number of lines for this alloc
          if bSQL then
          begin
            // MS-SQL
            qRecords := SQLDataModule.GetAllLinesFor(CurrentCo, thLines.thLine[j].tlGLCode, ARec.AllocName);
            AllCount := qRecords.RecordCount;
          end
          else
          begin
            // Pervasive
            AllCount := -1;
            KeyS := CurrentCo + FullNomKey(thLines.thLine[j].tlGLCode) + ARec.AllocName;
            KeyChk := KeyS;
            Res := FindRec(KeyS, B_GetGEq);
            while  (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
            begin
              inc(AllCount);
              Res := FindRec(KeyS, B_GetNext);
            end;{while}
          end;{if}

          if AllCount > 0 then
          begin

            if bSQL then
            begin
              // MS-SQL
              qRecords := SQLDataModule.GetAllRecordsFor(CurrentCo, thLines.thLine[j].tlGLCode,ARec.AllocName);
              qRecords.First;
              if not qRecords.EOF then qRecords.Next;
              bContinue := not qRecords.EOF;
            end
            else
            begin
              // Pervasive
              KeyS := CurrentCo + FullNomKey(thLines.thLine[j].tlGLCode) + ARec.AllocName;
              KeyChk := KeyS;
              Res := FindRec(KeyS, B_GetGEq); //NF: I am guessing that this gets the header record ?
              Res := FindRec(KeyS, B_GetNext); //NF: I am guessing that this then gets the first line record ?
              bContinue := Res = 0;
            end;{if}

            if bContinue then
            begin
              if thInvDocHed <> cuNMT then
              for k := thLines.thLineCount downto j + 1 do
              begin

                if (Trim(thLines.thLine[k].tlUserDef1) = '') and not (thLines.thLine[k].tlLinePos = ReceiptCode) then
                  thLines.thLine[k].tlLinePos := thLines.thLine[k].tlLinePos + (AllCount * 2);
              end;

              if bSQL then
              begin
                // MS-SQL
                ThisPerc := qRecords.FieldByName('Percentage').Asfloat / 100;
              end
              else
              begin
                // Pervasive
                ThisPerc := AllocRec.Percentage / 100;
              end;{if}

              TotalPerc := TotalPerc + ThisPerc;
              with TAbsInvLine7(thLines.thLine[j]) do
              begin
                // Stash details in local variables for use on other lines
                Desc := tlDescr;
                NomCode := tlGLCode;
                ThisCC := tlCostCentre;
                ThisDep := tlDepartment;
                VATCode := tlVatCode;
                ThisQty := tlQty;
                DiscFlag := tlDiscFlag;
                LineDisc := tlDiscount;

                // CA 12/04/2013 v7.0.3  ABSEXGENERIC-288: CC/Dept Cost Allocation plug-in not respecting currency
                //                       Currency needs to be passed through
                Currency  := tlCurrency;
                CompRate  := tlCompanyRate;
                DailyRate := tlDailyRate;

                LineDisc2 := tlMultiBuyDiscount;
                DiscFlag2 := tlMultiBuyDiscountFlag;
                LineDisc3 := tlTransValueDiscount;
                DiscFlag3 := tlTransValueDiscountFlag;
                DiscType3 := tlTransValueDiscountType;

                LineNet := tlNetValue;
                LineCost := tlCost;
                LineVat := tlVatAmount;

                {v6.20.015 - NF: Added for compatibilty with v6.2 EC Changes}
                ECService := tlECService;

                {v6.20.016 ABSEXCH-9439}
//                ECServiceStartDate := tlServiceStartDate;
//                ECServiceEndDate := tlServiceEndDate;
                if trim(tlServiceStartDate) <> '' then ECServiceStartDate := tlServiceStartDate;
                if trim(tlServiceEndDate) <> '' then ECServiceEndDate := tlServiceEndDate;

                // Update values on the original line to reflect its portion of the value
                tlNetValue := Round_Up(tlNetValue * ThisPerc, 2);
                tlCost := Round_Up(tlCost * ThisPerc, 2);
                if Copy(DiscFlag, 1, 1) <> '%' then
                  tlDiscount := Round_Up(tlDiscount * ThisPerc, 2);
                if Copy(DiscFlag2, 1, 1) <> '%' then
                  tlMultiBuyDiscount := Round_Up(tlMultiBuyDiscount * ThisPerc, 2);
                if Copy(DiscFlag3, 1, 1) <> '%' then
                  tlTransValueDiscount := Round_Up(tlTransValueDiscount * ThisPerc, 2);
                tlVatAmount := Round_Up(tlVatAmount * ThisPerc, 2);

                // Update running totals of what has been apportioned so far
                ThisNet := Round_Up(ThisNet + tlNetValue, 2);
                ThisCost := Round_Up(ThisCost + tlCost, 2);
                ThisVat := ThisVat + tlVATAmount;
                ThisDisc := ThisDisc + tlDiscount;
                ThisDisc2 := ThisDisc2 + tlMultiBuyDiscount;
                ThisDisc3 := ThisDisc3 + tlTransValueDiscount;

                if bSQL then
                begin
                  // MS-SQL
                  Case qRecords.FieldByName('Type').AsInteger of
                    0  : begin
                           tlCostCentre := qRecords.FieldByName('CostCentre').AsString;
                           tlDescr := Desc + ' (' + qRecords.FieldByName('CostCentre').AsString + ')';
                           tlDepartment := ThisDep;
                         end;
                    1  : begin
                           tlDepartment := qRecords.FieldByName('Department').AsString;
                           tlDescr := Desc + ' (' + qRecords.FieldByName('Department').AsString + ')';
                           tlCostCentre := ThisCC;
                         end;
                    2  : begin
                           tlCostCentre := qRecords.FieldByName('CostCentre').AsString;
                           tlDepartment := qRecords.FieldByName('Department').AsString;
                           tlDescr := Desc + ' (' + qRecords.FieldByName('CostCentre').AsString + '/'
                           + qRecords.FieldByName('Department').AsString + ')';
                         end;
                  end; //Case;
                end
                else
                begin
                  // Pervasive
                  Case AllocRec.AllocType of
                    0  : begin
                           tlCostCentre := AllocRec.CC;
                           tlDescr := Desc + ' (' + AllocRec.CC + ')';
                           tlDepartment := ThisDep;
                         end;
                    1  : begin
                           tlDepartment := AllocRec.Dep;
                           tlDescr := Desc + ' (' + AllocRec.Dep + ')';
                           tlCostCentre := ThisCC;
                         end;
                    2  : begin
                           tlCostCentre := AllocRec.CC;
                           tlDepartment := AllocRec.Dep;
                           tlDescr := Desc + ' (' + AllocRec.CC + '/' + AllocRec.Dep + ')';
                         end;
                  end; //Case;
                end;{if}

                tlUserDef1 := Trim(ARec.AllocName);
                Save;
              end;

              if bSQL then
              begin
                // MS-SQL
                qRecords.Next;
                bContinue := not qRecords.EOF;
              end
              else
              begin
                // Pervasive
                Res := FindRec(KeyS, B_GetNext); //NF: I am guessing that this then gets the Next line record ?
                bContinue := (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk);
              end;{if}

              while bContinue do
              begin
                inc(LCount);

                if bSQL then
                begin
                  // MS-SQL
                  ThisPerc := qRecords.FieldByName('Percentage').Asfloat / 100;
                end
                else
                begin
                  // Pervasive
                  ThisPerc := AllocRec.Percentage / 100;
                end;{if}
//                    ThisPerc := Round_Up(100 / AllocRec.Percentage, 2);

                TotalPerc := TotalPerc + ThisPerc;
                thLines.AddNewLine;
                with TAbsInvLine7(thLines.thCurrentLine) do
                begin
                  if thInvDocHed <> cuNMT then
                    tlLinePos := thLines.thLine[j].tlLinePos + (LCount {* 2})
                  else
                    tlLinePos := ReceiptCode;

                  // CA 16/04/2013 v7.0.3  ABSEXGENERIC-288: CC/Dept Cost Allocation plug-in not respecting currency
                  //                       Currency needs to be passed through
                  tlCurrency    := Currency;
                  tlCompanyRate := CompRate;
                  tlDailyRate   := DailyRate;

                  tlGLCode := NomCode;
                  tlNetValue := Round_Up(LineNet * ThisPerc, 2);
                  tlCost := Round_Up(LineCost * ThisPerc, 2);
                  tlDiscFlag := DiscFlag[1];
                  if (Copy(DiscFlag, 1, 1) <> '%') then
                    tlDiscount := Round_Up(LineDisc * ThisPerc, 2)
                  else
                    tlDiscount := LineDisc;

                  tlMultiBuyDiscountFlag := DiscFlag2[1];
                  if Copy(DiscFlag2, 1, 1) <> '%' then
                    tlMultiBuyDiscount := Round_Up(LineDisc2 * ThisPerc, 2)
                  Else
                    tlMultiBuyDiscount := LineDisc2;

                  tlTransValueDiscountFlag := DiscFlag3[1];
                  tlTransValueDiscountType := DiscType3;
                  if Copy(DiscFlag3, 1, 1) <> '%' then
                    tlTransValueDiscount := Round_Up(LineDisc3 * ThisPerc, 2)
                  Else
                    tlTransValueDiscount := LineDisc3;

                  if thInvDocHed <> cuNMT then
                    tlVATCode := VATCode;
                  tlQty := ThisQty;
                  tlVatAmount := Round_Up(tlVatAmount * ThisPerc, 2);

                  ThisNet := Round_Up(ThisNet + tlNetValue,2);
                  ThisCost := Round_Up(ThisCost + tlCost,2);
                  ThisVat := ThisVat + tlVATAmount;
                  ThisDisc := ThisDisc + tlDiscount;
                  ThisDisc2 := ThisDisc2 + tlMultiBuyDiscount;
                  ThisDisc3 := ThisDisc3 + tlTransValueDiscount;

                  if bSQL then
                  begin
                    // MS-SQL
                    Case qRecords.FieldByName('Type').AsInteger of
                      0  : begin
                             tlCostCentre := qRecords.FieldByName('CostCentre').AsString;
                             tlDescr := Desc + ' (' + qRecords.FieldByName('CostCentre').AsString + ')';
                             tlDepartment := ThisDep;
                           end;
                      1  : begin
                             tlDepartment := qRecords.FieldByName('Department').AsString;
                             tlDescr := Desc + ' (' + qRecords.FieldByName('Department').AsString + ')';
                             tlCostCentre := ThisCC;
                           end;
                      2  : begin
                             tlCostCentre := qRecords.FieldByName('CostCentre').AsString;
                             tlDepartment := qRecords.FieldByName('Department').AsString;
                             tlDescr := Desc + ' (' + qRecords.FieldByName('CostCentre').AsString + '/'
                             + qRecords.FieldByName('Department').AsString + ')';
                           end;
                    end; //Case;
                  end
                  else
                  begin
                    // Pervasive
                    Case AllocRec.AllocType of
                      0  : begin
                             tlCostCentre := AllocRec.CC;
                             tlDescr := Desc + ' (' + AllocRec.CC + ')';
                             tlDepartment := ThisDep;
                           end;
                      1  : begin
                             tlDepartment := AllocRec.Dep;
                             tlDescr := Desc + ' (' + AllocRec.Dep + ')';
                             tlCostCentre := ThisCC;
                           end;
                      2  : begin
                             tlCostCentre := AllocRec.CC;
                             tlDepartment := AllocRec.Dep;
                             tlDescr := Desc + ' (' + AllocRec.CC + '/' + AllocRec.Dep + ')';
                           end;
                    end; //Case;
                  end;{if}

                  tlUserDef1 := Trim(ARec.AllocName);

                  {v6.20.015 - NF: Added for compatibilty with v6.2 EC Changes}
                  tlECService := ECService;

                  // v6.20.017 - ABSEXCH-9662
//                  tlServiceStartDate := ECServiceStartDate;
///                  tlServiceEndDate := ECServiceEndDate;
                  if trim(ECServiceStartDate) <> '' then tlServiceStartDate := ECServiceStartDate;
                  if trim(ECServiceEndDate) <> '' then tlServiceEndDate := ECServiceEndDate;

                  if LCount = AllCount then
                  begin
                    tlNetValue := tlNetValue + (LineNet - ThisNet);
                    tlCost := tlCost + (LineCost - ThisCost);
                    tlVATAmount := tlVATAmount + (LineVAT - ThisVAT);
                    if (Copy(DiscFlag, 1, 1) <> '%') then
                      tlDiscount := tlDiscount + (LineDisc - ThisDisc);
                    if (Copy(DiscFlag2, 1, 1) <> '%') then
                      tlMultiBuyDiscount := tlMultiBuyDiscount + (LineDisc2 - ThisDisc2);
                    if (Copy(DiscFlag3, 1, 1) <> '%') then
                      tlTransValueDiscount := tlTransValueDiscount + (LineDisc3 - ThisDisc3);
                  end;

                  Save;
                end;

                //Next Record
                if bSQL then
                begin
                  // MS-SQL
                  qRecords.Next;
                  bContinue := not qRecords.EOF;
                end
                else
                begin
                  // Pervasive
                  Res := FindRec(KeyS, B_GetNext); //NF: I am guessing that this then gets the Next line record ?
                  bContinue := (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk);
                end;{if}
              end;{while}

            end;
          end; //AllCount > 0
        end;
      end;

{            if AllCount > 0 then
            Res := Save(False)
          else
            Cancel;}

{            if Res <> 0 then
            ShowMessage('Unable to save transaction ' +  EventData.Transaction.thOurRef +
                   #10#10 + 'Error: ' + QuotedStr(oToolkit.LastErrorString));}
//        end; //with update
{        end
        else
          ShowMessage('Unable to update transaction ' + EventData.Transaction.thOurRef);
      end
      else
        ShowMessage('Unable to access transaction ' + EventData.Transaction.thOurRef);}

{    end; //with oToolkit.transaction
    oToolkit.CloseToolkit;}
    end;
  end;
end;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
  Res : longint;
const
  sPlugInName = 'CC/Dept Cost Allocation Plug-In';
Begin
  CustomOn := True;

  //Check Plug-In Security
  bPlugInEnabled := PICheckSecurity('EXCHCCDCST000021', 'apnb[w!3]@qQ#\m/', sPlugInName
  , '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bPlugInEnabled then
  begin

    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText (sPlugInName, // sName
                         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                     // sVersionNo : string;
                         slAboutText);                          // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      SetHandlerStatus(wiTransaction, BEFORE_SAVE_TX, EventEnabled);
      SetHandlerStatus(wiTransLine, BEFORE_SAVE_TX_LINE, EventEnabled);

      // HM 07/02/05: Removed these as the CTK cannot be left open globally -
      // also StartToolkit duplicates the Create line?
      //oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
      //StartToolkit;

      // Open Data connection
      if bSQL then
      begin
        // MS-SQL

        // Open connection to MS-SQL
        SQLDataModule := TSQLDataModule.Create(nil);
        bPlugInEnabled := SQLDataModule.Connect;
      end
      else
      begin
        // Pervasive
        Res := OpenFile;  //Open allocation file
        bPlugInEnabled := Res = 0;
      end;{if}

      if not bPlugInEnabled then
      begin
        ShowMessage('Unable to open Allocation Table. Btrieve Error: ' + IntToStr(Res));
      end;{if}

      AllocList := TList.Create;
    End; { With }
  end;{if}

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;


{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
  // HM 07/02/05: Managed within the event 
  //oToolkit.CloseToolkit;
  oToolkit := nil;

  if bSQL then
  begin
    // MS-SQL
    if Assigned(SQLDataModule) then
    begin
      SQLDataModule.Disconnect;
      SQLDataModule := nil;
    end;{if}
  end
  else
  begin
    // Pervasive
    CloseFile;
  end;{if}

  AllocList.Free;
End;


{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  ThisAlloc : string;
  ALineNo : longint;
  pARec : PAllRec;
  Res, i : longint;
Begin
  If bPlugInEnabled And (((EventData.WinId = wiTransaction) and (EventData.HandlerId = BEFORE_SAVE_TX)) or
                         ((EventData.WinId = wiTransLine) and (EventData.HandlerId = BEFORE_SAVE_TX_LINE)))  Then
  begin
    if EventData.Transaction.thInvDocHed in [cuPQU, cuPIN, cuPJI, cuPCR, cuPJC, cuPRF, cuNMT] then
    begin
      // HM 07/02/05: Create/Destroy COMTK locally within the Event
      StartToolkit;
      Try
        oToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
        Res := oToolkit.OpenToolkit;
        if Res <> 0 then ShowMessage(IntToStr(Res));

        // Find Current Company
        with oToolkit.Company do
        begin
          for i := 1 to cmCount do
          begin
            if ExtractShortPathName(UpperCase(Trim(cmCompany[i].coPath)))  //NF: 26/03/2008 ExtractShortPathName added to support long filenames
            = ExtractShortPathName(UpperCase(Trim(EventData.Setup.ssDataPath))) then
            begin
              CurrentCo := cmCompany[i].coCode;
              Break;
            end;{if}
          end;{for}
        end;{with}

        if (EventData.WinId = wiTransaction) and (EventData.HandlerID = BEFORE_SAVE_TX) then
        begin
          // Before Store Transaction
          ProcessTrans(EventData);
          AllocList.Clear;
        end;{if}

        if (EventData.WinId = wiTransLine) and (EventData.HandlerID = BEFORE_SAVE_TX_LINE) then
        begin
          // Before Store Transaction Line
          with EventData.Transaction.thLines.thCurrentLine do
          begin
            ThisAlloc := SelectAllocation(tlGLCode, Trim(tlUserDef1));
          end;{with}

          if ThisAlloc <> '' then
          begin
            New(pARec);
            pARec^.AllocName := ThisAlloc;
            pARec^.AbsLineNo := EventData.Transaction.thLines.thCurrentLine.tlLineNo;
            AllocList.Add(pARec);
          end;{if}
        end;{if}

      Finally
        // Clear Up
        oToolkit.CloseToolkit;
        oToolkit := NIL;
      End;{try}

    end; //if thInvDocHed in
  end; //if bPlugInEnabled

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
