object frmSmsAccounts: TfrmSmsAccounts
  Left = 192
  Top = 107
  Width = 320
  Height = 310
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Create SMS Account File'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 216
    Top = 184
    Width = 89
    Height = 2
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 193
    Height = 249
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 156
      Width = 53
      Height = 13
      Caption = 'UserName:'
    end
    object Label2: TLabel
      Left = 16
      Top = 200
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Label3: TLabel
      Left = 16
      Top = 8
      Width = 104
      Height = 13
      Caption = 'Exchequer A/C Code:'
    end
    object Label4: TLabel
      Left = 16
      Top = 56
      Width = 68
      Height = 13
      Caption = 'Email address:'
    end
    object Label5: TLabel
      Left = 16
      Top = 108
      Width = 25
      Height = 13
      Caption = 'ESN:'
    end
    object edtUser: TEdit
      Left = 16
      Top = 172
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object edtPW: TEdit
      Left = 16
      Top = 216
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object edtEmail: TEdit
      Left = 16
      Top = 72
      Width = 145
      Height = 21
      TabOrder = 2
    end
    object cbAc: TComboBox
      Left = 16
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbAcChange
    end
    object edtAc: TEdit
      Left = 16
      Top = 24
      Width = 129
      Height = 21
      TabOrder = 1
      Visible = False
    end
    object meESN1: TMaskEdit
      Left = 16
      Top = 123
      Width = 158
      Height = 21
      EditMask = '999-999-999-999-999-999;1;_'
      MaxLength = 23
      TabOrder = 3
      Text = '   -   -   -   -   -   '
      OnExit = meESN1Exit
    end
  end
  object btnCreate: TButton
    Left = 216
    Top = 200
    Width = 89
    Height = 25
    Caption = 'Create A/C Fi&le'
    TabOrder = 5
    OnClick = btnCreateClick
  end
  object btnRead: TButton
    Left = 216
    Top = 232
    Width = 89
    Height = 25
    Caption = '&Read A/C File'
    TabOrder = 6
    OnClick = btnReadClick
  end
  object btnAdd: TButton
    Left = 216
    Top = 8
    Width = 89
    Height = 25
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnSave: TButton
    Left = 216
    Top = 104
    Width = 89
    Height = 25
    Caption = '&Save'
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object btnEdit: TButton
    Left = 216
    Top = 40
    Width = 89
    Height = 25
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditClick
  end
  object btnCancel: TButton
    Left = 216
    Top = 72
    Width = 89
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnDel: TButton
    Left = 216
    Top = 136
    Width = 89
    Height = 25
    Caption = '&Delete'
    TabOrder = 7
    OnClick = btnDelClick
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Smail.dat'
    Left = 168
    Top = 216
  end
  object OpenDialog1: TOpenDialog
    FileName = 'smail.dat'
    Left = 168
    Top = 184
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 168
    object File1: TMenuItem
      Caption = 'File'
      object CreateACFile1: TMenuItem
        Caption = 'Create SMS Account Fi&le'
        OnClick = btnCreateClick
      end
      object ReadACFile1: TMenuItem
        Caption = '&Read SMS Account File'
        OnClick = btnReadClick
      end
    end
    object Record1: TMenuItem
      Caption = '&Record'
      object Add1: TMenuItem
        Caption = '&Add'
        OnClick = btnAddClick
      end
      object Edit1: TMenuItem
        Caption = '&Edit'
        OnClick = btnEditClick
      end
      object Cancel1: TMenuItem
        Caption = '&Cancel'
        OnClick = btnCancelClick
      end
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = btnSaveClick
      end
      object Delete1: TMenuItem
        Caption = '&Delete'
        OnClick = btnDelClick
      end
    end
    object Reports1: TMenuItem
      Caption = '&Reports'
      object CheckSMSCredits1: TMenuItem
        Caption = 'Chec&k SMS Credits'
        OnClick = CheckSMSCredits1Click
      end
      object CheckSMSCreditsforAllAccounts1: TMenuItem
        Caption = 'Check SMS Credits for &All Accounts'
        OnClick = CheckSMSCreditsforAllAccounts1Click
      end
    end
  end
end
