object formDBAuthEditor: TformDBAuthEditor
  Left = 353
  Top = 202
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Database Connection Parameters'
  ClientHeight = 185
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 58
    Height = 13
    Caption = '&Datasource:'
    FocusControl = editDatasource
  end
  object Label2: TLabel
    Left = 27
    Top = 32
    Width = 39
    Height = 13
    Caption = '&Options:'
    FocusControl = memoOptions
  end
  object Label3: TLabel
    Left = 15
    Top = 105
    Width = 51
    Height = 13
    Caption = '&Username:'
    FocusControl = editUsername
  end
  object Label4: TLabel
    Left = 17
    Top = 129
    Width = 49
    Height = 13
    Caption = '&Password:'
    FocusControl = editPassword
  end
  object editDatasource: TEdit
    Left = 72
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 0
  end
  object editUsername: TEdit
    Left = 72
    Top = 100
    Width = 185
    Height = 21
    TabOrder = 2
  end
  object editPassword: TEdit
    Left = 72
    Top = 124
    Width = 185
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object memoOptions: TMemo
    Left = 72
    Top = 32
    Width = 185
    Height = 65
    TabOrder = 1
  end
  object butnCancel: TButton
    Left = 184
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object butnOk: TButton
    Left = 104
    Top = 152
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
end
