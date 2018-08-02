VERSION 5.00
Begin VB.Form frmPlugInConfiguration 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   5175
   ClientTop       =   3360
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   2  'CenterScreen
End
Attribute VB_Name = "frmPlugInConfiguration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public lBaseData As EnterpriseTrade.ITradeConnectionPoint

Private Sub Form_Activate()
    lBaseData.Functions.entActivateClient (Me.hwnd)
End Sub

