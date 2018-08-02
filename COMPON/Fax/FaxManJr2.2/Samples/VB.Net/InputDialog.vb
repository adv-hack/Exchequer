Imports Microsoft.VisualBasic
Imports System
Imports System.Drawing
Imports System.Collections
Imports System.ComponentModel
Imports System.Windows.Forms

Namespace JrNetTest
	''' <summary>
	''' Summary description for InputDialog.
	''' </summary>
	Public Class InputDialog
		Inherits System.Windows.Forms.Form
		Private lbInput As System.Windows.Forms.Label
		Private tbInput As System.Windows.Forms.TextBox
		Private WithEvents btnSend As System.Windows.Forms.Button
		Private btnCancel As System.Windows.Forms.Button
		''' <summary>
		''' Required designer variable.
		''' </summary>
		Private components As System.ComponentModel.Container = Nothing

		Public Sub New(ByVal title As String, ByVal prompt As String, ByVal currentInput As String)
			'
			' Required for Windows Form Designer support
			'
			InitializeComponent()

			_inputTitle = title
			_inputPrompt = prompt
			_inputText = currentInput
		End Sub

		''' <summary>
		''' Clean up any resources being used.
		''' </summary>
		Protected Overrides Overloads Sub Dispose(ByVal disposing As Boolean)
			If disposing Then
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
			Me.lbInput = New System.Windows.Forms.Label()
			Me.tbInput = New System.Windows.Forms.TextBox()
			Me.btnSend = New System.Windows.Forms.Button()
			Me.btnCancel = New System.Windows.Forms.Button()
			Me.SuspendLayout()
			' 
			' lbInput
			' 
			Me.lbInput.Location = New System.Drawing.Point(9, 12)
			Me.lbInput.Name = "lbInput"
			Me.lbInput.Size = New System.Drawing.Size(332, 44)
			Me.lbInput.TabIndex = 0
			Me.lbInput.Text = "lbInput"
			Me.lbInput.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
			' 
			' tbInput
			' 
			Me.tbInput.Location = New System.Drawing.Point(9, 64)
			Me.tbInput.Name = "tbInput"
			Me.tbInput.Size = New System.Drawing.Size(332, 20)
			Me.tbInput.TabIndex = 1
			Me.tbInput.Text = "tbInput"
			' 
			' btnSend
			' 
			Me.btnSend.Anchor = (CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles))
			Me.btnSend.DialogResult = System.Windows.Forms.DialogResult.OK
			Me.btnSend.Location = New System.Drawing.Point(193, 96)
			Me.btnSend.Name = "btnSend"
			Me.btnSend.Size = New System.Drawing.Size(128, 24)
			Me.btnSend.TabIndex = 18
			Me.btnSend.Text = "O&K"
'			Me.btnSend.Click += New System.EventHandler(Me.btnSend_Click);
			' 
			' btnCancel
			' 
			Me.btnCancel.Anchor = (CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles))
			Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
			Me.btnCancel.Location = New System.Drawing.Point(29, 96)
			Me.btnCancel.Name = "btnCancel"
			Me.btnCancel.Size = New System.Drawing.Size(128, 24)
			Me.btnCancel.TabIndex = 17
			Me.btnCancel.Text = "&Cancel"
			' 
			' InputDialog
			' 
			Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
			Me.ClientSize = New System.Drawing.Size(350, 134)
			Me.Controls.Add(Me.btnSend)
			Me.Controls.Add(Me.btnCancel)
			Me.Controls.Add(Me.tbInput)
			Me.Controls.Add(Me.lbInput)
			Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
			Me.Name = "InputDialog"
			Me.Text = "InputDialog"
'			Me.Load += New System.EventHandler(Me.InputDialog_Load);
			Me.ResumeLayout(False)

		End Sub
		#End Region

		Private _inputTitle As String
		Private _inputPrompt As String
		Private _inputText As String

		Private Sub InputDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
			Me.Text = _inputTitle
			lbInput.Text = _inputPrompt
			tbInput.Text = _inputText
		End Sub

		Private Sub btnSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSend.Click
			_inputText = tbInput.Text
		End Sub

		Public ReadOnly Property InputText() As String
			Get
				Return(_inputText)
			End Get
		End Property
	End Class
End Namespace
