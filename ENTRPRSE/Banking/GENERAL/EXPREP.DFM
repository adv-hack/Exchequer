object frmExportReport: TfrmExportReport
  Left = 201
  Top = 107
  ActiveControl = Button1
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'frmExportReport'
  ClientHeight = 312
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 8
    Width = 377
    Height = 249
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object ReportMemo: TMemo
      Left = 8
      Top = 8
      Width = 361
      Height = 233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 148
    Top = 272
    Width = 89
    Height = 25
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
