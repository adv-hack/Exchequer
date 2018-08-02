VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Class       :   CMessage
'// Description :   This class represents a GovTalk message.  It provides a wrapper for the XML
'//                 DOM Document that is the GovTalk XML message itself.
'//                 The class provides a number of properties for getting and setting common
'//                 GovTalk document elements, eg Function, Qualifier, CorrelationID etc.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'//


Option Explicit

' XPATH query strings to access specific Nodes of the GovTalk message
Private Const XPATH_QUALIFIER As String = "/GovTalkMessage/Header/MessageDetails/Qualifier"
Private Const XPATH_FUNCTION As String = "/GovTalkMessage/Header/MessageDetails/Function"
Private Const XPATH_CORRELATIONID As String = "/GovTalkMessage/Header/MessageDetails/CorrelationID"
Private Const XPATH_ERROR_CODE As String = "/GovTalkMessage/GovTalkDetails/GovTalkErrors/Error/Number"
Private Const XPATH_ERROR_TEXT As String = "/GovTalkMessage/GovTalkDetails/GovTalkErrors/Error/Text"
Private Const XPATH_RESPONSEENDPOINT As String = "/GovTalkMessage/Header/MessageDetails/ResponseEndPoint"
Private Const XPATH_ENVELOPE_VERSION As String = "/GovTalkMessage/EnvelopeVersion"
Private Const XPATH_CLASS As String = "/GovTalkMessage/Header/MessageDetails/Class"
Private Const XPATH_GATEWAYTEST As String = "/GovTalkMessage/Header/MessageDetails/GatewayTest"
Private Const XPATH_TRANSFORMATION As String = "/GovTalkMessage/Header/MessageDetails/Transformation"
Private Const XPATH_ROLEVALUE As String = "/GovTalkMessage/Header/SenderDetails/IDAuthentication/Authentication/Value"
Private Const XPATH_SENDERID As String = "/GovTalkMessage/Header/SenderDetails/IDAuthentication/SenderID"
Private Const XPATH_METHOD As String = "/GovTalkMessage/Header/SenderDetails/IDAuthentication/Authentication/Method"
Private Const XPATH_KEYS As String = "/GovTalkMessage/GovTalkDetails/Keys"
Private Const XPATH_GOVTALKDETAILS As String = "/GovTalkMessage/GovTalkDetails"


' The possible formats we can send a receive a message in
Public Enum MessageTransmissionFormat
    FORMAT_XML
    FORMAT_HTML
    FORMAT_TEXT
End Enum


Private meTransmissionFormat As MessageTransmissionFormat
' The text of the message in the format specified by meTransmissionFormt
Private mstrMessageText As String
' DOM Document object created from mstrMessageText
Private mobjDocument As MSXML2.DOMDocument






'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Initialize()
'//         Initialise the variables.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
    meTransmissionFormat = FORMAT_XML
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Terminate()
'//         Clean up the object.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Terminate()
    Set mobjDocument = Nothing
End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let XML()
'//         Assign an XML string to the object.
'//
'// Inputs: strXML - the XML string
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let XML(ByVal strXML As String)
    On Error GoTo Handler

    mstrMessageText = strXML
    
    ' Call the DOcument property to load the XML into the DOM, and make sure it is valid XML
    Dim doc As DOMDocument
    Set doc = Document
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get XML()
'//         Return the XML document as a string.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get XML() As String
    On Error GoTo Handler
    
   
    XML = Document.XML  ' The DOM object holds the master copy, in case any nodes have been altered
  
    Exit Property
    
    
