VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CResponse"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Class       :   CResponse
'// Description :   This class represents a response from the Government Gateway.  It wraps a
'//                 CMessage object that is the XML GovTalk message (if any) returned by the
'//                 gateway.  It also provides status information from the HTTP request/response
'//                 protocol and client-side state information based on the response.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'//



Option Explicit

' The version of the GovTalk message protocol that we understand
Private Const ENVELOPE_VERSION As String = "1.0"
Private Const ENVELOPE_VERSION2 As String = "2.0"


' Member variables -------------------------------------------------------------------------------
Private mstrStatusCode As String    ' HTTP status code
Private mstrStatusText As String    ' HTTP status text

Private mState As SubmissionState   ' The client-side state of this response
Private mstrStateText As String     ' a description of the state

' The GovTalk Message
Private mobjMessage As CMessage


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Initialize()
'//         Initialise member variables.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
    mState = SS_INIT
    
    Set mobjMessage = New CMessage
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Terminate()
'//         Object cleanup.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Terminate()
    Set mobjMessage = Nothing
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let/Get State()
'//         Get / Set the client-side state that this gateway response XML results in.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let State(ByVal State As SubmissionState)
    mState = State
End Property
Public Property Get State() As SubmissionState
    State = mState
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let/Get HTTPStatus()
'//         Get / Set HTTP status code returned from the gateway server in the HTTP header.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let HTTPStatus(ByVal strCode As String)
    mstrStatusCode = strCode
End Property
Public Property Get HTTPStatus() As String
    HTTPStatus = mstrStatusCode
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let/Get HTTPStatusText()
'//         Get / Set HTTP status text returned from the gateway server in the HTTP header.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let HTTPStatusText(ByVal strText As String)
    mstrStatusText = strText
End Property
Public Property Get HTTPStatusText() As String
    HTTPStatusText = mstrStatusText
End Property

Public Property Get StateText() As String
    StateText = mstrStateText
End Property
Public Property Let StateText(str As String)
    mstrStateText = str
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let/Get XML()
'//         Get / Set response text returned by the gateway server.  This should be XML, but in
'//         the case of errors it could theoretically be HTML.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let XML(ByVal strXML As String)

    On Error GoTo Handler:
    
    Set mobjMessage = New CMessage
    
    mobjMessage.XML = strXML
    
    'Validate the XML doc is a GovTalk response message
    Validate
    
    Exit Property
Handler:
    State = SS_ERROR
    If strXML = "" Then
        mstrStateText = "No data returned from Gateway."
    Else
        mstrStateText = "The data returned from Gateway could not be parsed - it may not be XML.  Check the HTTP response code for errors."
    End If
    
End Property

Public Property Get XML() As String
    On Error GoTo Handler
    
    XML = mobjMessage.XML
    
    Exit Property
Handler:
    XML = ""
End Property

Public Property Let ResponseText(data As String, Format As MessageTransmissionFormat)

    On Error GoTo Handler
    
    Set mobjMessage = New CMessage
    
    mobjMessage.TransmissionFormat = Format

    mobjMessage.MsgText = data

    'Validate the XML doc is a GovTalk response message
    Validate
    
    Exit Property
Handler:
    State = SS_ERROR
    If data = "" Then
        mstrStateText = "No data returned from Gateway."
    Else
        mstrStateText = "The data returned from Gateway could not be parsed - it may not be XML.  Check the HTTP response code for errors."
    End If
   
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Set Message()
'//         Get / Set the GovTalk XML message object that we wrap
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Set Message(ByVal obj As CMessage)
    Set mobjMessage = obj
End Property

Public Property Get Message() As CMessage
    Set Message = mobjMessage
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Validate()
'//         Check that the XML returned by the Gateway is a valid GovTalk XML document.
'//         We first check that the response text is XML, then check various elements of the XML
'//         docuemnt to make sure that i. they exists and ii. they have information in them that
'//         complies with the protocol rules.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Validate()

    On Error GoTo Handler
    
    If (HTTPStatus <> "200") Then
        State = SS_ERROR
        mstrStateText = "An HTTP error occurred when transmitting the message."
        Exit Sub
    End If

    Dim strXML As String
    strXML = Me.XML ' if this fails or gives us an empty string, then the server probably retruned HTML
    
    ' initialise state
    State = SS_PROCESSING
    
    If strXML = "" Then
        State = SS_ERROR
        mstrStateText = "Could not parse data returned from gateway."
        Exit Sub
    End If

    ' If we get to this point, then we know we have valid XML
    ' Let's assume we have a valid GovTalk document loaded in the Response object
    ' Extract various data elements and check the context
    
    ' Check the Gateway is responding with the version of the protocol that we understand
    If mobjMessage.EnvelopeVersion <> ENVELOPE_VERSION And mobjMessage.EnvelopeVersion <> ENVELOPE_VERSION2 Then
        State = SS_ERROR
        mstrStateText = "The GovTalk Envelope version was either missing, or incompatible with this application. (version: " & mobjMessage.EnvelopeVersion & ")"
        Exit Sub
    End If
    
    
    ' Qualifier ---
    If mobjMessage.MsgQualifier = "" Then
        State = SS_ERROR
        mstrStateText = "Message Qualifier is missing."
        Exit Sub
    End If
    
    ' check for error response from Gateway server
    If mobjMessage.MsgQualifier = QUALIFIER_ERR Then
        State = SS_ERROR
        mstrStateText = mobjMessage.ErrorCode & ": " & mobjMessage.ErrorText
        Exit Sub
    End If
    
    ' Function
    If mobjMessage.MsgFunction = "" Then
        State = SS_ERROR
        mstrStateText = "Message Function is missing."
        Exit Sub
    End If
    
    
    ' Correlation ID, we must have a correlation ID, unless we are doing a data request
    If (mobjMessage.MsgFunction <> FUNCTION_DATA) Then
        If (mobjMessage.CorrelationID = "") Then
            State = SS_ERROR
            mstrStateText = "Correlation ID is missing."
            Exit Sub
        End If
    End If
    
    ' for DATA function, the Poll Interval is not required, for others it is.
    If (mobjMessage.MsgFunction <> FUNCTION_DATA) Then
        ' Poll Interval ( and by definition Response End Point - since it is an attribute of this node)
        If (mobjMessage.PollInterval <= 0) Then
            ' poll interval must be present & positive
            State = SS_ERROR
            mstrStateText = "PollInterval is either missing or invalid."
        End If
    End If
    
    Exit Sub
Handler:
    State = SS_ERROR
    mstrStateText = "Could not parse the data returned from Gateway."
    
    
End Sub

