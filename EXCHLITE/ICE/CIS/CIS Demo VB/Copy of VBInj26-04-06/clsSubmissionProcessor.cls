VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSubmissionProcessor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Class       :   CSubmissionProcessor
'// Description :   This class is responsible for managing the submission process.  It
'//                 understands the submission protocol and the correct workflow required to
'//                 complete a submission.
'//                 The class maintains a record of all the GovTalk messages that we have sent
'//                 to the Gateway and the responses that the messages generated so that these may
'//                 be reviewed by the user.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'//

Option Explicit


Private Const MAX_ITERATIONS As Long = 20   ' max no. of times we hit the server

' possible Stats that the overall submission process can be in
Public Enum SubmissionState
    SS_INIT         ' newly initialised object, submission not yet started
    SS_PROCESSING   ' processing a submission
    SS_ERROR        ' an error has occurred during processing
    SS_FINISHED     ' processing of the submission has finished
End Enum


' The number of iterations that have been performed.
Private mlNumIterations As Long
' keep a record of all the request and response messages, so we can review them in the UI
Private mcolRequests As Collection
' Government gateway proxy object
Private mobjGateway As CGateway
' The current state of the submission
Private meSubmissionState As SubmissionState
' The submission format
Private meSubmissionFormat As MessageTransmissionFormat

