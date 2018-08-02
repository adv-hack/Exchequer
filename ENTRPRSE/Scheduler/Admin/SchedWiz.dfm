object frmTaskWizard: TfrmTaskWizard
  Left = 568
  Top = 154
  BorderStyle = bsDialog
  Caption = 'frmTaskWizard'
  ClientHeight = 303
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 439
    Height = 257
    ActivePage = tsDay
    TabIndex = 2
    TabOrder = 0
    OnChange = PageControl1Change
    object tsTask: TTabSheet
      Caption = 'Task'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 3
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        OnExit = edtTaskNameExit
        object Label1: TLabel
          Left = 24
          Top = 28
          Width = 54
          Height = 14
          Alignment = taRightJustify
          Caption = 'Task Type: '
        end
        object Label7: TLabel
          Left = 20
          Top = 68
          Width = 55
          Height = 14
          Alignment = taRightJustify
          Caption = 'Task Name:'
        end
        object edtTaskName: Text8Pt
          Left = 88
          Top = 64
          Width = 169
          Height = 22
          HelpContext = 3
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 50
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnExit = edtTaskNameExit
          TextId = 0
          ViaSBtn = False
        end
        object cbTaskType: TSBSComboBox
          Left = 88
          Top = 24
          Width = 169
          Height = 22
          HelpContext = 3
          Style = csDropDownList
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 0
          ParentFont = False
          TabOrder = 0
          OnChange = cbTaskTypeChange
          OnExit = cbTaskTypeExit
          MaxListWidth = 0
        end
      end
    end
    object tsDetails: TTabSheet
      Caption = 'Details'
      ImageIndex = 4
      object pnlView: TPanel
        Tag = 101
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 4
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        Visible = False
        object Label3: TLabel
          Left = 16
          Top = 28
          Width = 62
          Height = 14
          Alignment = taRightJustify
          Caption = 'Select View:'
        end
        object cbView: TSBSComboBox
          Left = 88
          Top = 24
          Width = 169
          Height = 22
          HelpContext = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 0
          ParentFont = False
          TabOrder = 0
          ExtendedList = True
          MaxListWidth = 0
        end
      end
      object pnlCustom: TPanel
        Tag = 101
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object Label10: TLabel
          Left = 24
          Top = 24
          Width = 385
          Height = 14
          Alignment = taCenter
          AutoSize = False
          Caption = 'This task has no detailed settings.'
        end
      end
      object pnlJobDaybook: TPanel
        Tag = 101
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        Align = alClient
        Caption = 'pnlJobDaybook'
        TabOrder = 2
        object SBSPanel4: TSBSBackGroup
          Left = 79
          Top = 32
          Width = 258
          Height = 147
          TextId = 0
        end
        object Label86: Label8
          Left = 92
          Top = 48
          Width = 221
          Height = 35
          AutoSize = False
          Caption = 'Job Posting...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -24
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
          TextId = 0
        end
        object chkCommitment: TBorCheck
          Left = 114
          Top = 82
          Width = 173
          Height = 20
          HelpContext = 1122
          Caption = 'Update commitment balances '
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 0
          TabStop = True
          TextId = 0
        end
        object chkActuals: TBorCheck
          Left = 90
          Top = 100
          Width = 197
          Height = 20
          HelpContext = 1122
          Caption = 'Post job details - update job actuals '
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 1
          TabStop = True
          TextId = 0
        end
        object chkTimesheets: TBorCheck
          Left = 114
          Top = 120
          Width = 173
          Height = 20
          HelpContext = 1123
          Caption = 'Post Timesheets '
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 2
          TabStop = True
          TextId = 0
        end
        object chkRetentions: TBorCheck
          Left = 114
          Top = 138
          Width = 173
          Height = 20
          HelpContext = 1124
          Caption = 'Check for expired retentions '
          Color = clBtnFace
          Checked = True
          ParentColor = False
          State = cbChecked
          TabOrder = 3
          TabStop = True
          TextId = 0
        end
        object chkJobProtectedMode: TBorCheck
          Left = 10
          Top = 192
          Width = 157
          Height = 20
          HelpContext = 9
          Caption = 'Use Protected Mode Posting'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
          TextId = 0
        end
        object chkJobSepPosting: TBorCheck
          Left = 244
          Top = 192
          Width = 173
          Height = 20
          HelpContext = 9
          Caption = 'Separate Posting Control entries'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
          TextId = 0
        end
      end
      object pnlDaybook: TPanel
        Tag = 101
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 9
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Label81: Label8
          Left = 14
          Top = 13
          Width = 152
          Height = 14
          HelpContext = 9
          Alignment = taCenter
          AutoSize = False
          Caption = 'Include in Posting'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object Label82: Label8
          Left = 265
          Top = 13
          Width = 152
          Height = 14
          HelpContext = 9
          Alignment = taCenter
          AutoSize = False
          Caption = 'Exclude from Posting'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object IncList: TListBox
          Left = 11
          Top = 30
          Width = 157
          Height = 153
          HelpContext = 9
          Color = clWhite
          DragMode = dmAutomatic
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MultiSelect = True
          ParentFont = False
          Sorted = True
          TabOrder = 0
          OnDblClick = Inc1Click
          OnDragDrop = IncListDragDrop
          OnDragOver = IncListDragOver
        end
        object chkPostProt: TBorCheck
          Left = 10
          Top = 192
          Width = 157
          Height = 20
          HelpContext = 9
          Caption = 'Use Protected Mode Posting'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TextId = 0
        end
        object chkPostSep: TBorCheck
          Left = 244
          Top = 192
          Width = 173
          Height = 20
          HelpContext = 9
          Caption = 'Separate Posting Control entries'
          CheckColor = clWindowText
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TextId = 0
        end
        object ExcList: TListBox
          Left = 260
          Top = 30
          Width = 157
          Height = 153
          HelpContext = 9
          Color = clWhite
          DragMode = dmAutomatic
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          MultiSelect = True
          ParentFont = False
          Sorted = True
          TabOrder = 3
          OnDblClick = Exc1Click
          OnDragDrop = ExcListDragDrop
          OnDragOver = IncListDragOver
        end
        object Inc1: TButton
          Left = 177
          Top = 48
          Width = 75
          Height = 21
          HelpContext = 9
          Caption = '>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Inc1Click
        end
        object IncAll: TButton
          Left = 177
          Top = 77
          Width = 75
          Height = 21
          HelpContext = 9
          Caption = '>>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = Inc1Click
        end
        object Exc1: TButton
          Left = 177
          Top = 106
          Width = 75
          Height = 21
          HelpContext = 9
          Caption = '<'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = Exc1Click
        end
        object ExcAll: TButton
          Left = 177
          Top = 136
          Width = 75
          Height = 21
          HelpContext = 9
          Caption = '<<'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = Exc1Click
        end
      end
    end
    object tsDay: TTabSheet
      Caption = 'Day'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 5
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object lblDay: TLabel
          Left = 28
          Top = 24
          Width = 218
          Height = 14
          Caption = 'Perform this task on the following days each '
        end
        object grpMonth: TGroupBox
          Left = 28
          Top = 56
          Width = 305
          Height = 153
          HelpContext = 5
          Caption = 'Days'
          TabOrder = 1
          OnEnter = grpMonthEnter
          object chkFirstOfMonth: TBorCheck
            Tag = 1
            Left = 16
            Top = 24
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 1'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck5: TBorCheck
            Tag = 2
            Left = 54
            Top = 24
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 2'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 1
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck6: TBorCheck
            Tag = 3
            Left = 93
            Top = 24
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 3'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 2
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck7: TBorCheck
            Tag = 4
            Left = 132
            Top = 24
            Width = 25
            Height = 20
            Align = alRight
            Caption = ' 4'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 3
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck8: TBorCheck
            Tag = 5
            Left = 170
            Top = 24
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 5'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 4
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck9: TBorCheck
            Tag = 6
            Left = 209
            Top = 24
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 6'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 5
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck10: TBorCheck
            Tag = 7
            Left = 248
            Top = 24
            Width = 41
            Height = 20
            Align = alRight
            Caption = ' 7'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 6
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck11: TBorCheck
            Tag = 8
            Left = 16
            Top = 48
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 8'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 7
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck12: TBorCheck
            Tag = 9
            Left = 54
            Top = 48
            Width = 33
            Height = 20
            Align = alRight
            Caption = ' 9'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 8
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck13: TBorCheck
            Tag = 10
            Left = 93
            Top = 48
            Width = 33
            Height = 20
            Align = alRight
            Caption = '10'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 9
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck14: TBorCheck
            Tag = 11
            Left = 132
            Top = 48
            Width = 37
            Height = 20
            Align = alRight
            Caption = '11'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 10
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck15: TBorCheck
            Tag = 12
            Left = 170
            Top = 48
            Width = 33
            Height = 20
            Align = alRight
            Caption = '12'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 11
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck16: TBorCheck
            Tag = 13
            Left = 209
            Top = 48
            Width = 33
            Height = 20
            Align = alRight
            Caption = '13'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 12
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck17: TBorCheck
            Tag = 14
            Left = 248
            Top = 48
            Width = 41
            Height = 20
            Align = alRight
            Caption = '14'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 13
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck18: TBorCheck
            Tag = 15
            Left = 16
            Top = 72
            Width = 33
            Height = 20
            Align = alRight
            Caption = '15'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 14
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck19: TBorCheck
            Tag = 16
            Left = 54
            Top = 72
            Width = 33
            Height = 20
            Align = alRight
            Caption = '16'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 15
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck20: TBorCheck
            Tag = 17
            Left = 93
            Top = 72
            Width = 33
            Height = 20
            Align = alRight
            Caption = '17'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 16
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck21: TBorCheck
            Tag = 18
            Left = 132
            Top = 72
            Width = 37
            Height = 20
            Align = alRight
            Caption = '18'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 17
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck22: TBorCheck
            Tag = 19
            Left = 170
            Top = 72
            Width = 33
            Height = 20
            Align = alRight
            Caption = '19'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 18
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck23: TBorCheck
            Tag = 20
            Left = 209
            Top = 72
            Width = 33
            Height = 20
            Align = alRight
            Caption = '20'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 19
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck24: TBorCheck
            Tag = 21
            Left = 248
            Top = 72
            Width = 41
            Height = 20
            Align = alRight
            Caption = '21'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 20
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck25: TBorCheck
            Tag = 22
            Left = 16
            Top = 96
            Width = 33
            Height = 20
            Align = alRight
            Caption = '22'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 21
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck26: TBorCheck
            Tag = 23
            Left = 54
            Top = 96
            Width = 33
            Height = 20
            Align = alRight
            Caption = '23'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 22
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck27: TBorCheck
            Tag = 24
            Left = 93
            Top = 96
            Width = 33
            Height = 20
            Align = alRight
            Caption = '24'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 23
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck28: TBorCheck
            Tag = 25
            Left = 132
            Top = 96
            Width = 37
            Height = 20
            Align = alRight
            Caption = '25'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 24
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck29: TBorCheck
            Tag = 26
            Left = 170
            Top = 96
            Width = 33
            Height = 20
            Align = alRight
            Caption = '26'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 25
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck30: TBorCheck
            Tag = 27
            Left = 209
            Top = 96
            Width = 33
            Height = 20
            Align = alRight
            Caption = '27'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 26
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck31: TBorCheck
            Tag = 28
            Left = 248
            Top = 96
            Width = 41
            Height = 20
            Align = alRight
            Caption = '28'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 27
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck32: TBorCheck
            Tag = 29
            Left = 16
            Top = 120
            Width = 33
            Height = 20
            Align = alRight
            Caption = '29'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 28
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck33: TBorCheck
            Tag = 30
            Left = 54
            Top = 120
            Width = 33
            Height = 20
            Align = alRight
            Caption = '30'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 29
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck34: TBorCheck
            Tag = 31
            Left = 93
            Top = 120
            Width = 33
            Height = 20
            Align = alRight
            Caption = '31'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 30
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
          object BorCheck1: TBorCheck
            Tag = 31
            Left = 132
            Top = 120
            Width = 137
            Height = 20
            Align = alRight
            Caption = 'Last day of the month'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 31
            TabStop = True
            TextId = 0
            OnClick = chkFirstOfMonthClick
          end
        end
        object grpWeek: TGroupBox
          Left = 28
          Top = 56
          Width = 305
          Height = 137
          HelpContext = 5
          Caption = 'Days'
          TabOrder = 2
          OnEnter = grpWeekEnter
          object chkMonday: TBorCheck
            Left = 40
            Top = 24
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Monday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 0
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkTuesday: TBorCheck
            Left = 40
            Top = 48
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Tuesday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 1
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkWednesday: TBorCheck
            Left = 40
            Top = 72
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Wednesday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 2
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkThursday: TBorCheck
            Left = 40
            Top = 96
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Thursday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 3
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkFriday: TBorCheck
            Left = 159
            Top = 24
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Friday'
            Color = clBtnFace
            Checked = True
            ParentColor = False
            State = cbChecked
            TabOrder = 4
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkSaturday: TBorCheck
            Left = 159
            Top = 48
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Saturday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 5
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
          object chkSunday: TBorCheck
            Left = 159
            Top = 72
            Width = 98
            Height = 20
            Align = alRight
            Caption = 'Sunday'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 6
            TabStop = True
            TextId = 0
            OnClick = chkMondayClick
          end
        end
        object cbWeekMonth: TSBSComboBox
          Left = 252
          Top = 20
          Width = 81
          Height = 22
          HelpContext = 5
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ItemIndex = 0
          ParentFont = False
          TabOrder = 0
          Text = 'Week'
          OnChange = cbWeekMonthChange
          Items.Strings = (
            'Week'
            'Month')
          MaxListWidth = 0
        end
        object pnlOneOff: TPanel
          Left = 2
          Top = 2
          Width = 427
          Height = 224
          Align = alClient
          Enabled = False
          TabOrder = 3
          Visible = False
          object Bevel1: TBevel
            Left = 17
            Top = 72
            Width = 185
            Height = 105
            Shape = bsFrame
          end
          object pnlDateTime: TPanel
            Left = 32
            Top = 88
            Width = 145
            Height = 73
            BevelOuter = bvNone
            TabOrder = 2
            object Label4: TLabel
              Left = 15
              Top = 12
              Width = 22
              Height = 14
              Alignment = taRightJustify
              Caption = 'Date'
            end
            object Label12: TLabel
              Left = 15
              Top = 44
              Width = 22
              Height = 14
              Alignment = taRightJustify
              Caption = 'Time'
            end
            object dtOneOffDate: TDateTimePicker
              Left = 48
              Top = 8
              Width = 81
              Height = 22
              CalAlignment = dtaLeft
              CalColors.TextColor = clNavy
              Date = 40631.4378489005
              Time = 40631.4378489005
              Color = clWhite
              DateFormat = dfShort
              DateMode = dmComboBox
              Font.Charset = ANSI_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Kind = dtkDate
              ParseInput = False
              ParentFont = False
              TabOrder = 0
            end
            object dtOneOffTime: TDateTimePicker
              Left = 48
              Top = 40
              Width = 81
              Height = 22
              CalAlignment = dtaLeft
              CalColors.TextColor = clNavy
              Date = 40631.4370403241
              Time = 40631.4370403241
              Color = clWhite
              DateFormat = dfShort
              DateMode = dmComboBox
              Font.Charset = ANSI_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              Kind = dtkTime
              ParseInput = False
              ParentFont = False
              TabOrder = 1
            end
          end
          object rbPostNow: TBorRadio
            Left = 33
            Top = 32
            Width = 98
            Height = 20
            Align = alRight
            Caption = ' Run post now'
            CheckColor = clWindowText
            TabOrder = 0
            TextId = 0
            OnClick = rbPostNowClick
          end
          object rbPostSchedule: TBorRadio
            Left = 33
            Top = 61
            Width = 110
            Height = 20
            Align = alRight
            Caption = ' Schedule post for   '
            CheckColor = clWindowText
            TabOrder = 1
            TextId = 0
            OnClick = rbPostScheduleClick
          end
        end
      end
    end
    object tsTime: TTabSheet
      Caption = 'Time'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 6
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label6: TLabel
          Left = 36
          Top = 24
          Width = 194
          Height = 14
          Caption = 'Perform this task at the following time(s)'
        end
        object Label46: TLabel
          Left = 138
          Top = 60
          Width = 22
          Height = 14
          HelpContext = 6
          Caption = 'Mins'
        end
        object Label28: TLabel
          Left = 134
          Top = 107
          Width = 71
          Height = 14
          HelpContext = 6
          Caption = 'Mins, between'
        end
        object Label29: TLabel
          Left = 202
          Top = 131
          Width = 18
          Height = 14
          HelpContext = 6
          Caption = 'and'
        end
        object Label2: TLabel
          Left = 58
          Top = 60
          Width = 28
          Height = 14
          HelpContext = 6
          Caption = 'Every'
        end
        object Label8: TLabel
          Left = 58
          Top = 107
          Width = 28
          Height = 14
          HelpContext = 6
          Caption = 'Every'
        end
        object Label9: TLabel
          Left = 60
          Top = 164
          Width = 64
          Height = 14
          HelpContext = 6
          Caption = 'Specific Time'
        end
        object dtBetweenStart: TDateTimePicker
          Left = 224
          Top = 103
          Width = 81
          Height = 22
          HelpContext = 6
          CalAlignment = dtaLeft
          CalColors.TextColor = clNavy
          Date = 36678.375
          Format = 'HH:mm'
          Time = 36678.375
          Color = clWhite
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 3
          OnChange = chkMondayClick
        end
        object dtBetweenEnd: TDateTimePicker
          Left = 224
          Top = 127
          Width = 81
          Height = 22
          HelpContext = 6
          CalAlignment = dtaLeft
          CalColors.TextColor = clNavy
          Date = 36678.7291666667
          Format = 'HH:mm'
          Time = 36678.7291666667
          Color = clWhite
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 4
          OnChange = chkMondayClick
        end
        object dtSpecific: TDateTimePicker
          Left = 136
          Top = 160
          Width = 81
          Height = 22
          HelpContext = 6
          CalAlignment = dtaLeft
          CalColors.TextColor = clNavy
          Date = 36678.5
          Format = 'HH:mm'
          Time = 36678.5
          Color = clWhite
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 5
          OnChange = chkMondayClick
          OnExit = dtSpecificExit
        end
        object ceMins: TCurrencyEdit
          Left = 92
          Top = 56
          Width = 34
          Height = 22
          HelpContext = 6
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '30')
          ParentFont = False
          TabOrder = 1
          WantReturns = False
          WordWrap = False
          OnChange = chkMondayClick
          OnExit = ceMinsExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###0'
          ShowCurrency = False
          TextId = 0
          Value = 30
        end
        object ceMinsBetween: TCurrencyEdit
          Left = 92
          Top = 103
          Width = 34
          Height = 22
          HelpContext = 6
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '30')
          ParentFont = False
          TabOrder = 2
          WantReturns = False
          WordWrap = False
          OnChange = chkMondayClick
          OnExit = ceMinsExit
          AutoSize = False
          BlockNegative = False
          BlankOnZero = False
          DisplayFormat = '###0'
          ShowCurrency = False
          TextId = 0
          Value = 30
        end
        object Panel5: TPanel
          Left = 15
          Top = 48
          Width = 37
          Height = 153
          BevelOuter = bvNone
          TabOrder = 0
          object rbMins: TRadioButton
            Left = 21
            Top = 11
            Width = 14
            Height = 17
            HelpContext = 6
            Caption = 'rbMins'
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbMinsClick
          end
          object rbMinsBetween: TRadioButton
            Left = 21
            Top = 59
            Width = 14
            Height = 17
            HelpContext = 6
            Caption = 'rbMinsBetween'
            TabOrder = 1
            OnClick = rbMinsClick
          end
          object rbSpecific: TRadioButton
            Left = 21
            Top = 115
            Width = 14
            Height = 17
            HelpContext = 6
            Caption = 'Specific Time :'
            TabOrder = 2
            OnClick = rbMinsClick
          end
        end
      end
    end
    object tsEmail: TTabSheet
      Caption = 'Email'
      ImageIndex = 3
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 431
        Height = 228
        HelpContext = 7
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label5: TLabel
          Left = 56
          Top = 24
          Width = 265
          Height = 49
          HelpContext = 7
          AutoSize = False
          Caption = 
            'Scheduler will use this email address for all posting reports an' +
            'd any exception reports generated by this task.'
          WordWrap = True
        end
        object Label11: TLabel
          Left = 56
          Top = 72
          Width = 257
          Height = 33
          AutoSize = False
          Caption = 
            'If the email address is left blank then the output will be redir' +
            'ected to this company'#39's Reports folder.'
          WordWrap = True
        end
        object edtEmail: Text8Pt
          Left = 56
          Top = 112
          Width = 265
          Height = 22
          HelpContext = 7
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
      end
    end
  end
  object btnNext: TSBSButton
    Left = 230
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Next'
    TabOrder = 1
    OnClick = btnNextClick
    OnExit = btnNextExit
    TextId = 0
  end
  object btnBack: TSBSButton
    Left = 142
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Back'
    TabOrder = 4
    OnClick = btnBackClick
    TextId = 0
  end
  object btnSave: TSBSButton
    Left = 318
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Finish'
    ModalResult = 1
    TabOrder = 2
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 54
    Top = 272
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 3
    OnExit = btnCancelExit
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Top = 272
  end
end
