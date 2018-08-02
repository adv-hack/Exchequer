object frmPIITree: TfrmPIITree
  Left = 202
  Top = 165
  Width = 1056
  Height = 655
  HelpContext = 2312
  Caption = 'frmPIITree'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 292
    Height = 14
    Caption = 'The following information has been found in known PII fields:'
  end
  object vstPII: TVirtualStringTree
    Left = 16
    Top = 24
    Width = 913
    Height = 561
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnGetText = vstPIIGetText
    OnPaintText = vstPIIPaintText
    OnInitNode = vstPIIInitNode
    Columns = <>
  end
  object pnlButtons: TPanel
    Left = 952
    Top = 0
    Width = 96
    Height = 588
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object btnClose: TSBSButton
      Left = 8
      Top = 24
      Width = 80
      Height = 21
      Caption = '&Close'
      TabOrder = 0
      OnClick = btnCloseClick
      TextId = 0
    end
    object btnPrint: TSBSButton
      Left = 8
      Top = 56
      Width = 80
      Height = 21
      Caption = 'Print &Report'
      TabOrder = 1
      OnClick = btnPrintClick
      TextId = 0
    end
    object btnExport: TSBSButton
      Left = 8
      Top = 80
      Width = 80
      Height = 21
      Caption = 'E&xport'
      TabOrder = 2
      OnClick = btnExportClick
      TextId = 0
    end
    object btnCloseEntity: TSBSButton
      Left = 8
      Top = 104
      Width = 80
      Height = 21
      Caption = 'C&lose Entity'
      TabOrder = 3
      TextId = 0
    end
    object btnEdit: TSBSButton
      Left = 8
      Top = 144
      Width = 80
      Height = 21
      Caption = '&Edit'
      TabOrder = 4
      OnClick = btnEditClick
      TextId = 0
    end
    object btnDelete: TSBSButton
      Left = 8
      Top = 168
      Width = 80
      Height = 21
      Caption = '&Delete'
      TabOrder = 5
      TextId = 0
    end
    object btnOpen: TSBSButton
      Left = 8
      Top = 192
      Width = 80
      Height = 21
      Caption = '&Open'
      TabOrder = 6
      TextId = 0
    end
    object btnPrintLink: TSBSButton
      Left = 8
      Top = 216
      Width = 80
      Height = 21
      Caption = '&Print'
      TabOrder = 7
      TextId = 0
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 588
    Width = 1048
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 16
      Top = 4
      Width = 466
      Height = 14
      Caption = 
        'If you are storing PII information in unsupported fields then yo' +
        'u will have to handle them manually.'
    end
    object Label3: TLabel
      Left = 16
      Top = 20
      Width = 537
      Height = 14
      Caption = 
        'You will also need to consider emailed Statements, Transactions,' +
        ' etc.., that may be stored on your email server.'
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML Files (*.xml)|*.xml'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export PII Report'
    Left = 616
    Top = 592
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 888
    Top = 248
    object PrintReport1: TMenuItem
      Caption = 'Print &Report'
      OnClick = btnPrintClick
    end
    object Export1: TMenuItem
      Caption = 'E&xport'
      OnClick = btnExportClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Properties1: TMenuItem
      Caption = '&Properties'
      OnClick = Properties1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object StoreCoordinates1: TMenuItem
      Caption = '&Save Coordinates'
      OnClick = StoreCoordinates1Click
    end
  end
end
