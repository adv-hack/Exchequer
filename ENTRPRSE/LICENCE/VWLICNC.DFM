object frmViewLic: TfrmViewLic
  Left = 192
  Top = 167
  Width = 426
  Height = 370
  Caption = 'View CD Licence'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 335
    Top = 0
    Width = 83
    Height = 343
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object btnOpenLicence: TButton
      Left = 3
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = btnOpenLicenceClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 335
    Height = 343
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object ListBox1: TListBox
      Left = 3
      Top = 3
      Width = 329
      Height = 337
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'LIC'
    FileEditStyle = fsEdit
    Filter = 'Licence Files (*.LIC)|*.LIC|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open Enterprise Licence'
    Left = 287
    Top = 15
  end
end
