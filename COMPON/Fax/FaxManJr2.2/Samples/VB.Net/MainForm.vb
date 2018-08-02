Imports Microsoft.VisualBasic
Imports System
Imports System.Text
Imports System.Drawing
Imports System.Drawing.Printing
Imports System.Collections
Imports System.ComponentModel
Imports System.Windows.Forms
Imports System.Data
Imports System.Diagnostics
Imports System.IO
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Formatters.Binary

Imports DataTech.FaxManJr
Imports DataTech.FaxManNet


Namespace JrNetTest
	''' <summary>
	''' Summary description for Form1.
	''' </summary>
	Public Class Form1
		Inherits System.Windows.Forms.Form
		Private mainMenu1 As System.Windows.Forms.MainMenu
		Private menuItem1 As System.Windows.Forms.MenuItem
		Private WithEvents mnuReceive As System.Windows.Forms.MenuItem
		Private WithEvents mnuCancel As System.Windows.Forms.MenuItem
		Private WithEvents mnuSend As System.Windows.Forms.MenuItem
		Private WithEvents mnuListen As System.Windows.Forms.MenuItem
		Private mnuDevices As System.Windows.Forms.MenuItem
		Private WithEvents mnuAutoDetect As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestSwitchModem As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestBlindSend As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestImportNada As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestBlindReceive As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestBlindAutoDetect As System.Windows.Forms.MenuItem
		Private WithEvents mnuBlindListen As System.Windows.Forms.MenuItem
		Private WithEvents mnuSend1000Faxes As System.Windows.Forms.MenuItem
		Private WithEvents mnuTestStopBatchSend As System.Windows.Forms.MenuItem
		Private menuItem6 As System.Windows.Forms.MenuItem
		Private mnuTesting As System.Windows.Forms.MenuItem
		Private mnuSettings As System.Windows.Forms.MenuItem
		Private mnuExceptions As System.Windows.Forms.MenuItem
		Private menuItem4 As System.Windows.Forms.MenuItem
		Private mnuResolution As System.Windows.Forms.MenuItem
		Private WithEvents mnuResolutionLow As System.Windows.Forms.MenuItem
		Private WithEvents mnuResolutionHigh As System.Windows.Forms.MenuItem
		Private mnuStation As System.Windows.Forms.MenuItem
		Private WithEvents mnuStationID As System.Windows.Forms.MenuItem
		Private mnuFilePrint As System.Windows.Forms.MenuItem
		Private WithEvents mnuInstallPrinter As System.Windows.Forms.MenuItem
		Private WithEvents mnuPrintTestPage As System.Windows.Forms.MenuItem
		Private WithEvents faxPrint1 As DataTech.FaxManNet.FaxPrint
		Private menuItem5 As System.Windows.Forms.MenuItem
		Private WithEvents mnuKBase As System.Windows.Forms.MenuItem
		Private WithEvents mnuUpdateCenter As System.Windows.Forms.MenuItem
		Private WithEvents mnuBadDevice As System.Windows.Forms.MenuItem
		Private mnuClass As System.Windows.Forms.MenuItem
		Private mnuInit As System.Windows.Forms.MenuItem
		Private mnuReset As System.Windows.Forms.MenuItem
		Private menuItem11 As System.Windows.Forms.MenuItem
		Private WithEvents mnuClass1 As System.Windows.Forms.MenuItem
		Private WithEvents mnuClass2 As System.Windows.Forms.MenuItem
		Private WithEvents mnuClass20 As System.Windows.Forms.MenuItem
		Private WithEvents mnuInitString As System.Windows.Forms.MenuItem
		Private WithEvents mnuResetString As System.Windows.Forms.MenuItem
		Private mnuDeviceSettings As System.Windows.Forms.MenuItem
		Private WithEvents mnuShowMessages As System.Windows.Forms.MenuItem
		Private WithEvents tabMessageOrView As System.Windows.Forms.TabControl
		Private lbMessages As System.Windows.Forms.ListBox
		Private tabMessages As System.Windows.Forms.TabPage
		Private tabViewFax As System.Windows.Forms.TabPage
		Private menuItem7 As System.Windows.Forms.MenuItem
		Private WithEvents mnuPageFirst As System.Windows.Forms.MenuItem
		Private WithEvents mnuPagePrevious As System.Windows.Forms.MenuItem
		Private WithEvents mnuPageNext As System.Windows.Forms.MenuItem
		Private WithEvents mnuPageLast As System.Windows.Forms.MenuItem
		Private Page As System.Windows.Forms.MenuItem
		Private pnViewFax As System.Windows.Forms.Panel
		Private pictureBox1 As System.Windows.Forms.PictureBox
		Private WithEvents mnuOpenFaxFile As System.Windows.Forms.MenuItem
		Private WithEvents mnuClass21 As System.Windows.Forms.MenuItem
		Private WithEvents mnuOnlineHelp As System.Windows.Forms.MenuItem
		Private components As System.ComponentModel.IContainer

		Public Sub New()
			'
			' Required for Windows Form Designer support
			'
			InitializeComponent()

			_faxing = New Faxing()
			AddHandler _faxing.FaxMessage, AddressOf _faxing_FaxMessage
			AddHandler _faxing.FaxCompletionStatus, AddressOf _faxing_FaxCompletionStatus
			AddHandler _faxing.FaxNegotiatedParameters, AddressOf _faxing_FaxNegotiatedParameters
			AddHandler _faxing.FaxReceiveFileName, AddressOf _faxing_FaxReceiveFileName
			AddHandler _faxing.FaxSetEndTime, AddressOf _faxing_FaxSetEndTime
			AddHandler _faxing.FaxSetPages, AddressOf _faxing_FaxSetPages
			AddHandler _faxing.FaxSetStartTime, AddressOf _faxing_FaxSetStartTime
			AddHandler _faxing.FaxStatus, AddressOf _faxing_FaxStatus
			AddHandler _faxing.FaxRing, AddressOf _faxing_FaxRing

			' Set the local ID
			_faxing.LocalID = "FmJrNet Sample"
			mnuStationID.Text = _faxing.LocalID
			_faxing.ReceiveDir = String.Format("{0}\", Application.UserAppDataPath)

			LoadModemOptions()
			LoadSendFaxInformation()

			If Nothing Is _fax Then
				_fax = New Fax()
				_fax.Coverpage = "cover2.pg"
			End If

			_faxJobs = New Queue()

			_showMessages = True

			Dim filename As String = String.Format("{0}\FmJrNetDebugLogFile_{1}.txt", Application.UserAppDataPath, DateTime.Now.ToLongTimeString().Replace(":", "_").Replace(" ", "_"))
			_faxing.InitializeLogging(filename)

			If faxPrint1.IsPrinterInstalled Then
				SetupPrintDocument()
			End If
		End Sub

		''' <summary>
		''' Clean up any resources being used.
		''' </summary>
		Protected Overrides Overloads Sub Dispose(ByVal disposing As Boolean)
			If disposing Then
				If CInt(Fix(_faxing.DeviceStatus)) > 1 Then
					_faxing.CancelFax()
				End If

				SaveModemOptions()
				SaveSendFaxInformation()

				If Not components Is Nothing Then
					components.Dispose()
				End If
			End If
			MyBase.Dispose(disposing)
		End Sub

		#Region "Windows Form Designer generated code"
		''' <summary>
		''' Required method for Designer support - do not modify
		''' the contents of this method with the code editor.
		''' </summary>
		Private Sub InitializeComponent()
			Me.components = New System.ComponentModel.Container()
			Me.mainMenu1 = New System.Windows.Forms.MainMenu()
			Me.menuItem1 = New System.Windows.Forms.MenuItem()
			Me.mnuOpenFaxFile = New System.Windows.Forms.MenuItem()
			Me.mnuSend = New System.Windows.Forms.MenuItem()
			Me.mnuReceive = New System.Windows.Forms.MenuItem()
			Me.mnuListen = New System.Windows.Forms.MenuItem()
			Me.mnuCancel = New System.Windows.Forms.MenuItem()
			Me.menuItem6 = New System.Windows.Forms.MenuItem()
			Me.mnuSettings = New System.Windows.Forms.MenuItem()
			Me.mnuResolution = New System.Windows.Forms.MenuItem()
			Me.mnuResolutionLow = New System.Windows.Forms.MenuItem()
			Me.mnuResolutionHigh = New System.Windows.Forms.MenuItem()
			Me.mnuStation = New System.Windows.Forms.MenuItem()
			Me.mnuStationID = New System.Windows.Forms.MenuItem()
			Me.menuItem7 = New System.Windows.Forms.MenuItem()
			Me.mnuShowMessages = New System.Windows.Forms.MenuItem()
			Me.mnuFilePrint = New System.Windows.Forms.MenuItem()
			Me.mnuInstallPrinter = New System.Windows.Forms.MenuItem()
			Me.mnuPrintTestPage = New System.Windows.Forms.MenuItem()
			Me.mnuDevices = New System.Windows.Forms.MenuItem()
			Me.mnuAutoDetect = New System.Windows.Forms.MenuItem()
			Me.mnuDeviceSettings = New System.Windows.Forms.MenuItem()
			Me.mnuClass = New System.Windows.Forms.MenuItem()
			Me.mnuClass1 = New System.Windows.Forms.MenuItem()
			Me.mnuClass2 = New System.Windows.Forms.MenuItem()
			Me.mnuClass20 = New System.Windows.Forms.MenuItem()
			Me.mnuClass21 = New System.Windows.Forms.MenuItem()
			Me.mnuInit = New System.Windows.Forms.MenuItem()
			Me.mnuInitString = New System.Windows.Forms.MenuItem()
			Me.mnuReset = New System.Windows.Forms.MenuItem()
			Me.mnuResetString = New System.Windows.Forms.MenuItem()
			Me.menuItem11 = New System.Windows.Forms.MenuItem()
			Me.Page = New System.Windows.Forms.MenuItem()
			Me.mnuPageFirst = New System.Windows.Forms.MenuItem()
			Me.mnuPagePrevious = New System.Windows.Forms.MenuItem()
			Me.mnuPageNext = New System.Windows.Forms.MenuItem()
			Me.mnuPageLast = New System.Windows.Forms.MenuItem()
			Me.mnuTesting = New System.Windows.Forms.MenuItem()
			Me.mnuSend1000Faxes = New System.Windows.Forms.MenuItem()
			Me.mnuTestStopBatchSend = New System.Windows.Forms.MenuItem()
			Me.menuItem4 = New System.Windows.Forms.MenuItem()
			Me.mnuExceptions = New System.Windows.Forms.MenuItem()
			Me.mnuTestSwitchModem = New System.Windows.Forms.MenuItem()
			Me.mnuTestBlindSend = New System.Windows.Forms.MenuItem()
			Me.mnuTestImportNada = New System.Windows.Forms.MenuItem()
			Me.mnuTestBlindReceive = New System.Windows.Forms.MenuItem()
			Me.mnuTestBlindAutoDetect = New System.Windows.Forms.MenuItem()
			Me.mnuBlindListen = New System.Windows.Forms.MenuItem()
			Me.mnuBadDevice = New System.Windows.Forms.MenuItem()
			Me.menuItem5 = New System.Windows.Forms.MenuItem()
			Me.mnuOnlineHelp = New System.Windows.Forms.MenuItem()
			Me.mnuKBase = New System.Windows.Forms.MenuItem()
			Me.mnuUpdateCenter = New System.Windows.Forms.MenuItem()
			Me.faxPrint1 = New DataTech.FaxManNet.FaxPrint(Me.components)
			Me.tabMessageOrView = New System.Windows.Forms.TabControl()
			Me.tabMessages = New System.Windows.Forms.TabPage()
			Me.tabViewFax = New System.Windows.Forms.TabPage()
			Me.lbMessages = New System.Windows.Forms.ListBox()
			Me.pnViewFax = New System.Windows.Forms.Panel()
			Me.pictureBox1 = New System.Windows.Forms.PictureBox()
			CType(Me.faxPrint1, System.ComponentModel.ISupportInitialize).BeginInit()
			Me.tabMessageOrView.SuspendLayout()
			Me.pnViewFax.SuspendLayout()
			Me.SuspendLayout()
			' 
			' mainMenu1
			' 
			Me.mainMenu1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.menuItem1, Me.mnuDevices, Me.Page, Me.mnuTesting, Me.menuItem5})
			' 
			' menuItem1
			' 
			Me.menuItem1.Index = 0
			Me.menuItem1.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuOpenFaxFile, Me.mnuSend, Me.mnuReceive, Me.mnuListen, Me.mnuCancel, Me.menuItem6, Me.mnuSettings, Me.mnuFilePrint})
			Me.menuItem1.Text = "&Fax"
			' 
			' mnuOpenFaxFile
			' 
			Me.mnuOpenFaxFile.Index = 0
			Me.mnuOpenFaxFile.Shortcut = System.Windows.Forms.Shortcut.CtrlO
			Me.mnuOpenFaxFile.Text = "&Open Fax File"
