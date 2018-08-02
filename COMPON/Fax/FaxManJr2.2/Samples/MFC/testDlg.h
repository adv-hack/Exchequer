// testDlg.h : header file
//
//{{AFX_INCLUDES()
#include "faxstatusobj.h"
#include "devicedesc.h"
#include "faxfinder.h"
#include "faxmanjr.h"
#include "fmprinter.h"
#include "FaxJrEnums.h"
//}}AFX_INCLUDES

#if !defined(AFX_TESTDLG_H__AFD95477_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_)
#define AFX_TESTDLG_H__AFD95477_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

// Import the PrintJob Interface
#import  "..\\..\\FmPrint4.ocx"  named_guids

/////////////////////////////////////////////////////////////////////////////
// CMFCtestDlg dialog

class CMFCtestDlg : public CDialog
{
// Construction
public:
	CMFCtestDlg(CWnd* pParent = NULL);	// standard constructor


	DumpStr(CString cs);
	DumpStr(LPCTSTR	lp);
	FaxStatus(CFaxStatusObj cfso);
	GetDevice(CString *csDev = NULL);
	void SaveFMRJSettings();
	void LoadFMRJSettings() ;
// Dialog Data
	//{{AFX_DATA(CMFCtestDlg)
	enum { IDD = IDD_MFCTEST_DIALOG };
	CButton	m_cbOption;
	CEdit	m_ebOption;
	CComboBox	m_cmbOption;
	CComboBox	m_cmbChoice;
	CButton	m_cbOptions;
	CListBox	m_lbOut;
	CEdit	m_ebOut;
	CEdit	m_ebNumber;
	CEdit	m_ebFile;
	CEdit	m_ebDevice;
	CButton	m_cbSend;
	CButton	m_cbReceive;
	CButton	m_cbFile;
	CButton	m_cbDevice;
	CFaxFinder	m_FF1;
	CFaxManJr	m_FJ1;
	CFmPrinter	m_FMP1;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMFCtestDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON	m_hIcon;
	bool	m_bDebugLogFile;
	bool	m_bMessage;
	CFile	m_cDebugLog;
	// Generated message map functions
	//{{AFX_MSG(CMFCtestDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnCompletionStatusFj1(LPDISPATCH pStatObj);
	afx_msg void OnMessageFj1(LPCTSTR bsMsg, short bNewLine);
	afx_msg void OnEndTimeFj1(LPDISPATCH pStatObj);
	afx_msg void OnNegotiatedParmsFj1(LPDISPATCH pStatObj);
	afx_msg void OnPagesFj1(LPDISPATCH pStatObj);
	afx_msg void OnReceiveFileNameFj1(LPDISPATCH pStatObj);
	afx_msg void OnRingFj1(short FAR* pnAction);
	afx_msg void OnStartTimeFj1(LPDISPATCH pStatObj);
	afx_msg void OnStatusFj1(LPDISPATCH pStatObj);
	afx_msg void OnPrintCompleteFmprint1(LPCTSTR PrintFileName, short Status, long Pages);
	afx_msg void OnPrintStartFmprint1(BSTR FAR* PrintFileName);
	afx_msg void OnCbdevice();
	afx_msg void OnCbfile();
	afx_msg void OnCbreceive();
	afx_msg void OnCbsend();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnSelchangeCmbchoice();
	afx_msg void OnSelchangeCmboption();
	afx_msg void OnKillfocusEboption();
	afx_msg void OnCboptions();
	afx_msg void OnCboption();
	afx_msg void OnClose();
	afx_msg void OnPrintCompleteFmprinter1();
	DECLARE_EVENTSINK_MAP()
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_TESTDLG_H__AFD95477_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_)
