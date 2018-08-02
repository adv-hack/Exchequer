Attribute VB_Name = "modVATUPD"
Option Explicit
Dim toolkit As Enterprise01.toolkit
'ABSPLUG 2993 Start
Dim companyCode As String
Dim isUDF2ToBeCopied As Boolean
Dim isUDF3ToBeCopied As Boolean
Dim isUDF4ToBeCopied As Boolean
Dim isUDF5ToBeCopied As Boolean
Dim isUDF6ToBeCopied As Boolean
Dim isUDF7ToBeCopied As Boolean
Dim isUDF8ToBeCopied As Boolean
Dim isUDF9ToBeCopied As Boolean
Dim isUDF10ToBeCopied As Boolean
'ABSPLUG 2993 End
Enum ToolkitResult
    success = 0
End Enum

'CA 19/04/2013 ABSEXGENERIC-313 : Provide a default G/L code to be used on all disallowed VAT transaction lines
'API Function to read information from INI File
Public Declare Function GetPrivateProfileString Lib "kernel32" _
    Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any _
    , ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long _
    , ByVal lpFileName As String) As Long

Private Sub Main()
    Dim args As String
    Dim dataDirectory As String
    Dim transactionOurRef As String

    args = Command

    'PR 29/08/2012 Removed this as it seems to be debugging left in accidentally and could cause problems.
    'If args = "" Then
        'args = "PIN000893 |Z:\Excheqr"
    'End If
    
    If args = "" Then
        MsgBox "VATUPD can only be run from within Exchequer.", vbCritical
        End
    End If
    
    'ABSPLUG-2993 Start
    'Set default UDF to be copied flag values
    SetUDFDefaultValue
    'ABSPLUG-2993 End
    
    dataDirectory = GetDataPathFromCommandLineArgs(args)
    transactionOurRef = GetTransRefFromCommandLineArgs(args)

    If CreateAndOpenToolkit(dataDirectory) = ToolkitResult.success Then
        'ABSPLUG-2993 Start
        If ((Not toolkit Is Nothing) And (Not toolkit.Enterprise Is Nothing)) Then
            'Get the company code based on active exchequer company path
            companyCode = GetExchequerCompanyCodeFromPath(toolkit.Enterprise.enCompanyPath)
            If Trim(companyCode) = "" Then
                MsgBox (toolkit.Enterprise.enCompanyPath) & " is not a valid Exchequer company path.", vbInformation, "Error"
                End
            Else
                Call ReadConfiguration(companyCode)
            End If
        End If
        'ABSPLUG-2993 End
        UpdateTransaction (transactionOurRef)
    End If
    
    CloseAndFreeToolkit
End Sub

Private Function GetDataPathFromCommandLineArgs(args As String) As String
    Dim result As String
    Dim k As Integer
    Dim j As Integer

    k = Len(args)
    j = InStr(1, args, "|")
    
    result = Mid(args, j + 1, k - j)
    GetDataPathFromCommandLineArgs = result
End Function

Private Function GetTransRefFromCommandLineArgs(args As String) As String
    Dim result As String
    Dim k As Integer
    Dim j As Integer

    k = Len(args)
    j = InStr(1, args, "|")
    
    result = Left(args, j - 1)
    GetTransRefFromCommandLineArgs = result
End Function

Private Function CreateAndOpenToolkit(dataDirectory As String) As Integer
    Set toolkit = CreateObject("Enterprise01.Toolkit")
    Dim result As Integer
    Dim I1, I2, I3 As Long
    
    I1 = 102
    I2 = 318542
    I3 = -14252363
        
    ' Call the E32Exch DLL to get current backdoor code
    CalcCTKDebugMode.CalcCTKDebugMode I1, I2, I3
  
    ' Disable Release Code / User Count mechanism
    Call toolkit.Configuration.SetDebugMode(I1, I2, I3)
    toolkit.Configuration.dataDirectory = dataDirectory

    result = toolkit.OpenToolkit()
    
    If result <> ToolkitResult.success Then
        MsgBox "The following error occurred opening the Toolkit:-" + _
           Chr(13) + Chr(13) + """" + toolkit.LastErrorString + """"
    End If
    
    CreateAndOpenToolkit = result