'			Me.mnuOpenFaxFile.Click += New System.EventHandler(Me.mnuOpenFaxFile_Click);
			' 
			' mnuSend
			' 
			Me.mnuSend.Index = 1
			Me.mnuSend.Shortcut = System.Windows.Forms.Shortcut.CtrlS
			Me.mnuSend.Text = "&Send"
'			Me.mnuSend.Click += New System.EventHandler(Me.mnuSend_Click);
			' 
			' mnuReceive
			' 
			Me.mnuReceive.Index = 2
			Me.mnuReceive.Shortcut = System.Windows.Forms.Shortcut.CtrlR
			Me.mnuReceive.Text = "Auto &Receive"
'			Me.mnuReceive.Click += New System.EventHandler(Me.mnuReceive_Click);
			' 
			' mnuListen
			' 
			Me.mnuListen.Index = 3
			Me.mnuListen.Shortcut = System.Windows.Forms.Shortcut.CtrlL
			Me.mnuListen.Text = "&Listen"
'			Me.mnuListen.Click += New System.EventHandler(Me.mnuListen_Click);
			' 
			' mnuCancel
			' 
			Me.mnuCancel.Index = 4
			Me.mnuCancel.Shortcut = System.Windows.Forms.Shortcut.Del
			Me.mnuCancel.Text = "&Cancel"
'			Me.mnuCancel.Click += New System.EventHandler(Me.mnuCancel_Click);
			' 
			' menuItem6
			' 
			Me.menuItem6.Index = 5
			Me.menuItem6.Text = "-"
			' 
			' mnuSettings
			' 
			Me.mnuSettings.Index = 6
			Me.mnuSettings.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuResolution, Me.mnuStation, Me.menuItem7, Me.mnuShowMessages})
			Me.mnuSettings.Text = "&Global Settings"
			' 
			' mnuResolution
			' 
			Me.mnuResolution.Index = 0
			Me.mnuResolution.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuResolutionLow, Me.mnuResolutionHigh})
			Me.mnuResolution.Text = "&Resolution"
			' 
			' mnuResolutionLow
			' 
			Me.mnuResolutionLow.Index = 0
			Me.mnuResolutionLow.RadioCheck = True
			Me.mnuResolutionLow.Text = "&Low"
'			Me.mnuResolutionLow.Click += New System.EventHandler(Me.mnuResolution_Click);
			' 
			' mnuResolutionHigh
			' 
			Me.mnuResolutionHigh.Checked = True
			Me.mnuResolutionHigh.Index = 1
			Me.mnuResolutionHigh.RadioCheck = True
			Me.mnuResolutionHigh.Text = "&High"
