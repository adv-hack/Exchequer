VERSION 5.00
Object = "{88C4D149-11DE-4857-8AAC-C1EBD3A072D4}#1.0#0"; "EntPrevX.Ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmPreviewAX 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Save As EDF"
   ClientHeight    =   6420
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8685
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6420
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
   Begin VB.CommandButton cmdSaveAsPDF 
      Caption         =   "Save As PDF"
      Height          =   315
      Left            =   2865
      TabIndex        =   13
      Top             =   5970
      Width           =   1200
   End
   Begin VB.CommandButton cmdSaveAsEDZ 
      Caption         =   "Save As EDZ"
      Height          =   315
      Left            =   1500
      TabIndex        =   12
      Top             =   5970
      Width           =   1200
   End
   Begin VB.CommandButton cmdSaveAsEDF 
      Caption         =   "Save As EDF"
      Height          =   315
      Left            =   120
      TabIndex        =   11
      Top             =   5970
      Width           =   1200
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
         Picture         =   "AXPREVF.frx":0000
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
         Picture         =   "AXPREVF.frx":061A
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
         Picture         =   "AXPREVF.frx":0C34
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
         Picture         =   "AXPREVF.frx":124E
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
         Picture         =   "AXPREVF.frx":1868
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
         Picture         =   "AXPREVF.frx":1E82
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
         Picture         =   "AXPREVF.frx":249C
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
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   4305
      Top             =   5880
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
      DefaultExt      =   "*.EDF"
      DialogTitle     =   "Save Form As"
      Filter          =   "Enterprise Forms|*.EFD|PCC Forms|*.DEF|All Files|*.*"
      Flags           =   6156
   End
End
Attribute VB_Name = "frmPreviewAX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public oPreviewTempFile As Enterprise01.IPrintTempFile

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

Private Sub cmdSaveAsEDF_Click()
On Error GoTo cmdSaveAsEDF_Click_Error
    Dim Res&
    
    With CommonDialog1
        ' setup defaults specifically for EDF files
        .DefaultExt = "*.EDF"
        .Filter = "Enterprise Document Files|*.EDF|All Files|*.*"
        .InitDir = frmAcSINList.oToolkit.Configuration.DataDirectory
        .ShowSave

On Error GoTo 0

        ' Save the printjob results as an .EDF file
        Res& = oPreviewTempFile.SaveAsFile(.FileName, saEDF)
    End With ' CommonDialog1
    
    Exit Sub
    
cmdSaveAsEDF_Click_Error:
    
End Sub

Private Sub cmdSaveAsEDZ_Click()
On Error GoTo cmdSaveAsEDZ_Click_Error
    Dim Res&
    
    With CommonDialog1
        ' setup defaults specifically for EDF files
        .DefaultExt = "*.EDZ"
        .Filter = "Enterprise Documents (Zipped)|*.EDZ|All Files|*.*"
        .InitDir = frmAcSINList.oToolkit.Configuration.DataDirectory
        .ShowSave

        ' Save the printjob results as an .EDZ file
        Res& = oPreviewTempFile.SaveAsFile(.FileName, saEDZ)
        If (Res& <> 0) Then
            MsgBox "SaveAsFile (" + .FileName + ", saEDZ) : " + Str(Res&)
        End If
    End With ' CommonDialog1
    
    Exit Sub
    
cmdSaveAsEDZ_Click_Error:

End Sub

Private Sub cmdSaveAsPDF_Click()
On Error GoTo cmdSaveAsPDF_Click_Error
    Dim Res&
    
    With CommonDialog1
        ' setup defaults specifically for EDF files
        .DefaultExt = "*.PDF"
        .Filter = "Adobe/Rave PDF Files|*.PDF|All Files|*.*"
        .InitDir = frmAcSINList.oToolkit.Configuration.DataDirectory
        .ShowSave

        ' Save the printjob results as an .PDF file
        Res& = oPreviewTempFile.SaveAsFile(.FileName, saPDF)
        If (Res& <> 0) Then
            MsgBox "SaveAsFile (" + .FileName + ", saPDF) : " + Str(Res&)
        End If
    End With ' CommonDialog1
    
    Exit Sub
    
cmdSaveAsPDF_Click_Error:
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