End Function

Private Sub UpdateTransaction(transactionOurRef As String)

    Dim transaction As ITransaction
    Dim line As ITransactionLine5
    Dim i As Integer
    Dim netValue As Double
    Dim qty As Double
    Dim discValue As Double
    Dim lineValue As Double
    Dim vatCode As String
    Dim vatRate As String
    Dim vatValue As Double
    Dim vatAllowed As Double
    Dim vatDisallowed As Double
    Dim vatTotalsByCode As Collection
               
    'CA 19/04/2013 ABSEXGENERIC-313 : Provide a default G/L code to be used on all disallowed VAT transaction lines
    'New fields required to access the appropriate field from the ini file
    Dim glCode As String
    Dim costCentre As String
    Dim department As String
    glCode = GetINISetting("Settings", "GLCODE", App.path & "\VATUPD.INI")
    costCentre = GetINISetting("Settings", "COSTCENTRE", App.path & "\VATUPD.INI")
    department = GetINISetting("Settings", "DEPARTMENT", App.path & "\VATUPD.INI")
               
    If GetTransactionByOurRef(toolkit, transactionOurRef) = ToolkitResult.success Then
        
        If (Not IsManualVat(toolkit.transaction)) _
        Or (IsVATLocked(toolkit.transaction)) Then
            Exit Sub
        End If
        
        Set transaction = GetEditableTransaction(toolkit.transaction)
                
        If Not (transaction Is Nothing) Then
            
            
            
            ClearPreviouslyGeneratedAdjustmentLines transaction
            ClearVATAnalysisValues transaction
            
            Dim areJobDetailsToBeCopied As Boolean
            areJobDetailsToBeCopied = GetValueOfCopyJobDetailsSetting()
            
            For i = 1 To transaction.thLines.thLineCount
                
                Set line = transaction.thLines.thLine(i)
                    
                If IsOKToUpdate(line) Then
                
                    netValue = line.tlNetValue
                    qty = line.tlQty
                    discValue = line.tlDiscount
                    vatCode = line.tlVATCode
                    lineValue = line.tlTotals(LineTotNet)
    
                    ' Recalculate Line VAT each time as the Line VAT field may have been reduced by
                    ' previous exemptions
                    vatValue = lineValue * toolkit.SystemSetup.ssVATRates(vatCode).svRate
                    vatValue = toolkit.Functions.entRound(vatValue, 2)
                    
                    vatRate = Str(Round(toolkit.SystemSetup.ssVATRates(vatCode).svRate * 100, 2))
                 
                    If line.tlVATCode = "1" Then
                        vatAllowed = _
                        lineValue * toolkit.SystemSetup.ssVATRates(vatCode).svRate * _
                                    toolkit.SystemSetup.ssVATRates("Y").svRate
                                    
                        vatAllowed = toolkit.Functions.entRound(vatAllowed, 2)
                        vatDisallowed = vatValue - vatAllowed
                        
                        line.tlUserField2 = Format(CDbl(vatRate), "##0.00") & "%"
                        line.tlUserField3 = Format(vatValue, "######0.00")
                        line.tlVATAmount = vatAllowed
                    Else
                        line.tlUserField2 = Format(CDbl(vatRate), "##0.00") & "%"
                        line.tlUserField3 = Format(vatValue, "######0.00")
                        line.tlVATAmount = Format(vatValue, "######0.00")
                    End If

                    'transaction.thVATAnalysis(vatCode) = transaction.thVATAnalysis(vatCode) + line.tlVATAmount
                    'transaction.thTotalVAT = transaction.thTotalVAT + line.tlVATAmount
                
                    If line.tlVATCode = "1" Then
                        
                        Dim newLine As ITransactionLine
                        Set newLine = transaction.thLines.Add()
                        
                        newLine.tlStockCode = line.tlStockCode
                        newLine.tlDescr = "VAT Disallowed on : " & line.tlDescr
                        newLine.tlLocation = line.tlLocation
                        
                        'CA 19/04/2013 ABSEXGENERIC-313 : Provide a default G/L code to be used on all disallowed VAT transaction lines
                        If glCode = "" Then
                          newLine.tlGLCode = line.tlGLCode
                        Else
                          newLine.tlGLCode = glCode
                        End If
                        
                        If costCentre = "" Then
                          newLine.tlCostCentre = line.tlCostCentre
                        Else
                          newLine.tlCostCentre = costCentre
                        End If
                          
                        If department = "" Then
                          newLine.tlDepartment = line.tlDepartment
                        Else
                          newLine.tlDepartment = department
                        End If
                         
                        newLine.tlQty = 1
                        newLine.tlQtyPicked = 1
                        newLine.tlNetValue = vatDisallowed
                        newLine.tlUserField1 = "DVA"
                        newLine.tlVATCode = "5"
                        newLine.tlVATAmount = 0

                         'ABSPLUG-2993 Start
                        'SET udf VALUE
                        Call SetUDFValues(line, newLine)
                        'ABSPLUG-2993 End
                        
                        If areJobDetailsToBeCopied Then
                          newLine.tlJobCode = line.tlJobCode
                          newLine.tlAnalysisCode = line.tlAnalysisCode
                        End If
                        
                        newLine.Save
                    End If
                    
                End If

                Set line = Nothing
            Next i
            
            SetVATAnalysisValues transaction
            
            transaction.thUserField1 = toolkit.Functions.entRound(transaction.thVATAnalysis("S"), 2)
            transaction.thUserField2 = toolkit.Functions.entRound(transaction.thVATAnalysis("1"), 2)
            
            If SaveTransaction(transaction) = ToolkitResult.success Then
                MsgBox "VAT Partial Exemption Hook" & vbCrLf & vbCrLf & "VAT Adjusted on Transaction : " & transaction.thOurRef
            Else
                MsgBox "VAT Partial Exemption Hook" & vbCrLf & vbCrLf & "Failed to adjust VAT on Transaction : " & transaction.thOurRef
            End If
            
            Set transaction = Nothing
        End If
    End If
