-- Target Table columns
DECLARE @srcRecPfix varchar(1)
      , @srcCompanyCode1 varbinary(7)
      , @srcCompany_code2 varchar(45)
      , @srcCompany_code3 varbinary(101)
      , @srcCompId int
      , @srcCompDemoData bit
      , @srcCompSpare varbinary(1354)
      , @srcCompDemoSys bit
      , @srcCompTKUCount int
      , @srcCompTrdUCount int
      , @srcCompSysESN varbinary(8)
      , @srcCompModId int
      , @srcCompModSynch int
      , @srcCompUCount int
      , @srcCompAnal int
      , @srcOptPWord varbinary(9)
      , @srcOptBackup varchar(200)
      , @srcOptRestore varchar(200)
      , @srcOptHidePath bit
      , @srcOptHideBackup bit
      , @srcOptWin9xCmd varchar(8)
      , @srcOptWinNTCmd varchar(8)
      , @srcOptShowCheckUsr bit
      , @srcoptSystemESN varbinary(8)
      , @srcOptSecurity varbinary(427)
      , @srcOptShowExch bit
      , @srcOptBureauModule bit
      , @srcOptBureauAdminPWord varbinary(11)
      , @srcOptShowViewCompany bit
      , @srcucCompanyId int
      , @srcucWStationId varchar(40)
      , @srcucUserId varchar(40)
      , @srcucRefCount int
      , @srchkId varchar(16)
      , @srchkSecCode varchar(16)
      , @srchkDesc varchar(100)
      , @srchkStuff varbinary(34)
      , @srchkMessage varchar(100)
      , @srchkVersion int
      , @srchkEncryptedCode varbinary(17)
      , @srcacSystemId varchar(1)

-- Target Table columns

      , @trgRecPfix varchar(1)
      , @trgCompanyCode1 varbinary(7)
      , @trgCompany_code2 varchar(45)
      , @trgCompany_code3 varbinary(101)
      , @trgCompId int
      , @trgCompDemoData bit
      , @trgCompSpare varbinary(1354)
      , @trgCompDemoSys bit
      , @trgCompTKUCount int
      , @trgCompTrdUCount int
      , @trgCompSysESN varbinary(8)
      , @trgCompModId int
      , @trgCompModSynch int
      , @trgCompUCount int
      , @trgCompAnal int
      , @trgOptPWord varbinary(9)
      , @trgOptBackup varchar(200)
      , @trgOptRestore varchar(200)
      , @trgOptHidePath bit
      , @trgOptHideBackup bit
      , @trgOptWin9xCmd varchar(8)
      , @trgOptWinNTCmd varchar(8)
      , @trgOptShowCheckUsr bit
      , @trgoptSystemESN varbinary(8)
      , @trgOptSecurity varbinary(427)
      , @trgOptShowExch bit
      , @trgOptBureauModule bit
      , @trgOptBureauAdminPWord varbinary(11)
      , @trgOptShowViewCompany bit
      , @trgucCompanyId int
      , @trgucWStationId varchar(40)
      , @trgucUserId varchar(40)
      , @trgucRefCount int
      , @trghkId varchar(16)
      , @trghkSecCode varchar(16)
      , @trghkDesc varchar(100)
      , @trghkStuff varbinary(34)
      , @trghkMessage varchar(100)
      , @trghkVersion int
      , @trghkEncryptedCode varbinary(17)
      , @trgacSystemId varchar(1)

