object frmHTMLTransViewer: TfrmHTMLTransViewer
  Left = 71
  Top = 92
  Width = 549
  Height = 308
  Caption = 'frmHTMLTransViewer'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 14
  object IpHtmlPanel1: TIpHtmlPanel
    Left = 0
    Top = 0
    Width = 452
    Height = 281
    Align = alClient
    DataProvider = IpHtmlDataProvider1
    FlagErrors = False
  end
  object pnlRight: TPanel
    Left = 452
    Top = 0
    Width = 89
    Height = 281
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object btnClose: TButton
      Left = 6
      Top = 8
      Width = 80
      Height = 21
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object IpHtmlDataProvider1: TIpHtmlDataProvider
    OnGetImage = IpHtmlDataProvider1GetImage
    Left = 592
    Top = 288
  end
end
