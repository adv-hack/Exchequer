inherited frmCompanyType: TfrmCompanyType
  Left = 433
  Top = 233
  HelpContext = 28
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Arial'
  PixelsPerInch = 96
  TextHeight = 14
  inherited TitleLbl: TLabel
    Caption = 'Company Creation'
  end
  inherited InstrLbl: TLabel
    Height = 32
    Caption = 'Please specify how you want to create your new company:'
  end
  object Label1: TLabel [3]
    Left = 197
    Top = 103
    Width = 247
    Height = 58
    AutoSize = False
    Caption = 
      'An empty company is installed and a wizard guides you through th' +
      'e initial configuration of the Company Information. You can also' +
      ' copy data in from another company if desired.'
    WordWrap = True
    OnClick = Label1Click
  end
  object Label3: TLabel [4]
    Left = 197
    Top = 187
    Width = 247
    Height = 43
    AutoSize = False
    Caption = 
      'The Demonstration Company is installed, this is a fully working ' +
      'company that is usually used for demonstration and training.'
    WordWrap = True
    OnClick = Label3Click
  end
  object Label2: TLabel [5]
    Left = 309
    Top = 87
    Width = 135
    Height = 18
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Recommended'
    OnClick = Label1Click
  end
  object radNew: TRadioButton [7]
    Left = 178
    Top = 86
    Width = 105
    Height = 17
    Caption = 'New Company'
    Checked = True
    TabOrder = 1
    TabStop = True
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
  object radDemo: TRadioButton
    Left = 179
    Top = 169
    Width = 154
    Height = 19
    Caption = 'Demonstration Company'
    TabOrder = 2
  end
end
