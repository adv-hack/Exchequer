object frmGroupsReportFilter: TfrmGroupsReportFilter
  Left = 349
  Top = 207
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Print Groups Report'
  ClientHeight = 150
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 4
    Top = 8
    Width = 402
    Height = 113
    Shape = bsFrame
  end
  object Label81: Label8
    Left = 33
    Top = 18
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Group Range from'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8
    Left = 33
    Top = 43
    Width = 100
    Height = 14
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'to'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object btnOK: TSBSButton
    Left = 126
    Top = 124
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 217
    Top = 124
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
    TextId = 0
  end
  object edtGroupFrom: Text8Pt
    Left = 137
    Top = 15
    Width = 186
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object edtGroupTo: Text8Pt
    Left = 137
    Top = 41
    Width = 186
    Height = 22
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object chkCompanyPaths: TBorCheck
    Left = 13
    Top = 68
    Width = 137
    Height = 20
    Caption = 'Show Company Paths'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    TabStop = True
    TextId = 0
  end
  object chkShowPwords: TBorCheck
    Left = 13
    Top = 92
    Width = 137
    Height = 20
    Caption = 'Show Users Passwords'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    TabStop = True
    TextId = 0
  end
end
