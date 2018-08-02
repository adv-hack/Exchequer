object frmEditRecord: TfrmEditRecord
  Left = 147
  Top = 277
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Edit Record'
  ClientHeight = 55
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object edtRecord: TEdit
    Left = 8
    Top = 16
    Width = 593
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 611
    Top = 0
    Width = 104
    Height = 55
    Align = alRight
    TabOrder = 1
    object btnOK: TButton
      Left = 15
      Top = 5
      Width = 80
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 15
      Top = 29
      Width = 80
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
