Attribute VB_Name = "EntJCost"
Option Explicit

'---------------------------------------------------------------------------------------

' Job Record
Type TBatchJHRec
    JobCodeLen    As String * 1
    JobCode       As String * 10    ' Job Code
    JobDescLen    As String * 1
    JobDesc       As String * 30    ' Job Description
    PadChar1      As String * 2     ' Padding Characters for Word Alignment
    JobFolio      As Long           ' Job Folio No
    CustCodeLen   As String * 1
    CustCode      As String * 6     ' Customer Code
    JobCatLen     As String * 1
    JobCat        As String * 10    ' Job Category
    JobAltCodeLen As String * 1
    JobAltCode    As String * 10    ' Job Alternative Code
    PadChar2      As String * 1     ' Padding Characters for Word Alignment
    Completed     As Integer        ' Completed Status
    ContactLen    As String * 1
    Contact       As String * 25    ' Contact Person
    JobManLen     As String * 1
    JobMan        As String * 25    ' Manager Name
    ChargeType    As String * 1     ' Type of Charge
    PadChar3      As String * 3     ' Padding Characters for Word Alignment
    QuotePrice    As Double         ' Quote Price
    CurrPrice     As Integer        ' Currency of Price
    StartDateLen  As String * 1
    StartDate     As String * 8     ' Job Start Date
    EndDateLen    As String * 1
    EndDate       As String * 8     ' Job End Date
    RevEDateLen   As String * 1
    RevEDate      As String * 8     ' Revised Completion Date
    SORRefLen     As String * 1
    SORRef        As String * 10    ' Sales Order No.
    VATCode       As String * 1     ' VAT Code
    JobAnalLen    As String * 1
    JobAnal       As String * 3     ' Job Analysis Code
    JobType       As String * 1     ' Job Type
    JobStat       As String * 1     ' Status of Job
    
    ' *** v4.31 10/12/99
    UserDef1Len   As String * 1
    UserDef1      As String * 20
    UserDef2Len   As String * 1
    UserDef2      As String * 20
    
    ' 21/10/2011 - v6.9 User Defined Fields 3-10
    UserDef3Len   As String * 1
    UserDef3      As String * 20
    UserDef4Len   As String * 1
    UserDef4      As String * 20
    
    UserDef5Len   As String * 1
    UserDef5      As String * 30
    UserDef6Len   As String * 1
    UserDef6      As String * 30
    UserDef7Len   As String * 1
    UserDef7      As String * 30
    UserDef8Len   As String * 1
    UserDef8      As String * 30
    UserDef9Len   As String * 1
    UserDef9      As String * 30
    UserDef10Len  As String * 1
    UserDef10     As String * 30

' 07/10/2013 - v7.0.6 CC/Dept
    jrCostCentreLen As String * 1
    jrCostCentre    As String * 3
    jrDepartmentLen As String * 1
    jrDepartment    As String * 3

    Spare         As String * 22
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type

'---------------------------------------------------------------------------------------

Type TBatchJobAnalRec
    JAnalCodeLen As String * 1
    JAnalCode    As String * 10  ' Job Analysis Code
    JAnalDescLen As String * 1
    JAnalDesc    As String * 30  '  "     "     Description
    JAnalType    As String * 1   '  "     "     Type
    JAnalCatry   As String * 1   '  "     "     Category
    WIPNomCode   As Long         '  "     "     WIP Nominal Code
    PLNomCode    As Long         '  "     "     P&L Nominal Code
    LineType     As String * 1   '  "     "     Line Type

    CISTaxRate   As String * 1   ' Taxable activity CIS Rate
    PadChar      As String * 2
    UpliftP      As Double       ' Uplift on cost %
    UpliftGL     As Long         ' Uplift GL Code + reversal
    RevenueType  As Byte         ' Link to Revenue activity for valuation
    jaPayCodeLen As String * 1
    jaPayCode    As String * 5

    Spare        As String * 252
    LastChar     As String * 1     ' Last Character in record - used for VB alignment
End Type ' TBatchJobAnalRec

'---------------------------------------------------------------------------------------

