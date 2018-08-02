object frmCoDetails: TfrmCoDetails
  Left = 278
  Top = 232
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'frmCoDetails'
  ClientHeight = 214
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 201
    Caption = 'Company/Payroll Details  '
    TabOrder = 0
    object Label1: TLabel
      Left = 36
      Top = 36
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Code:'
    end
    object Label2: TLabel
      Left = 33
      Top = 76
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Name:'
    end
    object Label3: TLabel
      Left = 16
      Top = 116
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'Payroll ID:'
    end
    object Label4: TLabel
      Left = 14
      Top = 156
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'File Name:'
    end
    object cbCode: TComboBox
      Left = 72
      Top = 32
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbCodeChange
    end
    object edtName: TEdit
      Left = 72
      Top = 72
      Width = 177
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtPayID: TEdit
      Left = 72
      Top = 112
      Width = 57
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '001'
    end
    object SpinButton1: TSpinButton
      Left = 128
      Top = 112
      Width = 20
      Height = 25
      DownGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000008080000080800000808000000000000080800000808000008080000080
        8000008080000080800000808000000000000000000000000000008080000080
        8000008080000080800000808000000000000000000000000000000000000000
        0000008080000080800000808000000000000000000000000000000000000000
        0000000000000000000000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      TabOrder = 3
      UpGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000000000000000000000000000000000000000000000000000000000000080
        8000008080000080800000000000000000000000000000000000000000000080
        8000008080000080800000808000008080000000000000000000000000000080
        8000008080000080800000808000008080000080800000808000000000000080
        8000008080000080800000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      OnDownClick = SpinButton1DownClick
      OnUpClick = SpinButton1UpClick
    end
    object edtFileName: TEdit
      Left = 72
      Top = 152
      Width = 177
      Height = 21
      TabOrder = 4
      OnExit = edtFileNameExit
    end
  end
  object SBSButton1: TSBSButton
    Left = 288
    Top = 16
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 1
    OnClick = SBSButton1Click
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 288
    Top = 40
    Width = 80
    Height = 21
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
end
