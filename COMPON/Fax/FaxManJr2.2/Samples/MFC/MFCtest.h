// MFCtest.h : main header file for the MFCTEST application
//

#if !defined(AFX_MFCTEST_H__AFD95475_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_)
#define AFX_MFCTEST_H__AFD95475_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMFCtestApp:
// See MFCtest.cpp for the implementation of this class
//

class CMFCtestApp : public CWinApp
{
public:
	CMFCtestApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMFCtestApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMFCtestApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MFCTEST_H__AFD95475_C77A_11D2_B2D9_0000F87AE18C__INCLUDED_)
