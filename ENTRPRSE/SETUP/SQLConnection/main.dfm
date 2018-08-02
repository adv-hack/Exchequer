object mainform: Tmainform
  Left = 221
  Top = 130
  BorderStyle = bsDialog
  Caption = 'Exchequer Connection String Editor'
  ClientHeight = 499
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 515
    Height = 457
    ActivePage = connStrSheet
    Align = alTop
    TabIndex = 0
    TabOrder = 0
    object connStrSheet: TTabSheet
      Caption = 'Connection String'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 473
        Height = 26
        Caption = 
          'WARNING.  You edit the connection string at your own risk.  Chan' +
          'ging your connection string could result in Exchequer not workin' +
          'g.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 8
        Top = 72
        Width = 42
        Height = 13
        Caption = 'Login file'
      end
      object Label3: TLabel
        Left = 8
        Top = 136
        Width = 84
        Height = 13
        Caption = 'Connection String'
      end
      object Label6: TLabel
        Left = 8
        Top = 40
        Width = 423
        Height = 13
        Caption = 
          'Browse for the ExchSQLLogin.xml file you want to decode.  Then c' +
          'lick Open to decode it.'
        WordWrap = True
      end
      object editLoginFile: TEdit
        Left = 8
        Top = 88
        Width = 409
        Height = 21
        TabOrder = 0
      end
      object btnBrowse: TButton
        Left = 424
        Top = 88
        Width = 75
        Height = 25
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
      object btnOpen: TButton
        Left = 424
        Top = 120
        Width = 75
        Height = 25
        Caption = 'Open'
        TabOrder = 2
        OnClick = btnOpenClick
      end
      object memoConnStr: TMemo
        Left = 8
        Top = 152
        Width = 489
        Height = 233
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object btnSave: TButton
        Left = 184
        Top = 392
        Width = 75
        Height = 25
        Caption = 'Save'
        Enabled = False
        TabOrder = 4
        OnClick = btnSaveClick
      end
      object btnSaveAs: TButton
        Left = 264
        Top = 392
        Width = 75
        Height = 25
        Caption = 'Save As...'
        Enabled = False
        TabOrder = 5
        OnClick = btnSaveAsClick
      end
      object btnTest: TButton
        Left = 8
        Top = 392
        Width = 75
        Height = 25
        Caption = 'Test'
        TabOrder = 6
        OnClick = btnTestClick
      end
    end
    object utilSheet: TTabSheet
      Caption = 'Decoder'
      ImageIndex = 1
      object Label5: TLabel
        Left = 8
        Top = 72
        Width = 71
        Height = 13
        Caption = 'Encoded string'
      end
      object Label7: TLabel
        Left = 8
        Top = 248
        Width = 43
        Height = 13
        Caption = 'Plain text'
      end
      object Label4: TLabel
        Left = 8
        Top = 0
        Width = 483
        Height = 26
        Caption = 
          'This utility performs a Decode from BASE64 followed by a decrypt' +
          'ion using the  default Exchequer key.  It can be used to decode ' +
          'entries in the Exchequer  common.IRISDatasetConnection table.'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 8
        Top = 40
        Width = 59
        Height = 13
        Caption = 'Decode Key'
      end
      object Label9: TLabel
        Left = 240
        Top = 40
        Width = 203
        Height = 13
        Caption = 'Leave blank to use Exchequer default. key'
      end
      object decodeUtilbtn: TBitBtn
        Left = 8
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Decode'
        TabOrder = 0
        OnClick = decodeUtilbtnClick
      end
      object plainTextEdit: TMemo
        Left = 8
        Top = 264
        Width = 489
        Height = 153
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object encodedEdit: TMemo
        Left = 8
        Top = 88
        Width = 489
        Height = 121
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object decodeKeyEdit: TEdit
        Left = 72
        Top = 40
        Width = 161
        Height = 21
        TabOrder = 3
      end
    end
    object encodeSheet: TTabSheet
      Caption = 'Encoder'
      ImageIndex = 2
      object Label10: TLabel
        Left = 8
        Top = 8
        Width = 306
        Height = 13
        Caption = 'This utility performs an encryption followed by a BASE64 encode.'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 8
        Top = 40
        Width = 58
        Height = 13
        Caption = 'Encode Key'
      end
      object Label12: TLabel
        Left = 240
        Top = 40
        Width = 203
        Height = 13
        Caption = 'Leave blank to use Exchequer default. key'
      end
      object Label13: TLabel
        Left = 8
        Top = 248
        Width = 71
        Height = 13
        Caption = 'Encoded string'
      end
      object Label14: TLabel
        Left = 8
        Top = 72
        Width = 43
        Height = 13
        Caption = 'Plain text'
      end
      object encodeKeyEdit: TEdit
        Left = 72
        Top = 40
        Width = 161
        Height = 21
        TabOrder = 0
      end
      object plainTextMemo: TMemo
        Left = 8
        Top = 88
        Width = 489
        Height = 121
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object encodeBtn: TBitBtn
        Left = 8
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Encode'
        TabOrder = 2
        OnClick = encodeBtnClick
      end
      object encodedMemo: TMemo
        Left = 8
        Top = 264
        Width = 489
        Height = 153
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
    end
  end
  object btnClose: TButton
    Left = 432
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.xml'
    FileName = 'ExchSQLLogin.xml'
    Filter = 'ExchSQLLogin.xml|ExchSQLLogin.xml|XML files (*.xml)|*.xml'
    Left = 40
    Top = 464
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 8
    Top = 464
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.xml'
    Filter = 'ExchSQLLogin.xml|ExchSQLLogin.xml|XML files (*.xml)|*.xml'
    Left = 72
    Top = 464
  end
end
