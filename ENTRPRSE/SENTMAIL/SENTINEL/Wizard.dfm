object frmElWizard: TfrmElWizard
  Left = 286
  Top = 247
  BorderStyle = bsDialog
  Caption = 'Sentinel Wizard'
  ClientHeight = 385
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 183
    Top = 8
    Width = 433
    Height = 339
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Notebook1: TNotebook
      Left = 2
      Top = 2
      Width = 429
      Height = 335
      Align = alClient
      PageIndex = 1
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgDescription'
        object Label51: TLabel
          Left = 16
          Top = 16
          Width = 63
          Height = 14
          Caption = 'Description'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label52: TLabel
          Left = 16
          Top = 40
          Width = 348
          Height = 14
          Caption = 
            'Please enter a name and description for the Sentinel you wish to' +
            ' create.'
        end
        object Label57: TLabel
          Left = 32
          Top = 72
          Width = 30
          Height = 14
          Caption = 'Name:'
        end
        object Label58: TLabel
          Left = 32
          Top = 128
          Width = 57
          Height = 14
          Caption = 'Description:'
        end
        object edtDescription: TEdit
          Left = 32
          Top = 144
          Width = 369
          Height = 22
          HelpContext = 43
          MaxLength = 60
          TabOrder = 1
        end
        object edtName: TEdit
          Left = 32
          Top = 88
          Width = 177
          Height = 22
          HelpContext = 42
          MaxLength = 30
          TabOrder = 0
          OnChange = edtNameChange
          OnExit = edtNameExit
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgType'
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 429
          Height = 335
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Label61: TLabel
            Left = 16
            Top = 16
            Width = 74
            Height = 14
            Caption = 'Sentinel Type'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label79: TLabel
            Left = 16
            Top = 40
            Width = 180
            Height = 14
            Caption = 'Please select the type of this Sentinel'
          end
          object lblCSVName: TLabel
            Left = 72
            Top = 216
            Width = 239
            Height = 14
            Caption = 'CSV Filename (Max 60 chars including extension)'
          end
          object rbAlert: TRadioButton
            Left = 32
            Top = 72
            Width = 177
            Height = 17
            HelpContext = 48
            Caption = 'Email/SMS-based Alert'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbReportClick
          end
          object rbReport: TRadioButton
            Left = 32
            Top = 104
            Width = 209
            Height = 17
            HelpContext = 49
            Caption = 'Exchequer Report'
            TabOrder = 1
            OnClick = rbReportClick
          end
          object chkRepConditions: TCheckBox
            Left = 56
            Top = 168
            Width = 201
            Height = 17
            Caption = 'Set conditions for running report'
            TabOrder = 2
            Visible = False
          end
          object chkRepAsCSV: TCheckBox
            Left = 56
            Top = 192
            Width = 177
            Height = 17
            Caption = 'Output report as '
            TabOrder = 3
            OnClick = chkRepAsCSVClick
          end
          object edtCSVName: TEdit
            Left = 72
            Top = 232
            Width = 337
            Height = 22
            MaxLength = 60
            TabOrder = 4
            OnChange = edtCSVNameChange
          end
          object cbCSVType: TComboBox
            Left = 156
            Top = 190
            Width = 145
            Height = 22
            ItemHeight = 14
            TabOrder = 5
            Text = 'CSV File'
            OnChange = cbCSVTypeClick
            OnClick = cbCSVTypeClick
            Items.Strings = (
              'CSV File'
              'DBF File'
              'HTML file'
              'Excel file (.xlsx)'
              'PDF File')
          end
          object rbNewRep: TRadioButton
            Left = 32
            Top = 136
            Width = 145
            Height = 17
            Caption = 'Exchequer Visual Report'
            TabOrder = 6
            OnClick = rbReportClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgPriority'
        object Label59: TLabel
          Left = 16
          Top = 16
          Width = 40
          Height = 14
          Caption = 'Priority'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label60: TLabel
          Left = 16
          Top = 40
          Width = 262
          Height = 14
          Caption = 'Please select the priority you wish to give this Sentinel'
        end
        object rbHigh: TRadioButton
          Left = 32
          Top = 72
          Width = 113
          Height = 17
          HelpContext = 51
          Caption = 'High priority'
          TabOrder = 0
        end
        object rbLow: TRadioButton
          Left = 32
          Top = 104
          Width = 113
          Height = 17
          HelpContext = 52
          Caption = 'Low priority'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgPushPull'
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 88
          Height = 14
          Caption = 'Sentinel Trigger'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 16
          Top = 40
          Width = 245
          Height = 14
          Caption = 'Please select how you want to trigger this Sentinel'
        end
        object rbTimer: TRadioButton
          Left = 32
          Top = 72
          Width = 113
          Height = 17
          HelpContext = 55
          Caption = 'From a timer'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbEventClick
        end
        object rbEvent: TRadioButton
          Left = 32
          Top = 104
          Width = 209
          Height = 17
          HelpContext = 56
          Caption = 'From an event in Exchequer'
          TabOrder = 1
          OnClick = rbEventClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgEvent'
        object Label34: TLabel
          Left = 16
          Top = 16
          Width = 30
          Height = 14
          Caption = 'Event'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label35: TLabel
          Left = 16
          Top = 40
          Width = 371
          Height = 14
          Caption = 
            'Please select the Exchequer event from which you wish to run thi' +
            's Sentinel..'
        end
        object Label36: TLabel
          Left = 32
          Top = 72
          Width = 30
          Height = 14
          Caption = 'Event:'
        end
        object Label37: TLabel
          Left = 32
          Top = 128
          Width = 52
          Height = 14
          Caption = 'Window ID'
        end
        object Label38: TLabel
          Left = 32
          Top = 184
          Width = 46
          Height = 14
          Caption = 'HandlerID'
        end
        object cbEventDesc: TComboBox
          Left = 32
          Top = 88
          Width = 289
          Height = 22
          HelpContext = 61
          ItemHeight = 0
          TabOrder = 0
          OnChange = cbEventDescChange
        end
        object edtWindowID: TEdit
          Left = 32
          Top = 144
          Width = 121
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 1
        end
        object edtHandlerID: TEdit
          Left = 32
          Top = 200
          Width = 121
          Height = 22
          Color = clMenu
          ReadOnly = True
          TabOrder = 2
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgDatafile'
        object Label19: TLabel
          Left = 16
          Top = 16
          Width = 40
          Height = 14
          Caption = 'Datafile'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label20: TLabel
          Left = 16
          Top = 40
          Width = 277
          Height = 14
          Caption = 'Please select the main datafile to be used for this Sentinel'
        end
        object Label21: TLabel
          Left = 32
          Top = 72
          Width = 36
          Height = 14
          Caption = 'Datafile'
        end
        object cbDatafile: TComboBox
          Left = 32
          Top = 88
          Width = 225
          Height = 22
          ItemHeight = 0
          Sorted = True
          TabOrder = 0
          OnChange = cbDatafileChange
        end
        object pnlIdx: TPanel
          Left = 24
          Top = 112
          Width = 289
          Height = 169
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object lblIndex: TLabel
            Left = 8
            Top = 8
            Width = 26
            Height = 14
            Caption = 'Index'
          end
          object Label23: TLabel
            Left = 8
            Top = 64
            Width = 70
            Height = 14
            Caption = 'Start of Range'
          end
          object lblOffStart: TLabel
            Left = 152
            Top = 64
            Width = 67
            Height = 14
            Caption = 'Offset (Days)'
            Visible = False
          end
          object lblOffEnd: TLabel
            Left = 152
            Top = 112
            Width = 67
            Height = 14
            Caption = 'Offset (Days)'
            Visible = False
          end
          object Label24: TLabel
            Left = 8
            Top = 112
            Width = 62
            Height = 14
            Caption = 'End of range'
          end
          object bvContEmploy: TBevel
            Left = 8
            Top = 28
            Width = 225
            Height = 2
            Visible = False
          end
          object lblContEmploy: TLabel
            Left = 8
            Top = 36
            Width = 225
            Height = 25
            AutoSize = False
            Caption = 'Date range for continuous employment'
            Visible = False
            WordWrap = True
          end
          object cbIndex: TComboBox
            Left = 8
            Top = 24
            Width = 225
            Height = 22
            Enabled = False
            ItemHeight = 0
            TabOrder = 0
            OnChange = cbIndexChange
          end
          object cbRangeStart: TComboBox
            Left = 8
            Top = 80
            Width = 121
            Height = 22
            ItemHeight = 0
            TabOrder = 1
            OnChange = cbRangeStartChange
            OnDblClick = cbRangeStartDblClick
            OnExit = cbRangeStartExit
          end
          object spnOffStart: TSpinEdit
            Left = 152
            Top = 80
            Width = 81
            Height = 23
            MaxValue = 0
            MinValue = 0
            TabOrder = 2
            Value = 0
            Visible = False
          end
          object spnOffEnd: TSpinEdit
            Left = 152
            Top = 128
            Width = 81
            Height = 23
            MaxValue = 0
            MinValue = 0
            TabOrder = 3
            Value = 0
            Visible = False
          end
          object cbRangeEnd: TComboBox
            Left = 8
            Top = 128
            Width = 121
            Height = 22
            ItemHeight = 0
            TabOrder = 4
            OnChange = cbRangeStartChange
            OnDblClick = cbRangeStartDblClick
            OnExit = cbRangeStartExit
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgConditions'
        object Label30: TLabel
          Left = 16
          Top = 16
          Width = 60
          Height = 14
          Caption = 'Conditions'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label31: TLabel
          Left = 16
          Top = 40
          Width = 377
          Height = 14
          Caption = 
            'Please enter the conditions under which you want this Sentinel t' +
            'o be triggered'
        end
        object lblReportWarn: TLabel
          Left = 32
          Top = 272
          Width = 321
          Height = 57
          AutoSize = False
          Caption = 
            'Please note: if you enter any condition then a query will be run' +
            ' and the report will be triggered if any record meets the query ' +
            'condition.  If you leave the conditions blank then the report wi' +
            'll always be triggered.'
          Visible = False
          WordWrap = True
        end
        object memConditions: TMemo
          Left = 32
          Top = 72
          Width = 321
          Height = 193
          TabStop = False
          Color = clMenu
          ReadOnly = True
          TabOrder = 0
          OnDblClick = btnLogicEditClick
        end
        object btnLogicEdit: TButton
          Left = 360
          Top = 72
          Width = 56
          Height = 25
          HelpContext = 63
          Caption = '&Edit'
          TabOrder = 1
          OnClick = btnLogicEditClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgFrequency'
        object Label43: TLabel
          Left = 16
          Top = 16
          Width = 82
          Height = 14
          Caption = 'Data frequency'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label44: TLabel
          Left = 16
          Top = 40
          Width = 393
          Height = 33
          AutoSize = False
          Caption = 
            'Please select how often you wish the same data to be included in' +
            ' the output from this Sentinel'
          WordWrap = True
        end
        object edtDays: TEdit
          Left = 192
          Top = 118
          Width = 41
          Height = 22
          HelpContext = 66
          TabOrder = 2
          Text = '1'
        end
        object cbFrequency: TComboBox
          Left = 240
          Top = 118
          Width = 73
          Height = 22
          HelpContext = 66
          ItemHeight = 14
          TabOrder = 3
          Text = 'Days'
          OnChange = cbFrequencyChange
          Items.Strings = (
            'Days'
            'Weeks'
            'Months')
        end
        object rbFreqAlways: TRadioButton
          Left = 32
          Top = 88
          Width = 113
          Height = 17
          HelpContext = 65
          Caption = 'Never omit data'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbFreqRepeatClick
        end
        object rbFreqRepeat: TRadioButton
          Left = 32
          Top = 120
          Width = 161
          Height = 17
          HelpContext = 66
          Caption = 'Repeat the same data every'
          TabOrder = 1
          OnClick = rbFreqRepeatClick
        end
        object rbFreqNever: TRadioButton
          Left = 32
          Top = 152
          Width = 113
          Height = 17
          HelpContext = 67
          Caption = 'Never repeat data'
          TabOrder = 4
          OnClick = rbFreqRepeatClick
        end
        object chkMarkExisting: TCheckBox
          Left = 64
          Top = 184
          Width = 305
          Height = 17
          Caption = 'Treat existing data as already sent'
          TabOrder = 5
          OnClick = chkMarkExistingClick
        end
        object rgAcType: TRadioGroup
          Left = 64
          Top = 216
          Width = 249
          Height = 49
          Caption = 'Treat Account as...'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Customer'
            'Supplier')
          TabOrder = 6
          Visible = False
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgTransmission'
        object Label3: TLabel
          Left = 16
          Top = 16
          Width = 76
          Height = 14
          Caption = 'Transmission'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 17
          Top = 40
          Width = 328
          Height = 14
          Caption = 
            'Please select the way(s) in which you want to transmit this Sent' +
            'inel'
        end
        object chkEmail: TCheckBox
          Left = 40
          Top = 72
          Width = 97
          Height = 17
          HelpContext = 58
          Caption = 'Email message'
          TabOrder = 0
          OnClick = chkEmailClick
        end
        object chkSMS: TCheckBox
          Left = 40
          Top = 104
          Width = 97
          Height = 17
          HelpContext = 59
          Caption = 'SMS Message'
          TabOrder = 1
          OnClick = chkEmailClick
        end
        object chkCSV: TCheckBox
          Left = 200
          Top = 104
          Width = 169
          Height = 17
          Caption = 'Enterprise Report as CSV'
          TabOrder = 2
          Visible = False
          OnClick = chkEmailClick
        end
        object gbEmailType: TGroupBox
          Left = 40
          Top = 136
          Width = 297
          Height = 89
          HelpContext = 82
          Caption = 'Send Email as'
          TabOrder = 3
          Visible = False
          object rbSingleEmail: TRadioButton
            Left = 8
            Top = 24
            Width = 193
            Height = 17
            Caption = 'Put all records into one Email'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = chkEmailClick
          end
          object rbMultEmail: TRadioButton
            Left = 8
            Top = 56
            Width = 217
            Height = 17
            Caption = 'Send a separate Email for each record'
            TabOrder = 1
            OnClick = chkEmailClick
          end
        end
        object gbRepOutput: TGroupBox
          Left = 40
          Top = 72
          Width = 297
          Height = 89
          Caption = 'Send Report by'
          TabOrder = 4
          Visible = False
          object chkRepEmail: TCheckBox
            Left = 24
            Top = 24
            Width = 97
            Height = 17
            Caption = 'Email'
            TabOrder = 0
            OnClick = chkRepEmailClick
          end
          object chkRepFax: TCheckBox
            Left = 24
            Top = 56
            Width = 97
            Height = 17
            Caption = 'Fax'
            TabOrder = 1
            OnClick = chkRepEmailClick
          end
        end
        object gbCSVOutput: TGroupBox
          Left = 40
          Top = 72
          Width = 297
          Height = 153
          Caption = 'Send CSV file by'
          TabOrder = 5
          Visible = False
          object chkCSVEmail: TCheckBox
            Left = 24
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Email'
            TabOrder = 0
            OnClick = chkCSVEmailClick
          end
          object chkCSVFtp: TCheckBox
            Left = 24
            Top = 64
            Width = 97
            Height = 17
            Caption = 'FTP'
            TabOrder = 1
            OnClick = chkCSVEmailClick
          end
          object chkCSVFolder: TCheckBox
            Left = 24
            Top = 96
            Width = 97
            Height = 17
            Caption = 'Save to Folder'
            TabOrder = 2
            OnClick = chkCSVEmailClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgEmailAdd'
        object Label14: TLabel
          Left = 16
          Top = 16
          Width = 151
          Height = 14
          Caption = 'Email Message - Recipients'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label15: TLabel
          Left = 16
          Top = 32
          Width = 401
          Height = 33
          AutoSize = False
          Caption = 
            'Click the Add button to enter an email address.  Alternatively, ' +
            'click the Contacts button to select from known email recipients.'
          WordWrap = True
        end
        object Label18: TLabel
          Left = 16
          Top = 72
          Width = 53
          Height = 14
          Caption = 'Recipients:'
        end
        object btnEmailAdd: TButton
          Left = 360
          Top = 88
          Width = 57
          Height = 25
          HelpContext = 69
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnEmailAddClick
        end
        object lvEmailRecip: TListView
          Left = 16
          Top = 88
          Width = 337
          Height = 233
          Columns = <
            item
              Width = 30
            end
            item
              Caption = 'Name'
              Width = 120
            end
            item
              Caption = 'Address'
              Width = 165
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          OnDblClick = btnEmAddEditClick
          OnDeletion = lvEmailRecipInsert
          OnInsert = lvEmailRecipInsert
          OnKeyUp = lvEmailRecipKeyUp
        end
        object btnContacts: TButton
          Left = 360
          Top = 296
          Width = 57
          Height = 25
          HelpContext = 72
          Caption = 'Con&tacts'
          TabOrder = 2
          OnClick = btnContactsClick
        end
        object btnEmAddDelete: TButton
          Left = 360
          Top = 152
          Width = 57
          Height = 25
          HelpContext = 71
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnEmAddDeleteClick
        end
        object btnEmAddEdit: TButton
          Left = 360
          Top = 120
          Width = 57
          Height = 25
          HelpContext = 70
          Caption = '&Edit'
          TabOrder = 4
          OnClick = btnEmAddEditClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgEmailMsg'
        object Label12: TLabel
          Left = 16
          Top = 16
          Width = 145
          Height = 14
          Caption = 'Email Message - message'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 16
          Top = 32
          Width = 326
          Height = 33
          AutoSize = False
          Caption = 'Please type the email message you want to send.'
          WordWrap = True
        end
        object Label55: TLabel
          Left = 16
          Top = 56
          Width = 36
          Height = 14
          Caption = 'Subject'
        end
        object lblEmailMsg: TLabel
          Left = 16
          Top = 104
          Width = 44
          Height = 14
          Caption = 'Message'
        end
        object btnEmailInsertDb: TButton
          Tag = 255
          Left = 16
          Top = 296
          Width = 80
          Height = 25
          HelpContext = 73
          Caption = '&DB Field'
          TabOrder = 2
          OnClick = btnEmailInsertDbClick
        end
        object edtEmSubject: TEdit
          Left = 16
          Top = 72
          Width = 401
          Height = 22
          HelpContext = 73
          TabOrder = 0
          OnChange = memEmailMsgChange
          OnEnter = edtEmSubjectEnter
          OnExit = edtEmSubjectExit
        end
        object chkAttachReport: TCheckBox
          Left = 232
          Top = 300
          Width = 81
          Height = 17
          Caption = 'Attach report'
          TabOrder = 3
          Visible = False
        end
        object chkAttachCSV: TCheckBox
          Left = 328
          Top = 300
          Width = 81
          Height = 17
          Caption = 'Attach CSV'
          TabOrder = 4
          Visible = False
        end
        object pgcEmailMsg: TPageControl
          Left = 16
          Top = 120
          Width = 401
          Height = 169
          HelpContext = 73
          ActivePage = pgEmailTrailer
          TabIndex = 2
          TabOrder = 1
          OnChange = pgcEmailMsgChange
          object pgEmailHeader: TTabSheet
            Tag = 1
            Caption = 'Header'
            object lblEmailHeader: TLabel
              Left = 0
              Top = 8
              Width = 235
              Height = 14
              Caption = 'The header will be included once in the message'
            end
            object memEmailHeader: TMemo
              Left = 0
              Top = 24
              Width = 393
              Height = 113
              TabOrder = 0
            end
          end
          object pgEmailLines: TTabSheet
            Tag = 2
            Caption = 'Lines'
            ImageIndex = 1
            object lblEmailLines: TLabel
              Left = 0
              Top = 8
              Width = 349
              Height = 14
              Caption = 
                'This data will be repeated in the message once for each included' +
                ' record'
            end
            object memEmailLines: TMemo
              Left = 0
              Top = 24
              Width = 393
              Height = 113
              ScrollBars = ssHorizontal
              TabOrder = 0
              WordWrap = False
              OnExit = memEmailLinesExit
            end
          end
          object pgEmailTrailer: TTabSheet
            Tag = 3
            Caption = 'Trailer'
            ImageIndex = 2
            object Label47: TLabel
              Left = 0
              Top = 8
              Width = 228
              Height = 14
              Caption = 'The trailer will be included once in the message'
            end
            object memEmailTrailer: TMemo
              Left = 0
              Top = 24
              Width = 393
              Height = 113
              TabOrder = 0
            end
          end
          object pgForm: TTabSheet
            Caption = 'Form'
            ImageIndex = 3
            object pnlPaperless: TPanel
              Left = 8
              Top = 7
              Width = 377
              Height = 130
              BevelInner = bvRaised
              BevelOuter = bvLowered
              TabOrder = 0
              object Label78: TLabel
                Left = 24
                Top = 72
                Width = 60
                Height = 14
                Caption = 'Form to use:'
              end
              object spTransForm: TSpeedButton
                Left = 242
                Top = 68
                Width = 23
                Height = 22
                Caption = '...'
                OnClick = spFaxCoverClick
              end
              object edtTransForm: TEdit
                Left = 94
                Top = 68
                Width = 147
                Height = 22
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 0
              end
              object chkSendDoc: TCheckBox
                Left = 24
                Top = 26
                Width = 257
                Height = 17
                Caption = 'Send paperless copy of transaction with email'
                TabOrder = 1
                OnClick = chkSendDocClick
              end
            end
          end
        end
        object btnEmFuncs: TButton
          Tag = 255
          Left = 104
          Top = 296
          Width = 80
          Height = 25
          HelpContext = 73
          Caption = '&Functions'
          TabOrder = 5
          OnClick = btnEmFuncsClick
        end
        object chkWordWrap: TCheckBox
          Left = 336
          Top = 120
          Width = 73
          Height = 17
          Caption = 'Word Wrap'
          TabOrder = 6
          Visible = False
          OnClick = chkWordWrapClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgSMSNos'
        object Label5: TLabel
          Left = 16
          Top = 16
          Width = 177
          Height = 14
          Caption = 'SMS Message - Phone numbers'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 16
          Top = 32
          Width = 401
          Height = 33
          AutoSize = False
          Caption = 
            'Click the Add button to enter a phone number and an optional nam' +
            'e. Alternatively click the Contacts button to select from a list' +
            ' of known SMS recipients.'
          WordWrap = True
        end
        object Label7: TLabel
          Left = 16
          Top = 72
          Width = 53
          Height = 14
          Caption = 'Recipients:'
        end
        object btnSMSAdd: TButton
          Left = 360
          Top = 88
          Width = 57
          Height = 25
          Caption = '&Add'
          TabOrder = 0
          OnClick = btnSMSAddClick
        end
        object lvSMSRecip: TListView
          Left = 16
          Top = 88
          Width = 337
          Height = 233
          Columns = <
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Number'
              Width = 165
            end>
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          OnDblClick = btnSMSNoEditClick
          OnDeletion = lvSMSRecipInsert
          OnInsert = lvSMSRecipInsert
          OnKeyUp = lvSMSRecipKeyUp
        end
        object btnSMSContacts: TButton
          Left = 360
          Top = 296
          Width = 57
          Height = 25
          Caption = '&Contacts'
          TabOrder = 2
          OnClick = btnSMSContactsClick
        end
        object btnSMSDelete: TButton
          Left = 360
          Top = 152
          Width = 57
          Height = 25
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnSMSDeleteClick
        end
        object btnSMSNoEdit: TButton
          Left = 360
          Top = 120
          Width = 57
          Height = 25
          Caption = '&Edit'
          TabOrder = 4
          OnClick = btnSMSNoEditClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgSMSMsg'
        object Label10: TLabel
          Left = 16
          Top = 16
          Width = 140
          Height = 14
          Caption = 'SMS Message - message'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 16
          Top = 32
          Width = 393
          Height = 33
          AutoSize = False
          Caption = 
            'Please type the message you want to send.  (Remember that SMS me' +
            'ssages are limited to 160 characters.)'
          WordWrap = True
        end
        object Label8: TLabel
          Left = 16
          Top = 312
          Width = 106
          Height = 14
          Caption = 'Characters remaining:'
        end
        object lblCharsRemaining: TLabel
          Left = 128
          Top = 312
          Width = 18
          Height = 14
          Caption = '160'
        end
        object memSMSMsg: TMemo
          Left = 16
          Top = 72
          Width = 313
          Height = 233
          TabOrder = 0
          OnChange = memSMSMsgChange
        end
        object btnSMSInsertDB: TButton
          Left = 336
          Top = 72
          Width = 80
          Height = 25
          Caption = '&DB Field'
          TabOrder = 1
          OnClick = btnSMSInsertDBClick
        end
        object btnSMSFunc: TButton
          Left = 336
          Top = 104
          Width = 81
          Height = 25
          Caption = '&Functions'
          TabOrder = 2
          OnClick = btnSMSFuncClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgReport'
        object Label25: TLabel
          Left = 16
          Top = 16
          Width = 37
          Height = 14
          Caption = 'Report'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 16
          Top = 40
          Width = 235
          Height = 14
          Caption = 'Please select the report format you wish to send'
        end
        object Label50: TLabel
          Left = 16
          Top = 72
          Width = 77
          Height = 14
          Caption = 'Selected report:'
        end
        object lblReport: TLabel
          Left = 96
          Top = 72
          Width = 25
          Height = 14
          Caption = 'None'
        end
        object Label80: TLabel
          Left = 16
          Top = 308
          Width = 55
          Height = 14
          Caption = 'Search for:'
        end
        object tvReports: TTreeView
          Left = 16
          Top = 88
          Width = 393
          Height = 209
          Images = ImageList1
          Indent = 19
          ReadOnly = True
          TabOrder = 0
          OnChange = tvReportsChange
          OnCollapsing = tvReportsCollapsing
          OnExpanding = tvReportsExpanding
        end
        object edtFind: TEdit
          Left = 80
          Top = 304
          Width = 249
          Height = 22
          TabOrder = 1
          OnChange = edtFindChange
        end
        object btnFind: TButton
          Left = 336
          Top = 304
          Width = 75
          Height = 25
          Caption = '&Find'
          Enabled = False
          TabOrder = 2
          OnClick = btnFindClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgReportParams'
        object Label53: TLabel
          Left = 16
          Top = 16
          Width = 105
          Height = 14
          Caption = 'Report Parameters'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label54: TLabel
          Left = 16
          Top = 40
          Width = 393
          Height = 41
          AutoSize = False
          Caption = 
            'Select a parameter and click the Edit button to change the value' +
            's that will be sent to the report'
          WordWrap = True
        end
        object Label45: TLabel
          Left = 16
          Top = 80
          Width = 58
          Height = 14
          Caption = 'Parameters:'
        end
        object btnEditParams: TButton
          Left = 352
          Top = 96
          Width = 62
          Height = 25
          Caption = '&Edit'
          TabOrder = 0
          OnClick = btnEditParamsClick
        end
        object lvParams: TListView
          Left = 16
          Top = 96
          Width = 329
          Height = 225
          Columns = <
            item
              Caption = 'No.'
              Width = 28
            end
            item
              Caption = 'Description'
              Width = 145
            end
            item
              Caption = 'From'
              Width = 75
            end
            item
              Caption = 'To'
              Width = 75
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          RowSelect = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnDblClick = btnEditParamsClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgCSVFTP'
        object Label81: TLabel
          Left = 16
          Top = 16
          Width = 66
          Height = 14
          Caption = 'FTP Options'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label85: TLabel
          Left = 32
          Top = 64
          Width = 62
          Height = 14
          Caption = 'Site Address'
        end
        object Label86: TLabel
          Left = 32
          Top = 112
          Width = 74
          Height = 14
          Caption = 'Site User Name'
        end
        object Label87: TLabel
          Left = 32
          Top = 160
          Width = 71
          Height = 14
          Caption = 'Site Password'
        end
        object Label88: TLabel
          Left = 32
          Top = 208
          Width = 40
          Height = 14
          Caption = 'Site Port'
        end
        object Label89: TLabel
          Left = 32
          Top = 272
          Width = 80
          Height = 14
          Caption = 'Upload Directory'
        end
        object Bevel2: TBevel
          Left = 32
          Top = 260
          Width = 321
          Height = 2
        end
        object Label82: TLabel
          Left = 144
          Top = 208
          Width = 73
          Height = 14
          Caption = 'Time out (mins)'
        end
        object Label83: TLabel
          Left = 16
          Top = 40
          Width = 377
          Height = 14
          Caption = 
            'Please enter the details of the FTP site to which you wish to se' +
            'nd this Sentinel'
        end
        object edtFTPSite: TEdit
          Left = 32
          Top = 80
          Width = 313
          Height = 22
          TabOrder = 0
        end
        object edtFTPUser: TEdit
          Left = 32
          Top = 128
          Width = 185
          Height = 22
          TabOrder = 1
        end
        object edtFTPPassword: TEdit
          Left = 32
          Top = 176
          Width = 185
          Height = 22
          PasswordChar = '*'
          TabOrder = 2
          OnEnter = edtFTPPasswordEnter
          OnExit = edtFTPPasswordExit
        end
        object edtFTPPort: TEdit
          Left = 32
          Top = 224
          Width = 65
          Height = 22
          TabOrder = 3
          Text = '0'
          OnExit = edtFTPPortExit
        end
        object edtFTPDir: TEdit
          Left = 32
          Top = 288
          Width = 321
          Height = 22
          TabOrder = 4
        end
        object edtTimeout: TEdit
          Left = 144
          Top = 224
          Width = 73
          Height = 22
          TabOrder = 5
          Text = '10'
          OnExit = edtFTPPortExit
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgDay'
        object Label32: TLabel
          Left = 16
          Top = 16
          Width = 83
          Height = 14
          Caption = 'Day Scheduling'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label33: TLabel
          Left = 16
          Top = 40
          Width = 321
          Height = 28
          AutoSize = False
          Caption = 'Please choose the days on which you want this sentinel to run.'
          WordWrap = True
        end
        object grpDays: TGroupBox
          Left = 32
          Top = 136
          Width = 305
          Height = 113
          Caption = 'Days'
          TabOrder = 0
          object chkMonday: TCheckBox
            Left = 40
            Top = 24
            Width = 81
            Height = 17
            Caption = 'Monday'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkTuesday: TCheckBox
            Left = 40
            Top = 45
            Width = 81
            Height = 17
            Caption = 'Tuesday'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkWednesday: TCheckBox
            Left = 40
            Top = 67
            Width = 81
            Height = 17
            Caption = 'Wednesday'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chkThursday: TCheckBox
            Left = 40
            Top = 88
            Width = 81
            Height = 17
            Caption = 'Thursday'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object chkFriday: TCheckBox
            Left = 176
            Top = 24
            Width = 81
            Height = 17
            Caption = 'Friday'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object chkSaturday: TCheckBox
            Left = 176
            Top = 45
            Width = 81
            Height = 17
            Caption = 'Saturday'
            TabOrder = 5
          end
          object chkSunday: TCheckBox
            Left = 176
            Top = 64
            Width = 81
            Height = 17
            Caption = 'Sunday'
            TabOrder = 6
          end
        end
        object GroupBox2: TGroupBox
          Left = 32
          Top = 256
          Width = 305
          Height = 57
          Caption = 'Starting on'
          TabOrder = 1
          object dtStartDate: TDateTimePicker
            Left = 104
            Top = 20
            Width = 105
            Height = 22
            CalAlignment = dtaLeft
            Date = 36723.4924209606
            Time = 36723.4924209606
            DateFormat = dfShort
            DateMode = dmUpDown
            Kind = dtkDate
            ParseInput = False
            TabOrder = 0
          end
        end
        object grpPeriod: TGroupBox
          Left = 32
          Top = 136
          Width = 305
          Height = 113
          Caption = 'Period'
          TabOrder = 2
          object Label48: TLabel
            Left = 72
            Top = 52
            Width = 28
            Height = 14
            Caption = 'Every'
          end
          object Label49: TLabel
            Left = 200
            Top = 52
            Width = 25
            Height = 14
            Caption = 'Days'
          end
          object spnDaysBetween: TSpinEdit
            Left = 112
            Top = 48
            Width = 81
            Height = 23
            MaxValue = 999
            MinValue = 1
            TabOrder = 0
            Value = 1
          end
        end
        object GroupBox1: TGroupBox
          Left = 32
          Top = 64
          Width = 305
          Height = 65
          Caption = 'Run'
          TabOrder = 3
          object rbDaily: TRadioButton
            Left = 64
            Top = 16
            Width = 177
            Height = 17
            Caption = 'Daily on specified days'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbDailyClick
          end
          object rbPeriod: TRadioButton
            Left = 64
            Top = 40
            Width = 193
            Height = 17
            Caption = 'Periodically with an interval of days'
            TabOrder = 1
            OnClick = rbDailyClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgTime'
        object Label26: TLabel
          Left = 16
          Top = 16
          Width = 92
          Height = 14
          Caption = 'Time Scheduling'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label27: TLabel
          Left = 16
          Top = 40
          Width = 329
          Height = 28
          AutoSize = False
          Caption = 'Please choose the times at which you want this Sentinel to run.'
          WordWrap = True
        end
        object Label28: TLabel
          Left = 118
          Top = 116
          Width = 86
          Height = 14
          Caption = 'Minutes, between'
        end
        object Label29: TLabel
          Left = 186
          Top = 140
          Width = 18
          Height = 14
          Caption = 'and'
        end
        object Label46: TLabel
          Left = 118
          Top = 76
          Width = 37
          Height = 14
          Caption = 'Minutes'
        end
        object rbMinsBetween: TRadioButton
          Left = 32
          Top = 115
          Width = 49
          Height = 17
          Caption = 'Every'
          TabOrder = 0
          OnClick = rbMinsClick
        end
        object dtBetweenStart: TDateTimePicker
          Left = 208
          Top = 112
          Width = 81
          Height = 22
          CalAlignment = dtaLeft
          Date = 36678.375
          Time = 36678.375
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkTime
          ParseInput = False
          TabOrder = 1
        end
        object dtBetweenEnd: TDateTimePicker
          Left = 208
          Top = 136
          Width = 81
          Height = 22
          CalAlignment = dtaLeft
          Date = 36678.7291666667
          Time = 36678.7291666667
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkTime
          ParseInput = False
          TabOrder = 2
        end
        object dtSpecific: TDateTimePicker
          Left = 128
          Top = 176
          Width = 81
          Height = 22
          CalAlignment = dtaLeft
          Date = 36678.5
          Time = 36678.5
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkTime
          ParseInput = False
          TabOrder = 3
        end
        object rbSpecific: TRadioButton
          Left = 32
          Top = 179
          Width = 89
          Height = 17
          Caption = 'Specific Time :'
          TabOrder = 4
          OnClick = rbMinsClick
        end
        object rbMins: TRadioButton
          Left = 32
          Top = 75
          Width = 49
          Height = 17
          Caption = 'Every'
          Checked = True
          TabOrder = 5
          TabStop = True
          OnClick = rbMinsClick
        end
        object edMins: TEdit
          Left = 80
          Top = 74
          Width = 34
          Height = 22
          TabOrder = 6
          Text = '60'
        end
        object edMinsBetween: TEdit
          Left = 80
          Top = 112
          Width = 34
          Height = 22
          TabOrder = 7
          Text = '60'
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgExpiry'
        object Label39: TLabel
          Left = 16
          Top = 16
          Width = 33
          Height = 14
          Caption = 'Expiry'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label40: TLabel
          Left = 16
          Top = 40
          Width = 250
          Height = 14
          Caption = 'Please select when you want this Sentinel to expire'
        end
        object Label56: TLabel
          Left = 218
          Top = 144
          Width = 94
          Height = 14
          Caption = 'successful triggers'
        end
        object Bevel1: TBevel
          Left = 32
          Top = 248
          Width = 377
          Height = 2
        end
        object rbNeverExpire: TRadioButton
          Left = 32
          Top = 72
          Width = 113
          Height = 17
          HelpContext = 75
          Caption = 'Never expire'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbDateExpireClick
        end
        object rbDateExpire: TRadioButton
          Left = 32
          Top = 108
          Width = 97
          Height = 17
          HelpContext = 76
          Caption = 'Expire on date:'
          TabOrder = 1
          OnClick = rbDateExpireClick
        end
        object rbExpireOneRun: TRadioButton
          Left = 32
          Top = 144
          Width = 81
          Height = 17
          HelpContext = 77
          Caption = 'Expire after '
          TabOrder = 2
          OnClick = rbDateExpireClick
        end
        object dtDateExpire: TDateTimePicker
          Left = 128
          Top = 104
          Width = 81
          Height = 22
          HelpContext = 76
          CalAlignment = dtaLeft
          Date = 36723.4924209606
          Time = 36723.4924209606
          DateFormat = dfShort
          DateMode = dmUpDown
          Enabled = False
          Kind = dtkDate
          ParseInput = False
          TabOrder = 3
        end
        object spnTriggerCount: TSpinEdit
          Left = 128
          Top = 140
          Width = 81
          Height = 23
          HelpContext = 77
          MaxValue = 64000
          MinValue = 1
          TabOrder = 4
          Value = 1
        end
        object chkDeleteAfterExpiry: TCheckBox
          Left = 32
          Top = 264
          Width = 145
          Height = 17
          Caption = 'Delete after expiry'
          TabOrder = 5
        end
        object Panel4: TPanel
          Left = 32
          Top = 180
          Width = 377
          Height = 53
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 6
          object lblTrigger: TLabel
            Left = 8
            Top = 12
            Width = 265
            Height = 14
            AutoSize = False
            Caption = 'This sentinel has been successfully triggered 0 times'
          end
          object Button9: TButton
            Left = 304
            Top = 8
            Width = 65
            Height = 25
            HelpContext = 78
            Caption = '&Reset'
            TabOrder = 0
            OnClick = Button9Click
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgActive'
        object Label41: TLabel
          Left = 16
          Top = 16
          Width = 34
          Height = 14
          Caption = 'Active'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label42: TLabel
          Left = 16
          Top = 40
          Width = 235
          Height = 14
          Caption = 'Check the box below to make this Sentinel active'
        end
        object chkActive: TCheckBox
          Left = 34
          Top = 72
          Width = 97
          Height = 17
          HelpContext = 80
          Caption = 'Sentinel Active'
          TabOrder = 0
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRepEmailAdd'
        object Label68: TLabel
          Left = 16
          Top = 16
          Width = 140
          Height = 14
          Caption = 'Email Report  - Recipients'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label69: TLabel
          Left = 16
          Top = 40
          Width = 401
          Height = 33
          AutoSize = False
          Caption = 
            'Type an email address (and an optional name) and click the Add b' +
            'utton.  Alternatively, click the Contacts button to select from ' +
            'known email recipients.'
          WordWrap = True
        end
        object Label70: TLabel
          Left = 16
          Top = 80
          Width = 53
          Height = 14
          Caption = 'Recipients:'
        end
        object lvRepEmailAdd: TListView
          Left = 16
          Top = 96
          Width = 337
          Height = 225
          Columns = <
            item
              Width = 30
            end
            item
              Caption = 'Name'
              Width = 120
            end
            item
              Caption = 'Address'
              Width = 165
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = btnEmAddEditClick
          OnDeletion = lvEmailRecipInsert
          OnInsert = lvEmailRecipInsert
          OnKeyUp = lvEmailRecipKeyUp
        end
        object btnRepContacts: TButton
          Left = 360
          Top = 296
          Width = 57
          Height = 25
          Caption = 'Con&tacts'
          TabOrder = 1
          OnClick = btnContactsClick
        end
        object Button2: TButton
          Left = 360
          Top = 160
          Width = 57
          Height = 25
          Caption = '&Delete'
          TabOrder = 2
          OnClick = btnEmAddDeleteClick
        end
        object Button3: TButton
          Left = 360
          Top = 128
          Width = 57
          Height = 25
          Caption = '&Edit'
          TabOrder = 3
          OnClick = btnEmAddEditClick
        end
        object Button4: TButton
          Left = 360
          Top = 96
          Width = 57
          Height = 25
          Caption = '&Add'
          TabOrder = 4
          OnClick = btnEmailAddClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRepEmailMsg'
        object Label16: TLabel
          Left = 16
          Top = 16
          Width = 133
          Height = 14
          Caption = 'Email Report  - Message'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label17: TLabel
          Left = 16
          Top = 40
          Width = 326
          Height = 17
          AutoSize = False
          Caption = 'Please type the email message you want to send with the report.'
          WordWrap = True
        end
        object Label62: TLabel
          Left = 16
          Top = 120
          Width = 47
          Height = 14
          Caption = 'Message:'
        end
        object Label63: TLabel
          Left = 16
          Top = 72
          Width = 39
          Height = 14
          Caption = 'Subject:'
        end
        object edtRepEmailSub: TEdit
          Left = 16
          Top = 88
          Width = 401
          Height = 22
          TabOrder = 0
        end
        object memRepEmailMsg: TMemo
          Left = 16
          Top = 136
          Width = 401
          Height = 177
          TabOrder = 1
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRepFaxAdd'
        object Label64: TLabel
          Left = 16
          Top = 16
          Width = 126
          Height = 14
          Caption = 'Fax Report - Recipients'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label65: TLabel
          Left = 16
          Top = 40
          Width = 401
          Height = 33
          AutoSize = False
          Caption = 
            'Click the Add button to enter a phone number and an optional nam' +
            'e. Alternatively click the Contacts button to select from a list' +
            ' of known fax recipients.'
          WordWrap = True
        end
        object Label71: TLabel
          Left = 16
          Top = 80
          Width = 53
          Height = 14
          Caption = 'Recipients:'
        end
        object lvRepFaxAdd: TListView
          Left = 16
          Top = 96
          Width = 337
          Height = 225
          Columns = <
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Number'
              Width = 165
            end>
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = btnSMSNoEditClick
          OnDeletion = lvSMSRecipInsert
          OnInsert = lvSMSRecipInsert
          OnKeyUp = lvSMSRecipKeyUp
        end
        object Button5: TButton
          Left = 360
          Top = 96
          Width = 57
          Height = 25
          Caption = '&Add'
          TabOrder = 1
          OnClick = btnSMSAddClick
        end
        object Button6: TButton
          Left = 360
          Top = 128
          Width = 57
          Height = 25
          Caption = '&Edit'
          TabOrder = 2
          OnClick = btnSMSNoEditClick
        end
        object Button7: TButton
          Left = 360
          Top = 160
          Width = 57
          Height = 25
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnSMSDeleteClick
        end
        object Button8: TButton
          Left = 360
          Top = 296
          Width = 57
          Height = 25
          Caption = '&Contacts'
          TabOrder = 4
          OnClick = btnSMSContactsClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRepFaxOpts'
        object Label66: TLabel
          Left = 16
          Top = 16
          Width = 111
          Height = 14
          Caption = 'Fax Report - Options'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label67: TLabel
          Left = 16
          Top = 40
          Width = 363
          Height = 14
          Caption = 
            'Please enter the details to be shown on the fax and the options ' +
            'for sending'
        end
        object GroupBox3: TGroupBox
          Left = 16
          Top = 64
          Width = 385
          Height = 81
          Caption = 'From...'
          TabOrder = 0
          object Label73: TLabel
            Left = 24
            Top = 24
            Width = 30
            Height = 14
            Caption = 'Name:'
          end
          object Label74: TLabel
            Left = 200
            Top = 24
            Width = 40
            Height = 14
            Caption = 'Number:'
          end
          object edtRepFaxName: TEdit
            Left = 24
            Top = 40
            Width = 134
            Height = 22
            TabOrder = 0
          end
          object edtRepFaxNo: TEdit
            Left = 200
            Top = 40
            Width = 134
            Height = 22
            TabOrder = 1
          end
        end
        object GroupBox4: TGroupBox
          Left = 16
          Top = 144
          Width = 385
          Height = 177
          TabOrder = 1
          object Label75: TLabel
            Left = 200
            Top = 24
            Width = 59
            Height = 14
            Caption = 'Cover page:'
          end
          object spFaxCover: TSpeedButton
            Left = 312
            Top = 40
            Width = 23
            Height = 22
            Caption = '...'
            OnClick = spFaxCoverClick
          end
          object Label76: TLabel
            Left = 24
            Top = 72
            Width = 25
            Height = 14
            Caption = 'Note:'
          end
          object Label77: TLabel
            Left = 24
            Top = 24
            Width = 33
            Height = 14
            Caption = 'Priority'
          end
          object edtFaxCover: TEdit
            Left = 200
            Top = 40
            Width = 113
            Height = 22
            Color = clBtnFace
            TabOrder = 0
          end
          object memFaxNote: TMemo
            Left = 24
            Top = 88
            Width = 345
            Height = 81
            TabOrder = 1
          end
          object cbFaxPriority: TComboBox
            Left = 24
            Top = 40
            Width = 137
            Height = 22
            ItemHeight = 14
            ItemIndex = 1
            TabOrder = 2
            Text = 'Normal'
            Items.Strings = (
              'Urgent'
              'Normal'
              'OffPeak')
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgCSVFolder'
        object Label72: TLabel
          Left = 16
          Top = 16
          Width = 88
          Height = 14
          Caption = 'Save CSV File to'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblCSVFolder: TLabel
          Left = 32
          Top = 80
          Width = 53
          Height = 14
          Caption = 'Sub-Folder'
        end
        object Label84: TLabel
          Left = 16
          Top = 40
          Width = 337
          Height = 25
          AutoSize = False
          Caption = 
            'Select a sub-folder of the Exchequer folder in which to save the' +
            ' file.'
          WordWrap = True
        end
        object lblEntFolder: TLabel
          Left = 32
          Top = 64
          Width = 88
          Height = 14
          Caption = 'Exchequer Folder:'
        end
        object tvFolder: TTreeView
          Left = 32
          Top = 96
          Width = 313
          Height = 225
          HideSelection = False
          Images = ImageList1
          Indent = 19
          ReadOnly = True
          TabOrder = 0
          OnCollapsed = tvFolderCollapsed
          OnExpanded = tvFolderExpanded
          OnKeyUp = tvFolderKeyUp
          OnMouseUp = tvFolderMouseUp
        end
        object Button10: TButton
          Left = 352
          Top = 96
          Width = 65
          Height = 25
          Caption = 'New &Folder'
          TabOrder = 1
          OnClick = Button10Click
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgNotify'
        object Label22: TLabel
          Left = 16
          Top = 16
          Width = 31
          Height = 14
          Caption = 'Notify'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label90: TLabel
          Left = 16
          Top = 40
          Width = 181
          Height = 14
          Caption = 'Notify the administrator if this Sentinel'
        end
        object Label91: TLabel
          Left = 34
          Top = 72
          Width = 71
          Height = 14
          Caption = 'Hasn'#39't finished'
        end
        object Label92: TLabel
          Left = 168
          Top = 72
          Width = 102
          Height = 14
          Caption = 'hours after it started.'
        end
        object Label93: TLabel
          Left = 34
          Top = 104
          Width = 336
          Height = 14
          Caption = 
            'Set the value to zero if you don'#39't ever want to notify the admin' +
            'istrator.'
        end
        object spNotifyHours: TSpinEdit
          Left = 112
          Top = 68
          Width = 49
          Height = 23
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pgRemote'
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 429
          Height = 335
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel5'
          TabOrder = 0
          object Label94: TLabel
            Left = 16
            Top = 16
            Width = 204
            Height = 14
            Caption = 'Remote triggering - email addresses'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label95: TLabel
            Left = 16
            Top = 32
            Width = 401
            Height = 33
            AutoSize = False
            Caption = 
              'This sentinel can only be remotely triggered by emails sent from' +
              ' the addresses below. Click the Add button to enter an email add' +
              'ress.'
            WordWrap = True
          end
          object Label96: TLabel
            Left = 16
            Top = 72
            Width = 57
            Height = 14
            Caption = 'Addresses:'
          end
          object lvRemoteAdd: TListView
            Left = 16
            Top = 88
            Width = 337
            Height = 233
            Columns = <
              item
                Width = 30
              end
              item
                Caption = 'Name'
                Width = 120
              end
              item
                Caption = 'Address'
                Width = 165
              end>
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = btnEmAddEditClick
            OnDeletion = lvEmailRecipInsert
            OnInsert = lvEmailRecipInsert
            OnKeyUp = lvEmailRecipKeyUp
          end
          object Button11: TButton
            Left = 360
            Top = 88
            Width = 57
            Height = 25
            HelpContext = 69
            Caption = '&Add'
            TabOrder = 1
            OnClick = btnEmailAddClick
          end
          object Button12: TButton
            Left = 360
            Top = 120
            Width = 57
            Height = 25
            HelpContext = 70
            Caption = '&Edit'
            TabOrder = 2
            OnClick = btnEmAddEditClick
          end
          object Button13: TButton
            Left = 360
            Top = 152
            Width = 57
            Height = 25
            HelpContext = 71
            Caption = '&Delete'
            TabOrder = 3
            OnClick = btnEmAddDeleteClick
          end
          object btnRemoteContacts: TButton
            Left = 360
            Top = 296
            Width = 57
            Height = 25
            HelpContext = 72
            Caption = 'Con&tacts'
            TabOrder = 4
            OnClick = btnContactsClick
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 168
    Height = 339
    BevelOuter = bvLowered
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 166
      Height = 337
      Align = alClient
      Stretch = True
    end
  end
  object btnNext: TButton
    Left = 543
    Top = 354
    Width = 73
    Height = 25
    HelpContext = 47
    Caption = '&Next  >>'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnNextClick
  end
  object btnPrev: TButton
    Left = 463
    Top = 354
    Width = 74
    Height = 25
    HelpContext = 46
    Caption = '<<  &Previous'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnPrevClick
  end
  object btnCancel: TButton
    Left = 383
    Top = 354
    Width = 73
    Height = 25
    HelpContext = 45
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
  end
  object btnSave: TButton
    Left = 303
    Top = 354
    Width = 73
    Height = 25
    HelpContext = 44
    Caption = '&Save'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'EFD'
    Filter = 'Exchequer forms (*.efx) |*.efx'
    Left = 8
    Top = 352
  end
  object ImageList1: TImageList
    Left = 184
    Top = 352
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008484840084848400848484008484840084848400C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C60084848400C6C6C600C6C6C600C6C6C600FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C60084848400C6C6C600C6C6C600FFFFFF00FFFFFF00C6C6C600FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600FFFFFF000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      84000084840000848400000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C600C6C6C600C6C6C6008484840000000000000000000000000000848400FFFF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600C6C6C600C6C6C600C6C6
      C60084848400008484000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00000000000000000000000000000000000000000000848400FFFFFF00FFFF
      FF0000FFFF00FFFFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600C6C6C60084848400000000000000000000848400FFFFFF0000FF
      FF00FFFFFF00C6C6C600FFFFFF00C6C6C60000FFFF00C6C6C600C6C6C600C6C6
      C6008484840000000000008484000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      000000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF000000000000000000000000000000000000848400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C60084848400000000000000000000848400FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00C6C6C60000FFFF00C6C6C600C6C6
      C60000848400000000000084840000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0000000000000000000000000000848400FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00848484000000000000848400FFFFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00C6C6C60000FFFF00FFFFFF00C6C6C60000FFFF008484
      84000000000084848400848484000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000FFFF00C6C6
      C60000FFFF00C6C6C600848484000000000000848400FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00C6C6C60000FFFF00C6C6C6008484
      840000000000848484008484840000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000848400FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0084848400000000000084840000848400008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      840084848400FFFFFF0084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000848400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000FFFF00C6C6C60084848400000000000000000000848400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0084848400000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000FFFF0084848400000000000000000000848400FFFFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000008484
      8400000000000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484008484
      8400848484008484840084848400848484008484840000848400008484000084
      8400008484000084840000848400000000000000000000848400FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000848400008484000084
      8400008484000084840000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000848400FFFF
      FF0000FFFF00FFFFFF0000FFFF0000FFFF000084840000000000000000000000
      000000000000000000000000000000000000000000000000000000848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000FFFF000000000000
      E007000000000000E007000000000000E007000000000000E007000000000000
      E007000000000000E007000000000000E007000000000000E007000000000000
      E007000000000000E007000000000000E00F000000000000E01F000000000000
      E03F000000000000FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFC000E000E007FFFF8000C000C007C00F8000C000C007800780008000
      C007800380008000C007800180000000C007800180000000C007800F80000000
      C00F800F80008000E07F801F80008000E07FC0FF80018001FFFFC0FFC03FC07F
      FFFFFFFFE07FE0FFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