DECLARE srcCompany CURSOR FOR SELECT RecPfix
                                    , CompanyCode1
                                    , Company_code2
                                    , Company_code3
                                    , CompId
                                    , CompDemoData
                                    , CompSpare
                                    , CompDemoSys
                                    , CompTKUCount
                                    , CompTrdUCount
                                    , CompSysESN
                                    , CompModId
                                    , CompModSynch
                                    , CompUCount
                                    , CompAnal
                                    , OptPWord
                                    , OptBackup
                                    , OptRestore
                                    , OptHidePath
                                    , OptHideBackup
                                    , OptWin9xCmd
                                    , OptWinNTCmd
                                    , OptShowCheckUsr
                                    , optSystemESN
                                    , OptSecurity
                                    , OptShowExch
                                    , OptBureauModule
                                    , OptBureauAdminPWord
                                    , OptShowViewCompany
                                    , ucCompanyId
                                    , ucWStationId
                                    , ucUserId
                                    , ucRefCount
                                    , hkId
                                    , hkSecCode
                                    , hkDesc
                                    , hkStuff
                                    , hkMessage
                                    , hkVersion
                                    , hkEncryptedCode
                                    , acSystemId
                               FROM   ConvMasterPR70.Common.Company

OPEN srcCompany

FETCH NEXT FROM srcCompany INTO @srcRecPfix
                               , @srcCompanyCode1
                               , @srcCompany_code2
                               , @srcCompany_code3
                               , @srcCompId
                               , @srcCompDemoData
                               , @srcCompSpare
                               , @srcCompDemoSys
                               , @srcCompTKUCount
                               , @srcCompTrdUCount
                               , @srcCompSysESN
                               , @srcCompModId
                               , @srcCompModSynch
                               , @srcCompUCount
                               , @srcCompAnal
                               , @srcOptPWord
                               , @srcOptBackup
                               , @srcOptRestore
                               , @srcOptHidePath
                               , @srcOptHideBackup
                               , @srcOptWin9xCmd
                               , @srcOptWinNTCmd
                               , @srcOptShowCheckUsr
                               , @srcoptSystemESN
                               , @srcOptSecurity
                               , @srcOptShowExch
                               , @srcOptBureauModule
                               , @srcOptBureauAdminPWord
                               , @srcOptShowViewCompany
                               , @srcucCompanyId
                               , @srcucWStationId
                               , @srcucUserId
                               , @srcucRefCount
                               , @srchkId
                               , @srchkSecCode
                               , @srchkDesc
                               , @srchkStuff
                               , @srchkMessage
                               , @srchkVersion
                               , @srchkEncryptedCode
                               , @srcacSystemId

