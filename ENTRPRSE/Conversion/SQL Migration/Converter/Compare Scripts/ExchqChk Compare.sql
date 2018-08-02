-- Target Table columns
DECLARE @srcRecPfix varchar(1)
      , @srcSubType int
      , @srcEXCHQCHKcode1 varbinary(13)
      , @srcEXCHQCHKcode2 varbinary(10)
      , @srcEXCHQCHKcode3 varbinary(12)
      , @srcAccess varbinary(244)
      , @srcLastPno int
      , @srcPassDesc varbinary(69)
      , @srcPassPage int
      , @srcPassLNo int
      , @srcNoteFolio varbinary(11)
      , @srcNType varchar(1)
      , @srcSpare1 varbinary(2)
      , @srcLineNumber int
      , @srcNoteLine varchar(100)
      , @srcNoteUser varchar(10)
      , @srcTmpImpCode varchar(16)
      , @srcShowDate bit
      , @srcRepeatNo int
      , @srcNoteFor varchar(10)
      , @srcSettledVal varbinary(5)
      , @srcOwnCVal float
      , @srcMCurrency int
      , @srcMatchType varchar(1)
      , @srcOldAltRef varchar(10)
      , @srcRCurrency int
      , @srcRecOwnCVal float
      , @srcAltRef varchar(20)
      , @srcQtyUsed varbinary(5)
      , @srcQtyCost float
      , @srcQCurrency int
      , @srcFullStkCode varchar(20)
      , @srcFreeIssue bit
      , @srcQtyTime int
      , @srcBACSTagRunNo varbinary(3)
      , @srcPayType varchar(1)
      , @srcBACSBankNom int
      , @srcPayCurr int
      , @srcInvCurr int
      , @srcCQStart int
      , @srcAgeType int
      , @srcAgeInt int
      , @srcTagStatus bit
      , @srcTotalTag0 float
      , @srcTotalTag1 float
      , @srcTotalTag2 float
      , @srcTotalTag3 float
      , @srcTotalTag4 float
      , @srcTagAsDate varchar(8)
      , @srcTagCount int
      , @srcTagDepartment varchar(3)
      , @srcTagCostCentre varchar(3)
      , @srcTagRunDate varchar(8)
      , @srcTagRunYr int
      , @srcTagRunPr int
      , @srcSalesMode bit
      , @srcLastInv int
      , @srcSRCPIRef varchar(10)
      , @srcLastTagRunNo int
      , @srcTagCtrlCode int
      , @srcUseAcCC bit
      , @srcSetCQatP bit
      , @srcIncSDisc bit
      , @srcSDDaysOver int
      , @srcShowLog bit
      , @srcUseOsNdx bit
      , @srcBACSCLIUCount int
      , @srcYourRef varchar(20)
      , @srcTagRunNo varbinary(3)
      , @srcBankNom int
      , @srcBankCr int
      , @srcReconOpo varchar(10)
      , @srcEntryTotDr float
      , @srcEntryTotCr float
      , @srcEntryDate varchar(8)
      , @srcNomEntTyp varchar(1)
      , @srcAllMatchOk bit
      , @srcMatchCount int
      , @srcMatchOBal float
      , @srcManTotDr float
      , @srcManTotCr float
      , @srcManRunNo int
      , @srcManChange bit
      , @srcManCount int
      , @srcAllocSF varbinary(5)
      , @srcCCDesc varbinary(19)
      , @srcCCTag bit
      , @srcLastAccess varchar(8)
      , @srcNLineCount int
      , @srcHideAC int
      , @srcMoveCodeNom varbinary(3)
      , @srcMoveFromNom int
      , @srcMoveToNom int
      , @srcMoveTypeNom varchar(1)
      , @srcMoveCodeStk varbinary(16)
      , @srcMoveFromStk varchar(16)
      , @srcMoveToStk varchar(16)
      , @srcNewStkCode varchar(16)
      , @srcStuff varbinary(205)
      , @srcOpoName varbinary(10)
      , @srcStartDate varchar(8)
      , @srcStartTime varchar(6)
      , @srcWinLogName varchar(50)
      , @srcWinCPUName varchar(50)
      , @srcBACSULIUCount int
      , @srcSCodeOld varbinary(13)
      , @srcSCodeNew varchar(20)
      , @srcMoveStage int
      , @srcOldNCode int
      , @srcNewNCode int
      , @srcNTypOld varchar(1)
      , @srcNTypNew varchar(1)
      , @srcMoveKey1 varchar(50)
      , @srcMoveKey2 varchar(50)
      , @srcWasMode int
      , @srcSGrpNew varchar(20)
      , @srcSUser varchar(10)
      , @srcFinStage bit
      , @srcProgCounter int
      , @srcMIsCust bit
      , @srcMListRecAddr int
      , @srcPositionId int

-- Target Table columns

      , @trgRecPfix varchar(1)
      , @trgSubType int
      , @trgEXCHQCHKcode1 varbinary(13)
      , @trgEXCHQCHKcode2 varbinary(10)
      , @trgEXCHQCHKcode3 varbinary(12)
      , @trgAccess varbinary(244)
      , @trgLastPno int
      , @trgPassDesc varbinary(69)
      , @trgPassPage int
      , @trgPassLNo int
      , @trgNoteFolio varbinary(11)
      , @trgNType varchar(1)
      , @trgSpare1 varbinary(2)
      , @trgLineNumber int
      , @trgNoteLine varchar(100)
      , @trgNoteUser varchar(10)
      , @trgTmpImpCode varchar(16)
      , @trgShowDate bit
      , @trgRepeatNo int
      , @trgNoteFor varchar(10)
      , @trgSettledVal varbinary(5)
      , @trgOwnCVal float
      , @trgMCurrency int
      , @trgMatchType varchar(1)
      , @trgOldAltRef varchar(10)
      , @trgRCurrency int
      , @trgRecOwnCVal float
      , @trgAltRef varchar(20)
      , @trgQtyUsed varbinary(5)
      , @trgQtyCost float
      , @trgQCurrency int
      , @trgFullStkCode varchar(20)
      , @trgFreeIssue bit
      , @trgQtyTime int
      , @trgBACSTagRunNo varbinary(3)
      , @trgPayType varchar(1)
      , @trgBACSBankNom int
      , @trgPayCurr int
      , @trgInvCurr int
      , @trgCQStart int
      , @trgAgeType int
      , @trgAgeInt int
      , @trgTagStatus bit
      , @trgTotalTag0 float
      , @trgTotalTag1 float
      , @trgTotalTag2 float
      , @trgTotalTag3 float
      , @trgTotalTag4 float
      , @trgTagAsDate varchar(8)
      , @trgTagCount int
      , @trgTagDepartment varchar(3)
      , @trgTagCostCentre varchar(3)
      , @trgTagRunDate varchar(8)
      , @trgTagRunYr int
      , @trgTagRunPr int
      , @trgSalesMode bit
      , @trgLastInv int
      , @trgSRCPIRef varchar(10)
      , @trgLastTagRunNo int
      , @trgTagCtrlCode int
      , @trgUseAcCC bit
      , @trgSetCQatP bit
      , @trgIncSDisc bit
      , @trgSDDaysOver int
      , @trgShowLog bit
      , @trgUseOsNdx bit
      , @trgBACSCLIUCount int
      , @trgYourRef varchar(20)
      , @trgTagRunNo varbinary(3)
      , @trgBankNom int
      , @trgBankCr int
      , @trgReconOpo varchar(10)
      , @trgEntryTotDr float
      , @trgEntryTotCr float
      , @trgEntryDate varchar(8)
      , @trgNomEntTyp varchar(1)
      , @trgAllMatchOk bit
      , @trgMatchCount int
      , @trgMatchOBal float
      , @trgManTotDr float
      , @trgManTotCr float
      , @trgManRunNo int
      , @trgManChange bit
      , @trgManCount int
      , @trgAllocSF varbinary(5)
      , @trgCCDesc varbinary(19)
      , @trgCCTag bit
      , @trgLastAccess varchar(8)
      , @trgNLineCount int
      , @trgHideAC int
      , @trgMoveCodeNom varbinary(3)
      , @trgMoveFromNom int
      , @trgMoveToNom int
      , @trgMoveTypeNom varchar(1)
      , @trgMoveCodeStk varbinary(16)
      , @trgMoveFromStk varchar(16)
      , @trgMoveToStk varchar(16)
      , @trgNewStkCode varchar(16)
      , @trgStuff varbinary(205)
      , @trgOpoName varbinary(10)
      , @trgStartDate varchar(8)
      , @trgStartTime varchar(6)
      , @trgWinLogName varchar(50)
      , @trgWinCPUName varchar(50)
      , @trgBACSULIUCount int
      , @trgSCodeOld varbinary(13)
      , @trgSCodeNew varchar(20)
      , @trgMoveStage int
      , @trgOldNCode int
      , @trgNewNCode int
      , @trgNTypOld varchar(1)
      , @trgNTypNew varchar(1)
      , @trgMoveKey1 varchar(50)
      , @trgMoveKey2 varchar(50)
      , @trgWasMode int
      , @trgSGrpNew varchar(20)
      , @trgSUser varchar(10)
      , @trgFinStage bit
      , @trgProgCounter int
      , @trgMIsCust bit
      , @trgMListRecAddr int
      , @trgPositionId int

