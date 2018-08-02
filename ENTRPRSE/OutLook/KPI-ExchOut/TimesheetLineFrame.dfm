object FrameTimesheetLine: TFrameTimesheetLine
  Left = 0
  Top = 0
  Width = 833
  Height = 178
  TabOrder = 0
  object gbTransactionLine: TGroupBox
    Left = 0
    Top = 0
    Width = 833
    Height = 177
    Caption = ' The Royal Bath Hotel / General Rate / Electrical Engineer '
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object lblRateCode: TLabel
      Left = 68
      Top = 21
      Width = 194
      Height = 14
      Caption = 'No rates set for this job / employee'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblNarrative: TLabel
      Left = 274
      Top = 21
      Width = 95
      Height = 14
      Caption = 'Narrative / CC / Dep'
      Transparent = True
    end
    object lblRateAnalysisCodes: TLabel
      Left = 154
      Top = 21
      Width = 106
      Height = 14
      Caption = 'Rate / Analysis Codes'
      Transparent = True
    end
    object lblJobCode: TLabel
      Left = 10
      Top = 21
      Width = 45
      Height = 14
      Caption = 'Job Code'
      Transparent = True
    end
    object lblDay1: TLabel
      Left = 458
      Top = 24
      Width = 20
      Height = 14
      Caption = 'Mon'
    end
    object lblDay2: TLabel
      Left = 499
      Top = 24
      Width = 18
      Height = 14
      Caption = 'Tue'
    end
    object lblDay3: TLabel
      Left = 538
      Top = 24
      Width = 22
      Height = 14
      Caption = 'Wed'
    end
    object lblDay4: TLabel
      Left = 578
      Top = 24
      Width = 18
      Height = 14
      Caption = 'Thu'
    end
    object lblDay5: TLabel
      Left = 622
      Top = 24
      Width = 12
      Height = 14
      Caption = 'Fri'
    end
    object lblDay6: TLabel
      Left = 660
      Top = 24
      Width = 16
      Height = 14
      Caption = 'Sat'
    end
    object lblDay7: TLabel
      Left = 698
      Top = 24
      Width = 19
      Height = 14
      Caption = 'Sun'
    end
    object lblDate1: TLabel
      Left = 450
      Top = 11
      Width = 35
      Height = 14
      Caption = '(27/10)'
      Visible = False
    end
    object lblDate2: TLabel
      Left = 490
      Top = 11
      Width = 35
      Height = 14
      Caption = '(28/10)'
      Visible = False
    end
    object lblDate3: TLabel
      Left = 530
      Top = 11
      Width = 35
      Height = 14
      Caption = '(29/10)'
      Visible = False
    end
    object lblDate4: TLabel
      Left = 570
      Top = 11
      Width = 35
      Height = 14
      Caption = '(30/10)'
      Visible = False
    end
    object lblDate5: TLabel
      Left = 610
      Top = 11
      Width = 35
      Height = 14
      Caption = '(31/10)'
      Visible = False
    end
    object lblDate6: TLabel
      Left = 650
      Top = 11
      Width = 34
      Height = 14
      Caption = '(01/11)'
      Visible = False
    end
    object lblDate7: TLabel
      Left = 690
      Top = 11
      Width = 34
      Height = 14
      Caption = '(02/11)'
      Visible = False
    end
    object lblHrsQty: TLabel
      Left = 766
      Top = 24
      Width = 54
      Height = 14
      Caption = 'Total Hours'
    end
    object xlblChargeOutCurrency: TLabel
      Left = 636
      Top = 75
      Width = 27
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = #163
      Visible = False
    end
    object xlblCostHourCurrency: TLabel
      Left = 636
      Top = 107
      Width = 27
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = #163
      Visible = False
    end
    object lblChargeOutRate: TLabel
      Left = 573
      Top = 75
      Width = 79
      Height = 14
      Caption = 'Charge-out Rate'
    end
    object lblCostHour: TLabel
      Left = 598
      Top = 107
      Width = 54
      Height = 14
      Caption = 'Cost / Hour'
    end
    object lblTLUDF1: TLabel
      Left = 12
      Top = 94
      Width = 72
      Height = 14
      Caption = 'User-defined 1'
    end
    object lblTLUDF2: TLabel
      Left = 157
      Top = 94
      Width = 72
      Height = 14
      Caption = 'User-defined 2'
    end
    object lblTLUDF7: TLabel
      Left = 12
      Top = 134
      Width = 72
      Height = 14
      Caption = 'User-defined 7'
    end
    object lblTLUDF8: TLabel
      Left = 157
      Top = 134
      Width = 72
      Height = 14
      Caption = 'User-defined 8'
    end
    object lblTLUDF9: TLabel
      Left = 302
      Top = 134
      Width = 72
      Height = 14
      Caption = 'User-defined 9'
    end
    object lblTLUDF10: TLabel
      Left = 447
      Top = 134
      Width = 78
      Height = 14
      Caption = 'User-defined 10'
    end
    object lblTLUDF5: TLabel
      Left = 302
      Top = 94
      Width = 72
      Height = 14
      Caption = 'User-defined 5'
    end
    object lblTLUDF6: TLabel
      Left = 447
      Top = 94
      Width = 72
      Height = 14
      Caption = 'User-defined 6'
    end
    object ccbCostCentre: TColumnComboBox
      Left = 272
      Top = 65
      Width = 65
      Height = 22
      Color = 16445929
      Version = '1.3.1.1'
      Visible = True
      Columns = <
        item
          Color = clCream
          ColumnType = ctText
          Width = 100
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 0
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end>
      ComboItems = <>
      EditColumn = -1
      EditHeight = 16
      DropWidth = 0
      DropHeight = 200
      Enabled = True
      Flat = True
      GridLines = False
      ItemIndex = -1
      LookupColumn = 0
      SortColumn = 0
      TabOrder = 4
      OnChange = ccbCostCentreChange
    end
    object ccbDepartment: TColumnComboBox
      Left = 345
      Top = 65
      Width = 65
      Height = 22
      Color = 16445929
      Version = '1.3.1.1'
      Visible = True
      Columns = <
        item
          Color = clCream
          ColumnType = ctText
          Width = 100
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 0
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end>
      ComboItems = <>
      EditColumn = -1
      EditHeight = 16
      DropWidth = 0
      DropHeight = 200
      Enabled = True
      Flat = True
      GridLines = False
      ItemIndex = -1
      LookupColumn = 0
      SortColumn = 0
      TabOrder = 5
      OnChange = ccbDepartmentChange
    end
    object edtNarrative: TAdvEdit
      Tag = 1
      Left = 272
      Top = 38
      Width = 160
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      Visible = True
      OnChange = edtNarrativeChange
      Version = '2.7.4.1'
    end
    object ccbRateCode: TColumnComboBox
      Left = 152
      Top = 38
      Width = 113
      Height = 22
      Color = 16445929
      Version = '1.3.1.1'
      Visible = True
      Columns = <
        item
          Color = clCream
          ColumnType = ctText
          Width = 120
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 0
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 100
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end>
      ComboItems = <>
      EditColumn = -1
      EditHeight = 16
      DropWidth = 0
      DropHeight = 200
      Enabled = True
      Flat = True
      GridLines = False
      ItemIndex = -1
      LookupColumn = 0
      SortColumn = 0
      TabOrder = 1
      OnChange = ccbRateCodeChange
    end
    object ccbAnalysisCode: TColumnComboBox
      Left = 152
      Top = 65
      Width = 113
      Height = 22
      Color = 16445929
      Version = '1.3.1.1'
      Visible = True
      Columns = <
        item
          Color = clCream
          ColumnType = ctText
          Width = 120
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 0
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end>
      ComboItems = <>
      EditColumn = -1
      EditHeight = 16
      DropWidth = 0
      DropHeight = 200
      Enabled = True
      Flat = True
      GridLines = False
      ItemIndex = -1
      LookupColumn = 0
      SortColumn = 0
      TabOrder = 2
      OnChange = ccbAnalysisCodeChange
    end
    object ccbJobCode: TColumnComboBox
      Left = 8
      Top = 38
      Width = 137
      Height = 22
      Color = 16445929
      Version = '1.3.1.1'
      Visible = True
      Columns = <
        item
          Color = clCream
          ColumnType = ctText
          Width = 120
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end
        item
          Color = clWindow
          ColumnType = ctText
          Width = 100
          Alignment = taLeftJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
        end>
      ComboItems = <>
      EditColumn = -1
      EditHeight = 16
      DropWidth = 0
      DropHeight = 200
      Enabled = True
      Flat = True
      GridLines = False
      ItemIndex = -1
      LookupColumn = 0
      SortColumn = 0
      TabOrder = 0
      OnChange = ccbJobCodeChange
    end
    object edtDay1: TAdvEdit
      Tag = 1
      Left = 451
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 6
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay2: TAdvEdit
      Tag = 2
      Left = 491
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 7
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay3: TAdvEdit
      Tag = 3
      Left = 531
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 8
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay4: TAdvEdit
      Tag = 4
      Left = 571
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 9
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay5: TAdvEdit
      Tag = 5
      Left = 611
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 10
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay6: TAdvEdit
      Tag = 6
      Left = 651
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 11
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtDay7: TAdvEdit
      Tag = 7
      Left = 691
      Top = 38
      Width = 32
      Height = 22
      EditAlign = eaRight
      EditType = etMoney
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 12
      Text = '0.00'
      ValidChars = '0123456789'
      Visible = True
      OnExit = edtDay1Exit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtHrsQty: TAdvEdit
      Tag = 1
      Left = 748
      Top = 38
      Width = 73
      Height = 22
      EditAlign = eaRight
      EditType = etFloat
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 13
      Text = '0.00'
      Visible = True
      OnExit = edtHrsQtyExit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtTotChargeOutRate: TAdvEdit
      Tag = 1
      Left = 748
      Top = 71
      Width = 73
      Height = 22
      TabStop = False
      EditAlign = eaRight
      EditType = etFloat
      ReturnIsTab = True
      Precision = 2
      Prefix = #163' '
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 17
      Text = '0.00'
      Visible = True
      Version = '2.7.4.1'
    end
    object edtTotCostHour: TAdvEdit
      Tag = 1
      Left = 748
      Top = 104
      Width = 73
      Height = 22
      TabStop = False
      EditAlign = eaRight
      EditType = etFloat
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 19
      Text = '0.00'
      Visible = True
      Version = '2.7.4.1'
    end
    object edtTLUDF1: TAdvEdit
      Tag = 1
      Left = 8
      Top = 108
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 14
      Visible = True
      OnChange = edtTLUDF1Change
      Version = '2.7.4.1'
    end
    object edtTLUDF2: TAdvEdit
      Tag = 1
      Left = 154
      Top = 108
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 15
      Visible = True
      OnChange = edtTLUDF2Change
      Version = '2.7.4.1'
    end
    object edtChargeOutRate: TAdvEdit
      Tag = 1
      Left = 668
      Top = 71
      Width = 73
      Height = 22
      EditAlign = eaRight
      EditType = etFloat
      ReturnIsTab = True
      Precision = 2
      Prefix = #163' '
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 16
      Text = '0.00'
      Visible = True
      OnExit = edtChargeOutRateExit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtCostHour: TAdvEdit
      Tag = 1
      Left = 668
      Top = 104
      Width = 73
      Height = 22
      EditAlign = eaRight
      EditType = etFloat
      ReturnIsTab = True
      Precision = 2
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 18
      Text = '0.00'
      Visible = True
      OnExit = edtCostHourExit
      OnKeyPress = edtDay1KeyPress
      Version = '2.7.4.1'
    end
    object edtTLUDF7: TAdvEdit
      Tag = 1
      Left = 8
      Top = 148
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 20
      Visible = True
      OnChange = edtTLUDF7Change
      Version = '2.7.4.1'
    end
    object edtTLUDF8: TAdvEdit
      Tag = 1
      Left = 154
      Top = 148
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 21
      Visible = True
      OnChange = edtTLUDF8Change
      Version = '2.7.4.1'
    end
    object edtTLUDF9: TAdvEdit
      Tag = 1
      Left = 300
      Top = 148
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 22
      Visible = True
      OnChange = edtTLUDF9Change
      Version = '2.7.4.1'
    end
    object edtTLUDF10: TAdvEdit
      Tag = 1
      Left = 447
      Top = 148
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 23
      Visible = True
      OnChange = edtTLUDF10Change
      Version = '2.7.4.1'
    end
    object edtTLUDF5: TAdvEdit
      Tag = 1
      Left = 300
      Top = 108
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 24
      Visible = True
      OnChange = edtTLUDF5Change
      Version = '2.7.4.1'
    end
    object edtTLUDF6: TAdvEdit
      Tag = 1
      Left = 447
      Top = 108
      Width = 145
      Height = 22
      ReturnIsTab = True
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      AutoSize = False
      Color = clWindow
      Ctl3D = False
      Enabled = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 25
      Visible = True
      OnChange = edtTLUDF6Change
      Version = '2.7.4.1'
    end
    object cbDelete: TCheckBox
      Left = 772
      Top = 155
      Width = 53
      Height = 17
      Caption = 'Delete'
      TabOrder = 26
      OnClick = cbDeleteClick
    end
  end
end
