object ErrorLogFrm: TErrorLogFrm
  Left = 370
  Top = 96
  Width = 448
  Height = 376
  Caption = 'Error Logs'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 432
    Height = 292
    Align = alClient
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 292
    Width = 432
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object PBtn: TButton
      Left = 141
      Top = 15
      Width = 75
      Height = 25
      Caption = '&Print'
      Enabled = False
      TabOrder = 1
      OnClick = PBtnClick
    end
    object DBtn: TButton
      Left = 224
      Top = 15
      Width = 75
      Height = 25
      Caption = '&Delete'
      Enabled = False
      TabOrder = 2
      OnClick = GBtnClick
    end
    object GBtn: TButton
      Left = 59
      Top = 15
      Width = 75
      Height = 25
      Caption = '&Get'
      TabOrder = 0
      OnClick = GBtnClick
    end
    object ClsBtn: TButton
      Left = 306
      Top = 15
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 3
      OnClick = ClsBtnClick
    end
  end
end
