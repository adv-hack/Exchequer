VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   1920
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   1920
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCallDLL 
      Caption         =   "Call DLL"
      Height          =   1695
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCallDLL_Click()
    Dim oToolkit As Enterprise01.Toolkit
    Dim I1&, I2&, I3&
    Dim Res&
    
    ' Call the E32Exch DLL to get current backdoor code
    Call CalcCTKDebugMode(I1&, I2&, I3&)
  
    ' Run up COM Toolkit to check the code works
    Set oToolkit = CreateObject("Enterprise01.Toolkit")
    With oToolkit
        ' Disable Release Code / User Count mechanism
        Call .Configuration.SetDebugMode(I1&, I2&, I3&)
        
        ' Open the default company data set to test release code
        Res& = .OpenToolkit
        MsgBox "OpenToolkit: " + Str(Res&)
    End With ' oToolkit
    Set oToolkit = Nothing
End Sub

