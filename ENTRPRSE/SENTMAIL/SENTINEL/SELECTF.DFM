object frmSelectSent: TfrmSelectSent
  Left = 238
  Top = 87
  HelpContext = 32
  BorderStyle = bsDialog
  Caption = 'Select Sentinels'
  ClientHeight = 285
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblFile: TLabel
    Left = 8
    Top = 8
    Width = 19
    Height = 13
    Caption = 'File:'
  end
  object Button1: TButton
    Left = 288
    Top = 256
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 360
    Top = 256
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 24
    Width = 417
    Height = 225
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 92
      Height = 13
      Caption = 'Available Sentinels:'
    end
    object lblInclude: TLabel
      Left = 256
      Top = 8
      Width = 90
      Height = 13
      Caption = 'Sentinels to export:'
    end
    object lbAvailable: TListBox
      Left = 8
      Top = 24
      Width = 153
      Height = 185
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
      OnDblClick = lbAvailableDblClick
    end
    object lbInclude: TListBox
      Left = 256
      Top = 24
      Width = 153
      Height = 185
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 1
      OnDblClick = lbIncludeDblClick
    end
  end
  object btnIncToAvail: TButton
    Left = 184
    Top = 72
    Width = 65
    Height = 25
    Caption = '<'
    Enabled = False
    TabOrder = 3
    OnClick = btnIncToAvailClick
  end
  object btnAvailToInc: TButton
    Left = 184
    Top = 104
    Width = 65
    Height = 25
    Caption = '>'
    TabOrder = 4
    OnClick = btnAvailToIncClick
  end
  object btnIncToAvailAll: TButton
    Left = 184
    Top = 136
    Width = 65
    Height = 25
    Caption = '<<'
    Enabled = False
    TabOrder = 5
    OnClick = btnIncToAvailAllClick
  end
  object btnAvailToIncAll: TButton
    Left = 184
    Top = 168
    Width = 65
    Height = 25
    Caption = '>>'
    TabOrder = 6
    OnClick = btnAvailToIncAllClick
  end
end
