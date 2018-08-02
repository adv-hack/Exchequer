object frmParams: TfrmParams
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Sentinel Report Parameters'
  ClientHeight = 201
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    371
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object lblParam: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'lblParam'
  end
  object btnOK: TButton
    Left = 224
    Top = 168
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 296
    Top = 168
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object grpData: TGroupBox
    Left = 8
    Top = 32
    Width = 353
    Height = 129
    TabOrder = 2
    object Label4: TLabel
      Left = 32
      Top = 24
      Width = 26
      Height = 13
      Caption = 'From:'
    end
    object Label5: TLabel
      Left = 192
      Top = 24
      Width = 16
      Height = 13
      Caption = 'To:'
    end
    object lblOffStart: TLabel
      Left = 32
      Top = 75
      Width = 61
      Height = 13
      Caption = 'Offset (Days)'
      Visible = False
    end
    object lblOffEnd: TLabel
      Left = 192
      Top = 75
      Width = 61
      Height = 13
      Caption = 'Offset (Days)'
      Visible = False
    end
    object edtPFrom: TEdit
      Left = 32
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      Visible = False
      OnExit = edtPFromExit
    end
    object edtPTo: TEdit
      Left = 192
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Visible = False
      OnExit = edtPFromExit
    end
    object cbPFrom: TComboBox
      Left = 32
      Top = 40
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbPFrom'
      Visible = False
      OnChange = cbPFromChange
      OnDblClick = cbPFromDblClick
      OnExit = edtPFromExit
    end
    object cbPTo: TComboBox
      Left = 192
      Top = 40
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'cbPTo'
      Visible = False
      OnChange = cbPFromChange
      OnDblClick = cbPFromDblClick
      OnExit = edtPFromExit
    end
    object spnOffStart: TSpinEdit
      Left = 32
      Top = 90
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
      Visible = False
    end
    object spnOffEnd: TSpinEdit
      Left = 192
      Top = 90
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 0
      Visible = False
    end
  end
end
