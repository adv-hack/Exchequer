Option Explicit

Global HeaderRec As TBatchTHRec
Global TranLines As TBatchLinesRec
Global AccFlag As Integer

Function ConvDate (DLLDate As String) As String
    ConvDate = Mid$(DLLDate, 7, 2) + "/" + Mid$(DLLDate$, 5, 2) + "/" + Mid$(DLLDate$, 1, 4)
End Function

