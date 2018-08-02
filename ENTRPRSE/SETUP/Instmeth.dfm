inherited frmEntInstMeth: TfrmEntInstMeth
  Left = 395
  Top = 189
  HelpContext = 64
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Standard or Custom'
  end
  inherited InstrLbl: TLabel
    Top = 48
    Height = 27
    Caption = 'Please select the method you want to use for this %INSTUPG%:-'
  end
  object Label1: TLabel [3]
    Left = 197
    Top = 96
    Width = 247
    Height = 31
    AutoSize = False
    Caption = 
      'This method installs all the available modules and uses default ' +
      'settings wherever possible.'
    WordWrap = True
    OnClick = Label1Click
  end
  object Label2: TLabel [4]
    Left = 340
    Top = 79
    Width = 102
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Recommended'
    OnClick = Label1Click
  end
  object Label3: TLabel [5]
    Left = 197
    Top = 150
    Width = 247
    Height = 62
    AutoSize = False
    Caption = 
      'This method gives you the maximum amount of flexibility, allowin' +
      'g you to select which modules are installed, and allowing all se' +
      'ttings to be defined.'
    WordWrap = True
    OnClick = Label3Click
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    TabOrder = 6
  end
  object radStandard: TRadioButton
    Left = 178
    Top = 78
    Width = 145
    Height = 17
    Caption = 'Standard %INSTUPG%'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object radCustom: TRadioButton
    Left = 178
    Top = 132
    Width = 143
    Height = 17
    Caption = 'Custom %INSTUPG%'
    TabOrder = 2
  end
end
