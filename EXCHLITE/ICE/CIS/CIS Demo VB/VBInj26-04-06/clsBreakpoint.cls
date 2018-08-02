VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CBreakpoint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Class       :   CBreakpoint
'// Description :   This class represents a breakpoint that may be set on the submission process.
'//                 MsgFunction and MsqQualifer state at what part of the submission the break
'//                 should occur.  IsSet states whether the breakpoint is set or cleared.
'//
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'//

Option Explicit

' The function and qualifier of the XML on which to break
Private mstrFunction As String
Private mstrQualifier As String
' A name for the break point, must be unique
Private mstrName As String
' a description for the breakpoint - useful in the UI
Private mstrDescription As String
' Is the break point set of not?
Private mbSet As Boolean


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Class_Initialize()
'//         Initialise the object variables.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Class_Initialize()
    mbSet = False
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Let IsSet()
'//         Get/Set whether the break point is set or cleared.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get IsSet() As Boolean
    IsSet = mbSet
End Property
Public Property Let IsSet(bFlag As Boolean)
    mbSet = bFlag
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Let Name()
'//         Get/Set the unique name for the break point.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Name() As String
    Name = mstrName
End Property
Public Property Let Name(str As String)
    mstrName = str
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Let MsgFunction()
'//         Get/Set the GovTalk message function on which to break.  When the message function
'//         and qualifier of the breakpoint match a response from the Gateway server the
'//         application breaks to allow the new request to be reviewed or edited by the user.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get MsgFunction() As String
    MsgFunction = mstrFunction
End Property
Public Property Let MsgFunction(str As String)
    mstrFunction = str
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Let MsgQualifier()
'//         Get/Set the GovTalk message qualifier on which to break.  When the message function
'//         and qualifier of the breakpoint match a response from the Gateway server the
'//         application breaks to allow the new request to be reviewed or edited by the user.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get MsgQualifier() As String
    MsgQualifier = mstrQualifier
End Property
Public Property Let MsgQualifier(str As String)
    mstrQualifier = str
End Property

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Property Get/Let Description()
'//         Get/Set the description for the breakpoint.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Description() As String
    Description = mstrDescription
End Property
Public Property Let Description(str As String)
    mstrDescription = str
End Property


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Init()
'//         A convenience function to allow all the properties of the breakpoint to be
'//         initialised in one method call.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Public Sub Init(strName As String, strDescription As String, strFunction As String, strQualifier As String)
    IsSet = False
    Name = strName
    MsgFunction = strFunction
    MsgQualifier = strQualifier
    Description = strDescription
End Sub
