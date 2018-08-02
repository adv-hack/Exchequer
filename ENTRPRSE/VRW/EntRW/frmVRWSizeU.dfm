object frmVRWSize: TfrmVRWSize
  Left = 328
  Top = 324
  HelpContext = 17
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Size'
  ClientHeight = 158
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 150
    Top = 132
    Width = 80
    Height = 21
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 234
    Top = 132
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object WidthGrp: TGroupBox
    Left = 4
    Top = 4
    Width = 152
    Height = 121
    Caption = ' Width '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 124
      Top = 96
      Width = 16
      Height = 14
      Caption = 'mm'
    end
    object chkWidthNoChange: TBorRadio
      Tag = 1
      Left = 8
      Top = 16
      Width = 137
      Height = 20
      Align = alRight
      Caption = '&No change'
      Checked = True
      TabOrder = 0
      TabStop = True
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkWidthShrink: TBorRadio
      Tag = 2
      Left = 8
      Top = 41
      Width = 137
      Height = 20
      Align = alRight
      Caption = '&Shrink to smallest'
      TabOrder = 1
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkWidthGrow: TBorRadio
      Tag = 3
      Left = 8
      Top = 66
      Width = 137
      Height = 20
      Align = alRight
      Caption = '&Grow to largest'
      TabOrder = 2
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkWidth: TBorRadio
      Tag = 4
      Left = 8
      Top = 92
      Width = 57
      Height = 20
      Align = alRight
      Caption = '&Width:'
      TabOrder = 3
      TextId = 0
      OnClick = OnCheckClick
    end
    object edtWidth: TEdit
      Left = 68
      Top = 92
      Width = 37
      Height = 22
      TabOrder = 4
      Text = '0'
      OnChange = edtWidthChange
    end
    object spinWidth: TUpDown
      Left = 105
      Top = 92
      Width = 15
      Height = 22
      Associate = edtWidth
      Min = 0
      Position = 0
      TabOrder = 5
      Wrap = False
    end
  end
  object HeightGrp: TGroupBox
    Left = 161
    Top = 4
    Width = 152
    Height = 121
    Caption = ' Height '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label2: TLabel
      Left = 124
      Top = 96
      Width = 16
      Height = 14
      Caption = 'mm'
    end
    object chkHeightNoChange: TBorRadio
      Tag = 5
      Left = 8
      Top = 16
      Width = 137
      Height = 20
      Align = alRight
      Caption = 'No chan&ge'
      Checked = True
      TabOrder = 0
      TabStop = True
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHeightShrink: TBorRadio
      Tag = 6
      Left = 8
      Top = 41
      Width = 137
      Height = 20
      Align = alRight
      Caption = 'Sh&rink to smallest'
      TabOrder = 1
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHeightGrow: TBorRadio
      Tag = 7
      Left = 8
      Top = 66
      Width = 137
      Height = 20
      Align = alRight
      Caption = 'Gr&ow to largest'
      TabOrder = 2
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHeight: TBorRadio
      Tag = 8
      Left = 8
      Top = 92
      Width = 57
      Height = 20
      Align = alRight
      Caption = '&Height:'
      TabOrder = 3
      TextId = 0
      OnClick = OnCheckClick
    end
    object spinHeight: TUpDown
      Left = 105
      Top = 92
      Width = 15
      Height = 22
      Associate = edtHeight
      Min = 0
      Position = 0
      TabOrder = 4
      Wrap = False
    end
    object edtHeight: TEdit
      Left = 68
      Top = 92
      Width = 37
      Height = 22
      TabOrder = 5
      Text = '0'
      OnChange = edtHeightChange
    end
  end
end