WHILE @@FETCH_STATUS = 0
BEGIN
  -- Get Target Columns for same row
  SELECT @trgCompanyCode1 = CompanyCode1
       , @trgCompany_code2 = Company_code2
       , @trgCompany_code3 = Company_code3
       , @trgCompId = CompId
       , @trgCompDemoData = CompDemoData
       , @trgCompSpare = CompSpare
       , @trgCompDemoSys = CompDemoSys
       , @trgCompTKUCount = CompTKUCount
       , @trgCompTrdUCount = CompTrdUCount
       , @trgCompSysESN = CompSysESN
       , @trgCompModId = CompModId
       , @trgCompModSynch = CompModSynch
       , @trgCompUCount = CompUCount
       , @trgCompAnal = CompAnal
       , @trgOptPWord = OptPWord
       , @trgOptBackup = OptBackup
       , @trgOptRestore = OptRestore
       , @trgOptHidePath = OptHidePath
       , @trgOptHideBackup = OptHideBackup
       , @trgOptWin9xCmd = OptWin9xCmd
       , @trgOptWinNTCmd = OptWinNTCmd
       , @trgOptShowCheckUsr = OptShowCheckUsr
       , @trgoptSystemESN = optSystemESN
       , @trgOptSecurity = OptSecurity
       , @trgOptShowExch = OptShowExch
       , @trgOptBureauModule = OptBureauModule
       , @trgOptBureauAdminPWord = OptBureauAdminPWord
       , @trgOptShowViewCompany = OptShowViewCompany
       , @trgucCompanyId = ucCompanyId
       , @trgucWStationId = ucWStationId
       , @trgucUserId = ucUserId
       , @trgucRefCount = ucRefCount
       , @trghkId = hkId
       , @trghkSecCode = hkSecCode
       , @trghkDesc = hkDesc
       , @trghkStuff = hkStuff
       , @trghkMessage = hkMessage
       , @trghkVersion = hkVersion
       , @trghkEncryptedCode = hkEncryptedCode
       , @trgacSystemId = acSystemId
  FROM Exch70Conv.Common.Company
  WHERE RecPFix = @srcRecPfix
    And CompanyCode1 = @srcCompanyCode1 

  -- Compare columns
  IF (@srcCompanyCode1 <> @trgCompanyCode1) Or ((@srcCompanyCode1 IS NULL) And (@trgCompanyCode1 IS NOT NULL)) Or ((@srcCompanyCode1 IS NOT NULL) And (@trgCompanyCode1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompanyCode1 is different'
  END
  IF (@srcCompany_code2 <> @trgCompany_code2) Or ((@srcCompany_code2 IS NULL) And (@trgCompany_code2 IS NOT NULL)) Or ((@srcCompany_code2 IS NOT NULL) And (@trgCompany_code2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.Company_code2 = ' + @srcCompany_code2 + ' / ' + @trgCompany_code2
  END
  IF (@srcCompany_code3 <> @trgCompany_code3) Or ((@srcCompany_code3 IS NULL) And (@trgCompany_code3 IS NOT NULL)) Or ((@srcCompany_code3 IS NOT NULL) And (@trgCompany_code3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.Company_code3 is different'
  END
  IF (@srcCompId <> @trgCompId) Or ((@srcCompId IS NULL) And (@trgCompId IS NOT NULL)) Or ((@srcCompId IS NOT NULL) And (@trgCompId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompId = ' + STR(@srcCompId) + ' / ' + STR(@trgCompId)
  END
  IF (@srcCompDemoData <> @trgCompDemoData) Or ((@srcCompDemoData IS NULL) And (@trgCompDemoData IS NOT NULL)) Or ((@srcCompDemoData IS NOT NULL) And (@trgCompDemoData IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompDemoData = ' + STR(@srcCompDemoData) + ' / ' + STR(@trgCompDemoData)
  END
  IF (@srcCompSpare <> @trgCompSpare) Or ((@srcCompSpare IS NULL) And (@trgCompSpare IS NOT NULL)) Or ((@srcCompSpare IS NOT NULL) And (@trgCompSpare IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompSpare is different'
  END
  IF (@srcCompDemoSys <> @trgCompDemoSys) Or ((@srcCompDemoSys IS NULL) And (@trgCompDemoSys IS NOT NULL)) Or ((@srcCompDemoSys IS NOT NULL) And (@trgCompDemoSys IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompDemoSys = ' + STR(@srcCompDemoSys) + ' / ' + STR(@trgCompDemoSys)
  END
  IF (@srcCompTKUCount <> @trgCompTKUCount) Or ((@srcCompTKUCount IS NULL) And (@trgCompTKUCount IS NOT NULL)) Or ((@srcCompTKUCount IS NOT NULL) And (@trgCompTKUCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompTKUCount = ' + STR(@srcCompTKUCount) + ' / ' + STR(@trgCompTKUCount)
  END
  IF (@srcCompTrdUCount <> @trgCompTrdUCount) Or ((@srcCompTrdUCount IS NULL) And (@trgCompTrdUCount IS NOT NULL)) Or ((@srcCompTrdUCount IS NOT NULL) And (@trgCompTrdUCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompTrdUCount = ' + STR(@srcCompTrdUCount) + ' / ' + STR(@trgCompTrdUCount)
  END
  IF (@srcCompSysESN <> @trgCompSysESN) Or ((@srcCompSysESN IS NULL) And (@trgCompSysESN IS NOT NULL)) Or ((@srcCompSysESN IS NOT NULL) And (@trgCompSysESN IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompSysESN is different'
  END
  IF (@srcCompModId <> @trgCompModId) Or ((@srcCompModId IS NULL) And (@trgCompModId IS NOT NULL)) Or ((@srcCompModId IS NOT NULL) And (@trgCompModId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompModId = ' + STR(@srcCompModId) + ' / ' + STR(@trgCompModId)
  END
  IF (@srcCompModSynch <> @trgCompModSynch) Or ((@srcCompModSynch IS NULL) And (@trgCompModSynch IS NOT NULL)) Or ((@srcCompModSynch IS NOT NULL) And (@trgCompModSynch IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompModSynch = ' + STR(@srcCompModSynch) + ' / ' + STR(@trgCompModSynch)
  END
  IF (@srcCompUCount <> @trgCompUCount) Or ((@srcCompUCount IS NULL) And (@trgCompUCount IS NOT NULL)) Or ((@srcCompUCount IS NOT NULL) And (@trgCompUCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompUCount = ' + STR(@srcCompUCount) + ' / ' + STR(@trgCompUCount)
  END
  IF (@srcCompAnal <> @trgCompAnal) Or ((@srcCompAnal IS NULL) And (@trgCompAnal IS NOT NULL)) Or ((@srcCompAnal IS NOT NULL) And (@trgCompAnal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.CompAnal = ' + STR(@srcCompAnal) + ' / ' + STR(@trgCompAnal)
  END
  IF (@srcOptPWord <> @trgOptPWord) Or ((@srcOptPWord IS NULL) And (@trgOptPWord IS NOT NULL)) Or ((@srcOptPWord IS NOT NULL) And (@trgOptPWord IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptPWord is different'
  END
  IF (@srcOptBackup <> @trgOptBackup) Or ((@srcOptBackup IS NULL) And (@trgOptBackup IS NOT NULL)) Or ((@srcOptBackup IS NOT NULL) And (@trgOptBackup IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptBackup = ' + @srcOptBackup + ' / ' + @trgOptBackup
  END
  IF (@srcOptRestore <> @trgOptRestore) Or ((@srcOptRestore IS NULL) And (@trgOptRestore IS NOT NULL)) Or ((@srcOptRestore IS NOT NULL) And (@trgOptRestore IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptRestore = ' + @srcOptRestore + ' / ' + @trgOptRestore
  END
  IF (@srcOptHidePath <> @trgOptHidePath) Or ((@srcOptHidePath IS NULL) And (@trgOptHidePath IS NOT NULL)) Or ((@srcOptHidePath IS NOT NULL) And (@trgOptHidePath IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptHidePath = ' + STR(@srcOptHidePath) + ' / ' + STR(@trgOptHidePath)
  END
  IF (@srcOptHideBackup <> @trgOptHideBackup) Or ((@srcOptHideBackup IS NULL) And (@trgOptHideBackup IS NOT NULL)) Or ((@srcOptHideBackup IS NOT NULL) And (@trgOptHideBackup IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptHideBackup = ' + STR(@srcOptHideBackup) + ' / ' + STR(@trgOptHideBackup)
  END
  IF (@srcOptWin9xCmd <> @trgOptWin9xCmd) Or ((@srcOptWin9xCmd IS NULL) And (@trgOptWin9xCmd IS NOT NULL)) Or ((@srcOptWin9xCmd IS NOT NULL) And (@trgOptWin9xCmd IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptWin9xCmd = ' + @srcOptWin9xCmd + ' / ' + @trgOptWin9xCmd
  END
  IF (@srcOptWinNTCmd <> @trgOptWinNTCmd) Or ((@srcOptWinNTCmd IS NULL) And (@trgOptWinNTCmd IS NOT NULL)) Or ((@srcOptWinNTCmd IS NOT NULL) And (@trgOptWinNTCmd IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptWinNTCmd = ' + @srcOptWinNTCmd + ' / ' + @trgOptWinNTCmd
  END
  IF (@srcOptShowCheckUsr <> @trgOptShowCheckUsr) Or ((@srcOptShowCheckUsr IS NULL) And (@trgOptShowCheckUsr IS NOT NULL)) Or ((@srcOptShowCheckUsr IS NOT NULL) And (@trgOptShowCheckUsr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptShowCheckUsr = ' + STR(@srcOptShowCheckUsr) + ' / ' + STR(@trgOptShowCheckUsr)
  END
  IF (@srcoptSystemESN <> @trgoptSystemESN) Or ((@srcoptSystemESN IS NULL) And (@trgoptSystemESN IS NOT NULL)) Or ((@srcoptSystemESN IS NOT NULL) And (@trgoptSystemESN IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.optSystemESN is different'
  END
  IF (@srcOptSecurity <> @trgOptSecurity) Or ((@srcOptSecurity IS NULL) And (@trgOptSecurity IS NOT NULL)) Or ((@srcOptSecurity IS NOT NULL) And (@trgOptSecurity IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptSecurity is different'
  END
  IF (@srcOptShowExch <> @trgOptShowExch) Or ((@srcOptShowExch IS NULL) And (@trgOptShowExch IS NOT NULL)) Or ((@srcOptShowExch IS NOT NULL) And (@trgOptShowExch IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptShowExch = ' + STR(@srcOptShowExch) + ' / ' + STR(@trgOptShowExch)
  END
  IF (@srcOptBureauModule <> @trgOptBureauModule) Or ((@srcOptBureauModule IS NULL) And (@trgOptBureauModule IS NOT NULL)) Or ((@srcOptBureauModule IS NOT NULL) And (@trgOptBureauModule IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptBureauModule = ' + STR(@srcOptBureauModule) + ' / ' + STR(@trgOptBureauModule)
  END
  IF (@srcOptBureauAdminPWord <> @trgOptBureauAdminPWord) Or ((@srcOptBureauAdminPWord IS NULL) And (@trgOptBureauAdminPWord IS NOT NULL)) Or ((@srcOptBureauAdminPWord IS NOT NULL) And (@trgOptBureauAdminPWord IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptBureauAdminPWord is different'
  END
  IF (@srcOptShowViewCompany <> @trgOptShowViewCompany) Or ((@srcOptShowViewCompany IS NULL) And (@trgOptShowViewCompany IS NOT NULL)) Or ((@srcOptShowViewCompany IS NOT NULL) And (@trgOptShowViewCompany IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.OptShowViewCompany = ' + STR(@srcOptShowViewCompany) + ' / ' + STR(@trgOptShowViewCompany)
  END
  IF (@srcucCompanyId <> @trgucCompanyId) Or ((@srcucCompanyId IS NULL) And (@trgucCompanyId IS NOT NULL)) Or ((@srcucCompanyId IS NOT NULL) And (@trgucCompanyId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.ucCompanyId = ' + STR(@srcucCompanyId) + ' / ' + STR(@trgucCompanyId)
  END
  IF (@srcucWStationId <> @trgucWStationId) Or ((@srcucWStationId IS NULL) And (@trgucWStationId IS NOT NULL)) Or ((@srcucWStationId IS NOT NULL) And (@trgucWStationId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.ucWStationId = ' + @srcucWStationId + ' / ' + @trgucWStationId
  END
  IF (@srcucUserId <> @trgucUserId) Or ((@srcucUserId IS NULL) And (@trgucUserId IS NOT NULL)) Or ((@srcucUserId IS NOT NULL) And (@trgucUserId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.ucUserId = ' + @srcucUserId + ' / ' + @trgucUserId
  END
  IF (@srcucRefCount <> @trgucRefCount) Or ((@srcucRefCount IS NULL) And (@trgucRefCount IS NOT NULL)) Or ((@srcucRefCount IS NOT NULL) And (@trgucRefCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.ucRefCount = ' + STR(@srcucRefCount) + ' / ' + STR(@trgucRefCount)
  END
  IF (@srchkId <> @trghkId) Or ((@srchkId IS NULL) And (@trghkId IS NOT NULL)) Or ((@srchkId IS NOT NULL) And (@trghkId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkId = ' + @srchkId + ' / ' + @trghkId
  END
  IF (@srchkSecCode <> @trghkSecCode) Or ((@srchkSecCode IS NULL) And (@trghkSecCode IS NOT NULL)) Or ((@srchkSecCode IS NOT NULL) And (@trghkSecCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkSecCode = ' + @srchkSecCode + ' / ' + @trghkSecCode
  END
  IF (@srchkDesc <> @trghkDesc) Or ((@srchkDesc IS NULL) And (@trghkDesc IS NOT NULL)) Or ((@srchkDesc IS NOT NULL) And (@trghkDesc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkDesc = ' + @srchkDesc + ' / ' + @trghkDesc
  END
  IF (@srchkStuff <> @trghkStuff) Or ((@srchkStuff IS NULL) And (@trghkStuff IS NOT NULL)) Or ((@srchkStuff IS NOT NULL) And (@trghkStuff IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkStuff is different'
  END
  IF (@srchkMessage <> @trghkMessage) Or ((@srchkMessage IS NULL) And (@trghkMessage IS NOT NULL)) Or ((@srchkMessage IS NOT NULL) And (@trghkMessage IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkMessage = ' + @srchkMessage + ' / ' + @trghkMessage
  END
  IF (@srchkVersion <> @trghkVersion) Or ((@srchkVersion IS NULL) And (@trghkVersion IS NOT NULL)) Or ((@srchkVersion IS NOT NULL) And (@trghkVersion IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkVersion = ' + STR(@srchkVersion) + ' / ' + STR(@trghkVersion)
  END
  IF (@srchkEncryptedCode <> @trghkEncryptedCode) Or ((@srchkEncryptedCode IS NULL) And (@trghkEncryptedCode IS NOT NULL)) Or ((@srchkEncryptedCode IS NOT NULL) And (@trghkEncryptedCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.hkEncryptedCode is different'
  END
  IF (@srcacSystemId <> @trgacSystemId) Or ((@srcacSystemId IS NULL) And (@trgacSystemId IS NOT NULL)) Or ((@srcacSystemId IS NOT NULL) And (@trgacSystemId IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcRecPfix + master.sys.fn_varbintohexstr(@srcCompanyCode1) + '  Company.acSystemId = ' + @srcacSystemId + ' / ' + @trgacSystemId
  END
  FETCH NEXT FROM srcCompany INTO @srcRecPfix
                                 , @srcCompanyCode1
                                 , @srcCompany_code2
                                 , @srcCompany_code3
                                 , @srcCompId
                                 , @srcCompDemoData
                                 , @srcCompSpare
                                 , @srcCompDemoSys
                                 , @srcCompTKUCount
                                 , @srcCompTrdUCount
                                 , @srcCompSysESN
                                 , @srcCompModId
                                 , @srcCompModSynch
                                 , @srcCompUCount
                                 , @srcCompAnal
                                 , @srcOptPWord
                                 , @srcOptBackup
                                 , @srcOptRestore
                                 , @srcOptHidePath
                                 , @srcOptHideBackup
                                 , @srcOptWin9xCmd
                                 , @srcOptWinNTCmd
                                 , @srcOptShowCheckUsr
                                 , @srcoptSystemESN
                                 , @srcOptSecurity
                                 , @srcOptShowExch
                                 , @srcOptBureauModule
                                 , @srcOptBureauAdminPWord
                                 , @srcOptShowViewCompany
                                 , @srcucCompanyId
                                 , @srcucWStationId
                                 , @srcucUserId
                                 , @srcucRefCount
                                 , @srchkId
                                 , @srchkSecCode
                                 , @srchkDesc
                                 , @srchkStuff
                                 , @srchkMessage
                                 , @srchkVersion
                                 , @srchkEncryptedCode
                                 , @srcacSystemId
  END

  CLOSE srcCompany
  DEALLOCATE srcCompany
