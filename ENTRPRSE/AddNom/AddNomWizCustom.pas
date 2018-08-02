unit AddNomWizCustom;

interface
uses
  Enterprise04_TLB;

const
  hiAfterSaveTX = 170;
  hiValidateTX = 82;
  hiExitCostCentre = 16;
  hiExitDepartment = 17;
  hiExitNetValue = 9;
  hiEnterNetValue = 5;
  hiEnterDescription = 66;
  hiExitDescription = 181;
  hiEnterDailyRate = 7;
  hiLineValidation = 19;
  hiVATCalculation = 1;
  // CJS 2014-05-06 - ABSEXCH-14076 - After Store Line Hook point on NOM lines
  hiAfterSaveTXLine = 14;

  function ExecuteTXHook(oNom : ITransaction; iCurrentLine, iWindowID, iHandlerID : integer) : boolean;

implementation
uses
  CustAbsU, Dialogs, CustWinU, CustIntU, EXWrap1U;

function ExecuteTXHook(oNom : ITransaction; iCurrentLine, iWindowID, iHandlerID : integer) : boolean;
var
  sHead, sLine : WideString;
  CustomEvent  :  TCustomEvent;
  ExLocal : TdExLocal;
  iPos : integer;
Begin{ExecuteTXHook}

  // Default Result depending on hook
  case iWindowID of
    wiTransaction : begin
      case iHandlerID of
        hiAfterSaveTX, hiValidateTX : Result := TRUE;
        hiEnterDescription, hiEnterDailyRate : Result := FALSE;
      end;{case}
    end;

    wiTransLine : begin
      case iHandlerID of
        hiExitCostCentre, hiExitDepartment, hiExitNetValue : Result := FALSE;
        hiLineValidation : Result := TRUE;
        hiAfterSaveTXLine: Result := TRUE;
      end;{case}
    end;

    wiMisc+1 : begin
      case iHandlerID of
        hiVATCalculation : Result := FALSE;
      end;{case}
    end;
  end;{case}


  // Creates object to do this customisation event
  CustomEvent := TCustomEvent.Create(iWindowID, iHandlerID);

  try
    with CustomEvent do
    begin

      // Has the event been enabled by any plug-ins ?
      if (GotEvent) then
      begin

        // Create Object to hold the data
        ExLocal.Create;

        // Gets a string containing the Inv record for this ITransaction Object
        with oNOM as IToolkitRecord do
        begin
          // GetData Gets a TBatchTHRec
          // ConvertData converts the TBatchTHRec to an InvRec
          sHead := ConvertData(GetData);
        end;{with}

        // Moves the string InvRec into an actual InvRec record
        if Length(sHead) > 0
        then Move(sHead[1], ExLocal.LInv, SizeOf(ExLocal.LInv));

        // Gets a string containing the Id record for the ITransactionLine Object
        with oNOM.thLines[iCurrentLine] as IToolkitRecord do
        begin
          // GetData Gets a TBatchTLRec
          // ConvertData converts the TBatchTLRec to an Idetail
          sLine := ConvertData(GetData);
        end;{with}

        // Moves the string IDetail into an actual IDetail record
        if Length(sLine) > 0
        then Move(sLine[1], ExLocal.LId, SizeOf(ExLocal.LId));

        // Builds the customisation data for the event
        BuildEvent(ExLocal);

        // Execute Customisation Event
        Execute;

        // After Customisation

        // Set Result, depending on the hook
        // Populate changed fields back into the ITransaction / ITransactionLine Object
        case iWindowID of
          wiTransaction : begin
            case iHandlerID of

              hiAfterSaveTX : Result := TRUE;

              hiValidateTX : Result := EntSysObj.BoResult;

              hiEnterDescription, hiExitDescription : begin
                Result := DataChanged;
                if Result then oNom.thLongYourRef := EntSysObj.Transaction.thTransDesc;
              end;

              hiEnterDailyRate : begin
                Result := DataChanged;
                if Result then oNom.thDailyRate := EntSysObj.Transaction.thDailyRate;
              end;

            end;{case}
          end;

          wiTransLine : begin
            case iHandlerID of
              hiExitCostCentre : begin
                Result := DataChanged;
                if DataChanged then
                begin
                  oNom.thLines[iCurrentLine].tlCostCentre :=
                  EntSysObj.Transaction.thLines.thcurrentline.tlCostCentre;
                end;{if}
              end;

              hiExitDepartment : begin
                Result := DataChanged;
                if DataChanged then
                begin
                  oNom.thLines[iCurrentLine].tlDepartment :=
                  customevent.EntSysObj.Transaction.thLines.thcurrentline.tldepartment;
                end;{if}
              end;

              hiExitNetValue : begin
                Result := DataChanged;
                if DataChanged then
                begin
                  with customevent.EntSysObj.Transaction.thLines.thcurrentline do
                  begin
                    oNom.thLines[iCurrentLine].tlNetValue := tlNetValue;
                    oNom.thLines[iCurrentLine].tlDiscFlag := tlDiscFlag;
                    oNom.thLines[iCurrentLine].tlDiscount := tlDiscount;
                    (oNom.thLines[iCurrentLine] as ITransactionLine3).tlVATIncValue
                    := TAbsInvLine2(customevent.EntSysObj.Transaction.thLines.thcurrentline).tlVATInclValue;
                  end;{with}
                end;{if}
              end;

              hiLineValidation : begin
                Result := EntSysObj.ValidStatus and EntSysObj.BoResult;
              end;

              hiAfterSaveTXLine: begin
                Result := EntSysObj.BoResult;
              end;

            end;{case}
          end;

          wiMisc+1 : begin
            case iHandlerID of
              hiVATCalculation : begin
                Result := DataChanged;
                if DataChanged then
                begin
                  with customevent.EntSysObj.Transaction.thLines.thcurrentline do
                  begin
                    oNom.thLines[iCurrentLine].tlVATCode := tlVATCode;
                    oNom.thLines[iCurrentLine].tlVATAmount := tlVATAmount;
                    (oNom.thLines[iCurrentLine] as ITransactionLine3).tlVATIncValue
                    := TAbsInvLine2(customevent.EntSysObj.Transaction.thLines.thcurrentline).tlVATInclValue;
                  end;{with}
                end;{if}
              end;
            end;{case}
          end;
        end;{case}

        // Clear up
        ExLocal.Destroy;
      end;{if}
    end;{with}

  finally
    // Clear up
    CustomEvent.Free;
  end;
end;{ExecuteTXHook}


end.
