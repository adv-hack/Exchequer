Attribute VB_Name = "Module1"
Option Explicit

Type TCompanyType
    CompCodeLen  As String * 1
    CompCode     As String * 6       ' Company Code
    CompNameLen  As String * 1
    CompName     As String * 45      ' Company Name
    CompPathLen  As String * 1
    CompPath     As String * 100     ' Company Path - Short DOS 8.3 Format

    CompSpare    As String * 100
End Type ' TCompanyType

Type TCompanyArray
    Companies(1 To 4) As TCompanyType
End Type ' TCompanyArray

Declare Function EX_GETCOMPANY Lib "ENTCOMP.DLL" (ByVal COMPDIR As String, PARRAY As TCompanyArray, PARRAYSIZE As Long) As Integer