End Sub

Private Function GetTransactionByOurRef(ByRef toolkit As IToolkit, transactionOurRef As String) As Integer
    Dim result As Integer
   
    toolkit.transaction.index = thIdxOurRef
    result = toolkit.transaction.GetEqual(toolkit.transaction.BuildOurRefIndex(transactionOurRef))
    
    If (result <> ToolkitResult.success) Then
        MsgBox "The following error occured loading the Transaction:-" + _
               Chr(13) + Chr(13) + """" + toolkit.LastErrorString + """"
    End If
    
    GetTransactionByOurRef = result
End Function

Private Function IsManualVat(ByRef transaction As ITransaction) As Boolean
    Dim result As Boolean
    Dim i As Integer
    result = False
    For i = 1 To transaction.thLines.thLineCount
        If transaction.thLines.thLine(i).tlVATCode = "1" Then
            result = True
        End If
    Next i
    IsManualVat = result
End Function

Private Function IsVATLocked(ByRef transaction As ITransaction) As Boolean
    Dim result As Boolean
    result = Trim(UCase(transaction.thUserField3)) = "Y"
    IsVATLocked = result
End Function

Private Function GetEditableTransaction(readOnlyTransaction As ITransaction) As ITransaction
    Dim result As ITransaction
    Set result = toolkit.transaction.Update
    If (result Is Nothing) Then
        MsgBox "Unable to read Transaction. " & vbCrLf & "Check if record is in use.", vbCritical
    End If
    Set GetEditableTransaction = result
End Function