' Employee/Global Rates
Type TBatchJobRateRec
    JEmpCodeLen     As String * 1
    JEmpCode        As String * 10     ' Employee Code
    JRateCodeLen    As String * 1
    JRateCode       As String * 10     ' Job Rate Code
    JRateDescLen    As String * 1
    JRateDesc       As String * 30     ' Job Rate Description
    JAnalCodeLen    As String * 1
    JAnalCode       As String * 10     ' Job Analysis Code
    CostCurr        As Integer         ' Time Cost Currency
    PadChar1        As String * 2      ' Padding Character for Word Alignment
    Cost            As Double          ' Time Cost
    ChargeCurr      As Integer         ' Time Charge Currency
    PadChar2        As String * 2      ' Padding Character for Word Alignment
    ChargeRate      As Double          ' Time Charge Rate
    PayRollCode     As Integer         ' Payroll Code
    
    ' Added 19.02.2001
    PayFactor       As Integer         ' Payroll Factor Code
    PayRate         As Integer         ' Payroll Rate Code
    
    Spare           As String * 197
    LastChar        As String * 1      ' Last Character in record - used for VB alignment
End Type ' TBatchJobRateRec

'---------------------------------------------------------------------------------------

Type TBatchEmplRec
    EmpCodeLen    As String * 1
    EmpCode       As String * 6     ' Employee Code
    SupplierLen   As String * 1
    Supplier      As String * 6     ' Supplier Code
    EmpNameLen    As String * 1
    EmpName       As String * 30    ' Employee Name
    Addr(1 To 5)  As AddrType
    PhoneLen      As String * 1
    Phone         As String * 20    ' Telephone
    FaxLen        As String * 1
    Fax           As String * 20    ' Fax
    MobileLen     As String * 1
    Mobile        As String * 20    ' Mobile
    EmpType       As String * 1     ' Employee Type P/S/O

    PayNoLen      As String * 1
    PayNo         As String * 10    ' Payroll No
    CertNoLen     As String * 1
    CertNo        As String * 30    ' Certificate No
    CertExpiryLen As String * 1
    CertExpiry    As String * 8     '     "      Expiry Date
    PadChar1      As String * 1     ' Padding Character for Word Alignment
    UseORate      As Integer        ' Use pay rates setup for employee only
    UserDef1Len   As String * 1
    UserDef1      As String * 20    ' User Defined Field 1
    UserDef2Len   As String * 1
    UserDef2      As String * 20    ' User Defined Field 2
    CCLen         As String * 1
    CC            As String * 3     ' Default Cost Centre
    DepLen        As String * 1
    Dep           As String * 3     ' Default Dept

    ' 28/11/2002
    SelfBill      As Integer
    GroupCert     As Integer        ' Company Group CIS 6 Certificate}
    CertType      As String * 1     ' Certificate type N, 4, 5, 6
    UserDef3Len   As String * 1
    UserDef3      As String * 20    ' User Defined Field 1
    UserDef4Len   As String * 1
    UserDef4      As String * 20    ' User Defined Field 2
    ENINoLen      As String * 1
    ENINo         As String * 10    ' National Ins No UK/ Serial No IRL?

    ' 16/06/03 - v5.51
    LabourPLOnly  As Integer        ' Bool: True=Labour entered via PIN, False=Labour entered via TSH
    
    'v6.3
    emEmailAddressLen As String * 1
    emEmailAddress    As String * 100

    Spare         As String * 154
    LastChar      As String * 1     ' Last Character in record - used for VB alignment
End Type ' TBatchEmplRec

'---------------------------------------------------------------------------------------

Type TBatchJobTypeRec
    JTypeCodeLen As String * 1
    JTypeCode    As String * 3       ' Job type code
    JTypeDescLen As String * 1
    JTypeDesc    As String * 30      ' Job type description

    Spare        As String * 220
    LastChar     As String * 1       ' For VB alignment
End Type ' TBatchJobTypeRec

'---------------------------------------------------------------------------------------

' Job Costing functions
Declare Function EX_GETJOB Lib "ENTDLL32.DLL" (P As TBatchJHRec, ByVal PSIZE As Long, ByVal SearchKey As String, ByVal SearchPath As Integer, ByVal SearchMode As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_INITJOB Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef JobR As TBatchJHRec, ByVal StructSize As Long) As Integer

Declare Function EX_STOREJOB Lib "ENTDLL32.DLL" (P As TBatchJHRec, _
                                                 ByVal PSIZE As Long, _
                                                 ByVal SearchPath As Integer, _
                                                 ByVal SearchMode As Integer) As Integer

Declare Function EX_GETJOBEMPLOYEE Lib "ENTDLL32.DLL" (P As TBatchEmplRec, ByVal PSIZE As Long, ByVal SearchKey As String, ByVal SearchPath As Integer, ByVal SearchMode As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_GETJOBTIMERATE Lib "ENTDLL32.DLL" (P As TBatchJobRateRec, ByVal PSIZE As Long, ByVal SearchPath As Integer, ByVal SearchMode As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_INITTIMERATE Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef TIMERATE As TBatchJobRateRec, ByVal StructSize As Long) As Integer
