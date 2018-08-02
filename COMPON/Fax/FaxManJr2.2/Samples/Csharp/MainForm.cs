using System;
using System.Text;
using System.Drawing;
using System.Drawing.Printing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

using DataTech.FaxManJr;
using DataTech.FaxManNet;


namespace JrNetTest
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem mnuReceive;
		private System.Windows.Forms.MenuItem mnuCancel;
		private System.Windows.Forms.MenuItem mnuSend;
		private System.Windows.Forms.MenuItem mnuListen;
		private System.Windows.Forms.MenuItem mnuDevices;
		private System.Windows.Forms.MenuItem mnuAutoDetect;
		private System.Windows.Forms.MenuItem mnuTestSwitchModem;
		private System.Windows.Forms.MenuItem mnuTestBlindSend;
		private System.Windows.Forms.MenuItem mnuTestImportNada;
		private System.Windows.Forms.MenuItem mnuTestBlindReceive;
		private System.Windows.Forms.MenuItem mnuTestBlindAutoDetect;
		private System.Windows.Forms.MenuItem mnuBlindListen;
		private System.Windows.Forms.MenuItem mnuSend1000Faxes;
		private System.Windows.Forms.MenuItem mnuTestStopBatchSend;
		private System.Windows.Forms.MenuItem menuItem6;
		private System.Windows.Forms.MenuItem mnuTesting;
		private System.Windows.Forms.MenuItem mnuSettings;
		private System.Windows.Forms.MenuItem mnuExceptions;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem mnuResolution;
		private System.Windows.Forms.MenuItem mnuResolutionLow;
		private System.Windows.Forms.MenuItem mnuResolutionHigh;
		private System.Windows.Forms.MenuItem mnuStation;
		private System.Windows.Forms.MenuItem mnuStationID;
		private System.Windows.Forms.MenuItem mnuFilePrint;
		private System.Windows.Forms.MenuItem mnuInstallPrinter;
		private System.Windows.Forms.MenuItem mnuPrintTestPage;
		private DataTech.FaxManNet.FaxPrint faxPrint1;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem mnuKBase;
		private System.Windows.Forms.MenuItem mnuUpdateCenter;
		private System.Windows.Forms.MenuItem mnuBadDevice;
		private System.Windows.Forms.MenuItem mnuClass;
		private System.Windows.Forms.MenuItem mnuInit;
		private System.Windows.Forms.MenuItem mnuReset;
		private System.Windows.Forms.MenuItem menuItem11;
		private System.Windows.Forms.MenuItem mnuClass1;
		private System.Windows.Forms.MenuItem mnuClass2;
		private System.Windows.Forms.MenuItem mnuClass20;
		private System.Windows.Forms.MenuItem mnuInitString;
		private System.Windows.Forms.MenuItem mnuResetString;
		private System.Windows.Forms.MenuItem mnuDeviceSettings;
		private System.Windows.Forms.MenuItem mnuShowMessages;
		private System.Windows.Forms.TabControl tabMessageOrView;
		private System.Windows.Forms.ListBox lbMessages;
		private System.Windows.Forms.TabPage tabMessages;
		private System.Windows.Forms.TabPage tabViewFax;
		private System.Windows.Forms.MenuItem menuItem7;
		private System.Windows.Forms.MenuItem mnuPageFirst;
		private System.Windows.Forms.MenuItem mnuPagePrevious;
		private System.Windows.Forms.MenuItem mnuPageNext;
		private System.Windows.Forms.MenuItem mnuPageLast;
		private System.Windows.Forms.MenuItem Page;
		private System.Windows.Forms.Panel pnViewFax;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.MenuItem mnuOpenFaxFile;
		private System.Windows.Forms.MenuItem mnuClass21;
		private System.Windows.Forms.MenuItem mnuOnlineHelp;
		private System.ComponentModel.IContainer components;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			_faxing = new Faxing();
			_faxing.FaxMessage += new DataTech.FaxManJr.Faxing.__Delegate_FaxMessage(_faxing_FaxMessage);
			_faxing.FaxCompletionStatus +=new DataTech.FaxManJr.Faxing.__Delegate_FaxCompletionStatus(_faxing_FaxCompletionStatus);
			_faxing.FaxNegotiatedParameters +=new DataTech.FaxManJr.Faxing.__Delegate_FaxNegotiatedParameters(_faxing_FaxNegotiatedParameters);
			_faxing.FaxReceiveFileName +=new DataTech.FaxManJr.Faxing.__Delegate_FaxReceiveFileName(_faxing_FaxReceiveFileName);
			_faxing.FaxSetEndTime +=new DataTech.FaxManJr.Faxing.__Delegate_FaxSetEndTime(_faxing_FaxSetEndTime);
			_faxing.FaxSetPages +=new DataTech.FaxManJr.Faxing.__Delegate_FaxSetPages(_faxing_FaxSetPages);
			_faxing.FaxSetStartTime +=new DataTech.FaxManJr.Faxing.__Delegate_FaxSetStartTime(_faxing_FaxSetStartTime);
			_faxing.FaxStatus +=new DataTech.FaxManJr.Faxing.__Delegate_FaxStatus(_faxing_FaxStatus);
			_faxing.FaxRing +=new DataTech.FaxManJr.Faxing.__Delegate_FaxRing(_faxing_FaxRing);

			// Set the local ID
			_faxing.LocalID = "FmJrNet Sample";
			mnuStationID.Text = _faxing.LocalID;
			_faxing.ReceiveDir = String.Format("{0}\\", Application.UserAppDataPath);

			LoadModemOptions();
			LoadSendFaxInformation();

			if (null == _fax)
			{
				_fax = new Fax();
				_fax.Coverpage = "cover2.pg";
			}

			_faxJobs = new Queue();

			_showMessages = true;

			String filename = String.Format("{0}\\FmJrNetDebugLogFile_{1}.txt", 
				Application.UserAppDataPath, DateTime.Now.ToLongTimeString().Replace(":", "_").Replace(" ", "_"));
			_faxing.InitializeLogging(filename);

			if (faxPrint1.IsPrinterInstalled)
				SetupPrintDocument();
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if ((int)_faxing.DeviceStatus > 1)
					_faxing.CancelFax();
				
				SaveModemOptions();
				SaveSendFaxInformation();

				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuOpenFaxFile = new System.Windows.Forms.MenuItem();
			this.mnuSend = new System.Windows.Forms.MenuItem();
			this.mnuReceive = new System.Windows.Forms.MenuItem();
			this.mnuListen = new System.Windows.Forms.MenuItem();
			this.mnuCancel = new System.Windows.Forms.MenuItem();
			this.menuItem6 = new System.Windows.Forms.MenuItem();
			this.mnuSettings = new System.Windows.Forms.MenuItem();
			this.mnuResolution = new System.Windows.Forms.MenuItem();
			this.mnuResolutionLow = new System.Windows.Forms.MenuItem();
			this.mnuResolutionHigh = new System.Windows.Forms.MenuItem();
			this.mnuStation = new System.Windows.Forms.MenuItem();
			this.mnuStationID = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.mnuShowMessages = new System.Windows.Forms.MenuItem();
			this.mnuFilePrint = new System.Windows.Forms.MenuItem();
			this.mnuInstallPrinter = new System.Windows.Forms.MenuItem();
			this.mnuPrintTestPage = new System.Windows.Forms.MenuItem();
			this.mnuDevices = new System.Windows.Forms.MenuItem();
			this.mnuAutoDetect = new System.Windows.Forms.MenuItem();
			this.mnuDeviceSettings = new System.Windows.Forms.MenuItem();
			this.mnuClass = new System.Windows.Forms.MenuItem();
			this.mnuClass1 = new System.Windows.Forms.MenuItem();
			this.mnuClass2 = new System.Windows.Forms.MenuItem();
			this.mnuClass20 = new System.Windows.Forms.MenuItem();
			this.mnuClass21 = new System.Windows.Forms.MenuItem();
			this.mnuInit = new System.Windows.Forms.MenuItem();
			this.mnuInitString = new System.Windows.Forms.MenuItem();
			this.mnuReset = new System.Windows.Forms.MenuItem();
			this.mnuResetString = new System.Windows.Forms.MenuItem();
			this.menuItem11 = new System.Windows.Forms.MenuItem();
			this.Page = new System.Windows.Forms.MenuItem();
			this.mnuPageFirst = new System.Windows.Forms.MenuItem();
			this.mnuPagePrevious = new System.Windows.Forms.MenuItem();
			this.mnuPageNext = new System.Windows.Forms.MenuItem();
			this.mnuPageLast = new System.Windows.Forms.MenuItem();
			this.mnuTesting = new System.Windows.Forms.MenuItem();
			this.mnuSend1000Faxes = new System.Windows.Forms.MenuItem();
			this.mnuTestStopBatchSend = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.mnuExceptions = new System.Windows.Forms.MenuItem();
			this.mnuTestSwitchModem = new System.Windows.Forms.MenuItem();
			this.mnuTestBlindSend = new System.Windows.Forms.MenuItem();
			this.mnuTestImportNada = new System.Windows.Forms.MenuItem();
			this.mnuTestBlindReceive = new System.Windows.Forms.MenuItem();
			this.mnuTestBlindAutoDetect = new System.Windows.Forms.MenuItem();
			this.mnuBlindListen = new System.Windows.Forms.MenuItem();
			this.mnuBadDevice = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.mnuOnlineHelp = new System.Windows.Forms.MenuItem();
			this.mnuKBase = new System.Windows.Forms.MenuItem();
			this.mnuUpdateCenter = new System.Windows.Forms.MenuItem();
			this.faxPrint1 = new DataTech.FaxManNet.FaxPrint(this.components);
			this.tabMessageOrView = new System.Windows.Forms.TabControl();
			this.tabMessages = new System.Windows.Forms.TabPage();
			this.tabViewFax = new System.Windows.Forms.TabPage();
			this.lbMessages = new System.Windows.Forms.ListBox();
			this.pnViewFax = new System.Windows.Forms.Panel();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			((System.ComponentModel.ISupportInitialize)(this.faxPrint1)).BeginInit();
			this.tabMessageOrView.SuspendLayout();
			this.pnViewFax.SuspendLayout();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.mnuDevices,
																					  this.Page,
																					  this.mnuTesting,
																					  this.menuItem5});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.mnuOpenFaxFile,
																					  this.mnuSend,
																					  this.mnuReceive,
																					  this.mnuListen,
																					  this.mnuCancel,
																					  this.menuItem6,
																					  this.mnuSettings,
																					  this.mnuFilePrint});
			this.menuItem1.Text = "&Fax";
			// 
			// mnuOpenFaxFile
			// 
			this.mnuOpenFaxFile.Index = 0;
			this.mnuOpenFaxFile.Shortcut = System.Windows.Forms.Shortcut.CtrlO;
			this.mnuOpenFaxFile.Text = "&Open Fax File";
			this.mnuOpenFaxFile.Click += new System.EventHandler(this.mnuOpenFaxFile_Click);
			// 
			// mnuSend
			// 
			this.mnuSend.Index = 1;
			this.mnuSend.Shortcut = System.Windows.Forms.Shortcut.CtrlS;
			this.mnuSend.Text = "&Send";
			this.mnuSend.Click += new System.EventHandler(this.mnuSend_Click);
			// 
			// mnuReceive
			// 
			this.mnuReceive.Index = 2;
			this.mnuReceive.Shortcut = System.Windows.Forms.Shortcut.CtrlR;
			this.mnuReceive.Text = "Auto &Receive";
			this.mnuReceive.Click += new System.EventHandler(this.mnuReceive_Click);
			// 
			// mnuListen
			// 
			this.mnuListen.Index = 3;
			this.mnuListen.Shortcut = System.Windows.Forms.Shortcut.CtrlL;
			this.mnuListen.Text = "&Listen";
			this.mnuListen.Click += new System.EventHandler(this.mnuListen_Click);
			// 
			// mnuCancel
			// 
			this.mnuCancel.Index = 4;
			this.mnuCancel.Shortcut = System.Windows.Forms.Shortcut.Del;
			this.mnuCancel.Text = "&Cancel";
			this.mnuCancel.Click += new System.EventHandler(this.mnuCancel_Click);
			// 
			// menuItem6
			// 
			this.menuItem6.Index = 5;
			this.menuItem6.Text = "-";
			// 
			// mnuSettings
			// 
			this.mnuSettings.Index = 6;
			this.mnuSettings.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						this.mnuResolution,
																						this.mnuStation,
																						this.menuItem7,
																						this.mnuShowMessages});
			this.mnuSettings.Text = "&Global Settings";
			// 
			// mnuResolution
			// 
			this.mnuResolution.Index = 0;
			this.mnuResolution.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this.mnuResolutionLow,
																						  this.mnuResolutionHigh});
			this.mnuResolution.Text = "&Resolution";
			// 
			// mnuResolutionLow
			// 
			this.mnuResolutionLow.Index = 0;
			this.mnuResolutionLow.RadioCheck = true;
			this.mnuResolutionLow.Text = "&Low";
			this.mnuResolutionLow.Click += new System.EventHandler(this.mnuResolution_Click);
			// 
			// mnuResolutionHigh
			// 
			this.mnuResolutionHigh.Checked = true;
			this.mnuResolutionHigh.Index = 1;
			this.mnuResolutionHigh.RadioCheck = true;
			this.mnuResolutionHigh.Text = "&High";
			this.mnuResolutionHigh.Click += new System.EventHandler(this.mnuResolution_Click);
			// 
			// mnuStation
			// 
			this.mnuStation.Index = 1;
			this.mnuStation.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					   this.mnuStationID});
			this.mnuStation.Text = "&Station ID";
			// 
			// mnuStationID
			// 
			this.mnuStationID.Index = 0;
			this.mnuStationID.Text = "FmJrNet Sample";
			this.mnuStationID.Click += new System.EventHandler(this.mnuStationID_Click);
			// 
			// menuItem7
			// 
			this.menuItem7.Index = 2;
			this.menuItem7.Text = "-";
			// 
			// mnuShowMessages
			// 
			this.mnuShowMessages.Checked = true;
			this.mnuShowMessages.Index = 3;
			this.mnuShowMessages.Text = "Show &Messages";
			this.mnuShowMessages.Click += new System.EventHandler(this.mnuShowMessages_Click);
			// 
			// mnuFilePrint
			// 
			this.mnuFilePrint.Index = 7;
			this.mnuFilePrint.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						 this.mnuInstallPrinter,
																						 this.mnuPrintTestPage});
			this.mnuFilePrint.Text = "&Print";
			// 
			// mnuInstallPrinter
			// 
			this.mnuInstallPrinter.Index = 0;
			this.mnuInstallPrinter.Text = "&Install Printer";
			this.mnuInstallPrinter.Click += new System.EventHandler(this.mnuInstallPrinter_Click);
			// 
			// mnuPrintTestPage
			// 
			this.mnuPrintTestPage.Enabled = false;
			this.mnuPrintTestPage.Index = 1;
			this.mnuPrintTestPage.Text = "&Print Test Page";
			this.mnuPrintTestPage.Click += new System.EventHandler(this.mnuPrintTestPage_Click);
			// 
			// mnuDevices
			// 
			this.mnuDevices.Index = 1;
			this.mnuDevices.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					   this.mnuAutoDetect,
																					   this.mnuDeviceSettings,
																					   this.menuItem11});
			this.mnuDevices.Text = "&Devices";
			// 
			// mnuAutoDetect
			// 
			this.mnuAutoDetect.Index = 0;
			this.mnuAutoDetect.Text = "&Auto Detect";
			this.mnuAutoDetect.Click += new System.EventHandler(this.mnuAutoDetect_Click);
			// 
			// mnuDeviceSettings
			// 
			this.mnuDeviceSettings.Enabled = false;
			this.mnuDeviceSettings.Index = 1;
			this.mnuDeviceSettings.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																							  this.mnuClass,
																							  this.mnuInit,
																							  this.mnuReset});
			this.mnuDeviceSettings.Text = "&Device Settings";
			// 
			// mnuClass
			// 
			this.mnuClass.Index = 0;
			this.mnuClass.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.mnuClass1,
																					 this.mnuClass2,
																					 this.mnuClass20,
																					 this.mnuClass21});
			this.mnuClass.Text = "&Class";
			// 
			// mnuClass1
			// 
			this.mnuClass1.Index = 0;
			this.mnuClass1.Text = "Class &1";
			this.mnuClass1.Click += new System.EventHandler(this.mnuClass1_Click);
			// 
			// mnuClass2
			// 
			this.mnuClass2.Index = 1;
			this.mnuClass2.Text = "Class &2";
			this.mnuClass2.Click += new System.EventHandler(this.mnuClass2_Click);
			// 
			// mnuClass20
			// 
			this.mnuClass20.Index = 2;
			this.mnuClass20.Text = "Class 2.&0";
			this.mnuClass20.Click += new System.EventHandler(this.mnuClass20_Click);
			// 
			// mnuClass21
			// 
			this.mnuClass21.Index = 3;
			this.mnuClass21.Text = "Class 2.1";
			this.mnuClass21.Click += new System.EventHandler(this.mnuClass21_Click);
			// 
			// mnuInit
			// 
			this.mnuInit.Index = 1;
			this.mnuInit.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					this.mnuInitString});
			this.mnuInit.Text = "&Init";
			// 
			// mnuInitString
			// 
			this.mnuInitString.Index = 0;
			this.mnuInitString.Text = "AT&FE0V1C1D2S0=0M0";
			this.mnuInitString.Click += new System.EventHandler(this.mnuInitString_Click);
			// 
			// mnuReset
			// 
			this.mnuReset.Index = 2;
			this.mnuReset.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.mnuResetString});
			this.mnuReset.Text = "&Reset";
			// 
			// mnuResetString
			// 
			this.mnuResetString.Index = 0;
			this.mnuResetString.Text = "AT";
			this.mnuResetString.Click += new System.EventHandler(this.mnuResetString_Click);
			// 
			// menuItem11
			// 
			this.menuItem11.Index = 2;
			this.menuItem11.Text = "-";
			// 
			// Page
			// 
			this.Page.Index = 2;
			this.Page.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																				 this.mnuPageFirst,
																				 this.mnuPagePrevious,
																				 this.mnuPageNext,
																				 this.mnuPageLast});
			this.Page.Text = "&Page";
			this.Page.Visible = false;
			// 
			// mnuPageFirst
			// 
			this.mnuPageFirst.Index = 0;
			this.mnuPageFirst.Shortcut = System.Windows.Forms.Shortcut.F5;
			this.mnuPageFirst.Text = "&First";
			this.mnuPageFirst.Click += new System.EventHandler(this.mnuPageFirst_Click);
			// 
			// mnuPagePrevious
			// 
			this.mnuPagePrevious.Index = 1;
			this.mnuPagePrevious.Shortcut = System.Windows.Forms.Shortcut.F6;
			this.mnuPagePrevious.Text = "&Previous";
			this.mnuPagePrevious.Click += new System.EventHandler(this.mnuPagePrevious_Click);
			// 
			// mnuPageNext
			// 
			this.mnuPageNext.Index = 2;
			this.mnuPageNext.Shortcut = System.Windows.Forms.Shortcut.F7;
			this.mnuPageNext.Text = "&Next";
			this.mnuPageNext.Click += new System.EventHandler(this.mnuPageNext_Click);
			// 
			// mnuPageLast
			// 
			this.mnuPageLast.Index = 3;
			this.mnuPageLast.Shortcut = System.Windows.Forms.Shortcut.F8;
			this.mnuPageLast.Text = "&Last";
			this.mnuPageLast.Click += new System.EventHandler(this.mnuPageLast_Click);
			// 
			// mnuTesting
			// 
			this.mnuTesting.Index = 3;
			this.mnuTesting.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					   this.mnuSend1000Faxes,
																					   this.mnuTestStopBatchSend,
																					   this.menuItem4,
																					   this.mnuExceptions});
			this.mnuTesting.Text = "&Testing";
			// 
			// mnuSend1000Faxes
			// 
			this.mnuSend1000Faxes.Index = 0;
			this.mnuSend1000Faxes.Text = "Send Batch of &1000 Faxes";
			this.mnuSend1000Faxes.Click += new System.EventHandler(this.mnuTestBatchSend1000_Click);
			// 
			// mnuTestStopBatchSend
			// 
			this.mnuTestStopBatchSend.Index = 1;
			this.mnuTestStopBatchSend.Text = "Stop &Batch Send";
			this.mnuTestStopBatchSend.Click += new System.EventHandler(this.mnuTestStopBatchSend_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 2;
			this.menuItem4.Text = "-";
			// 
			// mnuExceptions
			// 
			this.mnuExceptions.Index = 3;
			this.mnuExceptions.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																						  this.mnuTestSwitchModem,
																						  this.mnuTestBlindSend,
																						  this.mnuTestImportNada,
																						  this.mnuTestBlindReceive,
																						  this.mnuTestBlindAutoDetect,
																						  this.mnuBlindListen,
																						  this.mnuBadDevice});
			this.mnuExceptions.Text = "Throw &Exceptions";
			// 
			// mnuTestSwitchModem
			// 
			this.mnuTestSwitchModem.Index = 0;
			this.mnuTestSwitchModem.Text = "Switch &Modem";
			this.mnuTestSwitchModem.Click += new System.EventHandler(this.mnuTestSwitchModem_Click);
			// 
			// mnuTestBlindSend
			// 
			this.mnuTestBlindSend.Index = 1;
			this.mnuTestBlindSend.Text = "Blind &Send";
			this.mnuTestBlindSend.Click += new System.EventHandler(this.mnuTestBlindSend_Click);
			// 
			// mnuTestImportNada
			// 
			this.mnuTestImportNada.Index = 2;
			this.mnuTestImportNada.Text = "&Import Nada";
			this.mnuTestImportNada.Click += new System.EventHandler(this.mnuTestImportNada_Click);
			// 
			// mnuTestBlindReceive
			// 
			this.mnuTestBlindReceive.Index = 3;
			this.mnuTestBlindReceive.Text = "Blind &Receive";
			this.mnuTestBlindReceive.Click += new System.EventHandler(this.mnuTestBlindReceive_Click);
			// 
			// mnuTestBlindAutoDetect
			// 
			this.mnuTestBlindAutoDetect.Index = 4;
			this.mnuTestBlindAutoDetect.Text = "Blind &Auto Detect";
			this.mnuTestBlindAutoDetect.Click += new System.EventHandler(this.mnuTestBlindAutoDetect_Click);
			// 
			// mnuBlindListen
			// 
			this.mnuBlindListen.Index = 5;
			this.mnuBlindListen.Text = "Blind &Listen";
			this.mnuBlindListen.Click += new System.EventHandler(this.mnuBlindListen_Click);
			// 
			// mnuBadDevice
			// 
			this.mnuBadDevice.Index = 6;
			this.mnuBadDevice.Text = "&Bad Device";
			this.mnuBadDevice.Click += new System.EventHandler(this.mnuBadDevice_Click);
			// 
			// menuItem5
			// 
			this.menuItem5.Index = 4;
			this.menuItem5.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.mnuOnlineHelp,
																					  this.mnuKBase,
																					  this.mnuUpdateCenter});
			this.menuItem5.Text = "&Help";
			// 
			// mnuOnlineHelp
			// 
			this.mnuOnlineHelp.Index = 0;
			this.mnuOnlineHelp.Shortcut = System.Windows.Forms.Shortcut.F1;
			this.mnuOnlineHelp.Text = "Online &Help";
			this.mnuOnlineHelp.Click += new System.EventHandler(this.mnuOnlineHelp_Click);
			// 
			// mnuKBase
			// 
			this.mnuKBase.Index = 1;
			this.mnuKBase.Text = "&DTI KnowledgeBase";
			this.mnuKBase.Click += new System.EventHandler(this.mnuKBase_Click);
			// 
			// mnuUpdateCenter
			// 
			this.mnuUpdateCenter.Index = 2;
			this.mnuUpdateCenter.Text = "Online &Update Center";
			this.mnuUpdateCenter.Click += new System.EventHandler(this.mnuUpdateCenter_Click);
			// 
			// faxPrint1
			// 
			this.faxPrint1.PrinterName = "FAXJR TEST";
			this.faxPrint1.PrintFilesPath = "C:\\DOCUME~1\\Eric\\LOCALS~1\\Temp\\";
			this.faxPrint1.PrintComplete += new DataTech.FaxManNet.FaxPrint.__Delegate_PrintComplete(this.faxPrint1_PrintComplete);
			// 
			// tabMessageOrView
			// 
			this.tabMessageOrView.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.tabMessageOrView.Controls.Add(this.tabMessages);
			this.tabMessageOrView.Controls.Add(this.tabViewFax);
			this.tabMessageOrView.Location = new System.Drawing.Point(0, 0);
			this.tabMessageOrView.Name = "tabMessageOrView";
			this.tabMessageOrView.SelectedIndex = 0;
			this.tabMessageOrView.Size = new System.Drawing.Size(432, 24);
			this.tabMessageOrView.TabIndex = 0;
			this.tabMessageOrView.SelectedIndexChanged += new System.EventHandler(this.tabMessageOrView_SelectedIndexChanged);
			// 
			// tabMessages
			// 
			this.tabMessages.Location = new System.Drawing.Point(4, 22);
			this.tabMessages.Name = "tabMessages";
			this.tabMessages.Size = new System.Drawing.Size(424, 0);
			this.tabMessages.TabIndex = 0;
			this.tabMessages.Text = "Events and Messages";
			// 
			// tabViewFax
			// 
			this.tabViewFax.Location = new System.Drawing.Point(4, 22);
			this.tabViewFax.Name = "tabViewFax";
			this.tabViewFax.Size = new System.Drawing.Size(424, -2);
			this.tabViewFax.TabIndex = 1;
			this.tabViewFax.Text = "View Fax";
			// 
			// lbMessages
			// 
			this.lbMessages.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.lbMessages.Location = new System.Drawing.Point(0, 24);
			this.lbMessages.Name = "lbMessages";
			this.lbMessages.ScrollAlwaysVisible = true;
			this.lbMessages.Size = new System.Drawing.Size(128, 420);
			this.lbMessages.TabIndex = 2;
			// 
			// pnViewFax
			// 
			this.pnViewFax.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.pnViewFax.AutoScroll = true;
			this.pnViewFax.Controls.Add(this.pictureBox1);
			this.pnViewFax.Location = new System.Drawing.Point(0, 24);
			this.pnViewFax.Name = "pnViewFax";
			this.pnViewFax.Size = new System.Drawing.Size(280, 416);
			this.pnViewFax.TabIndex = 4;
			// 
			// pictureBox1
			// 
			this.pictureBox1.Location = new System.Drawing.Point(0, 0);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(240, 232);
			this.pictureBox1.TabIndex = 4;
			this.pictureBox1.TabStop = false;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.AutoScroll = true;
			this.ClientSize = new System.Drawing.Size(432, 441);
			this.Controls.Add(this.lbMessages);
			this.Controls.Add(this.tabMessageOrView);
			this.Controls.Add(this.pnViewFax);
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.Text = "Faxman Jr.NET Test Application";
			this.Load += new System.EventHandler(this.Form1_Load);
			((System.ComponentModel.ISupportInitialize)(this.faxPrint1)).EndInit();
			this.tabMessageOrView.ResumeLayout(false);
			this.pnViewFax.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		// //////////////////////////////////////////
		// Form Level Variables
		private DataTech.FaxManJr.Faxing _faxing;
		private System.Collections.Specialized.ListDictionary _modemDictionary;
		private bool _waitingToSend;
		private DataTech.FaxManJr.Fax _fax;
		private System.Collections.Queue _faxJobs;
		private bool _showMessages;
		private PrintDocument _printDoc;
		private int	_receiveErrors;
		private LogDelegate _log;
		private delegate void ShowImageDelegate(bool image);
		private ShowImageDelegate _showImage;
		private ArrayList _imgs;
		private int _page;
		
		private delegate void LogDelegate(string msg);

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			// For ease of editing stacked controls are not full size
			// Make them full size now.
			pnViewFax.Width = this.ClientSize.Width;
			lbMessages.Width = this.ClientSize.Width;

			_log = new LogDelegate(LogHelper);
			_showImage = new ShowImageDelegate(ShowImageHelper);
		}

		// //////////////////////////////////////////
		// Main Sample Menu Handlers

		private void mnuOpenFaxFile_Click(object sender, System.EventArgs e)
		{
			String file = ImageOpenDialog();
			if (file.Length > 1)
			{
				_imgs =  LoadFaxFile(file);
				LoadImage();
			}

		}

		private void mnuSend_Click(object sender, System.EventArgs e)
		{
			SendFaxForm sendFax = new SendFaxForm(_fax);
			if (DialogResult.OK == sendFax.ShowDialog())
			{
				// may not be necessary if passing reference instead of copy
				_fax = sendFax._fax;
				if (!(IsReceiving()))
				{
					if (!CheckModem()) return;
					Log("======================================");
					Log("== Sending a Fax");
					
					_faxing.Send(_fax);
				}
			}
		
		}

		private void mnuReceive_Click(object sender, System.EventArgs e)
		{
			if (mnuReceive.Checked)
			{
				mnuReceive.Checked = false;
				if (_faxing.DeviceStatus == DeviceStatuses.DeviceReceiveMode) 
				{
					Log("= Turning off Receive Mode");
					_faxing.CancelFax();
				}
				else if (_faxing.DeviceStatus == DeviceStatuses.DeviceCurrentlyReceiving)
				{
					if (System.Windows.Forms.DialogResult.Yes == 
						System.Windows.Forms.MessageBox.Show( 
						"You are currently in the middle of receiving a fax! Do you want to cancel the current fax?", 
						"FaxManJr.NET sample application", MessageBoxButtons.YesNo)) 
					{
						Log("== Canceling Fax in the middle of reception by users request!");
					}
				}
			}
			else
			{
				if (!CheckModem()) return;
				Log("======================================");
				Log("== Ready to Receive a Fax");

				_faxing.Receive(1);
				mnuReceive.Checked = true;
			}
		}

		private void mnuListen_Click(object sender, System.EventArgs e)
		{
			if (!CheckModem()) return;
			Log("======================================");
			Log("== Listening for a Fax");

			_faxing.Listen();
		}

		private void mnuCancel_Click(object sender, System.EventArgs e)
		{
			if ((int)_faxing.DeviceStatus > 1)
			{
				Log("== Cancel Fax");
				_faxing.CancelFax();
			}
		}

		private void mnuStationID_Click(object sender, System.EventArgs e)
		{
			InputDialog id = new InputDialog("FmJr Net Test - Station ID", "Please Enter your station ID.\r\nNote: this field has a maximum length of 20 characters.", _faxing.LocalID);
			if (DialogResult.OK == id.ShowDialog())
			{
				_faxing.LocalID = id.InputText;
				mnuStationID.Text = id.InputText;
			}
		}

		private void mnuResolution_Click(object sender, System.EventArgs e)
		{
			MenuItem item = (MenuItem)sender;
			if (item.Text.IndexOf("High")>0)
			{
				_fax.FaxResolution = FaxResolution.High;
				mnuResolutionHigh.Checked = true;
				mnuResolutionLow.Checked = false;
			}
			else
			{
				_fax.FaxResolution = FaxResolution.Low;
				mnuResolutionHigh.Checked = false;
				mnuResolutionLow.Checked = true;
			}
		}

		private void mnuShowMessages_Click(object sender, System.EventArgs e)
		{
			mnuShowMessages.Checked = _showMessages = !_showMessages;
		}

		// //////////////////////////////////////////
		// Printing Support

		private void faxPrint1_PrintComplete()
		{
			Log("== Printing To Sample Application Completed.");
			DataTech.FaxManNet.PrintJob pj = faxPrint1.PrintJobs.GetNextPrintJob();
			Log("== File Created:"); 
			Log(pj.FileName);
			Log("== File Added to list of faxable files.");
			if (0 == pj.Status)
			{
				_fax.FaxFiles.Add(pj.FileName);
				_imgs = LoadFaxFile(pj.FileName);
				ShowImage(true);
			}
		}

		private void mnuInstallPrinter_Click(object sender, System.EventArgs e)
		{
			// Printer name set in Form startup code
			// faxPrint1.PrinterName = "JrNetTest Fax Printer";
			if (faxPrint1.IsPrinterInstalled)
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Printer Already Installed");
				System.Windows.Forms.MessageBox.Show("Printer already installed.", "FaxManJr.NET sample application");
				return;
			}
			Log("======================================");
			Log(String.Format("== Installing Printer: {0}", faxPrint1.PrinterName));
			
			faxPrint1.PrintFilesPath = Application.UserAppDataPath;
			if (faxPrint1.InstallPrinter(Application.ExecutablePath))
			{
				Log("== Printer Installed correctly.");
				SetupPrintDocument();
			}
			else
			{
				Log("!! Printer Installation Failed!!!");
				Log("!! Please make sure you have Administrative rights on this machine!");
				Log("!! Check the Installationg Log File for more information:");
				Log("C:\\Documents and Settings\\*CURRENTUSER*\\Local Settings\\Temp\\FaxNetPrinterInstall.log");
			}
		
		}

		private void SetupPrintDocument()
		{
			_printDoc = new PrintDocument();
			_printDoc.PrintPage +=new PrintPageEventHandler(OnPrintPage);
			_printDoc.PrinterSettings.PrinterName = faxPrint1.PrinterName;
			mnuPrintTestPage.Enabled = true;
		}

		private void mnuPrintTestPage_Click(object sender, System.EventArgs e)
		{
			Log("== Printing Test Page.");
			_printDoc.Print();
		}

		protected void OnPrintPage(object sender, PrintPageEventArgs e)
		{
			Rectangle PageBounds = new Rectangle(e.MarginBounds.Left, e.MarginBounds.Top, e.MarginBounds.Width, e.MarginBounds.Height);
			Pen LinePen = new Pen(Color.Black);
			e.Graphics.DrawLine(LinePen, PageBounds.Left, PageBounds.Top, PageBounds.Left + PageBounds.Width, PageBounds.Top);
			PageBounds.Inflate(-20, -20);
			e.Graphics.DrawString("FaxMan Jr Printing Test Page", new Font("Arial", 24), Brushes.Black, PageBounds);
			e.HasMorePages = false;
		}

		// //////////////////////////////////////////
		// Main Interface Is it viewing a fax or is it messages

		private void tabMessageOrView_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			if (1 == tabMessageOrView.SelectedIndex)
			{
				if ((null == _imgs) || (_imgs.Count < 1))
				{
					String file = ImageOpenDialog();
					if (file.Length > 1)
						_imgs =  LoadFaxFile(file);
				}
				pnViewFax.BringToFront();
				LoadImage();
			}
			else
			{
				lbMessages.BringToFront();
			}
		}


		// //////////////////////////////////////////
		// FaxMan Jr Control Status Event Handlers

		// FaxModem Strings sent to and from device
		private void _faxing_FaxMessage(object sender, FaxMessageArgs args)
		{
			if(_showMessages)
				Log(String.Format("      {0}", args.Message));
		}

		// This is the event when the device is no longer busy.
		// It is a good place to handle Auto Receive and Batch Sending.
		private void _faxing_FaxCompletionStatus(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Fax Completed - Fax Status: {0}.  General Error: {1}",
				args.Fax.FaxStatus, args.Fax.GeneralError));
			if (DataTech.FaxManJr.FaxError.Ok != args.Fax.FaxError)
				Log(String.Format("== Fax Error: {0}.  Fax Error String: {1}", args.Fax.FaxError, args.Fax.FaxErrorString));

			Log("== Fax Session Completed");
			Log("======================================");

			if (lbMessages.Items.Count > 2000)
			{
				lbMessages.Items.Clear();
				Log("======================================");
				Log("== Cleared out fax messages.");
				Log("== Messages were over 2000 entries.");
			}

			if (_faxJobs.Count > 0)
			{
				// reschedule if failed by sending to end of queue
				// limit number of retries ~ 3 by length of user data
				if ( (FaxError.Ok != args.Fax.FaxError) && (args.Fax.UserData.Length < 50) )
				{
					Log("== Fax Failed Rescheduling Fax");
					Log("======================================");
					args.Fax.UserData = String.Format("== {0} Trying Again", args.Fax.UserData);
					_faxJobs.Enqueue(args.Fax);
				}

				DataTech.FaxManJr.Fax fax = (DataTech.FaxManJr.Fax)_faxJobs.Dequeue();
				Log("======================================");
				Log(String.Format("== Sending {0}", fax.UserData));
				_faxing.Send(fax);

			}
			else if (_waitingToSend)
			{
				_waitingToSend = false;
				if (!CheckModem()) return;
				Log("======================================");
				Log("== Sending a Fax");

				_faxing.Send(_fax);
			}
			else if (mnuReceive.Checked == true)
			{
				// Check for bad receive device to prevent endless cycling
				_receiveErrors = (DataTech.FaxManJr.FaxError.Error == args.Fax.FaxError) ? _receiveErrors + 1 : 0;
				if (2 == ((_receiveErrors - 1) % 3))
				{
					Log(String.Format("== Failed {0} times in a row with a general modem error!!!", _receiveErrors));
					if (_receiveErrors < 15)
					{
						Log("== You may want to turn Auto Receive Off and check your device.");
						System.Threading.Thread.Sleep(5000);
					} 
					else
					{
						Log("== Turning Auto Receive Off!!!");
						mnuReceive.Checked = false;
						return;
					}
				}
				// Let's receive another fax
				Log("======================================");
				Log("== Ready to Receive another Fax");
				_faxing.Receive(1);
				
				if (DataTech.FaxManJr.FaxError.Ok == args.Fax.FaxError)
				{
					// Display received fax in The Framework image control which
					// is intolerant, for better display use ImageMan.Net
					// First Clean up received buffers by importing the file first,
					// This step is not necessary with ImageMan.Net.
					String fileName = args.Fax.FaxFiles[0].ToString();
					String tempFile = String.Format("{0}.tmp", fileName);
					_faxing.ImportFiles(fileName, tempFile);
					System.IO.File.Delete(fileName);
					System.IO.File.Move(tempFile, fileName);
					_imgs = LoadFaxFile(fileName);
					ShowImage(true);
				}
			}
		}

		private void _faxing_FaxNegotiatedParameters(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Negotiated Paramters Speed: {0} Resolution: {1} RemoteID: {2}",
				args.Fax.Speed, args.Fax.FaxResolution, args.Fax.RemoteID));
		}

		private void _faxing_FaxReceiveFileName(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Receive Filename File: {0}", args.Fax.Files));
		}

		private void _faxing_FaxSetEndTime(object sender, FaxEventArgs args)
		{
			Log(String.Format("== End Time Duration: {0}", args.Fax.Duration));
		}

		private void _faxing_FaxSetPages(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Page {0} of {1}", args.Fax.PagesSent, args.Fax.TotalPages));
		}

		private void _faxing_FaxSetStartTime(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Start Time Time: {0} {1}", 
				args.Fax.SentDateTime.ToLongTimeString(), args.Fax.SentDateTime.ToLongDateString()));
		}

		private void _faxing_FaxStatus(object sender, FaxEventArgs args)
		{
			Log(String.Format("== Status: {0}", args.Fax.FaxStatus));
			if ( (DataTech.FaxManJr.FaxStatus.Answering == args.Fax.FaxStatus) ||
				(DataTech.FaxManJr.FaxStatus.SendConnected == args.Fax.FaxStatus) )
				ShowImage(false);
		}

		private void _faxing_FaxRing(object sender, FaxRingArgs args)
		{
			Log("== Ring Event.");
			Log(String.Format("== Current Ring Action: {0}", args.Action.ToString()));
			Log(String.Format("== Setting to Ring Action: {0}", RingActions.ReceiveFax));
			args.Action = RingActions.ReceiveFax;
		}

		// //////////////////////////////////////////
		// Device Menu

		private void mnuAutoDetect_Click(object sender, System.EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			AutoDetect();
			this.Cursor = Cursors.Default;
		}

		private void mnuDevice_Click(object sender, System.EventArgs e)
		{
			if ((int)_faxing.DeviceStatus > 1)
			{
				MessageBox.Show("Can't switch modem while currently in use.");
				return;
			}

			// clear checks
			foreach (MenuItem mnu in mnuDevices.MenuItems)
				mnu.Checked = false;

			// check and select chosen modem
			MenuItem mnuSender = (MenuItem)sender;
			mnuSender.Checked = true;

			int port = int.Parse(mnuSender.Text.Substring(mnuSender.Text.IndexOf(":") - 2, 2));
			_faxing.Modem = (DataTech.FaxManJr.Modem)_modemDictionary[port];
			UpdateModemMenu(_faxing.Modem);
		}

		private void mnuInitString_Click(object sender, System.EventArgs e)
		{
			InputDialog id = new InputDialog("FmJr Net Test - Init String", "Consult your modem AT command set documentation.\r\nAdd Flow control to this string if not on by default.\r\nOften this is &F1, /Q1 or &K3.", _faxing.Modem.Init);
			if (DialogResult.OK == id.ShowDialog())
			{
				_faxing.Modem.Init = id.InputText;
				mnuInitString.Text = id.InputText;
			}
		}

		private void mnuResetString_Click(object sender, System.EventArgs e)
		{
			InputDialog id = new InputDialog("FmJr Net Test - Reset String", "This is often best left at AT.\r\nSome modems have an ATZ option but\r\nusing this may cause a delay and other problems.", _faxing.Modem.Reset);
			if (DialogResult.OK == id.ShowDialog())
			{
				_faxing.Modem.Reset = id.InputText;
				mnuResetString.Text = id.InputText;
			}
		}

		private void mnuClass1_Click(object sender, System.EventArgs e)
		{
			_faxing.Modem.FaxClass = FaxClass.Class1;
			UpdateModemMenu();
		}

		private void mnuClass2_Click(object sender, System.EventArgs e)
		{
			_faxing.Modem.FaxClass = FaxClass.Class2;
			UpdateModemMenu();
		}

		private void mnuClass20_Click(object sender, System.EventArgs e)
		{
			_faxing.Modem.FaxClass = FaxClass.Class20;
			UpdateModemMenu();
		}

		private void mnuClass21_Click(object sender, System.EventArgs e)
		{
			_faxing.Modem.FaxClass = FaxClass.Class21;
			UpdateModemMenu();
		}

		// //////////////////////////////////////////
		// Fax View Page Menu and variable and helper functions

		private void mnuPageFirst_Click(object sender, System.EventArgs e)
		{
			LoadImage(_page = 0);
		}

		private void mnuPagePrevious_Click(object sender, System.EventArgs e)
		{
			if (_page > 0) 
				LoadImage(--_page);
		}

		private void mnuPageNext_Click(object sender, System.EventArgs e)
		{
			if ( (null != _imgs) && (_imgs.Count - 1 > _page) ) 
				LoadImage(++_page);
		}

		private void mnuPageLast_Click(object sender, System.EventArgs e)
		{
			if ( (null != _imgs) && (_imgs.Count - 1 > _page) ) 
				LoadImage(_page = _imgs.Count - 1);
		}

		private void LoadImage() { LoadImage(0); }
		private void LoadImage(int page)
		{
			if ( (null != _imgs) && (_imgs.Count > page) )
			{
				Page.Text = String.Format("&Page {0} of {1}", page + 1, _imgs.Count);
				Page.Visible = (_imgs.Count > 1);
				pictureBox1.Image = (System.Drawing.Image)_imgs[page];
				pictureBox1.Width = pictureBox1.Image.Width;
				pictureBox1.Height = pictureBox1.Image.Height;
				pictureBox1.Refresh();
			}
		}

		private void ShowImage(bool image)
		{
			if (pnViewFax.InvokeRequired || tabMessageOrView.InvokeRequired || 
				lbMessages.InvokeRequired || pictureBox1.InvokeRequired)
					Invoke(_showImage, new object[] {image});
				else
					ShowImageHelper(image);
		}

		private void ShowImageHelper(bool image)
		{
			if (image)
			{
				LoadImage();
				pnViewFax.BringToFront();
				tabMessageOrView.SelectedIndex = 1;
			}
			else
			{
				// Let's see what is happening in the messages log
				lbMessages.BringToFront();
				tabMessageOrView.SelectedIndex = 0;
			}
		}

		// //////////////////////////////////////////
		// Test Menu

		private void mnuTestBatchSend1000_Click(object sender, System.EventArgs e)
		{
			try
			{
				SendFaxForm sendFax = new SendFaxForm(_fax);
				if (DialogResult.OK == sendFax.ShowDialog())
				{
					// may not be necessary if passing reference instead of copy
					_fax = sendFax._fax;

					Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					Log("!! Queing up 1000 faxes");

					for (int i = 0; i < 1000; i++)
					{	
						DataTech.FaxManJr.Fax fax = _fax.Clone();
						fax.UserData = String.Format("Fax {0} of {1}", i, 1000);
						_faxJobs.Enqueue(fax);
					}
					
					DataTech.FaxManJr.Fax tfax = (DataTech.FaxManJr.Fax)_faxJobs.Dequeue();
					Log("======================================");
					Log(String.Format("== Sending {0}", tfax.UserData));
					_faxing.Send(tfax);
				}


			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuTestStopBatchSend_Click(object sender, System.EventArgs e)
		{
			_faxJobs.Clear();
			_faxing.CancelFax();
		}

		private void mnuTestSwitchModem_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Blind Switch Modem");

				DataTech.FaxManJr.Modem mdm = new Modem(1, FaxClass.Class1);
				_faxing.Modem = mdm;
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuTestBlindSend_Click(object sender, System.EventArgs e)
		{
		
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Blind Send Fax");

				_faxing.Send(_fax);
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuTestImportNada_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Import Nothing");

				_faxing.ImportFiles("", "");
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuTestBlindReceive_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Blind Receive Fax");

				_faxing.Receive(1);
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuTestBlindAutoDetect_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Blind Auto Detect");

				DataTech.FaxManJr.Modems modems = new DataTech.FaxManJr.Modems();
				modems.AutoDetect();
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuBlindListen_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Blind Listen For Fax");

				_faxing.Listen();
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}

		private void mnuBadDevice_Click(object sender, System.EventArgs e)
		{
			try
			{
				Log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				Log("!! Pick a Bad Device, try port 21");

				DataTech.FaxManJr.Modem mdm = new Modem(21, FaxClass.Class21);
				_faxing.Modem = mdm;
			}
			catch (Exception ex)
			{
				Log(String.Format("!! Exception: {0} ", ex.Message));
			}
		}


		// //////////////////////////////////////////
		// Help Menu

		private void mnuOnlineHelp_Click(object sender, System.EventArgs e)
		{
			System.Diagnostics.Process.Start("http://www.data-tech.com/help/faxjr2/webframe.html");
		}

		private void mnuUpdateCenter_Click(object sender, System.EventArgs e)
		{
			System.Diagnostics.Process.Start("http://data-tech.com/myproducts/login.aspx");
		}

		private void mnuKBase_Click(object sender, System.EventArgs e)
		{
			System.Diagnostics.Process.Start("http://data-tech.com/support/newkb.aspx");
		}

		// //////////////////////////////////////////
		// Device Helper functions
		private bool CheckModem()
		{
			if (_faxing.DeviceStatus == DeviceStatuses.DeviceNotSet)
			{
				if (System.Windows.Forms.DialogResult.Yes == 
					System.Windows.Forms.MessageBox.Show( 
					"No Modems are detected. Would you like to Auto Detect for Modems?", 
					"FaxManJr.NET sample application", MessageBoxButtons.YesNo))
				{
					this.Cursor = Cursors.WaitCursor;
					AutoDetect();
					this.Cursor = Cursors.Default;
				}
			} 
			else if (_faxing.DeviceStatus != DeviceStatuses.DeviceReady)
			{
				MessageBox.Show("Modem Currently in use.");
			}

			return (_faxing.DeviceStatus == DeviceStatuses.DeviceReady);
		}

		private bool AutoDetect()
		{
			if ((int)_faxing.DeviceStatus > 1)
			{
				System.Windows.Forms.MessageBox.Show( 
					"You cannot Auto Detect modems when they are in use! Please cancel all current operations.", 
					"FaxManJr.NET sample application"); 
				return (false);
			}
			DataTech.FaxManJr.Modems modems = new DataTech.FaxManJr.Modems();
			Log("Detecting Modems...");
			modems.AutoDetect();
			_modemDictionary = new System.Collections.Specialized.ListDictionary();

			// first clear existing menu items if present.
			for (int i = mnuDevices.MenuItems.Count; i > 3; i--)
				mnuDevices.MenuItems.Remove(mnuDevices.MenuItems[i-1]);

			// now find modems and add to device menu
			foreach (DataTech.FaxManJr.Modem modem in modems)
			{
				modem.Init = String.Format("{0}M0", modem.Init);
				Log(modem.ToString());
				MenuItem mnuDevice = new MenuItem(modem.ToString(), new System.EventHandler(this.mnuDevice_Click));
				if (_faxing.DeviceStatus == DeviceStatuses.DeviceNotSet)
				{
					mnuDeviceSettings.Enabled = true;
					mnuDevice.Checked = true;
					_faxing.Modem = modem;
					UpdateModemMenu(modem);
				}
				//mnuDevice.
				mnuDevices.MenuItems.Add(mnuDevice);
				_modemDictionary.Add(modem.Port, modem);
			}

			if (_faxing.DeviceStatus == DeviceStatuses.DeviceNotSet)
			{
				Log("No Modems detected!");
				System.Windows.Forms.MessageBox.Show("No Modems detected.", "FaxManJr.NET sample application");
			}
			else
			{
				Log("Detecting Modems Complete.");
			}


			return (_faxing.DeviceStatus != DeviceStatuses.DeviceNotSet);
		}

		private void UpdateModemMenu() { UpdateModemMenu(_faxing.Modem); }
		private void UpdateModemMenu(DataTech.FaxManJr.Modem modem)
		{
			// First uncheck all menut items
			mnuClass1.Checked = mnuClass2.Checked = false;
			mnuClass20.Checked = mnuClass21.Checked = false;

			// Next enable all classes supported by the modem
			mnuClass1.Enabled = modem.Class1;
			mnuClass2.Enabled = modem.Class2;
			mnuClass20.Enabled = modem.Class20;
			mnuClass21.Enabled = modem.Class21;

			// Check the chosen FaxClass
			switch (modem.FaxClass)
			{
				case (FaxClass.Class1):
				mnuClass1.Checked = true;
					break;
				case (FaxClass.Class2):
					mnuClass2.Checked = true;
					break;
				case (FaxClass.Class20):
					mnuClass20.Checked = true;
					break;
				case (FaxClass.Class21):
					mnuClass21.Checked = true;
					break;
			}

			// Finally update the Init strings
			mnuInitString.Text = modem.Init;
			mnuResetString.Text = modem.Reset;
		}

		private bool IsReceiving()
		{
			if (_faxing.DeviceStatus == DeviceStatuses.DeviceListening) 
			{
				Log("== Cancel Listening for Fax to Send");
				_faxing.CancelFax();
				_waitingToSend = true;
			}
			else if (_faxing.DeviceStatus == DeviceStatuses.DeviceReceiveMode) 
			{
				_waitingToSend = true;
				Log("== Cancel Receive Mode to Send");
				_faxing.CancelFax();
			}
			else if (_faxing.DeviceStatus == DeviceStatuses.DeviceCurrentlyReceiving)
			{
				if (System.Windows.Forms.DialogResult.Yes == 
					System.Windows.Forms.MessageBox.Show( 
					"You are currently in the middle of receiving a fax! Are you sure you want to interupt this fax?", 
					"FaxManJr.NET sample application", MessageBoxButtons.YesNo)) 
				{
					_waitingToSend = true;
					Log("== Canceling Fax in the middle of reception by users request!");
				}
			}
			return (_waitingToSend);
		}


		// //////////////////////////////////////////
		// Persist Modem and Fax Objects Helper Functions
		
		private void SaveModemOptions()
		{
			if ( (null != _modemDictionary) && (_modemDictionary.Values.Count > 0) )
			{
				String filename = String.Format("{0}\\modems.opt", Application.UserAppDataPath);
				FileStream fs = new FileStream(filename, FileMode.OpenOrCreate);
				IFormatter formatter = new BinaryFormatter();
				try
				{
					formatter.Serialize(fs, _modemDictionary);
				} 
				catch (Exception e)
				{
					Log(String.Format("!! LoadModemOptions Exception: {0} ", e.Message));
				}
				finally
				{
					fs.Close();
				}
				fs.Close();
			}
		}

		private void LoadModemOptions()
		{
			// load modem info if available
			String filename = String.Format("{0}\\modems.opt", Application.UserAppDataPath);
			if (System.IO.File.Exists(filename))
			{
				FileStream fs = new FileStream(filename, FileMode.Open, System.IO.FileAccess.Read);
				// DeSerialize the ModemDictionary
				IFormatter formatter = new BinaryFormatter();
				try
				{
					Log("Loading previously configured modems options from file.");
					_modemDictionary = (System.Collections.Specialized.ListDictionary) formatter.Deserialize(fs);
					foreach (Modem modem in _modemDictionary.Values)
					{
						Log(modem.ToString());
						MenuItem mnuDevice = new MenuItem(modem.ToString(), new System.EventHandler(this.mnuDevice_Click));
						if (_faxing.DeviceStatus == DeviceStatuses.DeviceNotSet)
						{
							mnuDeviceSettings.Enabled = true;
							mnuDevice.Checked = true;
							_faxing.Modem = modem;
							UpdateModemMenu(modem);
						}
						mnuDevices.MenuItems.Add(mnuDevice);

					}
					Log("Done loading modems options from file.");
				} 
				catch (Exception e)
				{
					Log(String.Format("!! LoadModemOptions Exception: {0} ", e.Message));
				}
				finally
				{
					fs.Close();
				}
			}
		}

		private void SaveSendFaxInformation()
		{
			String filename = String.Format("{0}\\sendfax.opt", Application.UserAppDataPath);
			FileStream fs = new FileStream(filename, FileMode.OpenOrCreate);
			IFormatter formatter = new BinaryFormatter();
			try
			{
				formatter.Serialize(fs, _fax);
			}
			catch (Exception e)
			{
				Log(String.Format("!! SaveSendFaxInformation Exception: {0} ", e.Message));
			}
			finally
			{
				fs.Close();
			}
		}

		private void LoadSendFaxInformation()
		{
			String filename = String.Format("{0}\\sendfax.opt", Application.UserAppDataPath);
			if (System.IO.File.Exists(filename))
			{
				FileStream fs = new FileStream(filename, FileMode.Open, System.IO.FileAccess.Read);
				IFormatter formatter = new BinaryFormatter();
				try
				{
					_fax = (DataTech.FaxManJr.Fax) formatter.Deserialize(fs);
				} 
				catch (Exception e)
				{
					Log(String.Format("!! LoadSendFaxInformation Exception: {0} ", e.Message));
				}
				finally
				{
					fs.Close();
				}
			}
		}

		// //////////////////////////////////////////
		// Log Helper functions
		private void Log(String msg)
		{
			if (lbMessages.InvokeRequired)
				Invoke(_log, new object[] {msg});
			else
				LogHelper(msg);
		}

		private void LogHelper(String msg)
		{
			Debug.WriteLine(msg);

			lbMessages.Items.Add(msg);
			int itemsPerPage = (int)(lbMessages.Height / lbMessages.ItemHeight);
			if (lbMessages.Items.Count > itemsPerPage)
				lbMessages.TopIndex = lbMessages.Items.Count - itemsPerPage;
			lbMessages.Refresh();
		}

		// //////////////////////////////////////////
		// Image Helper function

		private String ImageOpenDialog()
		{
			String returnFileName = "";

			OpenFileDialog od = new OpenFileDialog();
			od.Title = "Open Image File";
			od.Filter = "Image file (*.fmf;*.fmp;*.tif)|*.fmf;*.fmp;*.tif|All files (*.*)|*.*";
			od.FilterIndex = 1;
			od.InitialDirectory = Application.UserAppDataPath;
			if (DialogResult.OK == od.ShowDialog())
				returnFileName = od.FileName;
			return (returnFileName);
		}

		private ArrayList LoadFaxFile(String fileName)
		{
			ArrayList _imgs = new ArrayList();
			try
			{

				// load image into bitmaparray
				// Sets the tiff file as an image object.
				System.Drawing.Image objImage = Image.FromFile(fileName);
				Guid objGuid = objImage.FrameDimensionsList[0];
				System.Drawing.Imaging.FrameDimension objDimension = new System.Drawing.Imaging.FrameDimension(objGuid);

				// Gets the total number of frames in the .tiff file
				int totFrame = objImage.GetFrameCount(objDimension);

				// Saves every frame as a seperate image in the ArrayList
				int i;
				for (i = 0; i < totFrame; i ++)
				{
					objImage.SelectActiveFrame(objDimension, i);
					Image img  = (System.Drawing.Image)objImage.Clone();
					_imgs.Add(img);
				}
			}
			catch (Exception e)
			{
				Log(String.Format("!! Load Fax File Exception: {0} ", e.Message));
			}
			return(_imgs);
		}

	}
}