Private Sub ClearPreviouslyGeneratedAdjustmentLines(ByRef transaction As ITransaction)
    Dim i As Integer
    Dim line As ITransactionLine
    'Delete all VPX lines & reset TLUDF's
    For i = 1 To transaction.thLines.thLineCount
        If i > transaction.thLines.thLineCount Then
            'do nothing
        Else
            Set line = transaction.thLines.thLine(i)
            If line.tlUserField1 = "DVA" Then
                transaction.thLines.Delete (i)
                i = i - 1
            Else
                line.tlUserField1 = ""
                line.tlUserField2 = ""
            End If
            Set line = Nothing
        End If
    Next i
End Sub

Private Function GetVatTotalsByCode(transaction As ITransaction) As Collection
    Dim results As Collection
    Dim line As ITransactionLine
    Dim vatCode As String
    Dim i As Integer
    
    Set results = New Collection
    
    For i = 1 To transaction.thLines.thLineCount
        Set line = transaction.thLines(i)
        
        If (Asc(line.tlVATCode) <> 0) Then
            
            
            'PR: 29/08/2012 ABSEXGENERIC-278 If inclusive vat, tlVATCode will be 'M' at this point:
            'if so, use tlInclusiveVATCode
            If (line.tlVATCode = "M") Then
              vatCode = Trim(line.tlInclusiveVATCode)
            Else
              vatCode = Trim(line.tlVATCode)
            End If
            
            If Not DoesCollectionItemExist(results, vatCode) Then
                results.Add 0, line.tlVATCode
            End If
            
            Dim temp As Double
            temp = results(vatCode)
            results.Remove vatCode
            results.Add (temp + line.tlVATAmount), vatCode
            
        End If
        
    Next i
 
    Set GetVatTotalsByCode = results
End Function

Private Function DoesCollectionItemExist(col As Collection, index As String) As Boolean
On Error GoTo ExistsTryNonObject
    Dim o As Object
    Set o = col(index)
    DoesCollectionItemExist = True
    Exit Function
ExistsTryNonObject:
    DoesCollectionItemExist = DoesCollectionItemExistNonObject(col, index)
End Function

Private Function DoesCollectionItemExistNonObject(col As Collection, index As String) As Boolean
On Error GoTo ExistsNonObjectErrorHandler
    Dim v As Variant
    v = col(index)
    DoesCollectionItemExistNonObject = True
    Exit Function
ExistsNonObjectErrorHandler:
    DoesCollectionItemExistNonObject = False
End Function

'CA 19/04/2013 ABSEXGENERIC-313 : Provide a default G/L code to be used on all disallowed VAT transaction lines
'Get the INI Setting from the File
Public Function GetINISetting(ByVal sHeading As String, ByVal sKey As String, sINIFileName) As String
    Const cparmLen = 50
    Dim sReturn As String * cparmLen
    Dim sDefault As String * cparmLen
    Dim lLength As Long
    lLength = GetPrivateProfileString(sHeading, sKey _
            , sDefault, sReturn, cparmLen, sINIFileName)
    GetINISetting = Mid(sReturn, 1, lLength)
End Function


Private Function GetVatCodes(ByRef transaction As ITransaction) As Collection
    Dim results As Collection
    Dim line As ITransactionLine
    
    'PR: 29/08/2012 ABSEXGENERIC-278
    Dim vatCode As String
    
    Set results = New Collection
    
    Dim i As Integer
    For i = 1 To transaction.thLines.thLineCount
        Set line = transaction.thLines.thLine(i)
        If (Asc(line.tlVATCode) <> 0) Then
            'PR: 29/08/2012 ABSEXGENERIC-278 If inclusive vat, tlVATCode will be 'M' at this point:
            'if so, use tlInclusiveVATCode
            If (line.tlVATCode = "M") Then
              vatCode = Trim(line.tlInclusiveVATCode)
            Else
              vatCode = Trim(line.tlVATCode)
            End If
            
            If Not DoesCollectionItemExist(results, vatCode) Then
                results.Add line.tlVATCode, line.tlVATCode
            End If
        End If
    Next i
    
    Set GetVatCodes = results
