object RollupBudgetDlg: TRollupBudgetDlg
  Left = 344
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Roll Up G/L Budgets'
  ClientHeight = 207
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object lblRollupBudgets: TLabel
    Left = 16
    Top = 12
    Width = 95
    Height = 14
    Caption = 'Roll up budgets by :'
  end
  object btnOk: TButton
    Tag = 1
    Left = 47
    Top = 174
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 133
    Top = 174
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object chkCostCentre: TRadioButton
    Left = 60
    Top = 44
    Width = 141
    Height = 17
    Caption = 'Co&st Centre'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object chkDepartment: TRadioButton
    Left = 60
    Top = 76
    Width = 141
    Height = 17
    Caption = '&Department'
    TabOrder = 1
  end
  object chkGLOnly: TRadioButton
    Left = 60
    Top = 140
    Width = 141
    Height = 17
    Caption = '&G/L Only'
    TabOrder = 2
  end
  object chkCombined: TRadioButton
    Left = 60
    Top = 108
    Width = 141
    Height = 17
    Caption = 'Com&bined'
    TabOrder = 5
  end
end
