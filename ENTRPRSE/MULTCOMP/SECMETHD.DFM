inherited frmSecMethod: TfrmSecMethod
  Left = 286
  Top = 253
  ActiveControl = nil
  Caption = 'frmSecMethod'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Get Security Release Code'
  end
  inherited InstrLbl: TLabel
    Height = 32
    Caption = 
      'You can apply for a Security Release Code in the following ways:' +
      '-'
  end
  object Label1: TLabel [3]
    Left = 167
    Top = 199
    Width = 285
    Height = 32
    AutoSize = False
    Caption = 'Click a button to select the method you want yo use.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 0
  end
  inherited Panel1: TPanel
    TabOrder = 4
  end
  inherited ExitBtn: TButton
    TabOrder = 1
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 281
    Width = 85
    Cancel = True
    TabOrder = 2
  end
  inherited NextBtn: TButton
    Enabled = False
    TabOrder = 3
  end
  object SBSButton1: TSBSButton
    Left = 186
    Top = 86
    Width = 239
    Height = 34
    Caption = 'Telephone'
    TabOrder = 5
    OnClick = SBSButton1Click
    TextId = 0
  end
  object SBSButton2: TSBSButton
    Left = 186
    Top = 122
    Width = 239
    Height = 34
    Caption = 'Fax or Mail'
    TabOrder = 6
    OnClick = SBSButton2Click
    TextId = 0
  end
  object SBSButton3: TSBSButton
    Left = 186
    Top = 158
    Width = 239
    Height = 34
    Caption = 'Email'
    TabOrder = 7
    OnClick = SBSButton3Click
    TextId = 0
  end
end
