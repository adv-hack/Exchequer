object frmAbout: TfrmAbout
  Left = 353
  Top = 241
  BorderStyle = bsDialog
  Caption = 'About Exchequer Data Query Add-In'
  ClientHeight = 138
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    423
    138)
  PixelsPerInch = 96
  TextHeight = 14
  object NameLbl: TLabel
    Left = 60
    Top = 16
    Width = 347
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Exchequer Data Query Add-In'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CopyrightLbl: TLabel
    Left = 59
    Top = 89
    Width = 287
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'All rights reserved.'
  end
  object DescLbl: TLabel
    Left = 60
    Top = 37
    Width = 107
    Height = 13
    AutoSize = False
    Caption = 'Excel Add-In Version:'
  end
  object lblCopyright: TLabel
    Left = 59
    Top = 73
    Width = 349
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Copyright '#169' Advanced Enterprise Software Ltd 2013'
    ShowAccelChar = False
  end
  object Image1: TImage
    Left = 17
    Top = 36
    Width = 32
    Height = 32
    Stretch = True
  end
  object Label2: TLabel
    Left = 60
    Top = 52
    Width = 107
    Height = 13
    AutoSize = False
    Caption = 'COM Server Version:'
  end
  object lblExcelAddInVer: TLabel
    Left = 173
    Top = 37
    Width = 239
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object lblCOMServerVer: TLabel
    Left = 173
    Top = 52
    Width = 239
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object OkBtn: TButton
    Left = 171
    Top = 109
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
