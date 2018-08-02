VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Interface to Enterprise COM Customistation
Dim WithEvents oEntCustom As Enterprise.COMCustomisation
Attribute oEntCustom.VB_VarHelpID = -1

Private Sub Form_Load()
On Error GoTo GetExisting_Error
 
    Dim oEntCustom2 As ICOMCustomisation2
 
    ' Try to get a handle to an existing COM Customisation object
    Set oEntCustom = GetObject(, "Enterprise.COMCustomisation")
    
    GoTo Skip_GetExisting_Error
 
GetExisting_Error:

    ' Failed to connect to an existing COM Customisation object,
    ' create a new one
    Set oEntCustom = GetObject("", "Enterprise.COMCustomisation")

Skip_GetExisting_Error:
 
    With oEntCustom
        ' Enable Hooks
        Call .EnableHook(wiTransaction, 10)   ' Sales Daybook - Main Tab - Button 1
        Call .EnableHook(wiTransaction, 20)   ' Sales Daybook - Main Tab - Button 2
        
        ' Add Label Customisation for Custom Buttons using descendant object
        Set oEntCustom2 = oEntCustom
        ' simple label customisation
        Call oEntCustom2.AddLabelCustomisation(wiTransaction, 10, "SDBK - Main1")
        ' extended label customisation with font support
        Call oEntCustom2.AddLabelCustomisationEx(wiTransaction, 20, "SDBK - Main2", "Comic Sans MS", 10, True, True, True, False, 255, 0, 0)
        Set oEntCustom2 = Nothing
                
        ' Setup Info and Copyright message in Enterprise' Help-About dialog
        Call .AddAboutString("")
        Call .AddAboutString("Exchequer COM Label Customisation Demo")
        Call .AddAboutString("Build 100 for Enterprise v5.00")
        Call .AddAboutString("Copyright (c) 2001 Exchequer Software Ltd")
        Call .AddAboutString("")
        Call .AddAboutString(String(76, "-"))
    End With ' oEntCustom
End Sub

Private Sub oEntCustom_OnClose()
    Set oEntCustom = Nothing
    
    Unload Me
End Sub