End Function


Private Sub ClearVATAnalysisValues(ByRef transaction As ITransaction)
    Dim i As Integer
    Dim line As ITransactionLine
    
    transaction.thManualVAT = True
    transaction.thTotalVAT = 0
    
    For i = 1 To transaction.thLines.thLineCount
        Set line = transaction.thLines.thLine(i)
        If (line.tlQty <> 0) And (Asc(line.tlVATCode) <> 0) Then
            transaction.thVATAnalysis(line.tlVATCode) = 0
        End If
    Next i
End Sub

Private Sub SetVATAnalysisValues(ByRef transaction As ITransaction)
    Dim vatCodes As Collection
    Dim vatTotalsByCode As Collection
    Dim vatCode As String
    Dim item As Variant
    
    Set vatCodes = GetVatCodes(transaction)
    Set vatTotalsByCode = GetVatTotalsByCode(transaction)
    
    For Each item In vatCodes
        vatCode = CStr(item)
        transaction.thVATAnalysis(vatCode) = vatTotalsByCode.item(vatCode)
        transaction.thTotalVAT = transaction.thTotalVAT + vatTotalsByCode.item(vatCode)
    Next item
End Sub

Private Function IsDiscountInfoLine(line As ITransactionLine) As Boolean
    Dim result As Boolean
    result = (line.tlTransValueDiscountType = 255)
    IsDiscountInfoLine = result
End Function

Private Function IsOKToUpdate(ByRef line As ITransactionLine5) As Boolean
    Dim result As Boolean
    
    If Not IsDiscountInfoLine(line) Then
        result = False
        
        If Trim(line.tlStockCode) = "" Then
            result = True
        Else
            If (line.tlStockCodeI.stType = stTypeDescription) Then
                result = True
            Else
                result = False
            End If
        End If
    End If
    
    If (line.tlQty = 0) Then
        result = False
    End If

    IsOKToUpdate = result
End Function

