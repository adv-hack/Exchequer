Attribute VB_Name = "EntLinks"
Option Explicit


' Letters / Links record structure
Type TBatchLinkRec
  lkCodeLen              As String * 1
  lkCode                 As String * 6       ' Code of record which link is attached to if Cust, Supp or Emp
  lkPadChar1             As String * 1       ' Padding Character for Word Alignment
  lkFolioKey             As Long             ' folio number of record which link is attached to if Job, Stock or Transaction
  lkAttachTo             As String * 1       ' C - Customer, S - Supplier, E - employee, J - Job, S - Stock, T - Transaction
  lkLetterLink           As String * 1       ' L - letter, K - link
  lkLinkType             As Byte             ' 0 - document to 9 - Internet file
  lkDateLen              As String * 1
  lkDate                 As String * 8       ' Date of entry YYYYMMDD
  lkTimeLen              As String * 1
  lkTime                 As String * 8       ' Time of entry hh:mm:ss
  lkUserCodeLen          As String * 1
  lkUserCode             As String * 10      ' UserID

  lkLetterDescriptionLen As String * 1
  lkLetterDescription    As String * 100     ' Description if letter
  lkLetterFileNameLen    As String * 1
  lkLetterFileName       As String * 12      ' Filename if letter (excluding path)

  lkLinkDescriptionLen   As String * 1
  lkLinkDescription      As String * 60      ' Description if link
  lkLinkFileNameLen      As String * 1
  lkLinkFileName         As String * 84      ' Filename if link - includes full path
  lkSpare                As String * 211
  LastChar               As String * 1       ' Last Character in record - used for VB alignment
End Type ' TBatchLinkRec


' Initialises a Link Record to Zero / Empty String / False
Declare Function EX_INITLINK Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef LinkR As TBatchLinkRec, ByVal StructSize As Long) As Integer


' Allows Letters/Links to be read
Declare Function EX_GETLINK Lib "ENTDLL32.DLL" (P As TBatchLinkRec, _
                                                ByVal PSize As Long, _
                                                ByVal SearchKey As String, _
                                                ByVal SearchPath As Integer, _
                                                ByVal SearchMode As Integer, _
                                                ByVal LockRec As Integer) As Integer

' Allows Links to be added and updated
Declare Function EX_STORELINK Lib "ENTDLL32.DLL" (P As TBatchLinkRec, _
                                                  ByVal PSize As Long, _
                                                  ByVal SearchPath As Integer, _
                                                  ByVal SearchMode As Integer) As Integer
                       
' Allows existing Links to be deleted
Declare Function EX_DELETELINK Lib "ENTDLL32.DLL" (P As TBatchLinkRec, _
                                                   ByVal PSize As Long, _
                                                   ByVal SearchPath As Integer) As Integer

