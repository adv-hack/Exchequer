object formILConfigInterbase: TformILConfigInterbase
  Left = 353
  Top = 202
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Database Connection Parameters'
  ClientHeight = 161
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 303
    Height = 120
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'Connection'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 42
        Height = 13
        Caption = 'Protocol:'
      end
      object lablServer: TLabel
        Left = 8
        Top = 40
        Width = 34
        Height = 13
        Caption = 'Server:'
      end
      object Label5: TLabel
        Left = 8
        Top = 64
        Width = 68
        Height = 13
        Caption = 'Database File:'
      end
      object cmboProtocol: TComboBox
        Left = 80
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnChange = cmboProtocolChange
      end
      object editServer: TEdit
        Left = 80
        Top = 32
        Width = 201
        Height = 21
        TabOrder = 1
      end
      object editFile: TEdit
        Left = 80
        Top = 56
        Width = 185
        Height = 21
        TabOrder = 2
      end
      object butnBrowseFile: TButton
        Left = 264
        Top = 57
        Width = 19
        Height = 19
        Caption = '...'
        TabOrder = 3
        OnClick = butnBrowseFileClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Authentication'
      object Label3: TLabel
        Left = 15
        Top = 25
        Width = 51
        Height = 13
        Caption = '&Username:'
        FocusControl = editUsername
      end
      object Label4: TLabel
        Left = 15
        Top = 49
        Width = 49
        Height = 13
        Caption = '&Password:'
        FocusControl = editPassword
      end
      object editUsername: TEdit
        Left = 72
        Top = 20
        Width = 185
        Height = 21
        TabOrder = 0
      end
      object editPassword: TEdit
        Left = 72
        Top = 44
        Width = 185
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 303
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object butnOk: TButton
      Left = 139
      Top = 8
      Width = 75
      Height = 25
      Action = actnOk
      Anchors = [akTop, akRight]
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object butnCancel: TButton
      Left = 219
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ActionList1: TActionList
    Left = 64
    Top = 92
    object actnOk: TAction
      Caption = '&Ok'
      OnUpdate = actnOkUpdate
    end
  end
  object odlgDatabase: TOpenDialog
    DefaultExt = '.gdb'
    Filter = 'Interbase Databases|*.gdb|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select Database File'
    Left = 32
    Top = 120
  end
end
