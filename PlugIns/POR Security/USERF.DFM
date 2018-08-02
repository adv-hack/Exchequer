object frmUserDetails: TfrmUserDetails
  Left = 396
  Top = 225
  BorderStyle = bsDialog
  Caption = 'User Details'
  ClientHeight = 132
  ClientWidth = 246
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 4
    Top = 2
    Width = 236
    Height = 93
    TabOrder = 0
    object Label1: TLabel
      Left = 3
      Top = 16
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'User Code'
    end
    object Label2: TLabel
      Left = 3
      Top = 42
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Type'
    end
    object Label3: TLabel
      Left = 3
      Top = 67
      Width = 60
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Department'
    end
    object edtUserCode: TEdit
      Left = 66
      Top = 13
      Width = 121
      Height = 22
      CharCase = ecUpperCase
      MaxLength = 8
      TabOrder = 0
    end
    object lstUserType: TComboBox
      Left = 66
      Top = 39
      Width = 121
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 1
      OnClick = lstUserTypeClick
    end
    object lstDepartment: TComboBox
      Left = 66
      Top = 64
      Width = 162
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 2
    end
  end
  object btnSave: TButton
    Left = 69
    Top = 104
    Width = 80
    Height = 21
    Caption = '&Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 104
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
