Attribute VB_Name = "EntTLArray"
Option Explicit

Type TLArrayInfoType
    TLArray      As Long           ' Pointer to variable size array
    NumTL        As Long           ' Number of lines added into array
    UsedSize     As Long           ' Total Memory used by added lines
    MaxTL        As Long           ' Maximum number of lines that can be stored
    TLSize       As Long           ' Total memory allocated for TLArray
    Spare        As String * 203
    LastChar     As String * 1     ' Last Character in record - used for VB alignment
End Type ' TLArrayInfoType

' functions for building TLArray structure
Declare Function EX_CREATETLARRAY Lib "ENTDLL32.DLL" (ByVal MaxLines As Long, TLArray As TLArrayInfoType) As Integer
Declare Function EX_ADDTLARRAYLINE Lib "ENTDLL32.DLL" (TLArrayInfo As TLArrayInfoType, TL As TBatchTLRec) As Integer
Declare Sub EX_DESTROYTLARRAY Lib "ENTDLL32.DLL" (TLArrayInfo As TLArrayInfoType)

' Existing function with modified declaration for use with the TLArray functions
Declare Function EX_STORETLARRAY Lib "ENTDLL32.DLL" Alias "EX_STORETRANS" (P As TBatchTHRec, ByVal PL As Long, ByVal PSIZE As Long, ByVal PLSize As Long, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer) As Integer

' v4.31 - Wrapper function around EX_GETTRANS which supports Transaction Line Arrays
Declare Function EX_GETTLARRAY Lib "ENTDLL32.DLL" (P As TBatchTHRec, ByVal PSIZE As Long, TLArray As TLArrayInfoType, ByVal SEARCHKEY As String, ByVal SEARCHPATH As Integer, ByVal SEARCHMODE As Integer, ByVal LockRec As Integer) As Integer

' v4.31 - Function to get a line from a Transaction Line Array
Declare Function EX_GETTLARRAYLINE Lib "ENTDLL32.DLL" (TLArray As TLArrayInfoType, ByRef TL As TBatchTLRec, ByVal TLSize As Long, ByVal LineNo As Long) As Integer

' v4.31 - Function to edit a line in a Transaction Line Array
Declare Function EX_EDITTLARRAYLINE Lib "ENTDLL32.DLL" (TLArray As TLArrayInfoType, ByRef TL As TBatchTLRec, ByVal ArrayLineNo As Long) As Integer


