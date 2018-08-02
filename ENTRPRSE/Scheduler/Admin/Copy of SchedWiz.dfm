object frmTaskWizard: TfrmTaskWizard
  Left = 238
  Top = 244
  BorderStyle = bsDialog
  Caption = 'frmTaskWizard'
  ClientHeight = 303
  ClientWidth = 392
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 377
    Height = 257
    ActivePage = tsTask
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tsTask: TTabSheet
      Caption = 'Task'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 228
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label1: TLabel
          Left = 38
          Top = 24
          Width = 56
          Height = 14
          Alignment = taRightJustify
          Caption = 'Task Type: '
        end
        object Label2: TLabel
          Left = 112
          Top = 24
          Width = 80
          Height = 14
          Caption = 'Update GL View'
        end
        object Label3: TLabel
          Left = 32
          Top = 88
          Width = 62
          Height = 14
          Alignment = taRightJustify
          Caption = 'Select View:'
        end
        object Label7: TLabel
          Left = 41
          Top = 56
          Width = 53
          Height = 14
          Alignment = taRightJustify
          Caption = 'Task Name'
        end
        object cbView: TSBSComboBox
          Left = 112
          Top = 88
          Width = 169
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 14
          ParentFont = False
          TabOrder = 1
          ExtendedList = True
          MaxListWidth = 0
        end
        object edtTaskName: Text8Pt
          Left = 112
          Top = 52
          Width = 121
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnExit = edtTaskNameExit
          TextId = 0
          ViaSBtn = False
        end
      end
    end
    object tsDay: TTabSheet
      Caption = 'Day'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 228
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label4: TLabel
          Left = 32
          Top = 24
          Width = 218
          Height = 14
          Caption = 'Perform this task on the following days each '
        end
        object grpMonth: TGroupBox
          Left = 32
          Top = 56
          Width = 305
          Height = 153
          Caption = 'Days'
          TabOrder = 2
          object CheckBox1: TCheckBox
            Tag = 1
            Left = 16
            Top = 24
            Width = 33
            Height = 17
            Caption = '1'
            TabOrder = 0
          end
          object CheckBox2: TCheckBox
            Tag = 2
            Left = 56
            Top = 24
            Width = 41
            Height = 17
            Caption = '2'
            TabOrder = 1
          end
          object CheckBox3: TCheckBox
            Tag = 3
            Left = 96
            Top = 24
            Width = 33
            Height = 17
            Caption = '3'
            TabOrder = 2
          end
          object CheckBox4: TCheckBox
            Tag = 4
            Left = 136
            Top = 24
            Width = 41
            Height = 17
            Caption = '4'
            TabOrder = 3
          end
          object CheckBox5: TCheckBox
            Tag = 5
            Left = 176
            Top = 24
            Width = 33
            Height = 17
            Caption = '5'
            TabOrder = 4
          end
          object CheckBox6: TCheckBox
            Tag = 6
            Left = 216
            Top = 24
            Width = 33
            Height = 17
            Caption = '6'
            TabOrder = 5
          end
          object CheckBox7: TCheckBox
            Tag = 7
            Left = 256
            Top = 24
            Width = 33
            Height = 17
            Caption = '7'
            TabOrder = 6
          end
          object CheckBox8: TCheckBox
            Tag = 8
            Left = 16
            Top = 48
            Width = 33
            Height = 17
            Caption = '8'
            TabOrder = 7
          end
          object CheckBox9: TCheckBox
            Tag = 9
            Left = 56
            Top = 48
            Width = 41
            Height = 17
            Caption = '9'
            TabOrder = 8
          end
          object CheckBox10: TCheckBox
            Tag = 10
            Left = 96
            Top = 48
            Width = 33
            Height = 17
            Caption = '10'
            TabOrder = 9
          end
          object CheckBox11: TCheckBox
            Tag = 11
            Left = 136
            Top = 48
            Width = 41
            Height = 17
            Caption = '11'
            TabOrder = 10
          end
          object CheckBox12: TCheckBox
            Tag = 12
            Left = 176
            Top = 48
            Width = 33
            Height = 17
            Caption = '12'
            TabOrder = 11
          end
          object CheckBox13: TCheckBox
            Tag = 13
            Left = 216
            Top = 48
            Width = 33
            Height = 17
            Caption = '13'
            TabOrder = 12
          end
          object CheckBox14: TCheckBox
            Tag = 14
            Left = 256
            Top = 48
            Width = 33
            Height = 17
            Caption = '14'
            TabOrder = 13
          end
          object CheckBox22: TCheckBox
            Tag = 22
            Left = 16
            Top = 96
            Width = 33
            Height = 17
            Caption = '22'
            TabOrder = 21
          end
          object CheckBox23: TCheckBox
            Tag = 23
            Left = 56
            Top = 96
            Width = 41
            Height = 17
            Caption = '23'
            TabOrder = 22
          end
          object CheckBox24: TCheckBox
            Tag = 24
            Left = 96
            Top = 96
            Width = 33
            Height = 17
            Caption = '24'
            TabOrder = 23
          end
          object CheckBox25: TCheckBox
            Tag = 25
            Left = 136
            Top = 96
            Width = 41
            Height = 17
            Caption = '25'
            TabOrder = 24
          end
          object CheckBox26: TCheckBox
            Tag = 26
            Left = 176
            Top = 96
            Width = 33
            Height = 17
            Caption = '26'
            TabOrder = 25
          end
          object CheckBox27: TCheckBox
            Tag = 27
            Left = 216
            Top = 96
            Width = 33
            Height = 17
            Caption = '27'
            TabOrder = 26
          end
          object CheckBox28: TCheckBox
            Tag = 28
            Left = 256
            Top = 96
            Width = 33
            Height = 17
            Caption = '28'
            TabOrder = 27
          end
          object CheckBox29: TCheckBox
            Tag = 29
            Left = 16
            Top = 120
            Width = 33
            Height = 17
            Caption = '29'
            TabOrder = 28
          end
          object chkLast: TCheckBox
            Tag = 32
            Left = 136
            Top = 120
            Width = 145
            Height = 17
            Caption = ' Last day of the month'
            TabOrder = 31
            Visible = False
          end
          object CheckBox15: TCheckBox
            Tag = 15
            Left = 16
            Top = 72
            Width = 33
            Height = 17
            Caption = '15'
            TabOrder = 14
          end
          object CheckBox16: TCheckBox
            Tag = 16
            Left = 56
            Top = 72
            Width = 41
            Height = 17
            Caption = '16'
            TabOrder = 15
          end
          object CheckBox17: TCheckBox
            Tag = 17
            Left = 96
            Top = 72
            Width = 33
            Height = 17
            Caption = '17'
            TabOrder = 16
          end
          object CheckBox18: TCheckBox
            Tag = 18
            Left = 136
            Top = 72
            Width = 41
            Height = 17
            Caption = '18'
            TabOrder = 17
          end
          object CheckBox19: TCheckBox
            Tag = 19
            Left = 176
            Top = 72
            Width = 33
            Height = 17
            Caption = '19'
            TabOrder = 18
          end
          object CheckBox20: TCheckBox
            Tag = 20
            Left = 216
            Top = 72
            Width = 33
            Height = 17
            Caption = '20'
            TabOrder = 19
          end
          object CheckBox21: TCheckBox
            Tag = 21
            Left = 256
            Top = 72
            Width = 33
            Height = 17
            Caption = '21'
            TabOrder = 20
          end
          object CheckBox31: TCheckBox
            Tag = 30
            Left = 56
            Top = 120
            Width = 33
            Height = 17
            Caption = '30'
            TabOrder = 29
          end
          object CheckBox32: TCheckBox
            Tag = 31
            Left = 96
            Top = 120
            Width = 33
            Height = 17
            Caption = '31'
            TabOrder = 30
          end
        end
        object cbWeekMonth: TSBSComboBox
          Left = 256
          Top = 20
          Width = 81
          Height = 22
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
        object grpWeek: TGroupBox
          Left = 32
          Top = 56
          Width = 305
          Height = 129
          Caption = 'Days'
          TabOrder = 1
          object chkMonday: TCheckBox
            Left = 40
            Top = 24
            Width = 81
            Height = 17
            Caption = 'Monday'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = chkMondayClick
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
            OnClick = chkMondayClick
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
      end
    end
    object tsTime: TTabSheet
      Caption = 'Time'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 228
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label6: TLabel
          Left = 32
          Top = 24
          Width = 194
          Height = 14
          Caption = 'Perform this task at the following time(s)'
        end
        object Label46: TLabel
          Left = 134
          Top = 60
          Width = 37
          Height = 14
          Caption = 'Minutes'
        end
        object Label28: TLabel
          Left = 134
          Top = 100
          Width = 86
          Height = 14
          Caption = 'Minutes, between'
        end
        object Label29: TLabel
          Left = 202
          Top = 124
          Width = 18
          Height = 14
          Caption = 'and'
        end
        object rbMins: TRadioButton
          Left = 48
          Top = 59
          Width = 49
          Height = 17
          Caption = 'Every'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbMinsClick
        end
        object rbMinsBetween: TRadioButton
          Left = 48
          Top = 99
          Width = 49
          Height = 17
          Caption = 'Every'
          TabOrder = 1
          OnClick = rbMinsClick
        end
        object dtBetweenStart: TDateTimePicker
          Left = 224
          Top = 96
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
          TabOrder = 2
          OnChange = chkMondayClick
        end
        object dtBetweenEnd: TDateTimePicker
          Left = 224
          Top = 120
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
          TabOrder = 3
          OnChange = chkMondayClick
        end
        object dtSpecific: TDateTimePicker
          Left = 144
          Top = 160
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
          TabOrder = 4
          OnChange = chkMondayClick
        end
        object rbSpecific: TRadioButton
          Left = 48
          Top = 163
          Width = 89
          Height = 17
          Caption = 'Specific Time :'
          TabOrder = 5
          OnClick = rbMinsClick
        end
        object ceMins: TCurrencyEdit
          Left = 96
          Top = 56
          Width = 34
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '60')
          ParentFont = False
          TabOrder = 6
          WantReturns = False
          WordWrap = False
          OnChange = chkMondayClick
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###0'
          ShowCurrency = False
          TextId = 0
          Value = 60
        end
        object ceMinsBetween: TCurrencyEdit
          Left = 96
          Top = 96
          Width = 34
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'ARIAL'
          Font.Style = []
          Lines.Strings = (
            '60')
          ParentFont = False
          TabOrder = 7
          WantReturns = False
          WordWrap = False
          OnChange = chkMondayClick
          AutoSize = False
          BlankOnZero = False
          DisplayFormat = '###0'
          ShowCurrency = False
          TextId = 0
          Value = 60
        end
      end
    end
    object tsEmail: TTabSheet
      Caption = 'Email'
      ImageIndex = 3
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 369
        Height = 228
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label5: TLabel
          Left = 32
          Top = 24
          Width = 286
          Height = 33
          AutoSize = False
          Caption = 
            'If the scheduled task encounters an error, send a notification e' +
            'mail to this address.'
          WordWrap = True
        end
        object edtEmail: Text8Pt
          Left = 32
          Top = 64
          Width = 265
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TextId = 0
          ViaSBtn = False
        end
        object BorCheck1: TBorCheck
          Left = 64
          Top = 104
          Width = 98
          Height = 20
          Caption = 'BorCheck1'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          TabStop = True
          TextId = 0
        end
        object BorCheck2: TBorCheck
          Left = 64
          Top = 128
          Width = 98
          Height = 20
          Caption = 'BorCheck2'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
          TabStop = True
          TextId = 0
        end
        object BorCheck3: TBorCheck
          Left = 64
          Top = 160
          Width = 98
          Height = 20
          Caption = 'BorCheck3'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
          TabStop = True
          TextId = 0
        end
      end
    end
  end
  object btnNext: TSBSButton
    Left = 304
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Next'
    TabOrder = 1
    OnClick = btnNextClick
    TextId = 0
  end
  object btnBack: TSBSButton
    Left = 216
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Back'
    TabOrder = 2
    OnClick = btnBackClick
    TextId = 0
  end
  object btnSave: TSBSButton
    Left = 128
    Top = 272
    Width = 80
    Height = 21
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 3
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 40
    Top = 272
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
    TextId = 0
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 8
    Top = 272
  end
end
