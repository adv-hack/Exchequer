Attribute VB_Name = "Constants"
Option Explicit

' Application specific errors
Public Const ERR_INVALIDXML As Long = vbObjectError + 1
Public Const ERR_INVALIDXML_MSG As String = "The specified XML cannot be parsed."
Public Const ERR_SUBMISSIONABORT As Long = vbObjectError + 2
Public Const ERR_SUBMISSIONABORT_MSG As String = "The submission was aborted by the user."


' GovTalk message types and sub-types
Public Const FUNCTION_SUBMIT As String = "submit"
Public Const FUNCTION_DELETE As String = "delete"
Public Const FUNCTION_DATA As String = "list"
Public Const QUALIFIER_POL As String = "poll"
Public Const QUALIFIER_REQ As String = "request"
Public Const QUALIFIER_ACK As String = "acknowledgement"
Public Const QUALIFIER_ERR As String = "error"
Public Const QUALIFIER_RES As String = "response"

'application names
Public Const APPLICATION_NAME As String = "Government Gateway Sample Client"
Public Const g_strLINENO As String = " Line No: "