Private Function GetValueOfCopyJobDetailsSetting() As Boolean
  Dim fileText As String
  Dim iniFileStream As Integer
  Dim result As Boolean
   
  Const iniFileName = "VATUPD.INI"
  iniFileStream = FreeFile
    
  'Find file and open
  Select Case iniFileName
    Case UCase(Trim(Dir(iniFileName)))
      Open iniFileName For Input As #iniFileStream
    Case UCase(Trim(Dir(App.path & "\" & iniFileName)))
      Open App.path & "\" & iniFileName For Input As #iniFileStream
    Case Else
      'File not found (this is fine)
      Exit Function
  End Select
    
  'Read file
  fileText = ""
  While (Not EOF(iniFileStream)) And (Not result)
    'read next line from file into strText
    Line Input #iniFileStream, fileText
    If Left(UCase(Trim(fileText)), 14) = "COPYJOBDETAILS" Then
      If Right(UCase(Trim(fileText)), 5) = "=TRUE" Then
        result = True
      End If
    End If
    DoEvents
  Wend
    
  Close #iniFileStream
  GetValueOfCopyJobDetailsSetting = result
End Function

Private Function SaveTransaction(ByRef transaction As ITransaction) As Integer
    Dim result As Integer
   
    result = transaction.Save(True)
    
    If (result <> ToolkitResult.success) Then
        MsgBox "The following error occured saving the Transaction:-" + _
               Chr(13) + Chr(13) + """" + toolkit.LastErrorString + """"
    End If
    
    SaveTransaction = result
End Function

Private Sub CloseAndFreeToolkit()
    toolkit.CloseToolkit
    Set toolkit = Nothing
End Sub

'ABSPLUG-2993 Start
'Reading the configuration file to get the UDF number
Private Sub ReadConfiguration(ByVal ComCod As String)
   Dim doc As New MSXML2.DOMDocument60
   Dim success As Boolean
   'ABSPLUG-3196 Added Error Handler
   On Error GoTo ExistFileErrorHandler
   
   success = doc.Load(App.path & "\PartialVATConfig.HTML")
   
   If success = True Then
    
      Dim nodeList As MSXML2.IXMLDOMNodeList
      Dim node As MSXML2.IXMLDOMNode
      'fetching company UDF node
      Set nodeList = doc.selectNodes("/CompanyConfigurations/CompanyConfig")
      
      For Each node In nodeList
      
            companyCode = node.selectSingleNode("CompanyCode").Text
            If UCase(Trim(ComCod)) = UCase(Trim(companyCode)) Then
            
                isUDF2ToBeCopied = node.selectSingleNode("UDF2").Text
                isUDF3ToBeCopied = node.selectSingleNode("UDF3").Text
                isUDF4ToBeCopied = node.selectSingleNode("UDF4").Text
                isUDF5ToBeCopied = node.selectSingleNode("UDF5").Text
                isUDF6ToBeCopied = node.selectSingleNode("UDF6").Text
                isUDF7ToBeCopied = node.selectSingleNode("UDF7").Text
                isUDF8ToBeCopied = node.selectSingleNode("UDF8").Text
                isUDF9ToBeCopied = node.selectSingleNode("UDF9").Text
                isUDF10ToBeCopied = node.selectSingleNode("UDF10").Text
            
            End If
      Next node
    End If
    Exit Sub
ExistFileErrorHandler:
    Err.Clear
End Sub

'Function to get the company code based on Exchequer path
Private Function GetExchequerCompanyCodeFromPath(ByVal path As String) As String
    Dim index As Integer
    Dim paths As String
    Dim title As String
    
    GetExchequerCompanyCodeFromPath = ""
    paths = ""
    
    For index = 1 To toolkit.Company.cmCount
        paths = paths & toolkit.Company.cmCompany(index).coPath
        If (Trim(UCase(toolkit.Company.cmCompany(index).coPath)) = Trim(UCase(path))) Then
            GetExchequerCompanyCodeFromPath = toolkit.Company.cmCompany(index).coCode
            Exit Function
        End If
    Next
    title = "Unable to find matching Exchequer company path : " & path & vbCrLf
    title = title & "Available paths are: " & vbCrLf & paths
    MsgBox title, vbInformation, "Exchequer company path not found"
End Function

'Assining Allowed Transaction line UDF values into Disallowed Vat Transaction line UDF values
Private Sub SetUDFValues(ByRef line As ITransactionLine5, ByRef newLine As ITransactionLine)
    
    If isUDF2ToBeCopied = True Then
        newLine.tlUserField2 = line.tlUserField2
    End If
    If isUDF3ToBeCopied = True Then
        newLine.tlUserField3 = line.tlUserField3
    End If
    If isUDF4ToBeCopied = True Then
        newLine.tlUserField4 = line.tlUserField4
    End If
    If isUDF5ToBeCopied = True Then
        newLine.tlUserField5 = line.tlUserField5
    End If
    
    If isUDF6ToBeCopied = True Then
        newLine.tlUserField6 = line.tlUserField6
    End If
    
    If isUDF7ToBeCopied = True Then
        newLine.tlUserField7 = line.tlUserField7
    End If
    
    If isUDF8ToBeCopied = True Then
        newLine.tlUserField8 = line.tlUserField8
    End If
    
    If isUDF9ToBeCopied = True Then
        newLine.tlUserField9 = line.tlUserField9
    End If
    
    If isUDF10ToBeCopied = True Then
        newLine.tlUserField10 = line.tlUserField10
    End If
    
End Sub

' Set default values to false for UDF to be copied flag
Private Sub SetUDFDefaultValue()
   isUDF2ToBeCopied = False
   isUDF3ToBeCopied = False
   isUDF4ToBeCopied = False
   isUDF5ToBeCopied = False
   isUDF6ToBeCopied = False
   isUDF7ToBeCopied = False
   isUDF8ToBeCopied = False
   isUDF9ToBeCopied = False
   isUDF10ToBeCopied = False
End Sub
'ABSPLUG-2993 End
