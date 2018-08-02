object frmMultiBacAdmin: TfrmMultiBacAdmin
  Left = 192
  Top = 133
  Width = 330
  Height = 315
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Multi-BACs Administration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = 'Bank GL Code:'
  end
  object lblMod: TLabel
    Left = 240
    Top = 120
    Width = 73
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 225
    Height = 225
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 30
      Top = 20
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sort Code:'
    end
    object Label2: TLabel
      Left = 16
      Top = 52
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bank A/C No'
    end
    object Label3: TLabel
      Left = 32
      Top = 84
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'Bank Ref:'
    end
    object Label4: TLabel
      Left = 22
      Top = 116
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'BACS Type:'
    end
    object Label5: TLabel
      Left = 17
      Top = 148
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = 'Payment File:'
    end
    object Label6: TLabel
      Left = 21
      Top = 180
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = 'Receipt File:'
    end
    object edtSort: TEdit
      Left = 88
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'edtSort'
      OnChange = edtSortChange
    end
    object edtAC: TEdit
      Left = 88
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'edtAC'
      OnChange = edtSortChange
    end
    object edtRef: TEdit
      Left = 88
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'edtRef'
      OnChange = edtSortChange
    end
    object edtPayF: TEdit
      Left = 88
      Top = 144
      Width = 121
      Height = 21
      TabOrder = 4
      Text = 'edtPayF'
      OnChange = edtSortChange
    end
    object edtRecF: TEdit
      Left = 88
      Top = 176
      Width = 121
      Height = 21
      TabOrder = 5
      Text = 'edtRecF'
      OnChange = edtSortChange
    end
    object cbType: TComboBox
      Left = 88
      Top = 112
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnChange = cbTypeChange
    end
  end
  object cbGL: TComboBox
    Left = 8
    Top = 24
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnChange = cbGLChange
  end
  object Button1: TButton
    Left = 240
    Top = 56
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object btnSave: TButton
    Left = 240
    Top = 88
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object Button5: TButton
    Left = 240
    Top = 256
    Width = 75
    Height = 25
    Caption = 'C&lose'
    TabOrder = 4
    OnClick = Button5Click
  end
  object edtGL: TEdit
    Left = 144
    Top = 24
    Width = 111
    Height = 21
    TabOrder = 5
    Visible = False
    OnExit = edtGLExit
  end
  object btnCancel: TButton
    Left = 240
    Top = 120
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Enabled = False
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object btnConfigure: TButton
    Left = 240
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Con&figure'
    Enabled = False
    TabOrder = 7
    OnClick = btnConfigureClick
  end
end