'			Me.mnuResolutionHigh.Click += New System.EventHandler(Me.mnuResolution_Click);
			' 
			' mnuStation
			' 
			Me.mnuStation.Index = 1
			Me.mnuStation.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuStationID})
			Me.mnuStation.Text = "&Station ID"
			' 
			' mnuStationID
			' 
			Me.mnuStationID.Index = 0
			Me.mnuStationID.Text = "FmJrNet Sample"
'			Me.mnuStationID.Click += New System.EventHandler(Me.mnuStationID_Click);
			' 
			' menuItem7
			' 
			Me.menuItem7.Index = 2
			Me.menuItem7.Text = "-"
			' 
			' mnuShowMessages
			' 
			Me.mnuShowMessages.Checked = True
			Me.mnuShowMessages.Index = 3
			Me.mnuShowMessages.Text = "Show &Messages"
'			Me.mnuShowMessages.Click += New System.EventHandler(Me.mnuShowMessages_Click);
			' 
			' mnuFilePrint
			' 
			Me.mnuFilePrint.Index = 7
			Me.mnuFilePrint.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuInstallPrinter, Me.mnuPrintTestPage})
			Me.mnuFilePrint.Text = "&Print"
			' 
			' mnuInstallPrinter
			' 
			Me.mnuInstallPrinter.Index = 0
			Me.mnuInstallPrinter.Text = "&Install Printer"
'			Me.mnuInstallPrinter.Click += New System.EventHandler(Me.mnuInstallPrinter_Click);
			' 
			' mnuPrintTestPage
			' 
			Me.mnuPrintTestPage.Enabled = False
			Me.mnuPrintTestPage.Index = 1
			Me.mnuPrintTestPage.Text = "&Print Test Page"
'			Me.mnuPrintTestPage.Click += New System.EventHandler(Me.mnuPrintTestPage_Click);
			' 
			' mnuDevices
			' 
			Me.mnuDevices.Index = 1
			Me.mnuDevices.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuAutoDetect, Me.mnuDeviceSettings, Me.menuItem11})
			Me.mnuDevices.Text = "&Devices"
			' 
			' mnuAutoDetect
			' 
			Me.mnuAutoDetect.Index = 0
			Me.mnuAutoDetect.Text = "&Auto Detect"
'			Me.mnuAutoDetect.Click += New System.EventHandler(Me.mnuAutoDetect_Click);
			' 
			' mnuDeviceSettings
			' 
			Me.mnuDeviceSettings.Enabled = False
			Me.mnuDeviceSettings.Index = 1
			Me.mnuDeviceSettings.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuClass, Me.mnuInit, Me.mnuReset})
			Me.mnuDeviceSettings.Text = "&Device Settings"
			' 
			' mnuClass
			' 
			Me.mnuClass.Index = 0
			Me.mnuClass.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuClass1, Me.mnuClass2, Me.mnuClass20, Me.mnuClass21})
			Me.mnuClass.Text = "&Class"
			' 
			' mnuClass1
			' 
			Me.mnuClass1.Index = 0
			Me.mnuClass1.Text = "Class &1"
'			Me.mnuClass1.Click += New System.EventHandler(Me.mnuClass1_Click);
			' 
			' mnuClass2
			' 
			Me.mnuClass2.Index = 1
			Me.mnuClass2.Text = "Class &2"
'			Me.mnuClass2.Click += New System.EventHandler(Me.mnuClass2_Click);
			' 
			' mnuClass20
			' 
			Me.mnuClass20.Index = 2
			Me.mnuClass20.Text = "Class 2.&0"
'			Me.mnuClass20.Click += New System.EventHandler(Me.mnuClass20_Click);
			' 
			' mnuClass21
			' 
			Me.mnuClass21.Index = 3
			Me.mnuClass21.Text = "Class 2.1"
'			Me.mnuClass21.Click += New System.EventHandler(Me.mnuClass21_Click);
			' 
			' mnuInit
			' 
			Me.mnuInit.Index = 1
			Me.mnuInit.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuInitString})
			Me.mnuInit.Text = "&Init"
			' 
			' mnuInitString
			' 
			Me.mnuInitString.Index = 0
			Me.mnuInitString.Text = "AT&FE0V1C1D2S0=0M0"
'			Me.mnuInitString.Click += New System.EventHandler(Me.mnuInitString_Click);
			' 
			' mnuReset
			' 
			Me.mnuReset.Index = 2
			Me.mnuReset.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuResetString})
			Me.mnuReset.Text = "&Reset"
			' 
			' mnuResetString
			' 
			Me.mnuResetString.Index = 0
			Me.mnuResetString.Text = "AT"
'			Me.mnuResetString.Click += New System.EventHandler(Me.mnuResetString_Click);
			' 
			' menuItem11
			' 
			Me.menuItem11.Index = 2
			Me.menuItem11.Text = "-"
			' 
			' Page
			' 
			Me.Page.Index = 2
			Me.Page.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuPageFirst, Me.mnuPagePrevious, Me.mnuPageNext, Me.mnuPageLast})
			Me.Page.Text = "&Page"
			Me.Page.Visible = False
			' 
			' mnuPageFirst
			' 
			Me.mnuPageFirst.Index = 0
			Me.mnuPageFirst.Shortcut = System.Windows.Forms.Shortcut.F5
			Me.mnuPageFirst.Text = "&First"
'			Me.mnuPageFirst.Click += New System.EventHandler(Me.mnuPageFirst_Click);
			' 
			' mnuPagePrevious
			' 
			Me.mnuPagePrevious.Index = 1
			Me.mnuPagePrevious.Shortcut = System.Windows.Forms.Shortcut.F6
			Me.mnuPagePrevious.Text = "&Previous"
'			Me.mnuPagePrevious.Click += New System.EventHandler(Me.mnuPagePrevious_Click);
			' 
			' mnuPageNext
			' 
			Me.mnuPageNext.Index = 2
			Me.mnuPageNext.Shortcut = System.Windows.Forms.Shortcut.F7
			Me.mnuPageNext.Text = "&Next"
'			Me.mnuPageNext.Click += New System.EventHandler(Me.mnuPageNext_Click);
			' 
			' mnuPageLast
			' 
			Me.mnuPageLast.Index = 3
			Me.mnuPageLast.Shortcut = System.Windows.Forms.Shortcut.F8
			Me.mnuPageLast.Text = "&Last"
'			Me.mnuPageLast.Click += New System.EventHandler(Me.mnuPageLast_Click);
			' 
			' mnuTesting
			' 
			Me.mnuTesting.Index = 3
			Me.mnuTesting.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuSend1000Faxes, Me.mnuTestStopBatchSend, Me.menuItem4, Me.mnuExceptions})
			Me.mnuTesting.Text = "&Testing"
			' 
			' mnuSend1000Faxes
			' 
			Me.mnuSend1000Faxes.Index = 0
			Me.mnuSend1000Faxes.Text = "Send Batch of &1000 Faxes"
'			Me.mnuSend1000Faxes.Click += New System.EventHandler(Me.mnuTestBatchSend1000_Click);
			' 
			' mnuTestStopBatchSend
			' 
			Me.mnuTestStopBatchSend.Index = 1
			Me.mnuTestStopBatchSend.Text = "Stop &Batch Send"
'			Me.mnuTestStopBatchSend.Click += New System.EventHandler(Me.mnuTestStopBatchSend_Click);
			' 
			' menuItem4
			' 
			Me.menuItem4.Index = 2
			Me.menuItem4.Text = "-"
			' 
			' mnuExceptions
			' 
			Me.mnuExceptions.Index = 3
			Me.mnuExceptions.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuTestSwitchModem, Me.mnuTestBlindSend, Me.mnuTestImportNada, Me.mnuTestBlindReceive, Me.mnuTestBlindAutoDetect, Me.mnuBlindListen, Me.mnuBadDevice})
			Me.mnuExceptions.Text = "Throw &Exceptions"
			' 
			' mnuTestSwitchModem
			' 
			Me.mnuTestSwitchModem.Index = 0
			Me.mnuTestSwitchModem.Text = "Switch &Modem"
