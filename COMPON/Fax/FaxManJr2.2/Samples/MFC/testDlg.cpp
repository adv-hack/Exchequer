// testDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MFCtest.h"
#include "testDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMFCtestDlg dialog

CMFCtestDlg::CMFCtestDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMFCtestDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CMFCtestDlg)
	//}}AFX_DATA_INIT
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMFCtestDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CMFCtestDlg)
	DDX_Control(pDX, IDC_CBOPTION, m_cbOption);
	DDX_Control(pDX, IDC_EBOPTION, m_ebOption);
	DDX_Control(pDX, IDC_CMBOPTION, m_cmbOption);
	DDX_Control(pDX, IDC_CMBCHOICE, m_cmbChoice);
	DDX_Control(pDX, IDC_CBOPTIONS, m_cbOptions);
	DDX_Control(pDX, IDC_LBOUT, m_lbOut);
	DDX_Control(pDX, IDC_EBNUMBER, m_ebNumber);
	DDX_Control(pDX, IDC_EBFILE, m_ebFile);
	DDX_Control(pDX, IDC_EBDEVICE, m_ebDevice);
	DDX_Control(pDX, IDC_CBSEND, m_cbSend);
	DDX_Control(pDX, IDC_CBRECEIVE, m_cbReceive);
	DDX_Control(pDX, IDC_CBFILE, m_cbFile);
	DDX_Control(pDX, IDC_CBDEVICE, m_cbDevice);
	DDX_Control(pDX, IDC_FF1, m_FF1);
	DDX_Control(pDX, IDC_FJ1, m_FJ1);
	DDX_Control(pDX, IDC_FMPRINTER1, m_FMP1);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CMFCtestDlg, CDialog)
	//{{AFX_MSG_MAP(CMFCtestDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_CBDEVICE, OnCbdevice)
	ON_BN_CLICKED(IDC_CBFILE, OnCbfile)
	ON_BN_CLICKED(IDC_CBRECEIVE, OnCbreceive)
	ON_BN_CLICKED(IDC_CBSEND, OnCbsend)
	ON_WM_SIZE()
	ON_CBN_SELCHANGE(IDC_CMBCHOICE, OnSelchangeCmbchoice)
	ON_CBN_SELCHANGE(IDC_CMBOPTION, OnSelchangeCmboption)
	ON_EN_KILLFOCUS(IDC_EBOPTION, OnKillfocusEboption)
	ON_BN_CLICKED(IDC_CBOPTIONS, OnCboptions)
	ON_BN_CLICKED(IDC_CBOPTION, OnCboption)
	ON_WM_CLOSE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMFCtestDlg message handlers

//	Gets the current applications path.

CString GetApplicationPath()
{
	//	Get the command line.
	CString commandLine = GetCommandLine();

	if(commandLine.GetLength() == 0)
		return CString("");

	//	The first parameter is the application path. If this begins with quotation marks, then we 
	//	get everything between that and the next set of quotation marks.

	if(commandLine[0] == '\"')
	{
		int nPos = commandLine.Find("\"", 1);

		if(nPos != -1)
			return commandLine.Mid(1, nPos - 1);
		else
			return commandLine.Mid(1, commandLine.GetLength()-1);
	}
	else
	{
		//	The path is not in quotation marks, so it ends with a space.
		int nPos = commandLine.Find(" ", 1);

		if(nPos != -1)
			return commandLine.Mid(0, nPos - 1);
		else
			return commandLine;
	}
}

