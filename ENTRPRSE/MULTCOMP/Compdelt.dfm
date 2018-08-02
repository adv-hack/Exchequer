object DeleteCompany: TDeleteCompany
  Left = 299
  Top = 151
  HelpContext = 11000
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Detach Company'
  ClientHeight = 332
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 6
    Top = 7
    Width = 381
    Height = 113
    Caption = '-'
    TextId = 0
    OnClick = RemoveAreaClick
  end
  object SBSBackGroup4: TSBSBackGroup
    Left = 6
    Top = 127
    Width = 381
    Height = 145
    Caption = '-'
    TextId = 0
    OnClick = DelAreaClick
  end
  object Label81: Label8
    Left = 13
    Top = 28
    Width = 355
    Height = 47
    AutoSize = False
    Caption = 
      'This option will remove the company from the list of companies s' +
      'hown in the multi-company manager. The program and data files fo' +
      'r this company will be left intact.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = RemoveAreaClick
    TextId = 0
  end
  object Label82: Label8
    Left = 13
    Top = 80
    Width = 361
    Height = 34
    AutoSize = False
    Caption = 
      'If this option is chosen the company can be added back into the ' +
      'companies list using the '#39'Attach Existing Company'#39' function on t' +
      'he File menu.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = RemoveAreaClick
    TextId = 0
  end
  object Label83: Label8
    Left = 67
    Top = 281
    Width = 258
    Height = 14
    Caption = 'Click the Cancel button if you do not wish to continue.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label84: Label8
    Left = 13
    Top = 148
    Width = 355
    Height = 45
    AutoSize = False
    Caption = 
      'This option will remove the company from the list of companies s' +
      'hown in the multi-company manager AND it will delete all the pro' +
      'gram and data files for this company.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = DelAreaClick
    TextId = 0
  end
  object Label85: Label8
    Left = 13
    Top = 199
    Width = 361
    Height = 33
    AutoSize = False
    Caption = 
      'If this option is chosen the company will be entirely removed an' +
      'd cannot be recovered. Any changes made since you last backed it' +
      ' up will be lost.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = DelAreaClick
    TextId = 0
  end
  object Label86: Label8
    Left = 13
    Top = 234
    Width = 360
    Height = 31
    AutoSize = False
    Caption = 
      'We recommend that you take a backup of the company before using ' +
      'this option, as it is not possible to undo the deletion of a com' +
      'pany.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = DelAreaClick
    TextId = 0
  end
  object CancelBtn: TButton
    Left = 205
    Top = 304
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object Remove: TBorRadio
    Left = 17
    Top = 3
    Width = 224
    Height = 20
    Align = alRight
    Caption = 'Detach Company from the Companies List'
    Checked = True
    TabOrder = 1
    TabStop = True
    TextId = 0
    OnClick = DoCheckyChecky
  end
  object Delete: TBorRadio
    Left = 17
    Top = 123
    Width = 100
    Height = 18
    Align = alRight
    Caption = 'Delete Company'
    TabOrder = 2
    TextId = 0
    OnClick = DoCheckyChecky
  end
  object DelBtn: TButton
    Left = 108
    Top = 304
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 3
    OnClick = DelBtnClick
  end
end
