Attribute VB_Name = "Module2"
Option Explicit

Type TBatchBinRec
  brBinCodeLen           As String * 1
  brBinCode              As String * 10
  brInDocRefLen          As String * 1
  brInDocRef             As String * 10
  brOutDocRefLen         As String * 1
  brOutDocRef            As String * 10
  PadChar1               As String * 1
  brSold                 As Integer
  brInDateLen            As String * 1
  brInDate               As String * 8     'Date bought yyyymmdd
  PadChar2               As String * 3
  brCostPrice            As Double        'Original cost
  brCapacity             As Double        'capacity of bin
  brStockFolio           As Long       'folio number of stock
  brOutDateLen           As String * 1
  brOutDate              As String * 8
  PadChar3               As String * 3
  brOutDocLine           As Long
  brInDocLine            As Long
  brQty                  As Double
  brQtyUsed              As Double
  brUsedRec              As Integer
  brInLocationLen        As String * 1
  brInLocation           As String * 10
  brOutLocationLen       As String * 1
  brOutLocation          As String * 10
  PadChar4               As String * 2
  brOutOrderRefLen       As String * 1
  brOutOrderRef          As String * 10
  brInOrderRefLen        As String * 1
  brInOrderRef           As String * 10
  brInOrderLine          As Long
  brOutOrderLine         As Long
  brCostPriceCurrency    As Integer
  brPickingPriorityLen   As String * 1
  brPickingPriority      As String * 10
  PadChar5               As String * 3
  brSalesPrice           As Double
  brCompanyRate          As Double
  brDailyRate            As Double
  brUseORate             As Integer
  PadChar6               As String * 2
  brTriRates             As Double
  brTriEuro              As Integer
  brTriInvert            As Integer
  brTriFloat             As Integer
  brUseByDateLen         As String * 1
  brUseByDate            As String * 10
  PadChar7               As String * 1
  brSalesPriceCurrency   As Integer
  brUnitOfMeasurementLen As String * 1
  brUnitOfMeasurement    As String * 10
  PadChar8               As String * 1
  brAutoPickMode         As Integer  'Auto pick settings - 0 Normal, 1 Lock bin, 2 Match bin by tagno
  brTagNo                As Integer
  brRecPos               As Long
  Spare                  As String * 515
  LastChar               As String * 1
End Type

Declare Function EX_GETMULTIBIN Lib "ENTDLL32.DLL" (P As TBatchBinRec, ByVal PSize As Long, ByVal SearchPath As Integer, ByVal SearchMode As Integer, ByVal LockRec As Integer) As Integer
Declare Function EX_STOREMULTIBIN Lib "ENTDLL32.DLL" (P As TBatchBinRec, ByVal PSize As Long, ByVal SearchPath As Integer, ByVal SearchMode As Integer) As Integer
Declare Function EX_USEMULTIBIN Lib "ENTDLL32.DLL" (P As TBatchBinRec, ByVal PSize As Long) As Integer
Declare Function EX_UNUSEMULTIBIN Lib "ENTDLL32.DLL" (P As TBatchBinRec, ByVal PSize As Long) As Integer