' Hooks for debugging
Public Event BeforeSend(ByRef objRequest As CRequest, ByRef bAbort As Boolean)


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Initialize()
'//         Initialise the member variables.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
    meSubmissionState = SS_INIT
    meSubmissionFormat = FORMAT_XML
    Set mcolRequests = New Collection
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Begin()
'//         Start the processing of a new submission to the gateway
'//
'// Inputs: strXML - The GovTalk message as a string
'//         strPasswird - Authorisation password
'//         strUsername -
'//         strURL - URL of the Government Gateway we are calling.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Function Begin(ByVal strXML As String, ByVal strPassword As String, ByVal strUsername As String, ByVal strURL As String) As CResponse

    On Error GoTo Handler
    
    mlNumIterations = 1
    Dim A As Variant
    A = Array()

    ' Initialise the Gateway Proxy
    Set mobjGateway = New CGateway
    mobjGateway.URL = strURL
    mobjGateway.Username = strUsername
    mobjGateway.Password = strPassword
    
    
    ' Build our first request object
    Dim objRequest As CRequest
    Set objRequest = New CRequest
    objRequest.XML = strXML ' assign the GovTalk message to the REquest object
    objRequest.Message.TransmissionFormat = meSubmissionFormat
    If (meSubmissionFormat = FORMAT_HTML) Then
        objRequest.Message.Transformation = "HTML"
    Else
        objRequest.Message.Transformation = "XML"
    End If
    
    'Dim objUnform As MSXML2.DOMDocument
    'Set objUnform = New MSXML2.DOMDocument
    'Dim tmpString As String
    
    
    'objUnform.async = False
    
    'objUnform.loadXML (objRequest.XML)
    
    'A = Split(objUnform.XML, "£")
    
    objRequest.XML = Replace((objRequest.XML), "£", "&#163;")
    
    'objUnform.loadXML (tmpString)
    
    ' Submit the request to the server.  The Request object is updated to have a response attached to it
    SubmitRequest objRequest
    
    ' return the Response object
    Set Begin = objRequest.Response
    
    Exit Function
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Process()
'//         Continue processing this submission.  Build up a new GovTalk message to poll the
'//         Gateway for updates.  The message is based on the contents of the last message we
'//         received back from the server.  Specifically it must contain the Correlation ID that
'//         the Gateway gave us and should have appropriate Function and Qualifier elements based
'//         on the current state of the submission.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Function Process() As CResponse

    On Error GoTo Handler
    
    Dim objRequest As CRequest
    
    mlNumIterations = mlNumIterations + 1
    
    ' build new message
    Set objRequest = BuildRequest
    
    ' Submit the request to the server.  The Request object is updated to have a response attached to it
    SubmitRequest objRequest
    
    ' return the Response object
    Set Process = objRequest.Response
    
    Exit Function
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   SubmitRequest()
'//         Submit the specified request to the gateway for processing.
'//         This Sub also manages process state based on the response received from the Gateway.
'//
'// Inputs: objRequest - The request we are sending
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub SubmitRequest(ByRef objRequest As CRequest)

    Dim objResponse As CResponse

    ' fire the BeforeSend event to allow debugging
    Dim bAbort As Boolean
    bAbort = False
    RaiseEvent BeforeSend(objRequest, bAbort)
    
    If (bAbort) Then
        meSubmissionState = SS_FINISHED
        Err.Raise ERR_SUBMISSIONABORT, App.Title, ERR_SUBMISSIONABORT_MSG
        Exit Sub
    End If
    
    ' send a new request to the Gateway
    objRequest.Message.TransmissionFormat = meSubmissionFormat
    Set objResponse = mobjGateway.Send(objRequest.Message)
    Set objRequest.Response = objResponse ' store the response with the request object that generated it
    
    ' Add the request to the collection we maintain
    mcolRequests.Add objRequest
    
    ' set the overall state of the pricess based on the latest response
    UpdateSubmissionState
        
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   BuildRequest()
'//         Build up a new GovTalk request based on the contents of the last message we
'//         received back from the server.  Specifically it must contain the Correlation ID that
'//         the Gateway gave us and should have appropriate Function and Qualifier elements based
'//         on the current state of the submission.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Function BuildRequest() As CRequest
    On Error GoTo Handler
    
    Dim objRequest As CRequest
    Set objRequest = New CRequest
    
    objRequest.XML = TemplatePollDocument 'LastRequest.Message.XML ' add a templat GovTalk message to the request
    
    
    ' use the last response message...
    With LastRequest.Response.Message
        
        ' if a response end point was specified in the last reply, then we must use it for our next request
        If (.ResponseEndPoint <> "") Then
            mobjGateway.URL = .ResponseEndPoint
        End If
        
        
        Select Case .MsgQualifier
            Case QUALIFIER_ACK
                
                Select Case .MsgFunction
                    Case FUNCTION_DATA
                        ' Nothing to do - no such thing as a data_acknowledge
                        
                    Case FUNCTION_DELETE    ' delete_ack means we do a delete_request next time
                        '  No poll qualifier for delete function.  Just keep sending requests until we get a QUALIFIER_RES
                        objRequest.XML = TemplateDeleteDocument
                        objRequest.Message.MsgQualifier = QUALIFIER_REQ
                        objRequest.Message.MsgFunction = FUNCTION_DELETE
                        
                    Case FUNCTION_SUBMIT    ' submit_ack means we do a submit_poll next time
                        objRequest.Message.MsgQualifier = QUALIFIER_POL
                        objRequest.Message.MsgFunction = FUNCTION_SUBMIT
                    End Select
                
            Case QUALIFIER_ERR
                ' no new message to build
                
            Case QUALIFIER_RES
                ' a response qualifier in last Response object, means we have to move on to the next function
                
                Select Case .MsgFunction
                    Case FUNCTION_DATA
                        ' Data-response means we have finished with this submission
                        meSubmissionState = SS_FINISHED
                        
                    Case FUNCTION_DELETE
                        '  Nothing further to do.
                        meSubmissionState = SS_FINISHED
                        
                    Case FUNCTION_SUBMIT
                        objRequest.XML = TemplateDeleteDocument
                        objRequest.Message.MsgFunction = FUNCTION_DELETE
                        objRequest.Message.MsgQualifier = QUALIFIER_REQ
                    End Select
            
            Case Else
                ' THis should never happen
        
        End Select
        
        ' set common elements
        objRequest.Message.CorrelationID = .CorrelationID
        objRequest.Message.RoleValue = LastRequest.Message.RoleValue
        objRequest.Message.SenderID = LastRequest.Message.SenderID
        objRequest.Message.Class = LastRequest.Message.Class
        objRequest.Message.TransmissionFormat = meSubmissionFormat
        objRequest.Message.ResponseEndPoint = LastRequest.Message.ResponseEndPoint
        objRequest.Message.AuthenticationMethod = LastRequest.Message.AuthenticationMethod
        Set objRequest.Message.Keys = LastRequest.Message.Keys
        If (objRequest.Message.TransmissionFormat = FORMAT_HTML) Then
            objRequest.Message.Transformation = "HTML"
        Else
            objRequest.Message.Transformation = "XML"
        End If
        
        
        
    End With
    
    Set BuildRequest = objRequest
    
    Exit Function
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   UpdateSubmissionState()
'//         Review the contents of the current message and based on its contents and our
'//         knowledge of the protocol, set the state of the Submission Process overall.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub UpdateSubmissionState()

    On Error GoTo Handler

    If LastRequest.Response.State = SS_ERROR Or LastRequest.Response.State = SS_FINISHED Then
        ' If the last request generated an error, or completed the submission process, then we
        ' flag the submission process in line with that response.
        meSubmissionState = LastRequest.Response.State
        
        ' Note: In a real life app when the Gateway returns an error we would probably choose to
        ' re-submit our lat request.
    Else
    
        ' do some checks to make sure the response correlates against the request --------------
    
        ' if we supplied a correlation ID, then the Gateway must have replied using the same ID
        If (LastRequest.Message.CorrelationID <> "") Then
            If (LastRequest.Message.CorrelationID <> LastRequest.Response.Message.CorrelationID) Then
                meSubmissionState = SS_ERROR
                LastRequest.Response.State = SS_ERROR
                LastRequest.Response.StateText = "The response Correlation ID did not match the Correlation ID of the request."
                Exit Sub
            End If
        End If
        
        ' we must make sure that the Function the Gateway replied to, is the one we sent
        If (LastRequest.Message.MsgFunction <> LastRequest.Response.Message.MsgFunction) Then
            meSubmissionState = SS_ERROR
            LastRequest.Response.State = SS_ERROR
            LastRequest.Response.StateText = "The response function did not match the requested function."
            Exit Sub
        End If
        
        
        ' No errors, so now determine what part of submission process we are in and set submission state accordingly
        Select Case LastRequest.Response.Message.MsgQualifier
            Case QUALIFIER_ACK  ' an acknowlegement always means we have more processing to do
                meSubmissionState = SS_PROCESSING
                
            Case QUALIFIER_ERR  ' an error from the server
                ' we flag the error on the process, and cease processing.  In a real life app
                ' when the Gateway returns an error we would probably choose to re-submit our
                ' last request
                
                meSubmissionState = SS_ERROR
                
            Case QUALIFIER_RES  ' a response message means the Gateway has processed the request fully.
                ' What we do next is dependent of what request the gateway was responding to...
                Select Case LastRequest.Message.MsgFunction
                    Case FUNCTION_DATA, FUNCTION_DELETE
                        ' a response to a delete or data request completes the processing of these requests
                        meSubmissionState = SS_FINISHED
                    
                    Case FUNCTION_SUBMIT
                        ' a response to a submit request is not the end of the line - we still have
                        ' a delete request to submit.
                        meSubmissionState = SS_PROCESSING
                        
                End Select
            
        End Select
        
    End If
    
    ' finally, if we are out of permitted iterations, then set state to finished, even though the submission is incomplete.
    ' We do this simply to keep the leghth of time that this sample application runs for to a reasonable limit.  In a real
    ' life application we would keep polling the Gateway until the submission was completed successfully.
    If mlNumIterations >= MAX_ITERATIONS Then
        meSubmissionState = SS_FINISHED
    End If
    
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get State()
'//         Get the state of the submission process.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get State() As SubmissionState
    State = meSubmissionState
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get LastRequest()
'//         Convenience property to return the most recent request object we sent to the gateway.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get LastRequest() As CRequest
    On Error GoTo Handler
    
    Set LastRequest = mcolRequests(mcolRequests.Count)
    
    Exit Property