'			Me.mnuTestSwitchModem.Click += New System.EventHandler(Me.mnuTestSwitchModem_Click);
			' 
			' mnuTestBlindSend
			' 
			Me.mnuTestBlindSend.Index = 1
			Me.mnuTestBlindSend.Text = "Blind &Send"
'			Me.mnuTestBlindSend.Click += New System.EventHandler(Me.mnuTestBlindSend_Click);
			' 
			' mnuTestImportNada
			' 
			Me.mnuTestImportNada.Index = 2
			Me.mnuTestImportNada.Text = "&Import Nada"
'			Me.mnuTestImportNada.Click += New System.EventHandler(Me.mnuTestImportNada_Click);
			' 
			' mnuTestBlindReceive
			' 
			Me.mnuTestBlindReceive.Index = 3
			Me.mnuTestBlindReceive.Text = "Blind &Receive"
'			Me.mnuTestBlindReceive.Click += New System.EventHandler(Me.mnuTestBlindReceive_Click);
			' 
			' mnuTestBlindAutoDetect
			' 
			Me.mnuTestBlindAutoDetect.Index = 4
			Me.mnuTestBlindAutoDetect.Text = "Blind &Auto Detect"
'			Me.mnuTestBlindAutoDetect.Click += New System.EventHandler(Me.mnuTestBlindAutoDetect_Click);
			' 
			' mnuBlindListen
			' 
			Me.mnuBlindListen.Index = 5
			Me.mnuBlindListen.Text = "Blind &Listen"
'			Me.mnuBlindListen.Click += New System.EventHandler(Me.mnuBlindListen_Click);
			' 
			' mnuBadDevice
			' 
			Me.mnuBadDevice.Index = 6
			Me.mnuBadDevice.Text = "&Bad Device"
'			Me.mnuBadDevice.Click += New System.EventHandler(Me.mnuBadDevice_Click);
			' 
			' menuItem5
			' 
			Me.menuItem5.Index = 4
			Me.menuItem5.MenuItems.AddRange(New System.Windows.Forms.MenuItem() { Me.mnuOnlineHelp, Me.mnuKBase, Me.mnuUpdateCenter})
			Me.menuItem5.Text = "&Help"
			' 
			' mnuOnlineHelp
			' 
			Me.mnuOnlineHelp.Index = 0
			Me.mnuOnlineHelp.Shortcut = System.Windows.Forms.Shortcut.F1
			Me.mnuOnlineHelp.Text = "Online &Help"
'			Me.mnuOnlineHelp.Click += New System.EventHandler(Me.mnuOnlineHelp_Click);
			' 
			' mnuKBase
			' 
			Me.mnuKBase.Index = 1
			Me.mnuKBase.Text = "&DTI KnowledgeBase"
'			Me.mnuKBase.Click += New System.EventHandler(Me.mnuKBase_Click);
			' 
			' mnuUpdateCenter
			' 
			Me.mnuUpdateCenter.Index = 2
			Me.mnuUpdateCenter.Text = "Online &Update Center"
'			Me.mnuUpdateCenter.Click += New System.EventHandler(Me.mnuUpdateCenter_Click);
			' 
			' faxPrint1
			' 
			Me.faxPrint1.PrinterName = "FAXJR TEST"
			Me.faxPrint1.PrintFilesPath = "C:\DOCUME~1\Eric\LOCALS~1\Temp\"
'			Me.faxPrint1.PrintComplete += New DataTech.FaxManNet.FaxPrint.__Delegate_PrintComplete(Me.faxPrint1_PrintComplete);
			' 
			' tabMessageOrView
			' 
			Me.tabMessageOrView.Anchor = (CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles))
			Me.tabMessageOrView.Controls.Add(Me.tabMessages)
			Me.tabMessageOrView.Controls.Add(Me.tabViewFax)
			Me.tabMessageOrView.Location = New System.Drawing.Point(0, 0)
			Me.tabMessageOrView.Name = "tabMessageOrView"
			Me.tabMessageOrView.SelectedIndex = 0
			Me.tabMessageOrView.Size = New System.Drawing.Size(432, 24)
			Me.tabMessageOrView.TabIndex = 0
'			Me.tabMessageOrView.SelectedIndexChanged += New System.EventHandler(Me.tabMessageOrView_SelectedIndexChanged);
			' 
			' tabMessages
			' 
			Me.tabMessages.Location = New System.Drawing.Point(4, 22)
			Me.tabMessages.Name = "tabMessages"
			Me.tabMessages.Size = New System.Drawing.Size(424, 0)
			Me.tabMessages.TabIndex = 0
			Me.tabMessages.Text = "Events and Messages"
			' 
			' tabViewFax
			' 
			Me.tabViewFax.Location = New System.Drawing.Point(4, 22)
			Me.tabViewFax.Name = "tabViewFax"
			Me.tabViewFax.Size = New System.Drawing.Size(424, -2)
			Me.tabViewFax.TabIndex = 1
			Me.tabViewFax.Text = "View Fax"
			' 
			' lbMessages
			' 
			Me.lbMessages.Anchor = (CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles))
			Me.lbMessages.Location = New System.Drawing.Point(0, 24)
			Me.lbMessages.Name = "lbMessages"
			Me.lbMessages.ScrollAlwaysVisible = True
			Me.lbMessages.Size = New System.Drawing.Size(128, 420)
			Me.lbMessages.TabIndex = 2
			' 
			' pnViewFax
			' 
			Me.pnViewFax.Anchor = (CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) Or System.Windows.Forms.AnchorStyles.Left) Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles))
			Me.pnViewFax.AutoScroll = True
			Me.pnViewFax.Controls.Add(Me.pictureBox1)
			Me.pnViewFax.Location = New System.Drawing.Point(0, 24)
			Me.pnViewFax.Name = "pnViewFax"
			Me.pnViewFax.Size = New System.Drawing.Size(280, 416)
			Me.pnViewFax.TabIndex = 4
			' 
			' pictureBox1
			' 
			Me.pictureBox1.Location = New System.Drawing.Point(0, 0)
			Me.pictureBox1.Name = "pictureBox1"
			Me.pictureBox1.Size = New System.Drawing.Size(240, 232)
			Me.pictureBox1.TabIndex = 4
			Me.pictureBox1.TabStop = False
			' 
			' Form1
			' 
			Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
			Me.AutoScroll = True
			Me.ClientSize = New System.Drawing.Size(432, 441)
			Me.Controls.Add(Me.lbMessages)
			Me.Controls.Add(Me.tabMessageOrView)
			Me.Controls.Add(Me.pnViewFax)
			Me.Menu = Me.mainMenu1
			Me.Name = "Form1"
			Me.Text = "Faxman Jr.NET Test Application"
