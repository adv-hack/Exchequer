Attribute VB_Name = "EntFuncs"
Option Explicit


Type ShortString
    StrLen     As Byte 'String * 1
    StrChars   As String * 255
End Type ' ShortString


Declare Function EntVersion Lib "EntFuncs.Dll" () As ShortString

Declare Function EntDefaultLogin Lib "EntFuncs.Dll" (ByRef UserId As ShortString, _
                                                     ByRef PWord As ShortString) As Integer

Declare Function EntConvertInts Lib "EntFuncs.Dll" (ByVal Int2%, ByVal Int4&) As Double

Declare Function EntDocSign Lib "EntFuncs.Dll" (DocType As ShortString) As Integer

Declare Function EntCustValue Lib "EntFuncs.Dll" (ByVal WantValue As Integer, _
                                                        Company As ShortString, _
                                                        CustCode As ShortString, _
                                                  ByVal Year As Integer, _
                                                  ByVal Period As Integer, _
                                                        CustBal As Double) As Integer

Declare Function EntGLValue Lib "EntFuncs.Dll" (ByVal WantValue As Integer, _
                                                ByVal SubType As Integer, _
                                                      Company As ShortString, _
                                                ByVal GLCode As Long, _
                                                ByVal Year As Integer, _
                                                ByVal Period As Integer, _
                                                ByVal ExCurrency As Integer, _
                                                      CCDep As ShortString, _
                                                ByVal Committed As Integer, _
                                                      GLBal As Double) As Integer
                                                     
Declare Function EntStockValue Lib "EntFuncs.Dll" (ByVal WantValue As Integer, _
                                                         Company As ShortString, _
                                                         StkCode As ShortString, _
                                                         LocCode As ShortString, _
                                                   ByVal Year As Integer, _
                                                   ByVal Period As Integer, _
                                                   ByVal ExCurrency As Integer, _
                                                         StkBal As Double) As Integer

Declare Function EntJCSummCat Lib "EntFuncs.Dll" (ByVal WantValue As Integer, _
                                                        Company As ShortString, _
                                                        TotalStr As ShortString) As Integer

Declare Function EntJobBudgetValue Lib "EntFuncs.Dll" (ByVal WantValue As Integer, _
                                                             Company As ShortString, _
                                                             JobCode As ShortString, _
                                                       ByVal HistFolio As Long, _
                                                       ByVal Year As Integer, _
                                                       ByVal Period As Integer, _
                                                       ByVal ExCurrency As Integer, _
                                                       ByVal Commit As Integer, _
                                                             HistVal As Double) As Integer

Declare Function EntStockQty Lib "EntFuncs.Dll" (Company As ShortString, _
                                                 StockCode As ShortString, _
                                                 LocCode As ShortString, _
                                                 HistVal As Double) As Integer

Declare Function EntSaveGLValue Lib "EntFuncs.Dll" (ByVal SaveValue As Integer, _
                                                    ByVal SubType As Integer, _
                                                          Company As ShortString, _
                                                    ByVal GLCode As Long, _
                                                    ByVal Year As Integer, _
                                                    ByVal Period As Integer, _
                                                    ByVal ExCurrency As Integer, _
                                                          CCDep As ShortString, _
                                                          NewBudget As Double) As Integer

Declare Sub EntFuncsShutDown Lib "EntFuncs.Dll" ()