BOOL CMFCtestDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	SetIcon(m_hIcon, TRUE);		// Set small icon
	
	OnCboptions();
	m_bDebugLogFile = false;
	LoadFMRJSettings();

	
	if (!(m_FMP1.IsPrinterInstalled()))
	{
		this->MessageBox("Installing Printer for this sample application. This will take a little time.");
		HICON hcursor = SetCursor(LoadCursor(NULL, IDC_WAIT));
		CString appPath = GetApplicationPath();
		VARIANT vt;
		vt.vt = VT_BSTR;
		vt.bstrVal = appPath.AllocSysString();
		m_FMP1.InstallPrinter(vt);
		SetCursor(hcursor);
	}
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CMFCtestDlg::OnClose() 
{
	SaveFMRJSettings();
	CDialog::OnClose();
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMFCtestDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

HCURSOR CMFCtestDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

BEGIN_EVENTSINK_MAP(CMFCtestDlg, CDialog)
    //{{AFX_EVENTSINK_MAP(CMFCtestDlg)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 7 /* CompletionStatus */, OnCompletionStatusFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 2 /* Message */, OnMessageFj1, VTS_BSTR VTS_I2)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 6 /* EndTime */, OnEndTimeFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 3 /* NegotiatedParms */, OnNegotiatedParmsFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 4 /* Pages */, OnPagesFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 9 /* ReceiveFileName */, OnReceiveFileNameFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 8 /* Ring */, OnRingFj1, VTS_PI2)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 5 /* StartTime */, OnStartTimeFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FJ1, 1 /* Status */, OnStatusFj1, VTS_DISPATCH)
	ON_EVENT(CMFCtestDlg, IDC_FMPRINTER1, 1 /* PrintComplete */, OnPrintCompleteFmprinter1, VTS_NONE)
	//}}AFX_EVENTSINK_MAP
END_EVENTSINK_MAP()

void CMFCtestDlg::OnCompletionStatusFj1(LPDISPATCH pStatObj) 
{
	DumpStr("***********************************************");
    DumpStr("****           Completed Fax               ****");
    DumpStr("***********************************************");
	
	CFaxStatusObj cfso = pStatObj;
	FaxStatus(cfso);	
	
	DumpStr("***********************************************");
}

void CMFCtestDlg::OnMessageFj1(LPCTSTR bsMsg, short bNewLine) 
{
	if (m_bMessage)
	{
		static CString	cs;

		cs += bsMsg;
		if (bNewLine)
		{
			DumpStr(cs);
			cs = "Msg:  ";
		}	
	}
}

void CMFCtestDlg::OnEndTimeFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnNegotiatedParmsFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnPagesFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnReceiveFileNameFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnRingFj1(short FAR* pnAction) 
{
	static int	nCount = 1;
	CString		cs;
	
	*pnAction = 1;

	if (nCount++ == 5) {
		nCount = 1;
		*pnAction = 2;
	}

	cs.Format("Ring %d", nCount);
	DumpStr(cs);
}

void CMFCtestDlg::OnStartTimeFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnStatusFj1(LPDISPATCH pStatObj) 
{
	CFaxStatusObj cfso = pStatObj;

	FaxStatus(cfso);
}

void CMFCtestDlg::OnCbdevice() 
{
    static int	nDevice = 0;
    CString		csDevStr;

	GetDevice(&csDevStr);

	SetDlgItemText(IDC_EBDEVICE, csDevStr);	
}

void CMFCtestDlg::OnCbfile() 
{
	char	szFilter[] = "Fax Files (*.tif;*.fmf;*.fmp)|*.fmf; *.fmp; *.tif; *.tiff; *.fax|All Files|*.*||";

	CFileDialog cfd(TRUE,
				NULL,
				NULL,
				OFN_HIDEREADONLY,
				szFilter,
				NULL);

	if (cfd.DoModal()) {
		SetDlgItemText(IDC_EBFILE, cfd.GetPathName()); 
	}
}

void CMFCtestDlg::OnCbreceive() 
{
	//CString		cDir;
	char		lpFile[MAX_PATH], *cPlace;

	//	Get Application Directory for placing files.
	GetModuleFileName(NULL, lpFile, sizeof(lpFile));
	cPlace = strrchr(lpFile, '\\');
	cPlace[0] = '\0';

	m_FJ1.SetReceiveDir((LPCTSTR)lpFile);
	m_FJ1.Receive(1);

	DumpStr("***********************************************");
    DumpStr("****       Preparing to Receive Fax        ****");
    DumpStr("***********************************************");
}

void CMFCtestDlg::OnCbsend() 
{
	CString		cFile, cNumber;

	GetDlgItemText(IDC_EBFILE, cFile);
	GetDlgItemText(IDC_EBNUMBER, cNumber);

	m_FJ1.SetFaxFiles(cFile);
	m_FJ1.SetFaxNumber(cNumber);

	m_FJ1.SendFax();

	DumpStr("***********************************************");
    DumpStr("****         Sending New Fax               ****");
    DumpStr("***********************************************");
}

void CMFCtestDlg::OnSize(UINT nType, int cx, int cy) 
{
	// If dialog is not minimized
	// Resize all the Input Fields
	static int	old_cx, old_cy;

	CDialog::OnSize(nType, cx, cy);
	
	if(nType == SIZE_MINIMIZED)
		return;

	int dx = cx - old_cx;
	int dy = cy - old_cy;

	if(old_cx)
	{
		CRect WndRect;
		CWnd *pWnd;
		int i;
	
		for ( i = IDC_EBFILE; i <= IDC_LBOUT; i++)
		{
			pWnd = GetDlgItem(i);
			pWnd->GetWindowRect(&WndRect);  
			ScreenToClient(&WndRect);
			
			WndRect.right += dx; // stretch Horizontal
			//	WndRect.OffsetRect(dx,0); // stick Horizontal

			if ( i == IDC_LBOUT)
				WndRect.bottom += dy;  // stretch Vetical also
			//	WndRect.OffsetRect(0,dy); // stick Vertical

			pWnd->MoveWindow(&WndRect);
		}

	}
	old_cx = cx;
	old_cy = cy;
}

int CMFCtestDlg::GetDevice(CString *csDev)
{
	static int					nDev = 0;
	int							nPort = 0;
	CDeviceDesc					cDD;

	if (csDev) {
		// Find next Device
		if (m_FF1.GetDeviceCount() == 0) {
			*csDev = "No Devices Detected.";
		} else {
			if (++nDev > m_FF1.GetDeviceCount() - 1) {
				nDev = 0;
			}

			cDD = m_FF1.GetItem(nDev);
			nPort = cDD.GetPort();
			m_FJ1.SetPort(nPort);

			// Get Dev Str
			*csDev += "Class ";
			if (cDD.GetBClass1())  
			{
				m_FJ1.SetClass(1);
				*csDev += "1, ";
			}
			else
			{
				m_FJ1.SetClass(cDD.GetBClass21() ? 4 : cDD.GetBClass2() ? 2 : cDD.GetBClass20() ? 3 : 1); //default to 1 if not set
			}
			if (cDD.GetBClass2())  
				*csDev += "2, ";
			if (cDD.GetBClass20()) 
				*csDev += "2.0, ";
			if (cDD.GetBClass20()) 
				*csDev += "2.1 ";

			CString	cTemp;

			cTemp.Format("Modem on Port %d.", nPort);
			*csDev += cTemp;
		}
		
	} else {
		if (m_FF1.GetDeviceCount()) {
			cDD = m_FF1.GetItem(nDev);
			nPort = cDD.GetPort();
		}
	}

	return (nPort);
}

CMFCtestDlg::FaxStatus(CFaxStatusObj cfso)
{	
	CString		cs;

	switch (cfso.GetLastEventType())
	{
		case EVENT_STATUS: 
		{
			cs = "Status:";
			cs += cfso.GetCurrentStatusDesc();
			break;
		}
		case  EVENT_NEGOTIATION:
		{
			cs = "RemoteID:";
			cs += cfso.GetRemoteID();
			DumpStr(cs);

			cs.Format("ConnectSpeed:%d", cfso.GetConnectSpeed());
			cs.Format("Resolution:%d",cfso.GetNegotiatedResolution);
			break;
		}
		case  EVENT_PAGES:
		{
			cs.Format( "Page %d of %d ", 
				cfso.GetPagesCompleted(), cfso.GetPages());
			break;
		}
		case  EVENT_STARTTIME:
		{
			cs.Format( "StartTime:%d ", cfso.GetStartTime());
			break;
		}
		case EVENT_ENDTIME:
		{
			cs.Format( "EndTime:%d ", cfso.GetEndTime());
			break;
		}
		case  EVENT_COMPLETE:
		{
			cs = "*** FaxCompleted:";
			DumpStr(cs);

			cs = "*** Status:";
			cs += cfso.GetCurrentStatusDesc();
			DumpStr(cs);
			cs = "*** RemoteID:";
			cs += cfso.GetRemoteID();
			DumpStr(cs);
			cs = "*** Receive FileName:";
			cs += cfso.GetReceiveFileName();
			DumpStr(cs);

			
			cs.Format( "*** ConnectSpeed:%d ", cfso.GetConnectSpeed());
			DumpStr(cs);
			cs.Format("*** Resolution:%d ", cfso.GetNegotiatedResolution());
			DumpStr(cs);
			cs.Format( "*** Page %d of %d ", cfso.GetPagesCompleted(), cfso.GetPages());
			DumpStr(cs);
			cs.Format( "*** StartTime:%d ", cfso.GetStartTime());
			DumpStr(cs);
			cs.Format( "*** EndTime:%d ", cfso.GetEndTime());

			if (cfso.GetErrorCode() != 0)
			{
				DumpStr(cs);
				cs = "*** Error:";
				cs += cfso.GetErrorDesc();
			}
			break;
		}
		case  EVENT_RECEIVE_FILENAME:
		{
			cs = "Receive FileName:";
			cs += cfso.GetReceiveFileName();
			break;
		}
		case  EVENT_TIMEOUT:
		{
			// cs = "."
			return 1;
			break;
		}
	}
	DumpStr(cs);
	return 1;
}

CMFCtestDlg::DumpStr(CString cs) 
{
	m_lbOut.AddString(cs);
	m_lbOut.SetCurSel(m_lbOut.GetCount() - 1);

	if (m_bDebugLogFile) {
		cs = cs + "\r\n";
		m_cDebugLog.Write(cs, cs.GetLength());
	}

	return 1;
}

CMFCtestDlg::DumpStr(LPCTSTR	lp) 
{
	CString cs = lp;
	
	DumpStr(cs);
	return 1;
}

void CMFCtestDlg::OnSelchangeCmbchoice() 
{
	int		nChoice;
	
	m_cmbOption.ShowWindow(SW_HIDE);
	m_ebOption.ShowWindow(SW_SHOW);
	m_cbOption.ShowWindow(SW_HIDE);
	
	m_ebOption.SetWindowText(NULL);

	nChoice = m_cmbChoice.GetCurSel();
	switch (nChoice)
	{
	case 0:		// Class
		m_cmbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cmbOption.ResetContent();
		m_cmbOption.AddString("Class 1");
		m_cmbOption.AddString("Class 2");
		m_cmbOption.AddString("Class 2.0");
		m_cmbOption.AddString("Class 2.1");
		m_cmbOption.SetCurSel(m_FJ1.GetClass() - 1);
		break;
	case 1:		// DeviceInit
		m_ebOption.SetWindowText(m_FJ1.GetDeviceInit());
		break;
	case 2:		// DeviceReset
		m_ebOption.SetWindowText(m_FJ1.GetDeviceReset());
		break;
	case 3:		// FaxBanner
		m_ebOption.SetWindowText(m_FJ1.GetFaxBanner());
		break;
	case 4:		// FaxComments
		m_ebOption.SetWindowText(m_FJ1.GetFaxComments());
		break;
	case 5:		// FaxCompany
		m_ebOption.SetWindowText(m_FJ1.GetFaxCompany());
		break;
	case 6:		// FaxCoverPage
		m_ebOption.SetWindowText(m_FJ1.GetFaxCoverPage());
		break;
	case 7:		// FaxName
		m_ebOption.SetWindowText(m_FJ1.GetFaxName());
		break;
	case 8:		// FaxResolution
		m_cmbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cmbOption.ResetContent();
		m_cmbOption.AddString("Low Resolution");
		m_cmbOption.AddString("High Resolution");
		m_cmbOption.SetCurSel(m_FJ1.GetFaxResolution());
		break;
	case 9:		// FaxSubject
		m_ebOption.SetWindowText(m_FJ1.GetFaxSubject());
		break;
	case 10:	// FaxUserData
		m_ebOption.SetWindowText(m_FJ1.GetFaxUserData());
		break;
	case 11:	// ImportFiles
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cbOption.SetWindowText("&Import Files");
		break;
	case 12:	// LocalId
		m_ebOption.SetWindowText(m_FJ1.GetLocalID());
		break;
	case 13:	// ReceiveDir
		m_ebOption.SetWindowText(m_FJ1.GetReceiveDir());
		break;
	case 14:	// CancelFax
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cbOption.SetWindowText("&Cancel Fax");
		break;
	case 15:	// UserCompany
		m_ebOption.SetWindowText(m_FJ1.GetUserCompany());
		break;
	case 16:	// UserFaxNumber
		m_ebOption.SetWindowText(m_FJ1.GetUserFaxNumber());
		break;
	case 17:	// UserName
		m_ebOption.SetWindowText(m_FJ1.GetUserName_());
		break;
	case 18:	// UserVoiceNumber
		m_ebOption.SetWindowText(m_FJ1.GetUserVoiceNumber());
		break;
	case 19:	// ViewFax
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cbOption.SetWindowText("&View Fax");
		break;
	case 20:   // bDebugLogFile
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		if (m_bDebugLogFile)
			m_cbOption.SetWindowText("&Close Log File");
		else
			m_cbOption.SetWindowText("&Debug Log File");
		break;
	case 21:   // Listen
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cbOption.SetWindowText("&Listen");
		break;
	case 22:   // Messages
		m_cbOption.ShowWindow(SW_SHOW);
		m_ebOption.ShowWindow(SW_HIDE);
		if (m_bMessage)
			m_cbOption.SetWindowText("&Message ON");
		else
			m_cbOption.SetWindowText("&Message OFF");
		break;
	}
}

void CMFCtestDlg::OnSelchangeCmboption() 
{
	int		nChoice;

	nChoice = m_cmbChoice.GetCurSel();
	switch (nChoice)
	{
	case 0:		// Class
		m_FJ1.SetClass(m_cmbOption.GetCurSel() + 1);
		break;
	case 1:		// DeviceInit
	case 2:		// DeviceReset
	case 3:		// FaxBanner
	case 4:		// FaxComments
	case 5:		// FaxCompany
	case 6:		// FaxCoverPage
	case 7:		// FaxName
		break;
	case 8:		// FaxResolution
		m_FJ1.SetFaxResolution(m_cmbOption.GetCurSel());
		break;
	case 9:		// FaxSubject
	case 10:	// FaxUserData
	case 11:	// ImportFiles
	case 12:	// LocalId
	case 13:	// ReceiveDir
	case 14:	// CancelFax
	case 15:	// UserCompany
	case 16:	// UserFaxNumber
	case 17:	// UserName
	case 18:	// UserVoiceNumber
	case 19:	// ViewFax
	case 20:   // bDebugLogFile
		break;
	}	
}

void CMFCtestDlg::OnKillfocusEboption() 
{
	int		nChoice;
	CString	csChoice;

	nChoice = m_cmbChoice.GetCurSel();
	switch (nChoice)
	{
	case 0:		// Class
		break;
	case 1:		// DeviceInit
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetDeviceInit(csChoice);
		break;
	case 2:		// DeviceReset
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetDeviceReset(csChoice);
		break;
	case 3:		// FaxBanner
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxBanner(csChoice);
		break;
	case 4:		// FaxComments
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxComments(csChoice);
		break;
	case 5:		// FaxCompany
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxCompany(csChoice);
		break;
	case 6:		// FaxCoverPage
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxCoverPage(csChoice);
		break;
	case 7:		// FaxName
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxName(csChoice);
		break;
	case 8:		// FaxResolution
		break;
	case 9:		// FaxSubject
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxSubject(csChoice);
		break;
	case 10:	// FaxUserData
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetFaxUserData(csChoice);
		break;
	case 11:	// ImportFiles
		break;
	case 12:	// LocalId
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetLocalID(csChoice);
		break;
	case 13:	// ReceiveDir
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetReceiveDir(csChoice);
		break;
	case 14:	// CancelFax
		break;
	case 15:	// UserCompany
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetUserCompany(csChoice);
		break;
	case 16:	// UserFaxNumber
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetUserFaxNumber(csChoice);
		break;
	case 17:	// UserName
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetUserName(csChoice);
		break;
	case 18:	// UserVoiceNumber
		m_ebOption.GetWindowText(csChoice);
		m_FJ1.SetUserVoiceNumber(csChoice);
		break;
	case 19:	// ViewFax
	case 20:   // bDebugLogFile
		break;
	}
}

void CMFCtestDlg::OnCboption() 
{
	int		nChoice;

	nChoice = m_cmbChoice.GetCurSel();
	switch (nChoice)
	{
	case 0:		// Class
	case 1:		// DeviceInit
	case 2:		// DeviceReset
	case 3:		// FaxBanner
	case 4:		// FaxComments
	case 5:		// FaxCompany
	case 6:		// FaxCoverPage
	case 7:		// FaxName
	case 8:		// FaxResolution
	case 9:		// FaxSubject
	case 10:	// FaxUserData
		break;
	case 11:	// ImportFiles
		// Pop up some common dialogs.
		{
		CFileDialog		cfdOpen(true), cfdSave(false);

		if (cfdOpen.DoModal()) 
			if (cfdSave.DoModal())
				m_FJ1.ImportFiles(cfdSave.GetPathName(), cfdOpen.GetPathName());
		}
		break;
	case 12:	// LocalId
	case 13:	// ReceiveDir
		break;
	case 14:	// CancelFax
		m_FJ1.CancelFax();
		break;
	case 15:	// UserCompany
	case 16:	// UserFaxNumber
	case 17:	// UserName
	case 18:	// UserVoiceNumber
		break;
	case 19:	// ViewFax
	{
		char		lpFile[1000];

		GetDlgItemText(IDC_EBFILE, lpFile, sizeof(lpFile));
		int nRet = (int)ShellExecute(NULL, "open", lpFile, NULL, NULL, SW_SHOWNORMAL);

		break;
	}
	case 20:   // bDebugLogFile
		// Open or Close a Log File
		if (m_bDebugLogFile)
		{
			m_cDebugLog.Flush();
			m_cDebugLog.Close();
			m_bDebugLogFile = false;
		}
		else
		{
			CFileDialog		cfd(true);

			if (cfd.DoModal()) {
				if(m_cDebugLog.Open(cfd.GetPathName(), CFile::modeCreate | CFile::modeWrite))
					m_bDebugLogFile = true;
				else
					MessageBox("Please Select a New File.", "File Already Exists.");
			}
		}
		if (m_bDebugLogFile)
			m_cbOption.SetWindowText("&Close Log File");
		else
			m_cbOption.SetWindowText("&Debug Log File");
		break;
	case 21:
		m_FJ1.Listen();
		break;
	case 22:
		if (m_bMessage = m_bMessage ? false : true)
			m_cbOption.SetWindowText("&Message ON");
		else
			m_cbOption.SetWindowText("&Message OFF");
		break;
	}
}


void CMFCtestDlg::OnCboptions() 
{
	// Toggle the Optional Settings (\/ or /\)
	static CPoint	loPoint(0,0), hiPoint;
	static bool		bShow = true;
	CWnd *pWnd;
	CRect r;

	pWnd = GetDlgItem(IDC_LBOUT);
	pWnd->GetWindowRect(&r);  
	ScreenToClient(&r);

	if (loPoint.x == 0) {
		// Get Window Left Top for resizing Output window
		CWnd *pWnd2;
		CRect r2;

		pWnd2 = GetDlgItem(IDC_CMBCHOICE);
		pWnd2->GetWindowRect(&r2);  
		ScreenToClient(&r2);
		hiPoint = r2.TopLeft();

		loPoint = r.TopLeft();
	} 

	if(bShow)
	{
		r.left = hiPoint.x;
		r.top = hiPoint.y;

		// hide Option windows
		m_cmbChoice.ShowWindow(SW_HIDE);
		m_cmbOption.ShowWindow(SW_HIDE);
		m_ebOption.ShowWindow(SW_HIDE);
		m_cbOption.ShowWindow(SW_HIDE);

		m_cbOptions.SetWindowText("&Options \\/");
		bShow = false;
	} 
	else
	{
		r.left = loPoint.x;
		r.top = loPoint.y;

		// Show Option window
		m_cmbChoice.ShowWindow(SW_SHOW);
		OnSelchangeCmbchoice();

		m_cbOptions.SetWindowText("&Options /\\");
		bShow = true;
	}

	pWnd->MoveWindow(&r);
}


void CMFCtestDlg::SaveFMRJSettings() 
{
	HKEY	hKey;


	if (ERROR_SUCCESS == RegCreateKey(HKEY_CURRENT_USER, 
		"Software\\VB and VBA Program Settings\\pFaxJr\\FaxManJr", &hKey))
	{	
		CString		cs;

		cs = (m_FJ1.GetClass() == 4) ? "4" : (m_FJ1.GetClass() == 3) ? "3" : (m_FJ1.GetClass()) == 2 ? "2" : "1";
		RegSetValueEx(hKey, "Class", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetDeviceInit();
		if (cs.GetLength() > 1)
			RegSetValueEx(hKey, "DeviceInit", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());
		
		cs = m_FJ1.GetDeviceReset();
		if (cs.GetLength() > 1)
			RegSetValueEx(hKey, "DeviceReset", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());
		
		cs = m_FJ1.GetFaxBanner();
		RegSetValueEx(hKey, "FaxBanner", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxComments();
		RegSetValueEx(hKey, "FaxComments", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxCompany();
		RegSetValueEx(hKey, "FaxCompany", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxCoverPage();
		RegSetValueEx(hKey, "FaxCoverPage", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxName();
		RegSetValueEx(hKey, "FaxName", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxResolution() == 0 ? "0" : "1";
		RegSetValueEx(hKey, "FaxResolution", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxSubject();
		RegSetValueEx(hKey, "FaxSubject", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetFaxUserData();
		RegSetValueEx(hKey, "FaxUserData", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_bMessage ? "ON" : "OFF";
		RegSetValueEx(hKey, "Message", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetReceiveDir();
		RegSetValueEx(hKey, "ReceiveDir", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetUserCompany();
		RegSetValueEx(hKey, "UserCompany", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetUserFaxNumber();
		RegSetValueEx(hKey, "UserFaxNumber", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetUserName_();
		RegSetValueEx(hKey, "UserName", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		cs = m_FJ1.GetUserVoiceNumber();
		RegSetValueEx(hKey, "UserVoiceNumber", NULL, REG_SZ, (unsigned char*)cs.GetBuffer(0), cs.GetLength());

		RegCloseKey(hKey);
	}
}

void CMFCtestDlg::LoadFMRJSettings() 
{	
	HKEY	hKey;


	if (ERROR_SUCCESS == RegCreateKey(HKEY_CURRENT_USER, 
		"Software\\VB and VBA Program Settings\\pFaxJr\\FaxManJr", &hKey))
	{
		unsigned char	pcData[250];
		DWORD			dwLen, dwType;
		CString			cStr;
		
		dwType = REG_SZ;
		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "Class", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetClass((((int)*pcData > 48) && ((int)*pcData < 52)) ? (int)*pcData - 48: 1);
		
		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxResolution", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxResolution((int)*pcData == 48 ? 0 : 1);
		
		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "DeviceInit", NULL, &dwType, pcData, &dwLen))
			if (strlen((const char*)pcData) > 1)
			{
				CString cTemp(pcData);
				m_FJ1.SetDeviceInit(cTemp);
			}
		
		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "DeviceReset", NULL, &dwType, pcData, &dwLen))
			if (strlen((const char*)pcData) > 1)
			{
				CString cTemp(pcData);
				m_FJ1.SetDeviceReset(cTemp);
			}

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxBanner", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxBanner((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxComments", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxComments((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxCompany", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxCompany((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxCoverPage", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxCoverPage((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxName", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxName((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxSubject", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxSubject((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "FaxUserData", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetFaxUserData((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "LocalID", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetLocalID((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "Message", NULL, &dwType, pcData, &dwLen))
			m_bMessage =  strcmp((const char*)pcData, "OFF") ? false: true;

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "ReceiveDir", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetReceiveDir((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "UserCompany", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetUserCompany((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "UserFaxNumber", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetUserFaxNumber((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "UserName", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetUserName((const char*)pcData);

		dwLen = sizeof(pcData);
		if (ERROR_SUCCESS ==RegQueryValueEx(hKey, "UserVoiceNumber", NULL, &dwType, pcData, &dwLen))
			m_FJ1.SetUserVoiceNumber((const char*)pcData);
		
		RegCloseKey(hKey);
	}

}

void CMFCtestDlg::OnPrintCompleteFmprinter1() 
{
	if (m_FMP1.GetPrintJobCount() > 0)
	{
		FmPrint::IPrintJobPtr pJob = (FmPrint::IPrintJobPtr)m_FMP1.GetNextPrintJob();
		BSTR bfilename;
		pJob->get_FileName(&bfilename);
		CString cTemp(bfilename);
		SetDlgItemText(IDC_EBFILE, cTemp);
	}
}