'			Me.Load += New System.EventHandler(Me.Form1_Load);
			CType(Me.faxPrint1, System.ComponentModel.ISupportInitialize).EndInit()
			Me.tabMessageOrView.ResumeLayout(False)
			Me.pnViewFax.ResumeLayout(False)
			Me.ResumeLayout(False)

		End Sub
		#End Region

		' //////////////////////////////////////////
		' Form Level Variables
		Private _faxing As DataTech.FaxManJr.Faxing
		Private _modemDictionary As System.Collections.Specialized.ListDictionary
		Private _waitingToSend As Boolean
		Private _fax As DataTech.FaxManJr.Fax
		Private _faxJobs As System.Collections.Queue
		Private _showMessages As Boolean
		Private _printDoc As PrintDocument
		Private _receiveErrors As Integer
		Private _log As LogDelegate
		Private Delegate Sub ShowImageDelegate(ByVal image As Boolean)
		Private _showImage As ShowImageDelegate
		Private _imgs As ArrayList
		Private _page As Integer

		Private Delegate Sub LogDelegate(ByVal msg As String)

		''' <summary>
		''' The main entry point for the application.
		''' </summary>
		<STAThread> _
		Shared Sub Main()
			Application.Run(New Form1())
		End Sub

		Private Sub Form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
			' For ease of editing stacked controls are not full size
			' Make them full size now.
			pnViewFax.Width = Me.ClientSize.Width
			lbMessages.Width = Me.ClientSize.Width

			_log = New LogDelegate(AddressOf LogHelper)
			_showImage = New ShowImageDelegate(AddressOf ShowImageHelper)
		End Sub

		' //////////////////////////////////////////
		' Main Sample Menu Handlers

		Private Sub mnuOpenFaxFile_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuOpenFaxFile.Click
			Dim file As String = ImageOpenDialog()
			If file.Length > 1 Then
				_imgs = LoadFaxFile(file)
				LoadImage()
			End If

		End Sub

		Private Sub mnuSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuSend.Click
			Dim sendFax As SendFaxForm = New SendFaxForm(_fax)
			If System.Windows.Forms.DialogResult.OK = sendFax.ShowDialog() Then
				' may not be necessary if passing reference instead of copy
				_fax = sendFax._fax
				If Not(IsReceiving()) Then
					If (Not CheckModem()) Then
					Return
					End If
					Log("======================================")
					Log("== Sending a Fax")

					_faxing.Send(_fax)
				End If
			End If

		End Sub

		Private Sub mnuReceive_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuReceive.Click
			If mnuReceive.Checked Then
				mnuReceive.Checked = False
				If _faxing.DeviceStatus = DeviceStatuses.DeviceReceiveMode Then
					Log("= Turning off Receive Mode")
					_faxing.CancelFax()
				ElseIf _faxing.DeviceStatus = DeviceStatuses.DeviceCurrentlyReceiving Then
					If System.Windows.Forms.DialogResult.Yes = System.Windows.Forms.MessageBox.Show("You are currently in the middle of receiving a fax! Do you want to cancel the current fax?", "FaxManJr.NET sample application", MessageBoxButtons.YesNo) Then
						Log("== Canceling Fax in the middle of reception by users request!")
					End If
				End If
			Else
				If (Not CheckModem()) Then
				Return
				End If
				Log("======================================")
				Log("== Ready to Receive a Fax")

				_faxing.Receive(1)
				mnuReceive.Checked = True
			End If
		End Sub

		Private Sub mnuListen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuListen.Click
			If (Not CheckModem()) Then
			Return
			End If
			Log("======================================")
			Log("== Listening for a Fax")

			_faxing.Listen()
		End Sub

		Private Sub mnuCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuCancel.Click
			If CInt(Fix(_faxing.DeviceStatus)) > 1 Then
				Log("== Cancel Fax")
				_faxing.CancelFax()
			End If
		End Sub

		Private Sub mnuStationID_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuStationID.Click
			Dim id As InputDialog = New InputDialog("FmJr Net Test - Station ID", "Please Enter your station ID.\r\nNote: this field has a maximum length of 20 characters.", _faxing.LocalID)
			If System.Windows.Forms.DialogResult.OK = id.ShowDialog() Then
				_faxing.LocalID = id.InputText
				mnuStationID.Text = id.InputText
			End If
		End Sub

		Private Sub mnuResolution_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuResolutionLow.Click, mnuResolutionHigh.Click
			Dim item As MenuItem = CType(sender, MenuItem)
			If item.Text.IndexOf("High")>0 Then
				_fax.FaxResolution = FaxResolution.High
				mnuResolutionHigh.Checked = True
				mnuResolutionLow.Checked = False
			Else
				_fax.FaxResolution = FaxResolution.Low
				mnuResolutionHigh.Checked = False
				mnuResolutionLow.Checked = True
			End If
		End Sub

		Private Sub mnuShowMessages_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuShowMessages.Click
			_showMessages = Not _showMessages
			mnuShowMessages.Checked = _showMessages
		End Sub

		' //////////////////////////////////////////
		' Printing Support

		Private Sub faxPrint1_PrintComplete() Handles faxPrint1.PrintComplete
			Log("== Printing To Sample Application Completed.")
			Dim pj As DataTech.FaxManNet.PrintJob = faxPrint1.PrintJobs.GetNextPrintJob()
			Log("== File Created:")
			Log(pj.FileName)
			Log("== File Added to list of faxable files.")
			If 0 = pj.Status Then
				_fax.FaxFiles.Add(pj.FileName)
				_imgs = LoadFaxFile(pj.FileName)
				ShowImage(True)
			End If
		End Sub

		Private Sub mnuInstallPrinter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuInstallPrinter.Click
			' Printer name set in Form startup code
			' faxPrint1.PrinterName = "JrNetTest Fax Printer";
			If faxPrint1.IsPrinterInstalled Then
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Printer Already Installed")
				System.Windows.Forms.MessageBox.Show("Printer already installed.", "FaxManJr.NET sample application")
				Return
			End If
			Log("======================================")
			Log(String.Format("== Installing Printer: {0}", faxPrint1.PrinterName))

			faxPrint1.PrintFilesPath = Application.UserAppDataPath
			If faxPrint1.InstallPrinter(Application.ExecutablePath) Then
				Log("== Printer Installed correctly.")
				SetupPrintDocument()
			Else
				Log("!! Printer Installation Failed!!!")
				Log("!! Please make sure you have Administrative rights on this machine!")
				Log("!! Check the Installationg Log File for more information:")
				Log("C:\Documents and Settings\*CURRENTUSER*\Local Settings\Temp\FaxNetPrinterInstall.log")
			End If

		End Sub

		Private Sub SetupPrintDocument()
			_printDoc = New PrintDocument()
			AddHandler _printDoc.PrintPage, AddressOf OnPrintPage
			_printDoc.PrinterSettings.PrinterName = faxPrint1.PrinterName
			mnuPrintTestPage.Enabled = True
		End Sub

		Private Sub mnuPrintTestPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPrintTestPage.Click
			Log("== Printing Test Page.")
			_printDoc.Print()
		End Sub

		Protected Sub OnPrintPage(ByVal sender As Object, ByVal e As PrintPageEventArgs)
			Dim PageBounds As RectangleF = New RectangleF(e.MarginBounds.Left, e.MarginBounds.Top, e.MarginBounds.Width, e.MarginBounds.Height)
			Dim LinePen As Pen = New Pen(Color.Black)
			e.Graphics.DrawLine(LinePen, PageBounds.Left, PageBounds.Top, PageBounds.Left + PageBounds.Width, PageBounds.Top)
			PageBounds.Inflate(-20, -20)
			e.Graphics.DrawString("FaxMan Jr Printing Test Page", New Font("Arial", 24), Brushes.Black, PageBounds)
			e.HasMorePages = False
		End Sub

		' //////////////////////////////////////////
		' Main Interface Is it viewing a fax or is it messages

		Private Sub tabMessageOrView_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabMessageOrView.SelectedIndexChanged
			If 1 = tabMessageOrView.SelectedIndex Then
				If (Nothing Is _imgs) OrElse (_imgs.Count < 1) Then
					Dim file As String = ImageOpenDialog()
					If file.Length > 1 Then
						_imgs = LoadFaxFile(file)
					End If
				End If
				pnViewFax.BringToFront()
				LoadImage()
			Else
				lbMessages.BringToFront()
			End If
		End Sub


		' //////////////////////////////////////////
		' FaxMan Jr Control Status Event Handlers

		' FaxModem Strings sent to and from device
		Private Sub _faxing_FaxMessage(ByVal sender As Object, ByVal args As FaxMessageArgs)
			If _showMessages Then
				Log(String.Format("      {0}", args.Message))
			End If
		End Sub

		' This is the event when the device is no longer busy.
		' It is a good place to handle Auto Receive and Batch Sending.
		Private Sub _faxing_FaxCompletionStatus(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Fax Completed - Fax Status: {0}.  General Error: {1}", args.Fax.FaxStatus, args.Fax.GeneralError))
			If DataTech.FaxManJr.FaxError.Ok <> args.Fax.FaxError Then
				Log(String.Format("== Fax Error: {0}.  Fax Error String: {1}", args.Fax.FaxError, args.Fax.FaxErrorString))
			End If

			Log("== Fax Session Completed")
			Log("======================================")

			If lbMessages.Items.Count > 2000 Then
				lbMessages.Items.Clear()
				Log("======================================")
				Log("== Cleared out fax messages.")
				Log("== Messages were over 2000 entries.")
			End If

			If _faxJobs.Count > 0 Then
				' reschedule if failed by sending to end of queue
				' limit number of retries ~ 3 by length of user data
				If (FaxError.Ok <> args.Fax.FaxError) AndAlso (args.Fax.UserData.Length < 50) Then
					Log("== Fax Failed Rescheduling Fax")
					Log("======================================")
					args.Fax.UserData = String.Format("== {0} Trying Again", args.Fax.UserData)
					_faxJobs.Enqueue(args.Fax)
				End If

				Dim fax As DataTech.FaxManJr.Fax = CType(_faxJobs.Dequeue(), DataTech.FaxManJr.Fax)
				Log("======================================")
				Log(String.Format("== Sending {0}", fax.UserData))
				_faxing.Send(fax)

			ElseIf _waitingToSend Then
				_waitingToSend = False
				If (Not CheckModem()) Then
				Return
				End If
				Log("======================================")
				Log("== Sending a Fax")

				_faxing.Send(_fax)
			ElseIf mnuReceive.Checked = True Then
				' Check for bad receive device to prevent endless cycling
				If (DataTech.FaxManJr.FaxError.Error = args.Fax.FaxError) Then
					_receiveErrors = _receiveErrors + 1
				Else
					_receiveErrors = 0
				End If
				If 2 = ((_receiveErrors - 1) Mod 3) Then
					Log(String.Format("== Failed {0} times in a row with a general modem error!!!", _receiveErrors))
					If _receiveErrors < 15 Then
						Log("== You may want to turn Auto Receive Off and check your device.")
						System.Threading.Thread.Sleep(5000)
					Else
						Log("== Turning Auto Receive Off!!!")
						mnuReceive.Checked = False
						Return
					End If
				End If
				' Let's receive another fax
				Log("======================================")
				Log("== Ready to Receive another Fax")
				_faxing.Receive(1)

				If DataTech.FaxManJr.FaxError.Ok = args.Fax.FaxError Then
					' Display received fax in The Framework image control which
					' is intolerant, for better display use ImageMan.Net
					' First Clean up received buffers by importing the file first,
					' This step is not necessary with ImageMan.Net.
					Dim fileName As String = args.Fax.FaxFiles(0).ToString()
					Dim tempFile As String = String.Format("{0}.tmp", fileName)
					_faxing.ImportFiles(fileName, tempFile)
					System.IO.File.Delete(fileName)
					System.IO.File.Move(tempFile, fileName)
					_imgs = LoadFaxFile(fileName)
					ShowImage(True)
				End If
			End If
		End Sub

		Private Sub _faxing_FaxNegotiatedParameters(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Negotiated Paramters Speed: {0} Resolution: {1} RemoteID: {2}", args.Fax.Speed, args.Fax.FaxResolution, args.Fax.RemoteID))
		End Sub

		Private Sub _faxing_FaxReceiveFileName(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Receive Filename File: {0}", args.Fax.Files))
		End Sub

		Private Sub _faxing_FaxSetEndTime(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== End Time Duration: {0}", args.Fax.Duration))
		End Sub

		Private Sub _faxing_FaxSetPages(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Page {0} of {1}", args.Fax.PagesSent, args.Fax.TotalPages))
		End Sub

		Private Sub _faxing_FaxSetStartTime(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Start Time Time: {0} {1}", args.Fax.SentDateTime.ToLongTimeString(), args.Fax.SentDateTime.ToLongDateString()))
		End Sub

		Private Sub _faxing_FaxStatus(ByVal sender As Object, ByVal args As FaxEventArgs)
			Log(String.Format("== Status: {0}", args.Fax.FaxStatus))
			If (DataTech.FaxManJr.FaxStatus.Answering = args.Fax.FaxStatus) OrElse (DataTech.FaxManJr.FaxStatus.SendConnected = args.Fax.FaxStatus) Then
				ShowImage(False)
			End If
		End Sub

		Private Sub _faxing_FaxRing(ByVal sender As Object, ByVal args As FaxRingArgs)
			Log("== Ring Event.")
			Log(String.Format("== Current Ring Action: {0}", args.Action.ToString()))
			Log(String.Format("== Setting to Ring Action: {0}", RingActions.ReceiveFax))
			args.Action = RingActions.ReceiveFax
		End Sub

		' //////////////////////////////////////////
		' Device Menu

		Private Sub mnuAutoDetect_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuAutoDetect.Click
			Me.Cursor = Cursors.WaitCursor
			AutoDetect()
			Me.Cursor = Cursors.Default
		End Sub

		Private Sub mnuDevice_Click(ByVal sender As Object, ByVal e As System.EventArgs)
			If CInt(Fix(_faxing.DeviceStatus)) > 1 Then
				MessageBox.Show("Can't switch modem while currently in use.")
				Return
			End If

			' clear checks
			For Each mnu As MenuItem In mnuDevices.MenuItems
				mnu.Checked = False
			Next mnu

			' check and select chosen modem
			Dim mnuSender As MenuItem = CType(sender, MenuItem)
			mnuSender.Checked = True

			Dim port As Integer = Integer.Parse(mnuSender.Text.Substring(mnuSender.Text.IndexOf(":") - 2, 2))
			_faxing.Modem = CType(_modemDictionary(port), DataTech.FaxManJr.Modem)
			UpdateModemMenu(_faxing.Modem)
		End Sub

		Private Sub mnuInitString_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuInitString.Click
			Dim id As InputDialog = New InputDialog("FmJr Net Test - Init String", "Consult your modem AT command set documentation." & Constants.vbCrLf & "Add Flow control to this string if not on by default." & Constants.vbCrLf & "Often this is &F1, /Q1 or &K3.", _faxing.Modem.Init)
			If System.Windows.Forms.DialogResult.OK = id.ShowDialog() Then
				_faxing.Modem.Init = id.InputText
				mnuInitString.Text = id.InputText
			End If
		End Sub

		Private Sub mnuResetString_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuResetString.Click
			Dim id As InputDialog = New InputDialog("FmJr Net Test - Reset String", "This is often best left at AT." & Constants.vbCrLf & "Some modems have an ATZ option but" & Constants.vbCrLf & "using this may cause a delay and other problems.", _faxing.Modem.Reset)
			If System.Windows.Forms.DialogResult.OK = id.ShowDialog() Then
				_faxing.Modem.Reset = id.InputText
				mnuResetString.Text = id.InputText
			End If
		End Sub

		Private Sub mnuClass1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuClass1.Click
			_faxing.Modem.FaxClass = FaxClass.Class1
			UpdateModemMenu()
		End Sub

		Private Sub mnuClass2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuClass2.Click
			_faxing.Modem.FaxClass = FaxClass.Class2
			UpdateModemMenu()
		End Sub

		Private Sub mnuClass20_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuClass20.Click
			_faxing.Modem.FaxClass = FaxClass.Class20
			UpdateModemMenu()
		End Sub

		Private Sub mnuClass21_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuClass21.Click
			_faxing.Modem.FaxClass = FaxClass.Class21
			UpdateModemMenu()
		End Sub

		' //////////////////////////////////////////
		' Fax View Page Menu and variable and helper functions

		Private Sub mnuPageFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPageFirst.Click
'TODO: INSTANT VB TODO TASK: Assignments within expressions are not supported in VB.NET
'ORIGINAL LINE: LoadImage(_page = 0);
			LoadImage(_page = 0)
		End Sub

		Private Sub mnuPagePrevious_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPagePrevious.Click
			If _page > 0 Then
				_page -= 1
				LoadImage(_page)
			End If
		End Sub

		Private Sub mnuPageNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPageNext.Click
			If (Not Nothing Is _imgs) AndAlso (_imgs.Count - 1 > _page) Then
				_page += 1
				LoadImage(_page)
			End If
		End Sub

		Private Sub mnuPageLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPageLast.Click
			If (Not Nothing Is _imgs) AndAlso (_imgs.Count - 1 > _page) Then
'TODO: INSTANT VB TODO TASK: Assignments within expressions are not supported in VB.NET
'ORIGINAL LINE: LoadImage(_page = _imgs.Count - 1);
				LoadImage(_page = _imgs.Count - 1)
			End If
		End Sub

		Private Sub LoadImage()
			LoadImage(0)
		End Sub
		Private Sub LoadImage(ByVal page As Integer)
			If (Not Nothing Is _imgs) AndAlso (_imgs.Count > page) Then
				Me.Page.Text = String.Format("&Page {0} of {1}", page + 1, _imgs.Count)
				Me.Page.Visible = (_imgs.Count > 1)
				pictureBox1.Image = CType(_imgs(page), System.Drawing.Image)
				pictureBox1.Width = pictureBox1.Image.Width
				pictureBox1.Height = pictureBox1.Image.Height
				pictureBox1.Refresh()
			End If
		End Sub

		Private Sub ShowImage(ByVal image As Boolean)
			If pnViewFax.InvokeRequired OrElse tabMessageOrView.InvokeRequired OrElse lbMessages.InvokeRequired OrElse pictureBox1.InvokeRequired Then
					Invoke(_showImage, New Object() {image})
				Else
					ShowImageHelper(image)
				End If
		End Sub

		Private Sub ShowImageHelper(ByVal image As Boolean)
			If image Then
				LoadImage()
				pnViewFax.BringToFront()
				tabMessageOrView.SelectedIndex = 1
			Else
				' Let's see what is happening in the messages log
				lbMessages.BringToFront()
				tabMessageOrView.SelectedIndex = 0
			End If
		End Sub

		' //////////////////////////////////////////
		' Test Menu

		Private Sub mnuTestBatchSend1000_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuSend1000Faxes.Click
			Try
				Dim sendFax As SendFaxForm = New SendFaxForm(_fax)
				If System.Windows.Forms.DialogResult.OK = sendFax.ShowDialog() Then
					' may not be necessary if passing reference instead of copy
					_fax = sendFax._fax

					Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					Log("!! Queing up 1000 faxes")

					For i As Integer = 0 To 999
						Dim fax As DataTech.FaxManJr.Fax = _fax.Clone()
						fax.UserData = String.Format("Fax {0} of {1}", i, 1000)
						_faxJobs.Enqueue(fax)
					Next i

					Dim tfax As DataTech.FaxManJr.Fax = CType(_faxJobs.Dequeue(), DataTech.FaxManJr.Fax)
					Log("======================================")
					Log(String.Format("== Sending {0}", tfax.UserData))
					_faxing.Send(tfax)
				End If


			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuTestStopBatchSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestStopBatchSend.Click
			_faxJobs.Clear()
			_faxing.CancelFax()
		End Sub

		Private Sub mnuTestSwitchModem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestSwitchModem.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Blind Switch Modem")

				Dim mdm As DataTech.FaxManJr.Modem = New Modem(1, FaxClass.Class1)
				_faxing.Modem = mdm
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuTestBlindSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestBlindSend.Click

			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Blind Send Fax")

				_faxing.Send(_fax)
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuTestImportNada_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestImportNada.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Import Nothing")

				_faxing.ImportFiles("", "")
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuTestBlindReceive_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestBlindReceive.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Blind Receive Fax")

				_faxing.Receive(1)
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuTestBlindAutoDetect_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTestBlindAutoDetect.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Blind Auto Detect")

				Dim modems As DataTech.FaxManJr.Modems = New DataTech.FaxManJr.Modems()
				modems.AutoDetect()
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuBlindListen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuBlindListen.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Blind Listen For Fax")

				_faxing.Listen()
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub

		Private Sub mnuBadDevice_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuBadDevice.Click
			Try
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				Log("!! Pick a Bad Device, try port 21")

				Dim mdm As DataTech.FaxManJr.Modem = New Modem(21, FaxClass.Class21)
				_faxing.Modem = mdm
			Catch ex As System.Exception
				Log(String.Format("!! Exception: {0} ", ex.Message))
			End Try
		End Sub


		' //////////////////////////////////////////
		' Help Menu

		Private Sub mnuOnlineHelp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuOnlineHelp.Click
			System.Diagnostics.Process.Start("http://www.data-tech.com/help/faxjr2/webframe.html")
		End Sub

		Private Sub mnuUpdateCenter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuUpdateCenter.Click
			System.Diagnostics.Process.Start("http://data-tech.com/myproducts/login.aspx")
		End Sub

		Private Sub mnuKBase_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuKBase.Click
			System.Diagnostics.Process.Start("http://data-tech.com/support/newkb.aspx")
		End Sub

		' //////////////////////////////////////////
		' Device Helper functions
		Private Function CheckModem() As Boolean
			If _faxing.DeviceStatus = DeviceStatuses.DeviceNotSet Then
				If System.Windows.Forms.DialogResult.Yes = System.Windows.Forms.MessageBox.Show("No Modems are detected. Would you like to Auto Detect for Modems?", "FaxManJr.NET sample application", MessageBoxButtons.YesNo) Then
					Me.Cursor = Cursors.WaitCursor
					AutoDetect()
					Me.Cursor = Cursors.Default
				End If
			ElseIf _faxing.DeviceStatus <> DeviceStatuses.DeviceReady Then
				MessageBox.Show("Modem Currently in use.")
			End If

			Return (_faxing.DeviceStatus = DeviceStatuses.DeviceReady)
		End Function

		Private Function AutoDetect() As Boolean
			If CInt(Fix(_faxing.DeviceStatus)) > 1 Then
				System.Windows.Forms.MessageBox.Show("You cannot Auto Detect modems when they are in use! Please cancel all current operations.", "FaxManJr.NET sample application")
				Return (False)
			End If
			Dim modems As DataTech.FaxManJr.Modems = New DataTech.FaxManJr.Modems()
			Log("Detecting Modems...")
			modems.AutoDetect()
			_modemDictionary = New System.Collections.Specialized.ListDictionary()

			' first clear existing menu items if present.
			For i As Integer = mnuDevices.MenuItems.Count To 4 Step -1
				mnuDevices.MenuItems.Remove(mnuDevices.MenuItems(i-1))
			Next i

			' now find modems and add to device menu
			For Each modem As DataTech.FaxManJr.Modem In modems
				modem.Init = String.Format("{0}M0", modem.Init)
				Log(modem.ToString())
				Dim mnuDevice As MenuItem = New MenuItem(modem.ToString(), New System.EventHandler(AddressOf Me.mnuDevice_Click))
				If _faxing.DeviceStatus = DeviceStatuses.DeviceNotSet Then
					mnuDeviceSettings.Enabled = True
					mnuDevice.Checked = True
					_faxing.Modem = modem
					UpdateModemMenu(modem)
				End If
				'mnuDevice.
				mnuDevices.MenuItems.Add(mnuDevice)
				_modemDictionary.Add(modem.Port, modem)
			Next modem

			If _faxing.DeviceStatus = DeviceStatuses.DeviceNotSet Then
				Log("No Modems detected!")
				System.Windows.Forms.MessageBox.Show("No Modems detected.", "FaxManJr.NET sample application")
			Else
				Log("Detecting Modems Complete.")
			End If


			Return (_faxing.DeviceStatus <> DeviceStatuses.DeviceNotSet)
		End Function

		Private Sub UpdateModemMenu()
			UpdateModemMenu(_faxing.Modem)
		End Sub
		Private Sub UpdateModemMenu(ByVal modem As DataTech.FaxManJr.Modem)
			' First uncheck all menut items
			mnuClass2.Checked = False
			mnuClass1.Checked = mnuClass2.Checked
			mnuClass21.Checked = False
			mnuClass20.Checked = mnuClass21.Checked

			' Next enable all classes supported by the modem
			mnuClass1.Enabled = modem.Class1
			mnuClass2.Enabled = modem.Class2
			mnuClass20.Enabled = modem.Class20
			mnuClass21.Enabled = modem.Class21

			' Check the chosen FaxClass
			Select Case modem.FaxClass
				Case (FaxClass.Class1)
				mnuClass1.Checked = True
				Case (FaxClass.Class2)
					mnuClass2.Checked = True
				Case (FaxClass.Class20)
					mnuClass20.Checked = True
				Case (FaxClass.Class21)
					mnuClass21.Checked = True
			End Select

			' Finally update the Init strings
			mnuInitString.Text = modem.Init
			mnuResetString.Text = modem.Reset
		End Sub

		Private Function IsReceiving() As Boolean
			If _faxing.DeviceStatus = DeviceStatuses.DeviceListening Then
				Log("== Cancel Listening for Fax to Send")
				_faxing.CancelFax()
				_waitingToSend = True
			ElseIf _faxing.DeviceStatus = DeviceStatuses.DeviceReceiveMode Then
				_waitingToSend = True
				Log("== Cancel Receive Mode to Send")
				_faxing.CancelFax()
			ElseIf _faxing.DeviceStatus = DeviceStatuses.DeviceCurrentlyReceiving Then
				If System.Windows.Forms.DialogResult.Yes = System.Windows.Forms.MessageBox.Show("You are currently in the middle of receiving a fax! Are you sure you want to interupt this fax?", "FaxManJr.NET sample application", MessageBoxButtons.YesNo) Then
					_waitingToSend = True
					Log("== Canceling Fax in the middle of reception by users request!")
				End If
			End If
			Return (_waitingToSend)
		End Function


		' //////////////////////////////////////////
		' Persist Modem and Fax Objects Helper Functions

		Private Sub SaveModemOptions()
			If (Not Nothing Is _modemDictionary) AndAlso (_modemDictionary.Values.Count > 0) Then
				Dim filename As String = String.Format("{0}\modems.opt", Application.UserAppDataPath)
				Dim fs As FileStream = New FileStream(filename, FileMode.OpenOrCreate)
				Dim formatter As IFormatter = New BinaryFormatter()
				Try
					formatter.Serialize(fs, _modemDictionary)
				Catch e As System.Exception
					Log(String.Format("!! LoadModemOptions Exception: {0} ", e.Message))
				Finally
					fs.Close()
				End Try
				fs.Close()
			End If
		End Sub

		Private Sub LoadModemOptions()
			' load modem info if available
			Dim filename As String = String.Format("{0}\modems.opt", Application.UserAppDataPath)
			If System.IO.File.Exists(filename) Then
				Dim fs As FileStream = New FileStream(filename, FileMode.Open, System.IO.FileAccess.Read)
				' DeSerialize the ModemDictionary
				Dim formatter As IFormatter = New BinaryFormatter()
				Try
					Log("Loading previously configured modems options from file.")
					_modemDictionary = CType(formatter.Deserialize(fs), System.Collections.Specialized.ListDictionary)
					For Each modem As Modem In _modemDictionary.Values
						Log(modem.ToString())
						Dim mnuDevice As MenuItem = New MenuItem(modem.ToString(), New System.EventHandler(AddressOf Me.mnuDevice_Click))
						If _faxing.DeviceStatus = DeviceStatuses.DeviceNotSet Then
							mnuDeviceSettings.Enabled = True
							mnuDevice.Checked = True
							_faxing.Modem = modem
							UpdateModemMenu(modem)
						End If
						mnuDevices.MenuItems.Add(mnuDevice)

					Next modem
					Log("Done loading modems options from file.")
				Catch e As System.Exception
					Log(String.Format("!! LoadModemOptions Exception: {0} ", e.Message))
				Finally
					fs.Close()
				End Try
			End If
		End Sub

		Private Sub SaveSendFaxInformation()
			Dim filename As String = String.Format("{0}\sendfax.opt", Application.UserAppDataPath)
			Dim fs As FileStream = New FileStream(filename, FileMode.OpenOrCreate)
			Dim formatter As IFormatter = New BinaryFormatter()
			Try
				formatter.Serialize(fs, _fax)
			Catch e As System.Exception
				Log(String.Format("!! SaveSendFaxInformation Exception: {0} ", e.Message))
			Finally
				fs.Close()
			End Try
		End Sub

		Private Sub LoadSendFaxInformation()
			Dim filename As String = String.Format("{0}\sendfax.opt", Application.UserAppDataPath)
			If System.IO.File.Exists(filename) Then
				Dim fs As FileStream = New FileStream(filename, FileMode.Open, System.IO.FileAccess.Read)
				Dim formatter As IFormatter = New BinaryFormatter()
				Try
					_fax = CType(formatter.Deserialize(fs), DataTech.FaxManJr.Fax)
				Catch e As System.Exception
					Log(String.Format("!! LoadSendFaxInformation Exception: {0} ", e.Message))
				Finally
					fs.Close()
				End Try
			End If
		End Sub

		' //////////////////////////////////////////
		' Log Helper functions
		Private Sub Log(ByVal msg As String)
			If lbMessages.InvokeRequired Then
				Invoke(_log, New Object() {msg})
			Else
				LogHelper(msg)
			End If
		End Sub

		Private Sub LogHelper(ByVal msg As String)
			Debug.WriteLine(msg)

			lbMessages.Items.Add(msg)
			Dim itemsPerPage As Integer = CInt(Fix(lbMessages.Height / lbMessages.ItemHeight))
			If lbMessages.Items.Count > itemsPerPage Then
				lbMessages.TopIndex = lbMessages.Items.Count - itemsPerPage
			End If
			lbMessages.Refresh()
		End Sub

		' //////////////////////////////////////////
		' Image Helper function

		Private Function ImageOpenDialog() As String
			Dim returnFileName As String = ""

			Dim od As OpenFileDialog = New OpenFileDialog()
			od.Title = "Open Image File"
			od.Filter = "Image file (*.fmf;*.fmp;*.tif)|*.fmf;*.fmp;*.tif|All files (*.*)|*.*"
			od.FilterIndex = 1
			od.InitialDirectory = Application.UserAppDataPath
			If System.Windows.Forms.DialogResult.OK = od.ShowDialog() Then
				returnFileName = od.FileName
			End If
			Return (returnFileName)
		End Function

		Private Function LoadFaxFile(ByVal fileName As String) As ArrayList
			Dim _imgs As ArrayList = New ArrayList()
			Try

				' load image into bitmaparray
				' Sets the tiff file as an image object.
				Dim objImage As System.Drawing.Image = Image.FromFile(fileName)
				Dim objGuid As Guid = objImage.FrameDimensionsList(0)
				Dim objDimension As System.Drawing.Imaging.FrameDimension = New System.Drawing.Imaging.FrameDimension(objGuid)

				' Gets the total number of frames in the .tiff file
				Dim totFrame As Integer = objImage.GetFrameCount(objDimension)

				' Saves every frame as a seperate image in the ArrayList
				Dim i As Integer
				i = 0
				Do While i < totFrame
					objImage.SelectActiveFrame(objDimension, i)
					Dim img As Image = CType(objImage.Clone(), System.Drawing.Image)
					_imgs.Add(img)
					i += 1
				Loop
			Catch e As System.Exception
				Log(String.Format("!! Load Fax File Exception: {0} ", e.Message))
			End Try
			Return(_imgs)
		End Function

	End Class
End Namespace
