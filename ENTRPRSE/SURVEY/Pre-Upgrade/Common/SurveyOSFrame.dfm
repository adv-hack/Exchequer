inherited SurveyFrameOperatingSystems: TSurveyFrameOperatingSystems
  Height = 351
  object Label20: TLabel
    Left = 6
    Top = 7
    Width = 298
    Height = 16
    Caption = 'Technical Site Information - Operating Systems'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 7
    Top = 28
    Width = 399
    Height = 33
    AutoSize = False
    Caption = 
      'Please specify the number of computers running Exchequer within ' +
      'your company for each of the Operating Systems listed below:-'
    WordWrap = True
  end
  object Label22: TLabel
    Left = 21
    Top = 67
    Width = 80
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 95'
  end
  object Label23: TLabel
    Left = 21
    Top = 94
    Width = 80
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 98'
  end
  object Label24: TLabel
    Left = 21
    Top = 121
    Width = 80
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows ME'
  end
  object Label25: TLabel
    Left = 2
    Top = 148
    Width = 99
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows NT 3/4'
  end
  object Label26: TLabel
    Left = 21
    Top = 175
    Width = 80
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 2000'
  end
  object Label27: TLabel
    Left = 203
    Top = 67
    Width = 80
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows XP'
  end
  object Label28: TLabel
    Left = 8
    Top = 203
    Width = 399
    Height = 13
    AutoSize = False
    Caption = 'What Server Operating System do you use:-'
  end
  object Label29: TLabel
    Left = 9
    Top = 250
    Width = 110
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Other, please specify'
  end
  object Label9: TLabel
    Left = 184
    Top = 94
    Width = 99
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 2003'
  end
  object Label32: TLabel
    Left = 184
    Top = 121
    Width = 99
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows Vista'
  end
  object Label1: TLabel
    Left = 8
    Top = 305
    Width = 399
    Height = 13
    AutoSize = False
    Caption = 'Do you use or intend to use Terminal Services or Citrix?'
  end
  object Label2: TLabel
    Left = 9
    Top = 279
    Width = 110
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Service Pack'
  end
  object Label3: TLabel
    Left = 184
    Top = 175
    Width = 99
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 8'
  end
  object Label4: TLabel
    Left = 184
    Top = 148
    Width = 99
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Windows 7'
  end
  object edtWindows95: TEdit
    Left = 111
    Top = 64
    Width = 46
    Height = 22
    TabOrder = 0
    Text = '0'
  end
  object udWindows95: TUpDown
    Left = 157
    Top = 64
    Width = 16
    Height = 22
    Associate = edtWindows95
    Min = 0
    Position = 0
    TabOrder = 1
    Wrap = False
  end
  object edtWindows98: TEdit
    Left = 111
    Top = 91
    Width = 46
    Height = 22
    TabOrder = 2
    Text = '0'
  end
  object udWindows98: TUpDown
    Left = 157
    Top = 91
    Width = 16
    Height = 22
    Associate = edtWindows98
    Min = 0
    Position = 0
    TabOrder = 3
    Wrap = False
  end
  object edtWindowsME: TEdit
    Left = 111
    Top = 118
    Width = 46
    Height = 22
    TabOrder = 4
    Text = '0'
  end
  object udWindowsME: TUpDown
    Left = 157
    Top = 118
    Width = 16
    Height = 22
    Associate = edtWindowsME
    Min = 0
    Position = 0
    TabOrder = 5
    Wrap = False
  end
  object edtWindowsNT: TEdit
    Left = 111
    Top = 145
    Width = 46
    Height = 22
    TabOrder = 6
    Text = '0'
  end
  object udWindowsNT: TUpDown
    Left = 157
    Top = 145
    Width = 16
    Height = 22
    Associate = edtWindowsNT
    Min = 0
    Position = 0
    TabOrder = 7
    Wrap = False
  end
  object edtWindows2000: TEdit
    Left = 111
    Top = 172
    Width = 46
    Height = 22
    TabOrder = 8
    Text = '0'
  end
  object udWindows2000: TUpDown
    Left = 157
    Top = 172
    Width = 16
    Height = 22
    Associate = edtWindows2000
    Min = 0
    Position = 0
    TabOrder = 9
    Wrap = False
  end
  object edtWindowsXP: TEdit
    Left = 293
    Top = 64
    Width = 46
    Height = 22
    TabOrder = 10
    Text = '0'
  end
  object udWindowsXP: TUpDown
    Left = 339
    Top = 64
    Width = 16
    Height = 22
    Associate = edtWindowsXP
    Min = 0
    Position = 0
    TabOrder = 11
    Wrap = False
  end
  object lstNetOs: TComboBox
    Left = 18
    Top = 221
    Width = 372
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 16
    OnClick = lstNetOsClick
  end
  object edtOtherNetOs: TEdit
    Left = 130
    Top = 247
    Width = 260
    Height = 22
    TabOrder = 17
  end
  object edtWindows2003: TEdit
    Left = 293
    Top = 91
    Width = 46
    Height = 22
    TabOrder = 12
    Text = '0'
  end
  object udWindows2003: TUpDown
    Left = 339
    Top = 91
    Width = 16
    Height = 22
    Associate = edtWindows2003
    Min = 0
    Position = 0
    TabOrder = 13
    Wrap = False
  end
  object edtWindowsVista: TEdit
    Left = 293
    Top = 118
    Width = 46
    Height = 22
    TabOrder = 14
    Text = '0'
  end
  object udWindowsVista: TUpDown
    Left = 339
    Top = 118
    Width = 16
    Height = 22
    Associate = edtWindowsVista
    Min = 0
    Position = 0
    TabOrder = 15
    Wrap = False
  end
  object lstCitrixUse: TComboBox
    Left = 18
    Top = 323
    Width = 372
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 19
  end
  object lstNetOSSP: TComboBox
    Left = 130
    Top = 274
    Width = 260
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 18
  end
  object edtWindows8: TEdit
    Left = 293
    Top = 172
    Width = 46
    Height = 22
    TabOrder = 20
    Text = '0'
  end
  object udWindows8: TUpDown
    Left = 339
    Top = 172
    Width = 16
    Height = 22
    Associate = edtWindows8
    Min = 0
    Position = 0
    TabOrder = 21
    Wrap = False
  end
  object edtWindows7: TEdit
    Left = 293
    Top = 145
    Width = 46
    Height = 22
    TabOrder = 22
    Text = '0'
  end
  object udWindows7: TUpDown
    Left = 339
    Top = 145
    Width = 16
    Height = 22
    Associate = edtWindows7
    Min = 0
    Position = 0
    TabOrder = 23
    Wrap = False
  end
end
