Imports Microsoft.VisualBasic
Imports System
Imports System.Drawing
Imports System.Collections
Imports System.ComponentModel
Imports System.IO
Imports System.Windows.Forms

Namespace JrNetTest
	''' <summary>
	''' Summary description for SendFaxForm.
	''' </summary>
	Public Class SendFaxForm
		Inherits System.Windows.Forms.Form
		Private panel1 As System.Windows.Forms.Panel
		Private tbFaxBanner As System.Windows.Forms.TextBox
		Private label2 As System.Windows.Forms.Label
		Private tbName As System.Windows.Forms.TextBox
		Private tbCompany As System.Windows.Forms.TextBox
		Private label3 As System.Windows.Forms.Label
		Private label4 As System.Windows.Forms.Label
		Private tbSenderPhone As System.Windows.Forms.TextBox
		Private label1 As System.Windows.Forms.Label
		Private tbSenderCompany As System.Windows.Forms.TextBox
		Private label5 As System.Windows.Forms.Label
		Private tbSenderName As System.Windows.Forms.TextBox
		Private label6 As System.Windows.Forms.Label
		Private tbSenderFax As System.Windows.Forms.TextBox
		Private label7 As System.Windows.Forms.Label
		Private tbDate As System.Windows.Forms.TextBox
		Private label8 As System.Windows.Forms.Label
		Private label9 As System.Windows.Forms.Label
		Private label10 As System.Windows.Forms.Label
		Private label11 As System.Windows.Forms.Label
		Private WithEvents btnCancel As System.Windows.Forms.Button
		Private WithEvents btnSend As System.Windows.Forms.Button
		Private tbFaxNumber As System.Windows.Forms.TextBox
		Private cbCoverpage As System.Windows.Forms.CheckBox
		Private lbFaxFiles As System.Windows.Forms.ListBox
		Private WithEvents btnAdd As System.Windows.Forms.Button
		Private WithEvents btnRemove As System.Windows.Forms.Button
		Private tbComments As System.Windows.Forms.TextBox
		Private WithEvents btnSave As System.Windows.Forms.Button
		Private lbImportingFiles As System.Windows.Forms.Label
		''' <summary>
		''' Required designer variable.
		''' </summary>
		Private components As System.ComponentModel.Container = Nothing

		Public Sub New(ByVal fax As DataTech.FaxManJr.Fax)
			'
			' Required for Windows Form Designer support
			'
			InitializeComponent()

			_fax = fax
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
        Friend WithEvents Faxing1 As DataTech.FaxManJr.Faxing
        Private Sub InitializeComponent()
            Me.panel1 = New System.Windows.Forms.Panel
            Me.tbFaxBanner = New System.Windows.Forms.TextBox
            Me.label2 = New System.Windows.Forms.Label
            Me.tbName = New System.Windows.Forms.TextBox
            Me.tbCompany = New System.Windows.Forms.TextBox
            Me.label3 = New System.Windows.Forms.Label
            Me.tbFaxNumber = New System.Windows.Forms.TextBox
            Me.label4 = New System.Windows.Forms.Label
            Me.cbCoverpage = New System.Windows.Forms.CheckBox
            Me.tbSenderPhone = New System.Windows.Forms.TextBox
            Me.label1 = New System.Windows.Forms.Label
            Me.tbSenderCompany = New System.Windows.Forms.TextBox
            Me.label5 = New System.Windows.Forms.Label
            Me.tbSenderName = New System.Windows.Forms.TextBox
            Me.label6 = New System.Windows.Forms.Label
            Me.tbSenderFax = New System.Windows.Forms.TextBox
            Me.label7 = New System.Windows.Forms.Label
            Me.tbDate = New System.Windows.Forms.TextBox
            Me.label8 = New System.Windows.Forms.Label
            Me.label9 = New System.Windows.Forms.Label
            Me.label10 = New System.Windows.Forms.Label
            Me.lbFaxFiles = New System.Windows.Forms.ListBox
            Me.btnAdd = New System.Windows.Forms.Button
            Me.btnRemove = New System.Windows.Forms.Button
            Me.label11 = New System.Windows.Forms.Label
            Me.tbComments = New System.Windows.Forms.TextBox
            Me.btnCancel = New System.Windows.Forms.Button
            Me.btnSend = New System.Windows.Forms.Button
            Me.btnSave = New System.Windows.Forms.Button
            Me.lbImportingFiles = New System.Windows.Forms.Label
            Me.Faxing1 = New DataTech.FaxManJr.Faxing
            Me.SuspendLayout()
            '
            'panel1
            '
            Me.panel1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.panel1.BackColor = System.Drawing.SystemColors.ActiveCaptionText
            Me.panel1.Location = New System.Drawing.Point(48, 28)
            Me.panel1.Name = "panel1"
            Me.panel1.Size = New System.Drawing.Size(512, 4)
            Me.panel1.TabIndex = 0
            '
            'tbFaxBanner
            '
            Me.tbFaxBanner.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbFaxBanner.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbFaxBanner.Location = New System.Drawing.Point(48, 4)
            Me.tbFaxBanner.Name = "tbFaxBanner"
            Me.tbFaxBanner.Size = New System.Drawing.Size(512, 20)
            Me.tbFaxBanner.TabIndex = 0
            Me.tbFaxBanner.Text = "From: %s  To: %r | %t %d |  Page %c  of %p"
            Me.tbFaxBanner.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
            '
            'label2
            '
            Me.label2.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label2.Location = New System.Drawing.Point(48, 72)
            Me.label2.Name = "label2"
            Me.label2.Size = New System.Drawing.Size(176, 24)
            Me.label2.TabIndex = 3
            Me.label2.Text = "To:"
            Me.label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbName
            '
            Me.tbName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbName.Location = New System.Drawing.Point(240, 72)
            Me.tbName.Name = "tbName"
            Me.tbName.Size = New System.Drawing.Size(320, 20)
            Me.tbName.TabIndex = 2
            Me.tbName.Text = ""
            '
            'tbCompany
            '
            Me.tbCompany.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbCompany.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbCompany.Location = New System.Drawing.Point(240, 96)
            Me.tbCompany.Name = "tbCompany"
            Me.tbCompany.Size = New System.Drawing.Size(320, 20)
            Me.tbCompany.TabIndex = 3
            Me.tbCompany.Text = ""
            '
            'label3
            '
            Me.label3.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label3.Location = New System.Drawing.Point(48, 96)
            Me.label3.Name = "label3"
            Me.label3.Size = New System.Drawing.Size(176, 24)
            Me.label3.TabIndex = 5
            Me.label3.Text = "Company:"
            Me.label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbFaxNumber
            '
            Me.tbFaxNumber.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbFaxNumber.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbFaxNumber.Location = New System.Drawing.Point(240, 120)
            Me.tbFaxNumber.Name = "tbFaxNumber"
            Me.tbFaxNumber.Size = New System.Drawing.Size(320, 20)
            Me.tbFaxNumber.TabIndex = 4
            Me.tbFaxNumber.Text = ""
            '
            'label4
            '
            Me.label4.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label4.Location = New System.Drawing.Point(48, 120)
            Me.label4.Name = "label4"
            Me.label4.Size = New System.Drawing.Size(176, 24)
            Me.label4.TabIndex = 7
            Me.label4.Text = "Fax:"
            Me.label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'cbCoverpage
            '
            Me.cbCoverpage.CheckAlign = System.Drawing.ContentAlignment.BottomRight
            Me.cbCoverpage.Checked = True
            Me.cbCoverpage.CheckState = System.Windows.Forms.CheckState.Checked
            Me.cbCoverpage.Font = New System.Drawing.Font("Arial", 15.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.cbCoverpage.Location = New System.Drawing.Point(40, 40)
            Me.cbCoverpage.Name = "cbCoverpage"
            Me.cbCoverpage.Size = New System.Drawing.Size(272, 24)
            Me.cbCoverpage.TabIndex = 1
            Me.cbCoverpage.Text = "Facsimile Cover Sheet"
            '
            'tbSenderPhone
            '
            Me.tbSenderPhone.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbSenderPhone.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbSenderPhone.Location = New System.Drawing.Point(240, 208)
            Me.tbSenderPhone.Name = "tbSenderPhone"
            Me.tbSenderPhone.Size = New System.Drawing.Size(320, 20)
            Me.tbSenderPhone.TabIndex = 7
            Me.tbSenderPhone.Text = ""
            '
            'label1
            '
            Me.label1.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label1.Location = New System.Drawing.Point(48, 208)
            Me.label1.Name = "label1"
            Me.label1.Size = New System.Drawing.Size(176, 24)
            Me.label1.TabIndex = 14
            Me.label1.Text = "Phone:"
            Me.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbSenderCompany
            '
            Me.tbSenderCompany.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbSenderCompany.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbSenderCompany.Location = New System.Drawing.Point(240, 184)
            Me.tbSenderCompany.Name = "tbSenderCompany"
            Me.tbSenderCompany.Size = New System.Drawing.Size(320, 20)
            Me.tbSenderCompany.TabIndex = 6
            Me.tbSenderCompany.Text = ""
            '
            'label5
            '
            Me.label5.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label5.Location = New System.Drawing.Point(48, 184)
            Me.label5.Name = "label5"
            Me.label5.Size = New System.Drawing.Size(176, 24)
            Me.label5.TabIndex = 12
            Me.label5.Text = "Company:"
            Me.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbSenderName
            '
            Me.tbSenderName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbSenderName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbSenderName.Location = New System.Drawing.Point(240, 160)
            Me.tbSenderName.Name = "tbSenderName"
            Me.tbSenderName.Size = New System.Drawing.Size(320, 20)
            Me.tbSenderName.TabIndex = 5
            Me.tbSenderName.Text = ""
            '
            'label6
            '
            Me.label6.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label6.Location = New System.Drawing.Point(48, 160)
            Me.label6.Name = "label6"
            Me.label6.Size = New System.Drawing.Size(176, 24)
            Me.label6.TabIndex = 10
            Me.label6.Text = "From:"
            Me.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbSenderFax
            '
            Me.tbSenderFax.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbSenderFax.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbSenderFax.Location = New System.Drawing.Point(240, 232)
            Me.tbSenderFax.Name = "tbSenderFax"
            Me.tbSenderFax.Size = New System.Drawing.Size(320, 20)
            Me.tbSenderFax.TabIndex = 8
            Me.tbSenderFax.Text = ""
            '
            'label7
            '
            Me.label7.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label7.Location = New System.Drawing.Point(48, 232)
            Me.label7.Name = "label7"
            Me.label7.Size = New System.Drawing.Size(176, 24)
            Me.label7.TabIndex = 16
            Me.label7.Text = "Fax:"
            Me.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'tbDate
            '
            Me.tbDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbDate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbDate.Location = New System.Drawing.Point(240, 272)
            Me.tbDate.Name = "tbDate"
            Me.tbDate.ReadOnly = True
            Me.tbDate.Size = New System.Drawing.Size(320, 20)
            Me.tbDate.TabIndex = 9
            Me.tbDate.Text = ""
            '
            'label8
            '
            Me.label8.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label8.Location = New System.Drawing.Point(48, 272)
            Me.label8.Name = "label8"
            Me.label8.Size = New System.Drawing.Size(176, 24)
            Me.label8.TabIndex = 18
            Me.label8.Text = "Date:"
            Me.label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'label9
            '
            Me.label9.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label9.Location = New System.Drawing.Point(40, 312)
            Me.label9.Name = "label9"
            Me.label9.Size = New System.Drawing.Size(176, 16)
            Me.label9.TabIndex = 20
            Me.label9.Text = "Pages including this"
            Me.label9.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'label10
            '
            Me.label10.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label10.Location = New System.Drawing.Point(40, 328)
            Me.label10.Name = "label10"
            Me.label10.Size = New System.Drawing.Size(176, 16)
            Me.label10.TabIndex = 21
            Me.label10.Text = "cover page:"
            Me.label10.TextAlign = System.Drawing.ContentAlignment.MiddleRight
            '
            'lbFaxFiles
            '
            Me.lbFaxFiles.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.lbFaxFiles.Location = New System.Drawing.Point(240, 312)
            Me.lbFaxFiles.Name = "lbFaxFiles"
            Me.lbFaxFiles.Size = New System.Drawing.Size(256, 56)
            Me.lbFaxFiles.TabIndex = 11
            '
            'btnAdd
            '
            Me.btnAdd.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnAdd.Location = New System.Drawing.Point(496, 312)
            Me.btnAdd.Name = "btnAdd"
            Me.btnAdd.Size = New System.Drawing.Size(64, 24)
            Me.btnAdd.TabIndex = 10
            Me.btnAdd.Text = "&Add"
            '
            'btnRemove
            '
            Me.btnRemove.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnRemove.Location = New System.Drawing.Point(496, 344)
            Me.btnRemove.Name = "btnRemove"
            Me.btnRemove.Size = New System.Drawing.Size(64, 24)
            Me.btnRemove.TabIndex = 12
            Me.btnRemove.Text = "&Remove"
            '
            'label11
            '
            Me.label11.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.label11.Location = New System.Drawing.Point(40, 372)
            Me.label11.Name = "label11"
            Me.label11.Size = New System.Drawing.Size(176, 24)
            Me.label11.TabIndex = 25
            Me.label11.Text = "Comments"
            Me.label11.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
            '
            'tbComments
            '
            Me.tbComments.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                        Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.tbComments.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
            Me.tbComments.Location = New System.Drawing.Point(40, 400)
            Me.tbComments.Multiline = True
            Me.tbComments.Name = "tbComments"
            Me.tbComments.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
            Me.tbComments.Size = New System.Drawing.Size(520, 76)
            Me.tbComments.TabIndex = 13
            Me.tbComments.Text = ""
            '
            'btnCancel
            '
            Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
            Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
            Me.btnCancel.Location = New System.Drawing.Point(48, 484)
            Me.btnCancel.Name = "btnCancel"
            Me.btnCancel.Size = New System.Drawing.Size(128, 24)
            Me.btnCancel.TabIndex = 14
            Me.btnCancel.Text = "&Cancel"
            '
            'btnSend
            '
            Me.btnSend.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnSend.DialogResult = System.Windows.Forms.DialogResult.OK
            Me.btnSend.Location = New System.Drawing.Point(424, 484)
            Me.btnSend.Name = "btnSend"
            Me.btnSend.Size = New System.Drawing.Size(128, 24)
            Me.btnSend.TabIndex = 16
            Me.btnSend.Text = "&Send"
            '
            'btnSave
            '
            Me.btnSave.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.btnSave.DialogResult = System.Windows.Forms.DialogResult.Cancel
            Me.btnSave.Location = New System.Drawing.Point(236, 484)
            Me.btnSave.Name = "btnSave"
            Me.btnSave.Size = New System.Drawing.Size(128, 24)
            Me.btnSave.TabIndex = 15
            Me.btnSave.Text = "Sa&ve"
            '
            'lbImportingFiles
            '
            Me.lbImportingFiles.Location = New System.Drawing.Point(248, 376)
            Me.lbImportingFiles.Name = "lbImportingFiles"
            Me.lbImportingFiles.Size = New System.Drawing.Size(216, 16)
            Me.lbImportingFiles.TabIndex = 30
            Me.lbImportingFiles.Text = "Importing Files...."
            Me.lbImportingFiles.Visible = False
            '
            'Faxing1
            '
            Me.Faxing1.LocalID = ""
            Me.Faxing1.ReceiveDir = ""
            '
            'SendFaxForm
            '
            Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
            Me.AutoScroll = True
            Me.ClientSize = New System.Drawing.Size(600, 514)
            Me.Controls.Add(Me.lbImportingFiles)
            Me.Controls.Add(Me.btnSave)
            Me.Controls.Add(Me.btnSend)
            Me.Controls.Add(Me.btnCancel)
            Me.Controls.Add(Me.tbComments)
            Me.Controls.Add(Me.tbDate)
            Me.Controls.Add(Me.tbSenderFax)
            Me.Controls.Add(Me.tbSenderPhone)
            Me.Controls.Add(Me.tbSenderCompany)
            Me.Controls.Add(Me.tbSenderName)
            Me.Controls.Add(Me.cbCoverpage)
            Me.Controls.Add(Me.tbFaxNumber)
            Me.Controls.Add(Me.tbCompany)
            Me.Controls.Add(Me.tbName)
            Me.Controls.Add(Me.tbFaxBanner)
            Me.Controls.Add(Me.label11)
            Me.Controls.Add(Me.btnRemove)
            Me.Controls.Add(Me.btnAdd)
            Me.Controls.Add(Me.lbFaxFiles)
            Me.Controls.Add(Me.label10)
            Me.Controls.Add(Me.label9)
            Me.Controls.Add(Me.label8)
            Me.Controls.Add(Me.label7)
            Me.Controls.Add(Me.label1)
            Me.Controls.Add(Me.label5)
            Me.Controls.Add(Me.label6)
            Me.Controls.Add(Me.label4)
            Me.Controls.Add(Me.label3)
            Me.Controls.Add(Me.label2)
            Me.Controls.Add(Me.panel1)
            Me.Name = "SendFaxForm"
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
            Me.Text = "Faxman Jr.NET Test Application - Send Fax Form"
            Me.ResumeLayout(False)

        End Sub
#End Region

		Public _fax As DataTech.FaxManJr.Fax

		Private Sub SendFaxForm_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
			If _fax.Banner.Length > 1 Then
				tbFaxBanner.Text = _fax.Banner
			End If
			cbCoverpage.Checked = (_fax.Coverpage.Length > 1)
			tbName.Text = _fax.Name
			tbCompany.Text = _fax.Company
			tbFaxNumber.Text = _fax.FaxNumber
			tbSenderName.Text = _fax.SenderName
			tbSenderCompany.Text = _fax.SenderCompany
			tbSenderPhone.Text = _fax.SenderPhone
			tbSenderFax.Text = _fax.SenderFax
			tbDate.Text = DateTime.Now.ToShortDateString()
			tbComments.Text = _fax.Comments
			lbFaxFiles.DisplayMember = "Text"

			For Each ff As Object In _fax.FaxFiles
				Dim li As ListViewItem = New ListViewItem()
				Dim ffile As String = ff.ToString()
				li.Tag = ffile
				If ffile.Length > 40 Then
					li.Text = String.Format("...{0}", ffile.Substring(ffile.Length - 40))
				Else
					li.Text = ffile
				End If
				lbFaxFiles.Items.Add(li)
			Next ff

		End Sub

		Private Sub btnSend_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSend.Click
			SaveSendFaxInformationToFaxObject()
			' Button returns DialogResult.OK
		End Sub

		Private Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
			SaveSendFaxInformationToFaxObject()
			' Button returns DialogResult.Cancel
		End Sub

		Private Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
			Me.Close()
			' Button returns DialogResult.Cancel
		End Sub

		Private Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAdd.Click
			Dim open As System.Windows.Forms.OpenFileDialog = New System.Windows.Forms.OpenFileDialog()
			open.Filter = "Faxable Files *.fmf;*.fmp;*.pdf|*.fmf;*.fmp;*.pdf|Monochrome Image Files *.tif;*.pcx;*.dcx;*.bmp|*.tif;*.tiff;*.pcx;*.dcx;*.bmp|Plain Text Files *.txt;|*.txt;"
			open.InitialDirectory = Application.UserAppDataPath
			If System.Windows.Forms.DialogResult.OK = open.ShowDialog() Then
				Dim file As String = open.FileName

				' import file if needed
				If Not(file.EndsWith(".fmf") OrElse file.EndsWith(".fmp")) Then
					Try
						lbImportingFiles.Visible = True
						lbImportingFiles.Refresh()
						Cursor = Cursors.WaitCursor
						Dim importedfile As String = String.Format("{0}{1}.fmf", Application.UserAppDataPath, file.Substring(file.LastIndexOf("\"), file.Length - file.LastIndexOf("\")))
						If Not(System.IO.File.Exists(importedfile)) Then
							Dim faxing As DataTech.FaxManJr.Faxing = New DataTech.FaxManJr.Faxing()
							faxing.ImportFiles(file, importedfile)
						End If
						Dim li As ListViewItem = New ListViewItem()
						li.Tag = importedfile
						If importedfile.Length > 40 Then
							li.Text = String.Format("..{0}", importedfile.Substring(importedfile.Length - 40))
						Else
							li.Text = importedfile
						End If
						lbFaxFiles.Items.Add(li)
					Finally
						Cursor = Cursors.Default
						lbImportingFiles.Visible = False
					End Try
				Else
					Dim li As ListViewItem = New ListViewItem()
					li.Tag = open.FileName
					If open.FileName.Length > 40 Then
						li.Text = String.Format("..{0}", open.FileName.Substring(open.FileName.Length - 40))
					Else
						li.Text = open.FileName
					End If
					lbFaxFiles.Items.Add(li)
				End If
			End If
		End Sub

		Private Sub btnRemove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemove.Click
			lbFaxFiles.Items.Remove(lbFaxFiles.SelectedItem)
		End Sub

		Private Sub SaveSendFaxInformationToFaxObject()
			If tbFaxBanner.Text.Length > 0 Then
			_fax.Banner = tbFaxBanner.Text
			End If
			If cbCoverpage.Checked Then
			_fax.Coverpage = "cover2.pg"
			Else
				_fax.Coverpage = ""
			End If
			If tbName.Text.Length > 0 Then
			_fax.Name = tbName.Text
			End If
			If tbCompany.Text.Length > 0 Then
			_fax.Company = tbCompany.Text
			End If
			If tbFaxNumber.Text.Length > 0 Then
			_fax.FaxNumber = tbFaxNumber.Text
			End If
			If tbSenderName.Text.Length > 0 Then
			_fax.SenderName = tbSenderName.Text
			End If
			If tbSenderCompany.Text.Length > 0 Then
			_fax.SenderCompany = tbSenderCompany.Text
			End If
			If tbSenderPhone.Text.Length > 0 Then
			_fax.SenderPhone = tbSenderPhone.Text
			End If
			If tbSenderFax.Text.Length > 0 Then
			_fax.SenderFax = tbSenderFax.Text
			End If
			If tbComments.Text.Length > 0 Then
			_fax.Comments = tbComments.Text
			End If

			_fax.FaxFiles.Clear()
			For Each li As ListViewItem In lbFaxFiles.Items
				_fax.FaxFiles.Add(li.Tag.ToString())
			Next li
		End Sub

	End Class
End Namespace