DECLARE srcExchqChk CURSOR FOR SELECT RecPfix
                                    , SubType
                                    , EXCHQCHKcode1
                                    , EXCHQCHKcode2
                                    , EXCHQCHKcode3
                                    , Access
                                    , LastPno
                                    , PassDesc
                                    , PassPage
                                    , PassLNo
                                    , NoteFolio
                                    , NType
                                    , Spare1
                                    , LineNumber
                                    , NoteLine
                                    , NoteUser
                                    , TmpImpCode
                                    , ShowDate
                                    , RepeatNo
                                    , NoteFor
                                    , SettledVal
                                    , OwnCVal
                                    , MCurrency
                                    , MatchType
                                    , OldAltRef
                                    , RCurrency
                                    , RecOwnCVal
                                    , AltRef
                                    , QtyUsed
                                    , QtyCost
                                    , QCurrency
                                    , FullStkCode
                                    , FreeIssue
                                    , QtyTime
                                    , BACSTagRunNo
                                    , PayType
                                    , BACSBankNom
                                    , PayCurr
                                    , InvCurr
                                    , CQStart
                                    , AgeType
                                    , AgeInt
                                    , TagStatus
                                    , TotalTag0
                                    , TotalTag1
                                    , TotalTag2
                                    , TotalTag3
                                    , TotalTag4
                                    , TagAsDate
                                    , TagCount
                                    , TagDepartment
                                    , TagCostCentre
                                    , TagRunDate
                                    , TagRunYr
                                    , TagRunPr
                                    , SalesMode
                                    , LastInv
                                    , SRCPIRef
                                    , LastTagRunNo
                                    , TagCtrlCode
                                    , UseAcCC
                                    , SetCQatP
                                    , IncSDisc
                                    , SDDaysOver
                                    , ShowLog
                                    , UseOsNdx
                                    , BACSCLIUCount
                                    , YourRef
                                    , TagRunNo
                                    , BankNom
                                    , BankCr
                                    , ReconOpo
                                    , EntryTotDr
                                    , EntryTotCr
                                    , EntryDate
                                    , NomEntTyp
                                    , AllMatchOk
                                    , MatchCount
                                    , MatchOBal
                                    , ManTotDr
                                    , ManTotCr
                                    , ManRunNo
                                    , ManChange
                                    , ManCount
                                    , AllocSF
                                    , CCDesc
                                    , CCTag
                                    , LastAccess
                                    , NLineCount
                                    , HideAC
                                    , MoveCodeNom
                                    , MoveFromNom
                                    , MoveToNom
                                    , MoveTypeNom
                                    , MoveCodeStk
                                    , MoveFromStk
                                    , MoveToStk
                                    , NewStkCode
                                    , Stuff
                                    , OpoName
                                    , StartDate
                                    , StartTime
                                    , WinLogName
                                    , WinCPUName
                                    , BACSULIUCount
                                    , SCodeOld
                                    , SCodeNew
                                    , MoveStage
                                    , OldNCode
                                    , NewNCode
                                    , NTypOld
                                    , NTypNew
                                    , MoveKey1
                                    , MoveKey2
                                    , WasMode
                                    , SGrpNew
                                    , SUser
                                    , FinStage
                                    , ProgCounter
                                    , MIsCust
                                    , MListRecAddr
                                    , PositionId 
                               FROM   ConvMasterPR70.MAIN01.ExchqChk

OPEN srcExchqChk

FETCH NEXT FROM srcExchqChk INTO @srcRecPfix
                               , @srcSubType
                               , @srcEXCHQCHKcode1
                               , @srcEXCHQCHKcode2
                               , @srcEXCHQCHKcode3
                               , @srcAccess
                               , @srcLastPno
                               , @srcPassDesc
                               , @srcPassPage
                               , @srcPassLNo
                               , @srcNoteFolio
                               , @srcNType
                               , @srcSpare1
                               , @srcLineNumber
                               , @srcNoteLine
                               , @srcNoteUser
                               , @srcTmpImpCode
                               , @srcShowDate
                               , @srcRepeatNo
                               , @srcNoteFor
                               , @srcSettledVal
                               , @srcOwnCVal
                               , @srcMCurrency
                               , @srcMatchType
                               , @srcOldAltRef
                               , @srcRCurrency
                               , @srcRecOwnCVal
                               , @srcAltRef
                               , @srcQtyUsed
                               , @srcQtyCost
                               , @srcQCurrency
                               , @srcFullStkCode
                               , @srcFreeIssue
                               , @srcQtyTime
                               , @srcBACSTagRunNo
                               , @srcPayType
                               , @srcBACSBankNom
                               , @srcPayCurr
                               , @srcInvCurr
                               , @srcCQStart
                               , @srcAgeType
                               , @srcAgeInt
                               , @srcTagStatus
                               , @srcTotalTag0
                               , @srcTotalTag1
                               , @srcTotalTag2
                               , @srcTotalTag3
                               , @srcTotalTag4
                               , @srcTagAsDate
                               , @srcTagCount
                               , @srcTagDepartment
                               , @srcTagCostCentre
                               , @srcTagRunDate
                               , @srcTagRunYr
                               , @srcTagRunPr
                               , @srcSalesMode
                               , @srcLastInv
                               , @srcSRCPIRef
                               , @srcLastTagRunNo
                               , @srcTagCtrlCode
                               , @srcUseAcCC
                               , @srcSetCQatP
                               , @srcIncSDisc
                               , @srcSDDaysOver
                               , @srcShowLog
                               , @srcUseOsNdx
                               , @srcBACSCLIUCount
                               , @srcYourRef
                               , @srcTagRunNo
                               , @srcBankNom
                               , @srcBankCr
                               , @srcReconOpo
                               , @srcEntryTotDr
                               , @srcEntryTotCr
                               , @srcEntryDate
                               , @srcNomEntTyp
                               , @srcAllMatchOk
                               , @srcMatchCount
                               , @srcMatchOBal
                               , @srcManTotDr
                               , @srcManTotCr
                               , @srcManRunNo
                               , @srcManChange
                               , @srcManCount
                               , @srcAllocSF
                               , @srcCCDesc
                               , @srcCCTag
                               , @srcLastAccess
                               , @srcNLineCount
                               , @srcHideAC
                               , @srcMoveCodeNom
                               , @srcMoveFromNom
                               , @srcMoveToNom
                               , @srcMoveTypeNom
                               , @srcMoveCodeStk
                               , @srcMoveFromStk
                               , @srcMoveToStk
                               , @srcNewStkCode
                               , @srcStuff
                               , @srcOpoName
                               , @srcStartDate
                               , @srcStartTime
                               , @srcWinLogName
                               , @srcWinCPUName
                               , @srcBACSULIUCount
                               , @srcSCodeOld
                               , @srcSCodeNew
                               , @srcMoveStage
                               , @srcOldNCode
                               , @srcNewNCode
                               , @srcNTypOld
                               , @srcNTypNew
                               , @srcMoveKey1
                               , @srcMoveKey2
                               , @srcWasMode
                               , @srcSGrpNew
                               , @srcSUser
                               , @srcFinStage
                               , @srcProgCounter
                               , @srcMIsCust
                               , @srcMListRecAddr
                               , @srcPositionId

