Attribute VB_Name = "EntForms"
Option Explicit

'
' Enterprise Paperless Module - Toolkit Interface
'

' ======================================================================

' List of Enterprise Form Numbers for use with TDefaultFormRecType

' Customer/Supplier Account Details            1
' Customer/Supplier Trading History            2
' Customer/Supplier Labels                     3
' Customer/Supplier Sales Statement            4
' Supplier Remittance Advice                   5
' Sales Invoice (SIN)                          6
' Sales Invoice with Receipt (SRI)             7
' Sales Credit Note (SCR)                      8
' Sales Credit with Refund (SRF)               9
' Sales Quotation (SQU)                       10
' Sales Order (SOR/SQU)                       11
' Sales Pro-Forma (SQU)                       12
' Sales Delivery Note (SDN/SQU)               13
' Sales Receipt (SRC)                         14
' Sales Journal Invoice (SJI)                 15
' Sales Journal Credit (SJC)                  16
' Consolidated Picking List                   17
' Individual Picking List                     18
' Sales Consignment Note                      19
' Sales Delivery Label                        20
' Product Labels for Delivery Run             21
' Purchase Invoice (PIN)                      22
' Purchase Credit Note (PCR)                  23
' Purchase Quotation (PQU)                    24
' Purchase Order (POR)                        25
' Purchase Journal Invoice (PJI)              26
' Purchase Journal Credit (PJC)               27
' Purchase Payment with Invoice (PPI)         28
' Purchase Refund (PRF)                       29
' Stock Record with Bill Of Materials List    30
' Stock Record with Notes                     31
' Stock Adjustment (ADJ)                      32
' Nominal Transfer (NOM)                      33
' Sales/Purchase Batch Entry                  34
' Time Sheet                                  35
' Backing Sheet                               36
' Job Record                                  37
' Debt Chase Letter 1                         38
' Debt Chase Letter 2                         39
' Debt Chase Letter 3                         40
' Purchase Payment (Remittance Advice)(PPY)   41
' Purchase Delivery Note (PDN)                42
' Email Cover Sheet                           43
' Fax Cover Sheet                             44
' Sales Receipt Details (SRC)                 45
' Purchase Payment Debit Note (PPY)           46
' Self Billing Sub Contractor Invoice (PJI)   47

' ======================================================================

' Structure for retrieving default FormName for a Customer/Supplier Account
Type TDefaultFormRecType
  dfAccountLen     As String * 1
  dfAccount        As String * 6          ' Optional Account Code
  dfPadChar1       As String * 1          ' Padding Character for Word Alignment
  dfFormNo         As Integer             ' Requested form number - see above
  dfCheckGlobal    As Integer             ' Boolean - Check global formset if no formset form defined
  dfFormNameLen    As String * 1
  dfFormName       As String * 8          ' Returned Form Name
  dfSpare          As String * 100
  dfLastChar       As String * 1          ' Last Character in record - used for VB alignment
End Type ' TDefaultFormRecType

' Returns the form name for a specific task for a customer or globally
Declare Function EX_DEFAULTFORM Lib "ENTDLL32.DLL" (P As TDefaultFormRecType, ByVal PSIZE As Long) As Integer
Declare Function EX_INITDEFAULTFORM Lib "ENTDLL32.DLL" Alias "EX_INITSTRUCTURE" (ByRef DFRM As TDefaultFormRecType, ByVal StructSize As Long) As Integer

' ======================================================================


' ======================================================================

' Structure containing 'Print To Email' details
Type TEmailPrintInfoType
  emPreview         As Integer             ' Boolean - True=Preview Window, False=Send email
  emCoverSheetLen   As String * 1
  emCoverSheet      As String * 8          ' Cover Sheet form name
  emSenderNameLen   As String * 1
  emSenderName      As String * 50         ' Sender Name e.g. Exchequer Software Ltd
  emSenderAddrLen   As String * 1
  emSenderAddr      As String * 50         ' Sender Email Address e.g. Accounts@Exchequer.Com
  emSubjectLen      As String * 1
  emSubject         As String * 255        ' Email Subject
  emPadChar1        As String * 1          ' Padding Character for Word Alignment
  emPriority        As Integer             ' 0=Ignore, 1=Normal, 2=Urgent
  emSendReader      As Integer             ' 0=Don't Send Reader, 1=Send Reader, 2=Send Read + Insert Text Help
  emCompress        As Integer             ' Boolean - True = Compress attached forms in PK-ZIP file
  emSpare           As String * 201
  emLastChar        As String * 1          ' Last Character in record - used for VB alignment
End Type ' TEmailPrintInfoType

' Initialises a set of email details with the Cover Sheet, Sender and User Signature, and
' if a valid Account code is entered it will also set the ToRecip and SendReader and
' Compression flags to the correct customer settings.
Declare Function EX_DEFAULTEMAILDETS Lib "ENTDLL32.DLL" (P As TEmailPrintInfoType, _
                                                         ByVal PSIZE As Long, _
                                                         ByVal ToRecip As String, _
                                                         ByVal CCRecip As String, _
                                                         ByVal BCCRecip As String, _
                                                         ByVal MsgText As String, _
                                                         ByVal UserCode As String, _
                                                         ByVal ACCODE As String) As Integer

' Replacement for Ex_PrintForm allowing the Paperless Module Email Interface to be used
Declare Function EX_PRINTTOEMAIL Lib "ENTDLL32.DLL" (P As TEmailPrintInfoType, _
                                                     ByVal PSIZE As Long, _
                                                     ByVal ToRecip As String, _
                                                     ByVal CCRecip As String, _
                                                     ByVal BCCRecip As String, _
                                                     ByVal MsgText As String, _
                                                     ByVal Attachments As String) As Integer

' ======================================================================

' Internal type used to keep all email info together in Demo Program
Type EmailPrintingInfoType
    PrintInfo As TEmailPrintInfoType
    
    ToRecip As String * 255         ' To Recipients in Name;Addr;Name;Addr;... format
    CCRecip As String * 255         ' CC Recipients in Name;Addr;Name;Addr;... format
    BCCRecip As String * 255        ' Blank CC Recipients in Name;Addr;Name;Addr;... format
    MsgText As String * 10000       ' Message text including line breaks. Max 10k from v4.31.004, previously 255 characters.
    Attachments As String * 255     ' File Attachments in Filepath;Filepath;... format
End Type ' EmailPrintingInfoType

' ======================================================================

' Initialises the Form Printing subsystem in the Toolkit DLL
Declare Function EX_INITPRINTFORM Lib "ENTDLL32.DLL" (ByVal DataPath As String) As Integer

' Terminates the Form Printing subsystem
Declare Sub EX_ENDPRINTFORM Lib "ENTDLL32.DLL" ()

' Adds a Transaction Form into the list of forms to print
Declare Function EX_ADDTRANSFORM Lib "ENTDLL32.DLL" (ByVal RefNo As String, ByVal FORMNAME As String) As Integer

' Adds a Customer Statement into the list of forms to print
Declare Function EX_ADDACSTATFORM Lib "ENTDLL32.DLL" (ByVal ACCODE As String, ByVal FORMNAME As String) As Integer

' Prints the current list of forms to Printer or Preview
Declare Function EX_PRINTFORM Lib "ENTDLL32.DLL" (ByVal PREVIEWSTAT As Integer, ByVal NOOFCOPIES As Integer) As Integer