Handler:
    XML = ""
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get MsgText()
'//         Returns the raw text of the messsage that the object was set-up with.  This is useful
'//         if the message represents a response, and the response is invalid (hence the XML
'//         property get returns and empty string).
'//         Note that if the object contains valid XML and the object Set properties MsgQualifier,
'//         MsgFunction etc have been used, then this functon will not return XML reflecting these
'//         changes.  Use the XML property instead.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get MsgText() As String

    MsgText = mstrMessageText

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let MsgText()
'//         Sets the raw text of the messsage. This is often HTML with embeedded base 64 xml
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let MsgText(str As String)

    On Error GoTo Handler

    mstrMessageText = str
    
    ' Call the DOcument property to load the XML into the DOM, and make sure it is valid XML
    Dim doc As DOMDocument
    Set doc = Document
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get Document()
'//         Get the DOM Document object for the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Property Get Document() As DOMDocument
    On Error GoTo Handler
    
    ' If a DOM object has not yet been created for this XML string then create one
    If (mobjDocument Is Nothing) Then
        Set mobjDocument = New DOMDocument
        
        ' Set properties of the XMLDOM to peform validation while we wait
        mobjDocument.async = False
        mobjDocument.validateOnParse = True
        'mobjDocument.Validate = False
        
        
        If Not mobjDocument.loadXML(DecodeResponseText) Then  ' and load the XML into the Document object
            Err.Raise ERR_INVALIDXML, App.EXEName, ERR_INVALIDXML_MSG & ": " & mobjDocument.parseError.reason
        End If
    End If
    
    Set Document = mobjDocument
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
    
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name: URLEncode
'// URL Encodes a Base-64 encoded string
'// Note this does not do full URL encoding - it only encodes those characters = / and = that can occur in a Base84 string
'/////////////////////////////////////////////////////////////////////////////////////////////////
Function URLEncode(strSource As String)

    Dim str As String
    
    str = Replace(strSource, "+", "%2B")
    str = Replace(str, "/", "%2F")
    str = Replace(str, "=", "%3D")
    
    URLEncode = str
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   URLDecode
'//  Decodes a URL Encoded Base-64 encoded string to return a Base64 encoded string
'/////////////////////////////////////////////////////////////////////////////////////////////////
Function URLDecode(strSource)

    Dim str As String
    
    str = Replace(strSource, "%2B", "+")
    str = Replace(str, "%2F", "/")
    str = Replace(str, "%3D", "=")
    
    URLDecode = str

