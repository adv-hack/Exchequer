object formILConfigAdvantage: TformILConfigAdvantage
  Left = 430
  Top = 195
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Database Connection Parameters'
  ClientHeight = 206
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 259
    Height = 165
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'Database'
      ImageIndex = 1
      object Label5: TLabel
        Left = 8
        Top = 3
        Width = 79
        Height = 13
        Caption = 'Connection Path'
      end
      object Label6: TLabel
        Left = 8
        Top = 43
        Width = 73
        Height = 13
        Caption = 'Database Type'
      end
      object editPath: TEdit
        Left = 8
        Top = 19
        Width = 209
        Height = 21
        TabOrder = 0
      end
      object butnBrowseFile: TButton
        Left = 217
        Top = 20
        Width = 19
        Height = 19
        Caption = '...'
        TabOrder = 1
        OnClick = butnBrowseFileClick
      end
      object cmboType: TComboBox
        Left = 8
        Top = 56
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        Sorted = True
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 80
        Width = 233
        Height = 49
        Caption = 'Server Types'
        TabOrder = 3
        object ckbxLocalServer: TCheckBox
          Left = 8
          Top = 24
          Width = 73
          Height = 17
          Caption = 'Local'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object ckbxRemoteServer: TCheckBox
          Left = 88
          Top = 24
          Width = 73
          Height = 17
          Caption = 'Remote'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object ckbxAISServer: TCheckBox
          Left = 168
          Top = 24
          Width = 57
          Height = 17
          Caption = 'AIS'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Authentication'
      object Label3: TLabel
        Left = 8
        Top = 37
        Width = 51
        Height = 13
        Caption = '&Username:'
        FocusControl = editUsername
      end
      object Label4: TLabel
        Left = 8
        Top = 77
        Width = 49
        Height = 13
        Caption = '&Password:'
        FocusControl = editPassword
      end
      object Label2: TLabel
        Left = 8
        Top = 0
        Width = 233
        Height = 33
        AutoSize = False
        Caption = 'Authentication credentials are used for Advantage 6.0 only.'
        WordWrap = True
      end
      object editUsername: TEdit
        Left = 8
        Top = 52
        Width = 233
        Height = 21
        TabOrder = 0
      end
      object editPassword: TEdit
        Left = 8
        Top = 92
        Width = 233
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 165
    Width = 259
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object butnOk: TButton
      Left = 95
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
      Left = 175
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
    Left = 24
    Top = 168
    object actnOk: TAction
      Caption = '&Ok'
      OnUpdate = actnOkUpdate
    end
  end
  object AdsQuery1: TAdsQuery
    Version = '2.70 (ACE 2.70)'
    Left = 148
    Top = 104
    ParamData = <>
  end
end
