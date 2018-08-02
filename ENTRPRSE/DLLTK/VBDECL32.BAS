Attribute VB_Name = "Module1"
' VB5 Test Functions
Declare Sub TESTCU Lib "VBRecTst.DLL" (AccRec As TBatchCURec, ByVal PSIZE As Long)
Declare Sub TESTTH Lib "VBRecTst.DLL" (InvRec As TBatchTHRec, ByVal PSIZE As Long)
Declare Sub TESTTL Lib "VBRecTst.DLL" (LineRec As TBatchTLRec, ByVal PSIZE As Long)
Declare Sub TESTTLINES Lib "VBRecTst.DLL" (Lines As TBatchLinesRec, ByVal PSIZE As Long)
Declare Sub TESTSB Lib "VBRecTst.DLL" (SaleBand As TSaleBandsRec, ByVal PSIZE As Long)
Declare Sub TESTSA Lib "VBRecTst.DLL" (SalesArray As TSaleBandAry, ByVal PSIZE As Long)
Declare Sub TESTSK Lib "VBRecTst.DLL" (Stock As TBatchSKRec, ByVal PSIZE As Long)
Declare Sub TESTHB Lib "VBRecTst.DLL" (HistBal As THistoryBalRec, ByVal PSIZE As Long)
Declare Sub TESTNM Lib "VBRecTst.DLL" (Nom As TBatchNomRec, ByVal PSIZE As Long)
Declare Sub TESTBOM Lib "VBRecTst.DLL" (Bom As TBatchBOMRec, ByVal PSIZE As Long)
Declare Sub TESTBOMLINES Lib "VBRecTst.DLL" (Lines As TBatchBOMLinesRec, ByVal PSIZE As Long)
Declare Sub TESTSR Lib "VBRecTst.DLL" (Serial As TBatchSRRec, ByVal PSIZE As Long)
Declare Sub TESTJH Lib "VBRecTst.DLL" (JobHed As TBatchJHRec, ByVal PSIZE As Long)
Declare Sub TESTSL Lib "VBRecTst.DLL" (SL As TBatchSLRec, ByVal PSIZE As Long)
Declare Sub TESTML Lib "VBRecTst.DLL" (Location As TBatchMLocRec, ByVal PSIZE As Long)
Declare Sub TESTMATCH Lib "VBRecTst.DLL" (Match As TBatchMatchRec, ByVal PSIZE As Long)
Declare Sub TESTNOTES Lib "VBRecTst.DLL" (NOTE As TBatchNotesRec, ByVal PSIZE As Long)
Declare Sub TESTCD Lib "VBRecTst.DLL" (CCDep As TBatchCCDepRec, ByVal PSIZE As Long)
Declare Sub TESTSTKPR Lib "VBRecTst.DLL" (Price As TBatchStkPriceRec, ByVal PSIZE As Long)
Declare Sub TESTVAT Lib "VBRecTst.DLL" (VATRate As TBatchVATRec, ByVal PSIZE As Long)
Declare Sub TESTSYS Lib "VBRecTst.DLL" (SysRec As TBatchSysRec, ByVal PSIZE As Long)
'Declare Sub TESTAUTOBANK Lib "VBRecTst.DLL" (ABRec As TBatchAutoBankRec, ByVal PSIZE As Long)
Declare Sub TESTLINK Lib "VBRecTst.DLL" (ABRec As TBatchLinkRec, ByVal PSIZE As Long)
Declare Sub TESTBIN Lib "VBRecTst.DLL" (ABRec As TBatchBinRec, ByVal PSIZE As Long)

Type ArrayRecType
    NumStrLen       As String * 1
    NumStr          As String * 10
End Type

Type ArrayType
    Recs(1 To 100)  As ArrayRecType
End Type


Declare Sub TESTARRAY Lib "VBRecTst.DLL" (P() As ArrayRecType, ByVal PSIZE As Long)
                     