End Function


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   DecodeResponseText()
'//         Decode the response message from the Gateway to return the XML
'//         GovTalk message only.  For XML posts, we don't need to do
'//         anything special.  For HTML posts, we need to extract the
'//         Base 64 encoded block and decode to give us the XML..
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Function DecodeResponseText() As String

    On Error GoTo Handler

    Dim strReturn As String
    Dim strSearch As String
    Dim objDoc As MSXML2.DOMDocument
    
    strSearch = "value="""
    Set objDoc = New MSXML2.DOMDocument
    

    If TransmissionFormat = FORMAT_XML Then
        strReturn = mstrMessageText
    Else
    
        ' need to try to decode the response HTML
        Dim strEncodedText As String
        strEncodedText = URLDecode(mstrMessageText)
        
        ' HTML is NOT case-sensitive, so first we have to convert to lowercase to make searching easier.
        Dim strLowerCase As String
        strLowerCase = LCase(strEncodedText)
        
        ' locate the element with the B64 block
        Dim lFormStart As Long
        lFormStart = InStr(strLowerCase, "<input")
        
        Dim lBase64BlockStart As Long
        lBase64BlockStart = InStr(lFormStart, strLowerCase, strSearch) + Len(strSearch)
        
        Dim lBase64BlockEnd As Long
        lBase64BlockEnd = InStr(lBase64BlockStart, strLowerCase, """")
        
        ' we now know where the Base 64 block starts and ends, so we can decode
        ' note we are using the mixed case text here
        strReturn = b64Decode(Mid$(strEncodedText, lBase64BlockStart, lBase64BlockEnd - lBase64BlockStart))
        
    End If
    
    'objDoc.loadXML(strReturn)
    
    DecodeResponseText = strReturn
    Exit Function
    
Handler:
    DecodeResponseText = ""
End Function


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   EncodeRequestText()
'// Notes   Get the text of the message exactly as it needs to be sent to
'//         the Gateway.  For XML posts, we don't need to do anything
'//         special.  FOr HTML posts, we need to Base 64 encode the XML
'//         and embed it in a HTML block.
'// Returns The request message, exactly as it needs to be sent.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Function EncodeRequestText() As String
    Dim returnText As String

    If (meTransmissionFormat = FORMAT_XML) Then
        returnText = Document.XML
    Else
        returnText = "GATEWAYDATA=" & URLEncode(b64Encode(Document.XML))
        
    End If
    
    EncodeRequestText = returnText
End Function


Public Property Let TransmissionFormat(data As MessageTransmissionFormat)
    meTransmissionFormat = data
    
End Property

Public Property Get TransmissionFormat() As MessageTransmissionFormat
    TransmissionFormat = meTransmissionFormat
End Property

' get the message in the right format for transmission
Public Function GetMessageForTransmission() As String

    On Error GoTo Handler

    Select Case TransmissionFormat
        Case FORMAT_HTML
            GetMessageForTransmission = EncodeRequestText
            
        Case FORMAT_XML
            GetMessageForTransmission = Document.XML
        
    
    End Select
    
    Exit Function
    
Handler:
    
    GetMessageForTransmission = ""
End Function





'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get MsgQualifier()
'//         Get the Function Qualifier from the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get MsgQualifier() As String
    On Error GoTo Handler
    
    MsgQualifier = ElementText(XPATH_QUALIFIER)
    
    Exit Property
Handler:
    MsgQualifier = ""


End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let MsgQualifier()
'//         Set the Function Qualifier in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let MsgQualifier(str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Correlation ID
    Set node = Document.selectSingleNode(XPATH_QUALIFIER)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get MsgFunction()
'//         Get the Function string from the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get MsgFunction() As String
    On Error GoTo Handler
    
    MsgFunction = ElementText(XPATH_FUNCTION)
    
    Exit Property
Handler:
    MsgFunction = ""


End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get Keys()
'//         Get the Keys string from the GovTalk Details of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Keys() As IXMLDOMNode
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode
    
    Set node = Document.selectSingleNode(XPATH_KEYS)
    Set Keys = node
    
    Exit Property
Handler:
    Set Keys = Nothing

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Set Keys()
'//         Set the Keys element in the GovTalk Details of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Set Keys(newNode As IXMLDOMNode)
    On Error GoTo Handler
    
    Dim parent As IXMLDOMNode
    
    Set parent = Document.selectSingleNode(XPATH_GOVTALKDETAILS)
    
    If Me.Keys Is Nothing Then
        ' must create the Keys element
        parent.appendChild newNode
    
    Else
        parent.replaceChild newNode, Me.Keys
    End If
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let MsgFunction()
'//         Set the Function String in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let MsgFunction(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Correlation ID
    Set node = Document.selectSingleNode(XPATH_FUNCTION)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get CorrelationID()
'//         Get the Correlation ID from the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get CorrelationID() As String
    On Error GoTo Handler
    
    CorrelationID = ElementText(XPATH_CORRELATIONID)
    
    Exit Property
Handler:
    CorrelationID = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let CorrelationID()
'//         Set the Correlation ID in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let CorrelationID(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Correlation ID
    Set node = Document.selectSingleNode(XPATH_CORRELATIONID)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get ErrorCode()
'//         Get the GovTalk error code, if any.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get ErrorCode() As String
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Correlation ID
    Set node = Document.selectSingleNode(XPATH_ERROR_CODE)
    ErrorCode = node.Text
    
    Exit Property
Handler:
    ErrorCode = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get ErrorText()
'//         Get the GovTalk error text, if any.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get ErrorText() As String
    On Error GoTo Handler
    
    ErrorText = ElementText(XPATH_ERROR_TEXT)
    
    Exit Property
Handler:
    ErrorText = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get EnvelopeVersion()
'//         Get the GovTalk Envelope Version string.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get EnvelopeVersion() As String
    On Error GoTo Handler
    
    EnvelopeVersion = ElementText(XPATH_ENVELOPE_VERSION)
    
    Exit Property
Handler:
    EnvelopeVersion = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get ResponseEndPoint()
'//         Get the ResponseEndPoint that specifies the URL to use in the next request.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get ResponseEndPoint() As String
    On Error GoTo Handler
    
    ResponseEndPoint = ElementText(XPATH_RESPONSEENDPOINT)
    
    Exit Property
Handler:
    ResponseEndPoint = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let ResponseEndPoint()
'//         Set the Class in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let ResponseEndPoint(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_RESPONSEENDPOINT)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get Class()
'//         Get the Class of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Class() As String
    On Error GoTo Handler
    
    Class = ElementText(XPATH_CLASS)
    
    Exit Property
Handler:
    Class = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let Class()
'//         Set the Class in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let Class(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_CLASS)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get GatewayTest()
'//         Get the GatewayTest text of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get GatewayTest() As String
    On Error GoTo Handler
    
    GatewayTest = ElementText(XPATH_GATEWAYTEST)
    
    Exit Property
Handler:
    GatewayTest = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let GatewayTest()
'//         Set the GatewayTest element in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let GatewayTest(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_GATEWAYTEST)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get Transformation()
'//         Get the Transformation text of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Transformation() As String
    On Error GoTo Handler
    
    Transformation = ElementText(XPATH_TRANSFORMATION)
    
    Exit Property
Handler:
    Transformation = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let Transformation()
'//         Set the Transformation element in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let Transformation(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_TRANSFORMATION)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get RoleValue()
'//         Get the Value text of the Role of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get RoleValue() As String
    On Error GoTo Handler
    
    RoleValue = ElementText(XPATH_ROLEVALUE)
    
    Exit Property
Handler:
    RoleValue = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let RoleValue()
'//         Set the Value element of the Role in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let RoleValue(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_ROLEVALUE)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get AuthenticationMethod()
'//         Get the Value text of the Role of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get AuthenticationMethod() As String
    On Error GoTo Handler
    
    AuthenticationMethod = ElementText(XPATH_METHOD)
    
    Exit Property
Handler:
    AuthenticationMethod = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let AuthenticationMethod()
'//         Set the Value element of the Role in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let AuthenticationMethod(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the Class
    Set node = Document.selectSingleNode(XPATH_METHOD)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get SenderID()
'//         Get the SenderID text of the Role of the message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get SenderID() As String
    On Error GoTo Handler
    
    SenderID = ElementText(XPATH_SENDERID)
    
    Exit Property
Handler:
    RoleValue = ""

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Let SenderID()
'//         Set the Sender ID text in the GovTalk header of the XML message.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Let SenderID(ByVal str As String)
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the node holding the SenderID
    Set node = Document.selectSingleNode(XPATH_SENDERID)
    node.Text = str
    
    Exit Property
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Property



'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get PollInterval()
'//         Get the GovTalk polling interval in milliseconds
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get PollInterval() As Long
    On Error GoTo Handler
    
    Dim str As String
    Dim lInterval As Long
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the specified node
    Set node = Document.selectSingleNode(XPATH_RESPONSEENDPOINT)
    str = node.Attributes.getNamedItem("PollInterval").Text ' and then get the attribute
    
    lInterval = Val(str)    ' protocol returns us poll interval in seconds
    
    PollInterval = lInterval * 1000 ' convert to millisec, since that's what VB uses internally
    
    Exit Property
Handler:
    PollInterval = 0

End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get ElementText()
'//         Get the text of the specified element in the GovTalk message, or empty string if not
'//         found
'//
'// Inputs: strQuery - XPATH query for the required element
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get ElementText(strQuery As String) As String
    On Error GoTo Handler
    
    Dim node As IXMLDOMNode

    ' Use an XPATH query to select the specified node
    Set node = Document.selectSingleNode(strQuery)
    ElementText = node.Text
    
    Exit Property
Handler:
    ElementText = ""

End Property




