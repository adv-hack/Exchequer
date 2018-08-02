Attribute VB_Name = "EntMCM"

Option Explicit

Type TCompanyType
    CompCodeLen   As String * 1
    CompCode      As String * 6     ' Company Code
    CompNameLen   As String * 1
    CompName      As String * 45    ' Company Name
    CompPathLen   As String * 1
    CompPath      As String * 100   ' Company Path - Short DOS 8.3 Format

    CompSpare     As String * 100
End Type ' TCompanyType

Type TCompanyArray
    Companies(1 To 10) As TCompanyType
End Type ' TCompanyArray

Declare Function EX_GETCOMPANY Lib "ENTCOMP2.DLL" (ByVal CompDir As String, PArray As TCompanyArray, ByRef PArraySize As Long) As Integer

'------------------------------------------

Type TCompanyType2
    CompCodeLen     As String * 1
    CompCode        As String * 6     ' Company Code
    CompNameLen     As String * 1
    CompName        As String * 45    ' Company Name
    CompPathLen     As String * 1
    CompPath        As String * 100   ' Company Path - Short DOS 8.3 Format
    CompConnectLen  As String * 1
    CompConnect     As String * 255   ' Connection Information

    CompSpare     As String * 100
End Type ' TCompanyType2

Type TCompanyArray2
    Companies(1 To 10) As TCompanyType2
End Type ' TCompanyArray2

Declare Function EX_GETCOMPANY2 Lib "ENTCOMP2.DLL" (ByVal CompDir As String, PArray As TCompanyArray2, ByRef PArraySize As Long) As Integer