WHILE @@FETCH_STATUS = 0
BEGIN
  -- Get Target Columns for same row
  SELECT @trgSubType = SubType
       , @trgEXCHQCHKcode1 = EXCHQCHKcode1
       , @trgEXCHQCHKcode2 = EXCHQCHKcode2
       , @trgEXCHQCHKcode3 = EXCHQCHKcode3
       , @trgAccess = Access
       , @trgLastPno = LastPno
       , @trgPassDesc = PassDesc
       , @trgPassPage = PassPage
       , @trgPassLNo = PassLNo
       , @trgNoteFolio = NoteFolio
       , @trgNType = NType
       , @trgSpare1 = Spare1
       , @trgLineNumber = LineNumber
       , @trgNoteLine = NoteLine
       , @trgNoteUser = NoteUser
       , @trgTmpImpCode = TmpImpCode
       , @trgShowDate = ShowDate
       , @trgRepeatNo = RepeatNo
       , @trgNoteFor = NoteFor
       , @trgSettledVal = SettledVal
       , @trgOwnCVal = OwnCVal
       , @trgMCurrency = MCurrency
       , @trgMatchType = MatchType
       , @trgOldAltRef = OldAltRef
       , @trgRCurrency = RCurrency
       , @trgRecOwnCVal = RecOwnCVal
       , @trgAltRef = AltRef
       , @trgQtyUsed = QtyUsed
       , @trgQtyCost = QtyCost
       , @trgQCurrency = QCurrency
       , @trgFullStkCode = FullStkCode
       , @trgFreeIssue = FreeIssue
       , @trgQtyTime = QtyTime
       , @trgBACSTagRunNo = BACSTagRunNo
       , @trgPayType = PayType
       , @trgBACSBankNom = BACSBankNom
       , @trgPayCurr = PayCurr
       , @trgInvCurr = InvCurr
       , @trgCQStart = CQStart
       , @trgAgeType = AgeType
       , @trgAgeInt = AgeInt
       , @trgTagStatus = TagStatus
       , @trgTotalTag0 = TotalTag0
       , @trgTotalTag1 = TotalTag1
       , @trgTotalTag2 = TotalTag2
       , @trgTotalTag3 = TotalTag3
       , @trgTotalTag4 = TotalTag4
       , @trgTagAsDate = TagAsDate
       , @trgTagCount = TagCount
       , @trgTagDepartment = TagDepartment
       , @trgTagCostCentre = TagCostCentre
       , @trgTagRunDate = TagRunDate
       , @trgTagRunYr = TagRunYr
       , @trgTagRunPr = TagRunPr
       , @trgSalesMode = SalesMode
       , @trgLastInv = LastInv
       , @trgSRCPIRef = SRCPIRef
       , @trgLastTagRunNo = LastTagRunNo
       , @trgTagCtrlCode = TagCtrlCode
       , @trgUseAcCC = UseAcCC
       , @trgSetCQatP = SetCQatP
       , @trgIncSDisc = IncSDisc
       , @trgSDDaysOver = SDDaysOver
       , @trgShowLog = ShowLog
       , @trgUseOsNdx = UseOsNdx
       , @trgBACSCLIUCount = BACSCLIUCount
       , @trgYourRef = YourRef
       , @trgTagRunNo = TagRunNo
       , @trgBankNom = BankNom
       , @trgBankCr = BankCr
       , @trgReconOpo = ReconOpo
       , @trgEntryTotDr = EntryTotDr
       , @trgEntryTotCr = EntryTotCr
       , @trgEntryDate = EntryDate
       , @trgNomEntTyp = NomEntTyp
       , @trgAllMatchOk = AllMatchOk
       , @trgMatchCount = MatchCount
       , @trgMatchOBal = MatchOBal
       , @trgManTotDr = ManTotDr
       , @trgManTotCr = ManTotCr
       , @trgManRunNo = ManRunNo
       , @trgManChange = ManChange
       , @trgManCount = ManCount
       , @trgAllocSF = AllocSF
       , @trgCCDesc = CCDesc
       , @trgCCTag = CCTag
       , @trgLastAccess = LastAccess
       , @trgNLineCount = NLineCount
       , @trgHideAC = HideAC
       , @trgMoveCodeNom = MoveCodeNom
       , @trgMoveFromNom = MoveFromNom
       , @trgMoveToNom = MoveToNom
       , @trgMoveTypeNom = MoveTypeNom
       , @trgMoveCodeStk = MoveCodeStk
       , @trgMoveFromStk = MoveFromStk
       , @trgMoveToStk = MoveToStk
       , @trgNewStkCode = NewStkCode
       , @trgStuff = Stuff
       , @trgOpoName = OpoName
       , @trgStartDate = StartDate
       , @trgStartTime = StartTime
       , @trgWinLogName = WinLogName
       , @trgWinCPUName = WinCPUName
       , @trgBACSULIUCount = BACSULIUCount
       , @trgSCodeOld = SCodeOld
       , @trgSCodeNew = SCodeNew
       , @trgMoveStage = MoveStage
       , @trgOldNCode = OldNCode
       , @trgNewNCode = NewNCode
       , @trgNTypOld = NTypOld
       , @trgNTypNew = NTypNew
       , @trgMoveKey1 = MoveKey1
       , @trgMoveKey2 = MoveKey2
       , @trgWasMode = WasMode
       , @trgSGrpNew = SGrpNew
       , @trgSUser = SUser
       , @trgFinStage = FinStage
       , @trgProgCounter = ProgCounter
       , @trgMIsCust = MIsCust
       , @trgMListRecAddr = MListRecAddr
       , @trgPositionId = PositionId
  FROM Exch70Conv.MAIN01.ExchqChk
  WHERE RecPFix = @srcRecPfix
    AND SubType = @srcSubType
    AND EXCHQCHKcode1 = @srcEXCHQCHKcode1
    AND EXCHQCHKcode2 = @srcEXCHQCHKcode2  -- Added check on this to reduce the number of problems because of duplicate values - specifically in Customer Notes

  -- Compare columns
  --IF (@srcSubType <> @trgSubType) Or ((@srcSubType IS NULL) And (@trgSubType IS NOT NULL)) Or ((@srcSubType IS NOT NULL) And (@trgSubType IS NULL))
  --BEGIN
  --  PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SubType = ' + STR(@srcSubType) + ' / ' + STR(@trgSubType)
  --END
  
  IF (@srcEXCHQCHKcode1 <> @trgEXCHQCHKcode1) Or ((@srcEXCHQCHKcode1 IS NULL) And (@trgEXCHQCHKcode1 IS NOT NULL)) Or ((@srcEXCHQCHKcode1 IS NOT NULL) And (@trgEXCHQCHKcode1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EXCHQCHKcode1 is different'
  END
  ELSE IF (@srcEXCHQCHKcode2 <> @trgEXCHQCHKcode2) Or ((@srcEXCHQCHKcode2 IS NULL) And (@trgEXCHQCHKcode2 IS NOT NULL)) Or ((@srcEXCHQCHKcode2 IS NOT NULL) And (@trgEXCHQCHKcode2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EXCHQCHKcode2 is different ' + Str(@srcPositionId) + '/' + Str(@trgPositionId)
  END
  ELSE IF (@srcEXCHQCHKcode3 <> @trgEXCHQCHKcode3) Or ((@srcEXCHQCHKcode3 IS NULL) And (@trgEXCHQCHKcode3 IS NOT NULL)) Or ((@srcEXCHQCHKcode3 IS NOT NULL) And (@trgEXCHQCHKcode3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EXCHQCHKcode3 is different'
  END
  ELSE IF (@srcAccess <> @trgAccess) Or ((@srcAccess IS NULL) And (@trgAccess IS NOT NULL)) Or ((@srcAccess IS NOT NULL) And (@trgAccess IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.Access is different'
  END
  ELSE IF (@srcLastPno <> @trgLastPno) Or ((@srcLastPno IS NULL) And (@trgLastPno IS NOT NULL)) Or ((@srcLastPno IS NOT NULL) And (@trgLastPno IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.LastPno = ' + STR(@srcLastPno) + ' / ' + STR(@trgLastPno)
  END
  ELSE IF (@srcPassDesc <> @trgPassDesc) Or ((@srcPassDesc IS NULL) And (@trgPassDesc IS NOT NULL)) Or ((@srcPassDesc IS NOT NULL) And (@trgPassDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.PassDesc is different'
  END
  ELSE IF (@srcPassPage <> @trgPassPage) Or ((@srcPassPage IS NULL) And (@trgPassPage IS NOT NULL)) Or ((@srcPassPage IS NOT NULL) And (@trgPassPage IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.PassPage = ' + STR(@srcPassPage) + ' / ' + STR(@trgPassPage)
  END
  ELSE IF (@srcPassLNo <> @trgPassLNo) Or ((@srcPassLNo IS NULL) And (@trgPassLNo IS NOT NULL)) Or ((@srcPassLNo IS NOT NULL) And (@trgPassLNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.PassLNo = ' + STR(@srcPassLNo) + ' / ' + STR(@trgPassLNo)
  END
  ELSE IF (@srcNoteFolio <> @trgNoteFolio) Or ((@srcNoteFolio IS NULL) And (@trgNoteFolio IS NOT NULL)) Or ((@srcNoteFolio IS NOT NULL) And (@trgNoteFolio IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NoteFolio is different'
  END
  ELSE IF (@srcNType <> @trgNType) Or ((@srcNType IS NULL) And (@trgNType IS NOT NULL)) Or ((@srcNType IS NOT NULL) And (@trgNType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NType = ' + @srcNType + ' / ' + @trgNType
  END
  ELSE IF (@srcSpare1 <> @trgSpare1) Or ((@srcSpare1 IS NULL) And (@trgSpare1 IS NOT NULL)) Or ((@srcSpare1 IS NOT NULL) And (@trgSpare1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.Spare1 is different'
  END
  ELSE IF (@srcLineNumber <> @trgLineNumber) Or ((@srcLineNumber IS NULL) And (@trgLineNumber IS NOT NULL)) Or ((@srcLineNumber IS NOT NULL) And (@trgLineNumber IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.LineNumber = ' + STR(@srcLineNumber) + ' / ' + STR(@trgLineNumber)
  END
  ELSE IF (@srcNoteLine <> @trgNoteLine) Or ((@srcNoteLine IS NULL) And (@trgNoteLine IS NOT NULL)) Or ((@srcNoteLine IS NOT NULL) And (@trgNoteLine IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NoteLine = ' + @srcNoteLine + ' / ' + @trgNoteLine
  END
  ELSE IF (@srcNoteUser <> @trgNoteUser) Or ((@srcNoteUser IS NULL) And (@trgNoteUser IS NOT NULL)) Or ((@srcNoteUser IS NOT NULL) And (@trgNoteUser IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NoteUser = ' + @srcNoteUser + ' / ' + @trgNoteUser
  END
  ELSE IF (@srcTmpImpCode <> @trgTmpImpCode) Or ((@srcTmpImpCode IS NULL) And (@trgTmpImpCode IS NOT NULL)) Or ((@srcTmpImpCode IS NOT NULL) And (@trgTmpImpCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TmpImpCode = ' + @srcTmpImpCode + ' / ' + @trgTmpImpCode
  END
  ELSE IF (@srcShowDate <> @trgShowDate) Or ((@srcShowDate IS NULL) And (@trgShowDate IS NOT NULL)) Or ((@srcShowDate IS NOT NULL) And (@trgShowDate IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ShowDate = ' + STR(@srcShowDate) + ' / ' + STR(@trgShowDate)
  END
  ELSE IF (@srcRepeatNo <> @trgRepeatNo) Or ((@srcRepeatNo IS NULL) And (@trgRepeatNo IS NOT NULL)) Or ((@srcRepeatNo IS NOT NULL) And (@trgRepeatNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.RepeatNo = ' + STR(@srcRepeatNo) + ' / ' + STR(@trgRepeatNo)
  END
  ELSE IF (@srcNoteFor <> @trgNoteFor) Or ((@srcNoteFor IS NULL) And (@trgNoteFor IS NOT NULL)) Or ((@srcNoteFor IS NOT NULL) And (@trgNoteFor IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NoteFor = ' + @srcNoteFor + ' / ' + @trgNoteFor
  END
  ELSE IF (@srcSettledVal <> @trgSettledVal) Or ((@srcSettledVal IS NULL) And (@trgSettledVal IS NOT NULL)) Or ((@srcSettledVal IS NOT NULL) And (@trgSettledVal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SettledVal is different'
  END
  ELSE IF (@srcOwnCVal <> @trgOwnCVal) Or ((@srcOwnCVal IS NULL) And (@trgOwnCVal IS NOT NULL)) Or ((@srcOwnCVal IS NOT NULL) And (@trgOwnCVal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.OwnCVal = ' + @srcOwnCVal + ' / ' + @trgOwnCVal
  END
  ELSE IF (@srcMCurrency <> @trgMCurrency) Or ((@srcMCurrency IS NULL) And (@trgMCurrency IS NOT NULL)) Or ((@srcMCurrency IS NOT NULL) And (@trgMCurrency IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MCurrency = ' + STR(@srcMCurrency) + ' / ' + STR(@trgMCurrency)
  END
  ELSE IF (@srcMatchType <> @trgMatchType) Or ((@srcMatchType IS NULL) And (@trgMatchType IS NOT NULL)) Or ((@srcMatchType IS NOT NULL) And (@trgMatchType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MatchType = ' + @srcMatchType + ' / ' + @trgMatchType
  END
  ELSE IF (@srcOldAltRef <> @trgOldAltRef) Or ((@srcOldAltRef IS NULL) And (@trgOldAltRef IS NOT NULL)) Or ((@srcOldAltRef IS NOT NULL) And (@trgOldAltRef IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.OldAltRef = ' + @srcOldAltRef + ' / ' + @trgOldAltRef
  END
  ELSE IF (@srcRCurrency <> @trgRCurrency) Or ((@srcRCurrency IS NULL) And (@trgRCurrency IS NOT NULL)) Or ((@srcRCurrency IS NOT NULL) And (@trgRCurrency IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.RCurrency = ' + STR(@srcRCurrency) + ' / ' + STR(@trgRCurrency)
  END
  ELSE IF (@srcRecOwnCVal <> @trgRecOwnCVal) Or ((@srcRecOwnCVal IS NULL) And (@trgRecOwnCVal IS NOT NULL)) Or ((@srcRecOwnCVal IS NOT NULL) And (@trgRecOwnCVal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.RecOwnCVal = ' + @srcRecOwnCVal + ' / ' + @trgRecOwnCVal
  END
  ELSE IF (@srcAltRef <> @trgAltRef) Or ((@srcAltRef IS NULL) And (@trgAltRef IS NOT NULL)) Or ((@srcAltRef IS NOT NULL) And (@trgAltRef IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.AltRef = ' + @srcAltRef + ' / ' + @trgAltRef
  END
  ELSE IF (@srcQtyUsed <> @trgQtyUsed) Or ((@srcQtyUsed IS NULL) And (@trgQtyUsed IS NOT NULL)) Or ((@srcQtyUsed IS NOT NULL) And (@trgQtyUsed IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.QtyUsed is different'
  END
  ELSE IF (@srcQtyCost <> @trgQtyCost) Or ((@srcQtyCost IS NULL) And (@trgQtyCost IS NOT NULL)) Or ((@srcQtyCost IS NOT NULL) And (@trgQtyCost IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.QtyCost = ' + @srcQtyCost + ' / ' + @trgQtyCost
  END
  ELSE IF (@srcQCurrency <> @trgQCurrency) Or ((@srcQCurrency IS NULL) And (@trgQCurrency IS NOT NULL)) Or ((@srcQCurrency IS NOT NULL) And (@trgQCurrency IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.QCurrency = ' + STR(@srcQCurrency) + ' / ' + STR(@trgQCurrency)
  END
  ELSE IF (@srcFullStkCode <> @trgFullStkCode) Or ((@srcFullStkCode IS NULL) And (@trgFullStkCode IS NOT NULL)) Or ((@srcFullStkCode IS NOT NULL) And (@trgFullStkCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.FullStkCode = ' + @srcFullStkCode + ' / ' + @trgFullStkCode
  END
  ELSE IF (@srcFreeIssue <> @trgFreeIssue) Or ((@srcFreeIssue IS NULL) And (@trgFreeIssue IS NOT NULL)) Or ((@srcFreeIssue IS NOT NULL) And (@trgFreeIssue IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.FreeIssue = ' + STR(@srcFreeIssue) + ' / ' + STR(@trgFreeIssue)
  END
  ELSE IF (@srcQtyTime <> @trgQtyTime) Or ((@srcQtyTime IS NULL) And (@trgQtyTime IS NOT NULL)) Or ((@srcQtyTime IS NOT NULL) And (@trgQtyTime IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.QtyTime = ' + STR(@srcQtyTime) + ' / ' + STR(@trgQtyTime)
  END
  ELSE IF (@srcBACSTagRunNo <> @trgBACSTagRunNo) Or ((@srcBACSTagRunNo IS NULL) And (@trgBACSTagRunNo IS NOT NULL)) Or ((@srcBACSTagRunNo IS NOT NULL) And (@trgBACSTagRunNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BACSTagRunNo is different'
  END
  ELSE IF (@srcPayType <> @trgPayType) Or ((@srcPayType IS NULL) And (@trgPayType IS NOT NULL)) Or ((@srcPayType IS NOT NULL) And (@trgPayType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.PayType = ' + @srcPayType + ' / ' + @trgPayType
  END
  ELSE IF (@srcBACSBankNom <> @trgBACSBankNom) Or ((@srcBACSBankNom IS NULL) And (@trgBACSBankNom IS NOT NULL)) Or ((@srcBACSBankNom IS NOT NULL) And (@trgBACSBankNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BACSBankNom = ' + STR(@srcBACSBankNom) + ' / ' + STR(@trgBACSBankNom)
  END
  ELSE IF (@srcPayCurr <> @trgPayCurr) Or ((@srcPayCurr IS NULL) And (@trgPayCurr IS NOT NULL)) Or ((@srcPayCurr IS NOT NULL) And (@trgPayCurr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.PayCurr = ' + STR(@srcPayCurr) + ' / ' + STR(@trgPayCurr)
  END
  ELSE IF (@srcInvCurr <> @trgInvCurr) Or ((@srcInvCurr IS NULL) And (@trgInvCurr IS NOT NULL)) Or ((@srcInvCurr IS NOT NULL) And (@trgInvCurr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.InvCurr = ' + STR(@srcInvCurr) + ' / ' + STR(@trgInvCurr)
  END
  ELSE IF (@srcCQStart <> @trgCQStart) Or ((@srcCQStart IS NULL) And (@trgCQStart IS NOT NULL)) Or ((@srcCQStart IS NOT NULL) And (@trgCQStart IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.CQStart = ' + STR(@srcCQStart) + ' / ' + STR(@trgCQStart)
  END
  ELSE IF (@srcAgeType <> @trgAgeType) Or ((@srcAgeType IS NULL) And (@trgAgeType IS NOT NULL)) Or ((@srcAgeType IS NOT NULL) And (@trgAgeType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.AgeType = ' + STR(@srcAgeType) + ' / ' + STR(@trgAgeType)
  END
  ELSE IF (@srcAgeInt <> @trgAgeInt) Or ((@srcAgeInt IS NULL) And (@trgAgeInt IS NOT NULL)) Or ((@srcAgeInt IS NOT NULL) And (@trgAgeInt IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.AgeInt = ' + STR(@srcAgeInt) + ' / ' + STR(@trgAgeInt)
  END
  ELSE IF (@srcTagStatus <> @trgTagStatus) Or ((@srcTagStatus IS NULL) And (@trgTagStatus IS NOT NULL)) Or ((@srcTagStatus IS NOT NULL) And (@trgTagStatus IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagStatus = ' + STR(@srcTagStatus) + ' / ' + STR(@trgTagStatus)
  END
  ELSE IF (@srcTotalTag0 <> @trgTotalTag0) Or ((@srcTotalTag0 IS NULL) And (@trgTotalTag0 IS NOT NULL)) Or ((@srcTotalTag0 IS NOT NULL) And (@trgTotalTag0 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TotalTag0 = ' + @srcTotalTag0 + ' / ' + @trgTotalTag0
  END
  ELSE IF (@srcTotalTag1 <> @trgTotalTag1) Or ((@srcTotalTag1 IS NULL) And (@trgTotalTag1 IS NOT NULL)) Or ((@srcTotalTag1 IS NOT NULL) And (@trgTotalTag1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TotalTag1 = ' + @srcTotalTag1 + ' / ' + @trgTotalTag1
  END
  ELSE IF (@srcTotalTag2 <> @trgTotalTag2) Or ((@srcTotalTag2 IS NULL) And (@trgTotalTag2 IS NOT NULL)) Or ((@srcTotalTag2 IS NOT NULL) And (@trgTotalTag2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TotalTag2 = ' + @srcTotalTag2 + ' / ' + @trgTotalTag2
  END
  ELSE IF (@srcTotalTag3 <> @trgTotalTag3) Or ((@srcTotalTag3 IS NULL) And (@trgTotalTag3 IS NOT NULL)) Or ((@srcTotalTag3 IS NOT NULL) And (@trgTotalTag3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TotalTag3 = ' + @srcTotalTag3 + ' / ' + @trgTotalTag3
  END
  ELSE IF (@srcTotalTag4 <> @trgTotalTag4) Or ((@srcTotalTag4 IS NULL) And (@trgTotalTag4 IS NOT NULL)) Or ((@srcTotalTag4 IS NOT NULL) And (@trgTotalTag4 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TotalTag4 = ' + @srcTotalTag4 + ' / ' + @trgTotalTag4
  END
  ELSE IF (@srcTagAsDate <> @trgTagAsDate) Or ((@srcTagAsDate IS NULL) And (@trgTagAsDate IS NOT NULL)) Or ((@srcTagAsDate IS NOT NULL) And (@trgTagAsDate IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagAsDate = ' + @srcTagAsDate + ' / ' + @trgTagAsDate
  END
  ELSE IF (@srcTagCount <> @trgTagCount) Or ((@srcTagCount IS NULL) And (@trgTagCount IS NOT NULL)) Or ((@srcTagCount IS NOT NULL) And (@trgTagCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagCount = ' + STR(@srcTagCount) + ' / ' + STR(@trgTagCount)
  END
  ELSE IF (@srcTagDepartment <> @trgTagDepartment) Or ((@srcTagDepartment IS NULL) And (@trgTagDepartment IS NOT NULL)) Or ((@srcTagDepartment IS NOT NULL) And (@trgTagDepartment IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagDepartment = ' + @srcTagDepartment + ' / ' + @trgTagDepartment
  END
  ELSE IF (@srcTagCostCentre <> @trgTagCostCentre) Or ((@srcTagCostCentre IS NULL) And (@trgTagCostCentre IS NOT NULL)) Or ((@srcTagCostCentre IS NOT NULL) And (@trgTagCostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagCostCentre = ' + @srcTagCostCentre + ' / ' + @trgTagCostCentre
  END
  ELSE IF (@srcTagRunDate <> @trgTagRunDate) Or ((@srcTagRunDate IS NULL) And (@trgTagRunDate IS NOT NULL)) Or ((@srcTagRunDate IS NOT NULL) And (@trgTagRunDate IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagRunDate = ' + @srcTagRunDate + ' / ' + @trgTagRunDate
  END
  ELSE IF (@srcTagRunYr <> @trgTagRunYr) Or ((@srcTagRunYr IS NULL) And (@trgTagRunYr IS NOT NULL)) Or ((@srcTagRunYr IS NOT NULL) And (@trgTagRunYr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagRunYr = ' + STR(@srcTagRunYr) + ' / ' + STR(@trgTagRunYr)
  END
  ELSE IF (@srcTagRunPr <> @trgTagRunPr) Or ((@srcTagRunPr IS NULL) And (@trgTagRunPr IS NOT NULL)) Or ((@srcTagRunPr IS NOT NULL) And (@trgTagRunPr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagRunPr = ' + STR(@srcTagRunPr) + ' / ' + STR(@trgTagRunPr)
  END
  ELSE IF (@srcSalesMode <> @trgSalesMode) Or ((@srcSalesMode IS NULL) And (@trgSalesMode IS NOT NULL)) Or ((@srcSalesMode IS NOT NULL) And (@trgSalesMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SalesMode = ' + STR(@srcSalesMode) + ' / ' + STR(@trgSalesMode)
  END
  ELSE IF (@srcLastInv <> @trgLastInv) Or ((@srcLastInv IS NULL) And (@trgLastInv IS NOT NULL)) Or ((@srcLastInv IS NOT NULL) And (@trgLastInv IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.LastInv = ' + STR(@srcLastInv) + ' / ' + STR(@trgLastInv)
  END
  ELSE IF (@srcSRCPIRef <> @trgSRCPIRef) Or ((@srcSRCPIRef IS NULL) And (@trgSRCPIRef IS NOT NULL)) Or ((@srcSRCPIRef IS NOT NULL) And (@trgSRCPIRef IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SRCPIRef = ' + @srcSRCPIRef + ' / ' + @trgSRCPIRef
  END
  ELSE IF (@srcLastTagRunNo <> @trgLastTagRunNo) Or ((@srcLastTagRunNo IS NULL) And (@trgLastTagRunNo IS NOT NULL)) Or ((@srcLastTagRunNo IS NOT NULL) And (@trgLastTagRunNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.LastTagRunNo = ' + STR(@srcLastTagRunNo) + ' / ' + STR(@trgLastTagRunNo)
  END
  ELSE IF (@srcTagCtrlCode <> @trgTagCtrlCode) Or ((@srcTagCtrlCode IS NULL) And (@trgTagCtrlCode IS NOT NULL)) Or ((@srcTagCtrlCode IS NOT NULL) And (@trgTagCtrlCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagCtrlCode = ' + STR(@srcTagCtrlCode) + ' / ' + STR(@trgTagCtrlCode)
  END
  ELSE IF (@srcUseAcCC <> @trgUseAcCC) Or ((@srcUseAcCC IS NULL) And (@trgUseAcCC IS NOT NULL)) Or ((@srcUseAcCC IS NOT NULL) And (@trgUseAcCC IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.UseAcCC = ' + STR(@srcUseAcCC) + ' / ' + STR(@trgUseAcCC)
  END
  ELSE IF (@srcSetCQatP <> @trgSetCQatP) Or ((@srcSetCQatP IS NULL) And (@trgSetCQatP IS NOT NULL)) Or ((@srcSetCQatP IS NOT NULL) And (@trgSetCQatP IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SetCQatP = ' + STR(@srcSetCQatP) + ' / ' + STR(@trgSetCQatP)
  END
  ELSE IF (@srcIncSDisc <> @trgIncSDisc) Or ((@srcIncSDisc IS NULL) And (@trgIncSDisc IS NOT NULL)) Or ((@srcIncSDisc IS NOT NULL) And (@trgIncSDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.IncSDisc = ' + STR(@srcIncSDisc) + ' / ' + STR(@trgIncSDisc)
  END
  ELSE IF (@srcSDDaysOver <> @trgSDDaysOver) Or ((@srcSDDaysOver IS NULL) And (@trgSDDaysOver IS NOT NULL)) Or ((@srcSDDaysOver IS NOT NULL) And (@trgSDDaysOver IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SDDaysOver = ' + STR(@srcSDDaysOver) + ' / ' + STR(@trgSDDaysOver)
  END
  ELSE IF (@srcShowLog <> @trgShowLog) Or ((@srcShowLog IS NULL) And (@trgShowLog IS NOT NULL)) Or ((@srcShowLog IS NOT NULL) And (@trgShowLog IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ShowLog = ' + STR(@srcShowLog) + ' / ' + STR(@trgShowLog)
  END
  ELSE IF (@srcUseOsNdx <> @trgUseOsNdx) Or ((@srcUseOsNdx IS NULL) And (@trgUseOsNdx IS NOT NULL)) Or ((@srcUseOsNdx IS NOT NULL) And (@trgUseOsNdx IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.UseOsNdx = ' + STR(@srcUseOsNdx) + ' / ' + STR(@trgUseOsNdx)
  END
  ELSE IF (@srcBACSCLIUCount <> @trgBACSCLIUCount) Or ((@srcBACSCLIUCount IS NULL) And (@trgBACSCLIUCount IS NOT NULL)) Or ((@srcBACSCLIUCount IS NOT NULL) And (@trgBACSCLIUCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BACSCLIUCount = ' + STR(@srcBACSCLIUCount) + ' / ' + STR(@trgBACSCLIUCount)
  END
  ELSE IF (@srcYourRef <> @trgYourRef) Or ((@srcYourRef IS NULL) And (@trgYourRef IS NOT NULL)) Or ((@srcYourRef IS NOT NULL) And (@trgYourRef IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.YourRef = ' + @srcYourRef + ' / ' + @trgYourRef
  END
  ELSE IF (@srcTagRunNo <> @trgTagRunNo) Or ((@srcTagRunNo IS NULL) And (@trgTagRunNo IS NOT NULL)) Or ((@srcTagRunNo IS NOT NULL) And (@trgTagRunNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.TagRunNo is different'
  END
  ELSE IF (@srcBankNom <> @trgBankNom) Or ((@srcBankNom IS NULL) And (@trgBankNom IS NOT NULL)) Or ((@srcBankNom IS NOT NULL) And (@trgBankNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BankNom = ' + STR(@srcBankNom) + ' / ' + STR(@trgBankNom)
  END
  ELSE IF (@srcBankCr <> @trgBankCr) Or ((@srcBankCr IS NULL) And (@trgBankCr IS NOT NULL)) Or ((@srcBankCr IS NOT NULL) And (@trgBankCr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BankCr = ' + STR(@srcBankCr) + ' / ' + STR(@trgBankCr)
  END
  ELSE IF (@srcReconOpo <> @trgReconOpo) Or ((@srcReconOpo IS NULL) And (@trgReconOpo IS NOT NULL)) Or ((@srcReconOpo IS NOT NULL) And (@trgReconOpo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ReconOpo = ' + @srcReconOpo + ' / ' + @trgReconOpo
  END
  ELSE IF (@srcEntryTotDr <> @trgEntryTotDr) Or ((@srcEntryTotDr IS NULL) And (@trgEntryTotDr IS NOT NULL)) Or ((@srcEntryTotDr IS NOT NULL) And (@trgEntryTotDr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EntryTotDr = ' + @srcEntryTotDr + ' / ' + @trgEntryTotDr
  END
  ELSE IF (@srcEntryTotCr <> @trgEntryTotCr) Or ((@srcEntryTotCr IS NULL) And (@trgEntryTotCr IS NOT NULL)) Or ((@srcEntryTotCr IS NOT NULL) And (@trgEntryTotCr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EntryTotCr = ' + @srcEntryTotCr + ' / ' + @trgEntryTotCr
  END
  ELSE IF (@srcEntryDate <> @trgEntryDate) Or ((@srcEntryDate IS NULL) And (@trgEntryDate IS NOT NULL)) Or ((@srcEntryDate IS NOT NULL) And (@trgEntryDate IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.EntryDate = ' + @srcEntryDate + ' / ' + @trgEntryDate
  END
  ELSE IF (@srcNomEntTyp <> @trgNomEntTyp) Or ((@srcNomEntTyp IS NULL) And (@trgNomEntTyp IS NOT NULL)) Or ((@srcNomEntTyp IS NOT NULL) And (@trgNomEntTyp IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NomEntTyp = ' + @srcNomEntTyp + ' / ' + @trgNomEntTyp
  END
  ELSE IF (@srcAllMatchOk <> @trgAllMatchOk) Or ((@srcAllMatchOk IS NULL) And (@trgAllMatchOk IS NOT NULL)) Or ((@srcAllMatchOk IS NOT NULL) And (@trgAllMatchOk IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.AllMatchOk = ' + STR(@srcAllMatchOk) + ' / ' + STR(@trgAllMatchOk)
  END
  ELSE IF (@srcMatchCount <> @trgMatchCount) Or ((@srcMatchCount IS NULL) And (@trgMatchCount IS NOT NULL)) Or ((@srcMatchCount IS NOT NULL) And (@trgMatchCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MatchCount = ' + STR(@srcMatchCount) + ' / ' + STR(@trgMatchCount)
  END
  ELSE IF (@srcMatchOBal <> @trgMatchOBal) Or ((@srcMatchOBal IS NULL) And (@trgMatchOBal IS NOT NULL)) Or ((@srcMatchOBal IS NOT NULL) And (@trgMatchOBal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MatchOBal = ' + @srcMatchOBal + ' / ' + @trgMatchOBal
  END
  ELSE IF (@srcManTotDr <> @trgManTotDr) Or ((@srcManTotDr IS NULL) And (@trgManTotDr IS NOT NULL)) Or ((@srcManTotDr IS NOT NULL) And (@trgManTotDr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ManTotDr = ' + @srcManTotDr + ' / ' + @trgManTotDr
  END
  ELSE IF (@srcManTotCr <> @trgManTotCr) Or ((@srcManTotCr IS NULL) And (@trgManTotCr IS NOT NULL)) Or ((@srcManTotCr IS NOT NULL) And (@trgManTotCr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ManTotCr = ' + @srcManTotCr + ' / ' + @trgManTotCr
  END
  ELSE IF (@srcManRunNo <> @trgManRunNo) Or ((@srcManRunNo IS NULL) And (@trgManRunNo IS NOT NULL)) Or ((@srcManRunNo IS NOT NULL) And (@trgManRunNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ManRunNo = ' + STR(@srcManRunNo) + ' / ' + STR(@trgManRunNo)
  END
  ELSE IF (@srcManChange <> @trgManChange) Or ((@srcManChange IS NULL) And (@trgManChange IS NOT NULL)) Or ((@srcManChange IS NOT NULL) And (@trgManChange IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ManChange = ' + STR(@srcManChange) + ' / ' + STR(@trgManChange)
  END
  ELSE IF (@srcManCount <> @trgManCount) Or ((@srcManCount IS NULL) And (@trgManCount IS NOT NULL)) Or ((@srcManCount IS NOT NULL) And (@trgManCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ManCount = ' + STR(@srcManCount) + ' / ' + STR(@trgManCount)
  END
  ELSE IF (@srcAllocSF <> @trgAllocSF) Or ((@srcAllocSF IS NULL) And (@trgAllocSF IS NOT NULL)) Or ((@srcAllocSF IS NOT NULL) And (@trgAllocSF IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.AllocSF is different'
  END
  ELSE IF (@srcCCDesc <> @trgCCDesc) Or ((@srcCCDesc IS NULL) And (@trgCCDesc IS NOT NULL)) Or ((@srcCCDesc IS NOT NULL) And (@trgCCDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.CCDesc is different'
  END
  ELSE IF (@srcCCTag <> @trgCCTag) Or ((@srcCCTag IS NULL) And (@trgCCTag IS NOT NULL)) Or ((@srcCCTag IS NOT NULL) And (@trgCCTag IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.CCTag = ' + STR(@srcCCTag) + ' / ' + STR(@trgCCTag)
  END
  ELSE IF (@srcLastAccess <> @trgLastAccess) Or ((@srcLastAccess IS NULL) And (@trgLastAccess IS NOT NULL)) Or ((@srcLastAccess IS NOT NULL) And (@trgLastAccess IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.LastAccess = ' + @srcLastAccess + ' / ' + @trgLastAccess
  END
  ELSE IF (@srcNLineCount <> @trgNLineCount) Or ((@srcNLineCount IS NULL) And (@trgNLineCount IS NOT NULL)) Or ((@srcNLineCount IS NOT NULL) And (@trgNLineCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NLineCount = ' + STR(@srcNLineCount) + ' / ' + STR(@trgNLineCount)
  END
  ELSE IF (@srcHideAC <> @trgHideAC) Or ((@srcHideAC IS NULL) And (@trgHideAC IS NOT NULL)) Or ((@srcHideAC IS NOT NULL) And (@trgHideAC IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.HideAC = ' + STR(@srcHideAC) + ' / ' + STR(@trgHideAC)
  END
  ELSE IF (@srcMoveCodeNom <> @trgMoveCodeNom) Or ((@srcMoveCodeNom IS NULL) And (@trgMoveCodeNom IS NOT NULL)) Or ((@srcMoveCodeNom IS NOT NULL) And (@trgMoveCodeNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveCodeNom is different'
  END
  ELSE IF (@srcMoveFromNom <> @trgMoveFromNom) Or ((@srcMoveFromNom IS NULL) And (@trgMoveFromNom IS NOT NULL)) Or ((@srcMoveFromNom IS NOT NULL) And (@trgMoveFromNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveFromNom = ' + STR(@srcMoveFromNom) + ' / ' + STR(@trgMoveFromNom)
  END
  ELSE IF (@srcMoveToNom <> @trgMoveToNom) Or ((@srcMoveToNom IS NULL) And (@trgMoveToNom IS NOT NULL)) Or ((@srcMoveToNom IS NOT NULL) And (@trgMoveToNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveToNom = ' + STR(@srcMoveToNom) + ' / ' + STR(@trgMoveToNom)
  END
  ELSE IF (@srcMoveTypeNom <> @trgMoveTypeNom) Or ((@srcMoveTypeNom IS NULL) And (@trgMoveTypeNom IS NOT NULL)) Or ((@srcMoveTypeNom IS NOT NULL) And (@trgMoveTypeNom IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveTypeNom = ' + @srcMoveTypeNom + ' / ' + @trgMoveTypeNom
  END
  ELSE IF (@srcMoveCodeStk <> @trgMoveCodeStk) Or ((@srcMoveCodeStk IS NULL) And (@trgMoveCodeStk IS NOT NULL)) Or ((@srcMoveCodeStk IS NOT NULL) And (@trgMoveCodeStk IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveCodeStk is different'
  END
  ELSE IF (@srcMoveFromStk <> @trgMoveFromStk) Or ((@srcMoveFromStk IS NULL) And (@trgMoveFromStk IS NOT NULL)) Or ((@srcMoveFromStk IS NOT NULL) And (@trgMoveFromStk IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveFromStk = ' + @srcMoveFromStk + ' / ' + @trgMoveFromStk
  END
  ELSE IF (@srcMoveToStk <> @trgMoveToStk) Or ((@srcMoveToStk IS NULL) And (@trgMoveToStk IS NOT NULL)) Or ((@srcMoveToStk IS NOT NULL) And (@trgMoveToStk IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveToStk = ' + @srcMoveToStk + ' / ' + @trgMoveToStk
  END
  ELSE IF (@srcNewStkCode <> @trgNewStkCode) Or ((@srcNewStkCode IS NULL) And (@trgNewStkCode IS NOT NULL)) Or ((@srcNewStkCode IS NOT NULL) And (@trgNewStkCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NewStkCode = ' + @srcNewStkCode + ' / ' + @trgNewStkCode
  END
  ELSE IF (@srcStuff <> @trgStuff) Or ((@srcStuff IS NULL) And (@trgStuff IS NOT NULL)) Or ((@srcStuff IS NOT NULL) And (@trgStuff IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.Stuff is different'
  END
  ELSE IF (@srcOpoName <> @trgOpoName) Or ((@srcOpoName IS NULL) And (@trgOpoName IS NOT NULL)) Or ((@srcOpoName IS NOT NULL) And (@trgOpoName IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.OpoName is different'
  END
  ELSE IF (@srcStartDate <> @trgStartDate) Or ((@srcStartDate IS NULL) And (@trgStartDate IS NOT NULL)) Or ((@srcStartDate IS NOT NULL) And (@trgStartDate IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.StartDate = ' + @srcStartDate + ' / ' + @trgStartDate
  END
  ELSE IF (@srcStartTime <> @trgStartTime) Or ((@srcStartTime IS NULL) And (@trgStartTime IS NOT NULL)) Or ((@srcStartTime IS NOT NULL) And (@trgStartTime IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.StartTime = ' + @srcStartTime + ' / ' + @trgStartTime
  END
  ELSE IF (@srcWinLogName <> @trgWinLogName) Or ((@srcWinLogName IS NULL) And (@trgWinLogName IS NOT NULL)) Or ((@srcWinLogName IS NOT NULL) And (@trgWinLogName IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.WinLogName = ' + @srcWinLogName + ' / ' + @trgWinLogName
  END
  ELSE IF (@srcWinCPUName <> @trgWinCPUName) Or ((@srcWinCPUName IS NULL) And (@trgWinCPUName IS NOT NULL)) Or ((@srcWinCPUName IS NOT NULL) And (@trgWinCPUName IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.WinCPUName = ' + @srcWinCPUName + ' / ' + @trgWinCPUName
  END
  ELSE IF (@srcBACSULIUCount <> @trgBACSULIUCount) Or ((@srcBACSULIUCount IS NULL) And (@trgBACSULIUCount IS NOT NULL)) Or ((@srcBACSULIUCount IS NOT NULL) And (@trgBACSULIUCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.BACSULIUCount = ' + STR(@srcBACSULIUCount) + ' / ' + STR(@trgBACSULIUCount)
  END
  ELSE IF (@srcSCodeOld <> @trgSCodeOld) Or ((@srcSCodeOld IS NULL) And (@trgSCodeOld IS NOT NULL)) Or ((@srcSCodeOld IS NOT NULL) And (@trgSCodeOld IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SCodeOld is different'
  END
  ELSE IF (@srcSCodeNew <> @trgSCodeNew) Or ((@srcSCodeNew IS NULL) And (@trgSCodeNew IS NOT NULL)) Or ((@srcSCodeNew IS NOT NULL) And (@trgSCodeNew IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SCodeNew = ' + @srcSCodeNew + ' / ' + @trgSCodeNew
  END
  ELSE IF (@srcMoveStage <> @trgMoveStage) Or ((@srcMoveStage IS NULL) And (@trgMoveStage IS NOT NULL)) Or ((@srcMoveStage IS NOT NULL) And (@trgMoveStage IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveStage = ' + STR(@srcMoveStage) + ' / ' + STR(@trgMoveStage)
  END
  ELSE IF (@srcOldNCode <> @trgOldNCode) Or ((@srcOldNCode IS NULL) And (@trgOldNCode IS NOT NULL)) Or ((@srcOldNCode IS NOT NULL) And (@trgOldNCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.OldNCode = ' + STR(@srcOldNCode) + ' / ' + STR(@trgOldNCode)
  END
  ELSE IF (@srcNewNCode <> @trgNewNCode) Or ((@srcNewNCode IS NULL) And (@trgNewNCode IS NOT NULL)) Or ((@srcNewNCode IS NOT NULL) And (@trgNewNCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NewNCode = ' + STR(@srcNewNCode) + ' / ' + STR(@trgNewNCode)
  END
  ELSE IF (@srcNTypOld <> @trgNTypOld) Or ((@srcNTypOld IS NULL) And (@trgNTypOld IS NOT NULL)) Or ((@srcNTypOld IS NOT NULL) And (@trgNTypOld IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NTypOld = ' + @srcNTypOld + ' / ' + @trgNTypOld
  END
  ELSE IF (@srcNTypNew <> @trgNTypNew) Or ((@srcNTypNew IS NULL) And (@trgNTypNew IS NOT NULL)) Or ((@srcNTypNew IS NOT NULL) And (@trgNTypNew IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.NTypNew = ' + @srcNTypNew + ' / ' + @trgNTypNew
  END
  ELSE IF (@srcMoveKey1 <> @trgMoveKey1) Or ((@srcMoveKey1 IS NULL) And (@trgMoveKey1 IS NOT NULL)) Or ((@srcMoveKey1 IS NOT NULL) And (@trgMoveKey1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveKey1 = ' + @srcMoveKey1 + ' / ' + @trgMoveKey1
  END
  ELSE IF (@srcMoveKey2 <> @trgMoveKey2) Or ((@srcMoveKey2 IS NULL) And (@trgMoveKey2 IS NOT NULL)) Or ((@srcMoveKey2 IS NOT NULL) And (@trgMoveKey2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MoveKey2 = ' + @srcMoveKey2 + ' / ' + @trgMoveKey2
  END
  ELSE IF (@srcWasMode <> @trgWasMode) Or ((@srcWasMode IS NULL) And (@trgWasMode IS NOT NULL)) Or ((@srcWasMode IS NOT NULL) And (@trgWasMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.WasMode = ' + STR(@srcWasMode) + ' / ' + STR(@trgWasMode)
  END
  ELSE IF (@srcSGrpNew <> @trgSGrpNew) Or ((@srcSGrpNew IS NULL) And (@trgSGrpNew IS NOT NULL)) Or ((@srcSGrpNew IS NOT NULL) And (@trgSGrpNew IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SGrpNew = ' + @srcSGrpNew + ' / ' + @trgSGrpNew
  END
  ELSE IF (@srcSUser <> @trgSUser) Or ((@srcSUser IS NULL) And (@trgSUser IS NOT NULL)) Or ((@srcSUser IS NOT NULL) And (@trgSUser IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.SUser = ' + @srcSUser + ' / ' + @trgSUser
  END
  ELSE IF (@srcFinStage <> @trgFinStage) Or ((@srcFinStage IS NULL) And (@trgFinStage IS NOT NULL)) Or ((@srcFinStage IS NOT NULL) And (@trgFinStage IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.FinStage = ' + STR(@srcFinStage) + ' / ' + STR(@trgFinStage)
  END
  ELSE IF (@srcProgCounter <> @trgProgCounter) Or ((@srcProgCounter IS NULL) And (@trgProgCounter IS NOT NULL)) Or ((@srcProgCounter IS NOT NULL) And (@trgProgCounter IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.ProgCounter = ' + STR(@srcProgCounter) + ' / ' + STR(@trgProgCounter)
  END
  ELSE IF (@srcMIsCust <> @trgMIsCust) Or ((@srcMIsCust IS NULL) And (@trgMIsCust IS NOT NULL)) Or ((@srcMIsCust IS NOT NULL) And (@trgMIsCust IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MIsCust = ' + STR(@srcMIsCust) + ' / ' + STR(@trgMIsCust)
  END
  ELSE IF (@srcMListRecAddr <> @trgMListRecAddr) Or ((@srcMListRecAddr IS NULL) And (@trgMListRecAddr IS NOT NULL)) Or ((@srcMListRecAddr IS NOT NULL) And (@trgMListRecAddr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + Char(@srcSubType) + '  ExchqChk.MListRecAddr = ' + STR(@srcMListRecAddr) + ' / ' + STR(@trgMListRecAddr)
  END
  FETCH NEXT FROM srcExchqChk INTO @srcRecPfix
                                 , @srcSubType
                                 , @srcEXCHQCHKcode1
                                 , @srcEXCHQCHKcode2
                                 , @srcEXCHQCHKcode3
                                 , @srcAccess
                                 , @srcLastPno
                                 , @srcPassDesc
                                 , @srcPassPage
                                 , @srcPassLNo
                                 , @srcNoteFolio
                                 , @srcNType
                                 , @srcSpare1
                                 , @srcLineNumber
                                 , @srcNoteLine
                                 , @srcNoteUser
                                 , @srcTmpImpCode
                                 , @srcShowDate
                                 , @srcRepeatNo
                                 , @srcNoteFor
                                 , @srcSettledVal
                                 , @srcOwnCVal
                                 , @srcMCurrency
                                 , @srcMatchType
                                 , @srcOldAltRef
                                 , @srcRCurrency
                                 , @srcRecOwnCVal
                                 , @srcAltRef
                                 , @srcQtyUsed
                                 , @srcQtyCost
                                 , @srcQCurrency
                                 , @srcFullStkCode
                                 , @srcFreeIssue
                                 , @srcQtyTime
                                 , @srcBACSTagRunNo
                                 , @srcPayType
                                 , @srcBACSBankNom
                                 , @srcPayCurr
                                 , @srcInvCurr
                                 , @srcCQStart
                                 , @srcAgeType
                                 , @srcAgeInt
                                 , @srcTagStatus
                                 , @srcTotalTag0
                                 , @srcTotalTag1
                                 , @srcTotalTag2
                                 , @srcTotalTag3
                                 , @srcTotalTag4
                                 , @srcTagAsDate
                                 , @srcTagCount
                                 , @srcTagDepartment
                                 , @srcTagCostCentre
                                 , @srcTagRunDate
                                 , @srcTagRunYr
                                 , @srcTagRunPr
                                 , @srcSalesMode
                                 , @srcLastInv
                                 , @srcSRCPIRef
                                 , @srcLastTagRunNo
                                 , @srcTagCtrlCode
                                 , @srcUseAcCC
                                 , @srcSetCQatP
                                 , @srcIncSDisc
                                 , @srcSDDaysOver
                                 , @srcShowLog
                                 , @srcUseOsNdx
                                 , @srcBACSCLIUCount
                                 , @srcYourRef
                                 , @srcTagRunNo
                                 , @srcBankNom
                                 , @srcBankCr
                                 , @srcReconOpo
                                 , @srcEntryTotDr
                                 , @srcEntryTotCr
                                 , @srcEntryDate
                                 , @srcNomEntTyp
                                 , @srcAllMatchOk
                                 , @srcMatchCount
                                 , @srcMatchOBal
                                 , @srcManTotDr
                                 , @srcManTotCr
                                 , @srcManRunNo
                                 , @srcManChange
                                 , @srcManCount
                                 , @srcAllocSF
                                 , @srcCCDesc
                                 , @srcCCTag
                                 , @srcLastAccess
                                 , @srcNLineCount
                                 , @srcHideAC
                                 , @srcMoveCodeNom
                                 , @srcMoveFromNom
                                 , @srcMoveToNom
                                 , @srcMoveTypeNom
                                 , @srcMoveCodeStk
                                 , @srcMoveFromStk
                                 , @srcMoveToStk
                                 , @srcNewStkCode
                                 , @srcStuff
                                 , @srcOpoName
                                 , @srcStartDate
                                 , @srcStartTime
                                 , @srcWinLogName
                                 , @srcWinCPUName
                                 , @srcBACSULIUCount
                                 , @srcSCodeOld
                                 , @srcSCodeNew
                                 , @srcMoveStage
                                 , @srcOldNCode
                                 , @srcNewNCode
                                 , @srcNTypOld
                                 , @srcNTypNew
                                 , @srcMoveKey1
                                 , @srcMoveKey2
                                 , @srcWasMode
                                 , @srcSGrpNew
                                 , @srcSUser
                                 , @srcFinStage
                                 , @srcProgCounter
                                 , @srcMIsCust
                                 , @srcMListRecAddr
                                 , @srcPositionId
  END

  CLOSE srcExchqChk
  DEALLOCATE srcExchqChk
