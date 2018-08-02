VERSION 5.00
Object = "{88C4D149-11DE-4857-8AAC-C1EBD3A072D4}#1.0#0"; "entPrevX.ocx"
Begin VB.Form frmPreviewAX 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Print Preview"
   ClientHeight    =   5910
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8685
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5910
   ScaleWidth      =   8685
   StartUpPosition =   2  'CenterScreen
   Begin entPrevX.entPreviewX entPreviewX1 
      Height          =   5175
      Left            =   60
      TabIndex        =   0
      Top             =   660
      Width           =   8220
      Active          =   0   'False
      CurrentPage     =   0
      Filename        =   ""
      Zoom            =   115
      ZoomInc         =   25
      ZoomPage        =   0
      ZoomPageWidth   =   0
      DoubleBuffered  =   0   'False
      Enabled         =   -1  'True
      Object.Visible         =   -1  'True
      Cursor          =   0
      HelpType        =   0
      HelpKeyword     =   ""
   End
   Begin VB.VScrollBar vscPages 
      Height          =   5175
      Left            =   8325
      TabIndex        =   10
      Top             =   660
      Width           =   270
   End
   Begin VB.Frame Frame1 
      Height          =   645
      Left            =   60
      TabIndex        =   1
      Top             =   -30
      Width           =   8535
      Begin VB.CommandButton cmdClose 
         Height          =   420
         Left            =   3045
         MaskColor       =   &H00D658FC&
         Picture         =   "AXPrevF.frx":0000
         Style           =   1  'Graphical
         TabIndex        =   8
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdPrint 
         Height          =   420
         Left            =   2505
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":061A
         Style           =   1  'Graphical
         TabIndex        =   7
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdNextPage 
         Height          =   420
         Left            =   1965
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":0C34
         Style           =   1  'Graphical
         TabIndex        =   6
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdPrevPage 
         Height          =   420
         Left            =   1515
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":124E
         Style           =   1  'Graphical
         TabIndex        =   5
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdZoomPage 
         Height          =   420
         Left            =   960
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":1868
         Style           =   1  'Graphical
         TabIndex        =   4
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdZoomOut 
         Height          =   420
         Left            =   525
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":1E82
         Style           =   1  'Graphical
         TabIndex        =   3
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.CommandButton cmdZoomIn 
         Height          =   420
         Left            =   75
         MaskColor       =   &H00FF00FF&
         Picture         =   "AXPrevF.frx":249C
         Style           =   1  'Graphical
         TabIndex        =   2
         TabStop         =   0   'False
         Top             =   150
         UseMaskColor    =   -1  'True
         Width           =   435
      End
      Begin VB.Label lblPageStatus 
         Caption         =   "Label1"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3705
         TabIndex        =   9
         Top             =   255
         Width           =   4665
      End
   End
End
Attribute VB_Name = "frmPreviewAX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public oPreviewTempFile As EnterpriseForms.IEFPrintTempFile

Private Sub cmdClose_Click()
    Me.Hide
End Sub

Private Sub cmdNextPage_Click()
    entPreviewX1.NextPage
    
    ' Update Pages scroll-bar so it doesn't get out of sync with the buttons
    If vscPages.Enabled Then vscPages.Value = entPreviewX1.CurrentPage
End Sub

Private Sub cmdPrevPage_Click()
    entPreviewX1.PreviousPage
    
    ' Update Pages scroll-bar so it doesn't get out of sync with the buttons
    If vscPages.Enabled Then vscPages.Value = entPreviewX1.CurrentPage
End Sub

Private Sub cmdPrint_Click()
    Load frmPrintOptions
    With frmPrintOptions
        .txtCopies.Text = Str(oPreviewTempFile.pfCopies)
        
        .Show 1, Me
        
        If (.SelectedOpt >= 0) Then
            oPreviewTempFile.pfCopies = CInt(.txtCopies.Text)
            
            Select Case .SelectedOpt
                Case 0 ' All Pages
                    oPreviewTempFile.pfStartPage = 0
                    oPreviewTempFile.pfFinishPage = 0
                    
                Case 1 ' Current Page
                    oPreviewTempFile.pfStartPage = entPreviewX1.CurrentPage
                    oPreviewTempFile.pfFinishPage = oPreviewTempFile.pfStartPage
                    
                Case 2 ' Page Range
                    oPreviewTempFile.pfStartPage = CInt(.txtStartPage.Text)
                    oPreviewTempFile.pfFinishPage = CInt(.txtFinishPage.Text)
            End Select ' .SelectedOpt
                    
            oPreviewTempFile.SendToDestination
        End If ' .SelectedOpt >= 0
    End With ' frmPrintOptions
    Unload frmPrintOptions
End Sub

Private Sub cmdZoomIn_Click()
    entPreviewX1.ZoomIn
End Sub

Private Sub cmdZoomOut_Click()
    entPreviewX1.ZoomOut
End Sub

Private Sub cmdZoomPage_Click()
    entPreviewX1.Zoom = entPreviewX1.ZoomPage
End Sub

Private Sub entPreviewX1_OnPageChanged()
    ' Setup Page x of y label on Toolbar
    lblPageStatus.Caption = "Page " + Trim(Str(entPreviewX1.CurrentPage)) + " of " + Trim(Str(entPreviewX1.Pages))
    
    ' Setup Toolbar Buttons
    cmdPrevPage.Enabled = (entPreviewX1.CurrentPage > 1)
    cmdNextPage.Enabled = (entPreviewX1.CurrentPage < entPreviewX1.Pages)
End Sub

Private Sub entPreviewX1_OnPreviewActivated()
    Dim LargeChange As Long

    ' Setup Pages Scroll-Bar
    vscPages.Enabled = (entPreviewX1.Pages > 1)
    
    If vscPages.Enabled Then
        ' Set starting position, min value and max value
        vscPages.Min = 1
        vscPages.Value = 1
        vscPages.Max = entPreviewX1.Pages

        ' Setup the scroll-bars large change as 10% of the pages with a 1 page minimum
        LargeChange = Round(entPreviewX1.Pages * 0.1, 0)
        If (LargeChange < 1) Then LargeChange = 1
        vscPages.LargeChange = LargeChange
    End If ' vscPages.Enabled
End Sub

Private Sub vscPages_Change()
    entPreviewX1.CurrentPage = vscPages.Value
End Sub
