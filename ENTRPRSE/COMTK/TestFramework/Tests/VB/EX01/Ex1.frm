VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Exercise 1 - Create COM Toolkit"
   ClientHeight    =   810
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   810
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oToolkit As Enterprise04.Toolkit
Dim FResult As Long
Dim FStatus As Integer
Dim h As Long

Private Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, _
                                                                        ByVal wMsg As Long, _
                                                                        ByVal wParam As Integer, _
                                                                        ByVal lParam As Long) As Integer


Private Sub Form_Load()
    Dim Res&
    Dim s() As String
    Dim oTrans As ITransaction
    
    
    FStatus = 201 ' Invalid Params until we've checked them
    Res& = 0
    
    If Command <> "" Then
      s = Split(Command, " ")
      
      If UBound(s) > 2 Then
    
          h = s(0)
        
        
        ' Create COM Toolkit object
          Set oToolkit = CreateObject("Enterprise04.Toolkit")
            
          With oToolkit
              ' open toolkit
              .Configuration.DataDirectory = s(2)
              Res& = .OpenToolkit&
            
              If Res& = 0 Then
                FStatus = 200 ' Params & Toolkit OK
                
                Res& = .Transaction.GetLessThanOrEqual(.Transaction.BuildAccountIndex("SIN999999"))
                
                
                If Res& = 0 Then
                  Set oTrans = .Transaction.Update
                
                  If Not (oTrans Is Nothing) Then
                    oTrans.thYourRef = "Test 1"
                  
                    Res& = oTrans.Save(True)
                  End If
                End If
              Else
                FStatus = 202 ' Problem with opening Toolkit
              End If
            
          End With ' oToolkit
      End If
    End If
    
    FResult = Res&
    Unload Me
End Sub

Private Sub Form_Unload(Cancel As Integer)

  Dim b As Boolean
  
    ' Close Company Data and remove reference to COM Toolkit
    oToolkit.CloseToolkit
    Set oToolkit = Nothing
    
    If h <> 0 Then
      b = PostMessage(h, 32869, FStatus, FResult)
    End If
End Sub
