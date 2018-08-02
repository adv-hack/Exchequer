object frmSignatures: TfrmSignatures
  Left = 329
  Top = 131
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'System Setup - Email and Fax Signatures'
  ClientHeight = 340
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup1: TSBSBackGroup
    Left = 5
    Top = 2
    Width = 500
    Height = 333
    TextId = 0
  end
  object Label81: Label8
    Left = 9
    Top = 20
    Width = 29
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 9
    Top = 43
    Width = 86
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Email Signature:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 10
    Top = 186
    Width = 81
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Fax Signature:-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object memEmailSig: TMemo
    Left = 16
    Top = 60
    Width = 477
    Height = 120
    ReadOnly = True
    TabOrder = 1
  end
  object memFaxSig: TMemo
    Left = 16
    Top = 201
    Width = 477
    Height = 120
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 2
  end
  object btnClose: TButton
    Left = 515
    Top = 17
    Width = 80
    Height = 21
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 3
  end
  object btnEdit: TButton
    Left = 515
    Top = 61
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 4
    OnClick = btnEditClick
  end
  object lstUsers: TComboBox
    Left = 43
    Top = 17
    Width = 448
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnClick = lstUsersClick
    Items.Strings = (
      'Company Default (Advanced Enterprise Software Ltd)')
  end
  object btnCancel: TButton
    Left = 515
    Top = 85
    Width = 80
    Height = 21
    Caption = '&Cancel'
    TabOrder = 5
    Visible = False
    OnClick = btnCancelClick
  end
end