Handler:
    Set LastRequest = Nothing
    
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get Request()
'//         Get the specified request object from the collection of requests we have sent to the
'//         gateway.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Request(ByVal Index As Long) As CRequest
    Set Request = mcolRequests(Index)
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get TemplatePollDocument()
'//         Get an empty template GovTalk document suitable for Poll messages.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Property Get TemplatePollDocument() As String
    ' A template document EmptySubmissionPoll.xml was installed in the Docs subdirectory
    
    Dim strTemp As String
    Dim lFile As Integer
    
    lFile = FreeFile
    
    ' Open the specified document for input
    Open App.Path & "\WorkingSubmissionPoll.xml" For Input As lFile
        
    ' Loop through the document adding an entry line by line
    Do While Not EOF(lFile)
        Line Input #lFile, strTemp
        TemplatePollDocument = TemplatePollDocument & strTemp & vbCrLf
    Loop
    
    Close lFile

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get TemplateDeleteDocument()
'//         Get an empty template GovTalk document suitable for Poll messages.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Property Get TemplateDeleteDocument() As String
    ' A template document EmptyDeleteRequest.xml was installed in the Docs subdirectory
    
    Dim strTemp As String
    Dim lFile As Integer
    
    lFile = FreeFile
    
    ' Open the specified document for input
    Open App.Path & "\WorkingDeleteRequest.xml" For Input As lFile
        
    ' Loop through the document adding an entry line by line
    Do While Not EOF(lFile)
        Line Input #lFile, strTemp
        TemplateDeleteDocument = TemplateDeleteDocument & strTemp & vbCrLf
    Loop
    
    Close lFile

End Property

Public Property Let SubmissionFormat(data As MessageTransmissionFormat)
    meSubmissionFormat = data
End Property


