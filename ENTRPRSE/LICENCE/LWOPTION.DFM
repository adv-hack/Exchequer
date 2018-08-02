object frmLicWizOptions: TfrmLicWizOptions
  Left = 383
  Top = 198
  Width = 407
  Height = 279
  Caption = 'Licence Options - Handle With Care'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 288
    Height = 29
    AutoSize = False
    Caption = 'Licence Options'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 33
    Width = 381
    Height = 36
    AutoSize = False
    Caption = 
      'These options supply additional functionality not normally requi' +
      'red by the setup program. Be VERY careful in their use.'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 3
    Top = 207
    Width = 387
    Height = 4
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 32
    Top = 93
    Width = 349
    Height = 31
    AutoSize = False
    Caption = 
      'When selected this option will cause all the Module Release Code' +
      's to be reset to none. This is only relevent for Upgrades.'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 32
    Top = 145
    Width = 349
    Height = 36
    AutoSize = False
    Caption = 
      'When selected this option will cause all the Country Codes to be' +
      ' changed to that of the Upgrade Licence. This is only relevent f' +
      'or Upgrades.'
    WordWrap = True
  end
  object btnCancel: TButton
    Left = 310
    Top = 218
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 223
    Top = 218
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object chkModRelReset: TCheckBox
    Left = 14
    Top = 74
    Width = 276
    Height = 17
    Caption = 'Reset Module Release Codes'
    TabOrder = 0
  end
  object chkResetCntry: TCheckBox
    Left = 14
    Top = 126
    Width = 276
    Height = 17
    Caption = 'Reset Country Codes During Upgrade'
    TabOrder = 1
  end
end
