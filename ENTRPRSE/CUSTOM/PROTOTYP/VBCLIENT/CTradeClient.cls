VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTradeClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' COM Object implements a descendant of the Trade Counter Customisation Class ITradeClient
Implements ITradeClient

' Local Reference to Base Object within the Trade Counter Customisation System
Dim oBaseData As EnterpriseTrade.ITradeConnectionPoint


' Called by Trade Counter when the user clicks the optional Setup button in Help|About
Private Sub ITradeClient_OnConfigure(ByVal Config As EnterpriseTrade.ITradeConfiguration)
    ' Create configuration window and setup a local reference to the Config object
    Load frmPlugInConfiguration
    Set frmPlugInConfiguration.lBaseData = oBaseData
    
    ' Display the Config window
    frmPlugInConfiguration.Show 1
    
    ' Remove local reference to Config object and destroy the window
    Set frmPlugInConfiguration.lBaseData = Nothing
    Unload frmPlugInConfiguration
    
    ' Return window focus back to the Trade Counter
    Call SetForegroundWindow(oBaseData.Functions.fnTradehWnd)
End Sub


' Called by Trade Counter whenever an enabled Hook Point is reached
Private Sub ITradeClient_OnCustomEvent(ByVal EventData As EnterpriseTrade.ITradeEventData)
    With EventData
        If (.edWindowId = twiTransaction) And (.edHandlerId = 1) Then
            ' Exit Edit 1
            .Transaction.Edit1 = FormatDateTime(Time, vbShortTime)
        ElseIf (.edWindowId = twiTransaction) And (.edHandlerId = 101) Then
            ' Custom Button 1
            .Transaction.Edit1 = "CuBtn1"
            .Transaction.Edit2 = ""
            .Transaction.Edit3 = ""
        ElseIf (.edWindowId = twiTransaction) And (.edHandlerId = 102) Then
            ' Custom Button 1
            .Transaction.Edit1 = ""
            .Transaction.Edit2 = "CuBtn2"
            .Transaction.Edit3 = ""
        End If
    End With ' EventData
End Sub


' Called by Trade Counter for Label Customisation e.g. Custom Buttons
Private Sub ITradeClient_OnCustomText(ByVal CustomText As EnterpriseTrade.ITradeCustomText)
    With CustomText
        If (.ctWindowId = twiTransaction) And (.ctTextId = 101) Then
            ' Custom Button 1 Caption
            .ctText = "Btn1"
        ElseIf (.ctWindowId = twiTransaction) And (.ctTextId = 102) Then
            ' Custom Button 2 Caption
            .ctText = "Btn2"
        End If
    End With ' CustomText
End Sub


Private Sub ITradeClient_OnShutdown()
    ' Remove reference to permanent connection object otherwise the
    ' Trade Counter won't unload properly
    Set oBaseData = Nothing
End Sub


Private Sub ITradeClient_OnStartup(ByVal BaseData As EnterpriseTrade.ITradeConnectionPoint)
    ' Make local reference to Base Object within the Trade Counter Customisation System
    ' NOTE: Reference MUST be removed in OnShutdown
    Set oBaseData = BaseData
       
    ' Using the Base Object setup the Help|About info and define the Hooks/Text to be used
    With oBaseData
        ' Define the Customisation Features supported by this Plug-In
        .piCustomisationSupport = "v1.00/CONFIG"
        
        ' Setup properties for Help|About Display in Trade Counter
        .piName = "Trade Counter Test Client (VB6)"
        .piVersion = "v5.00.002 (VB-EXE)"
        .piAuthor = "Exchequer Software Ltd."
        .piCopyright = "Copyright © Exchequer Software Ltd 1986-2002"
        .piSupport = "Contact your Enterprise helpline number"
        
        ' Enable Hook Points
        .piHookPoints(twiTransaction, 1) = thsEnabled       ' Exit Edit1
        
        ' Custom Button 1
        .piHookPoints(twiTransaction, 101) = thsEnabled     ' Enable Hook Point
        .piCustomText(twiTransaction, 101) = thsEnabled     ' Enable Custom Text
        
        ' Custom Button 2
        .piHookPoints(twiTransaction, 102) = thsEnabled     ' Enable Hook Point
        .piCustomText(twiTransaction, 102) = thsEnabled     ' Enable Custom Text
    End With ' oBaseData
End Sub


