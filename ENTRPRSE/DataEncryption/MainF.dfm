object frmMain: TfrmMain
  Left = 161
  Top = 113
  Width = 907
  Height = 651
  HelpContext = 29
  Caption = 'Pervasive Data Encryption'
  Color = clWindow
  Ctl3D = False
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    899
    620)
  PixelsPerInch = 96
  TextHeight = 14
  object CompanyTree: TVirtualStringTree
    Left = 7
    Top = 153
    Width = 804
    Height = 442
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Arial'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsFlatButtons
    TabOrder = 0
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnFocusChanged = CompanyTreeFocusChanged
    OnGetText = CompanyTreeGetText
    OnInitNode = CompanyTreeInitNode
    Columns = <
      item
        Position = 0
        Width = 300
      end
      item
        Position = 1
        Width = 350
        WideText = 'Encryption Status'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
        Position = 2
        Width = 125
        WideText = 'Encryption Estimate'
      end>
  end
  object chkGDPROnly: TCheckBox
    Left = 7
    Top = 597
    Width = 193
    Height = 17
    Caption = 'Show GDPR-related files only'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = chkGDPROnlyClick
  end
  object btnClose: TSBSButton
    Left = 814
    Top = 169
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
    TextId = 0
  end
  object btnEncrypt: TSBSButton
    Left = 814
    Top = 199
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Encrypt File'
    TabOrder = 3
    OnClick = btnEncryptClick
    TextId = 0
  end
  object pnlMessages: TPanel
    Left = 0
    Top = 0
    Width = 899
    Height = 145
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    object Label1: TLabel
      Left = 7
      Top = 5
      Width = 760
      Height = 28
      Caption = 
        'The following tree contains details of the Pervasive.SQL Edition' +
        ' data files that are not encrypted.  It is possible to extract d' +
        'ata from an unencrypted data file if the files are stolen.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 7
      Top = 37
      Width = 342
      Height = 14
      Caption = 
        'Before encrypting a data file you should consider the following ' +
        'points:-'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 23
      Top = 55
      Width = 784
      Height = 28
      AutoSize = False
      Caption = 
        'You MUST have a known good backup of the data file - the process' +
        ' cannot be reversed and in the event of a hardware or software f' +
        'ailure the data file will be irreversably damaged and cannot be ' +
        'repaired - restoring a backup is the only option.'
      WordWrap = True
    end
    object Label5: TLabel
      Left = 23
      Top = 87
      Width = 784
      Height = 28
      AutoSize = False
      Caption = 
        'No other users or applications can use the data file while it is' +
        ' being encrypted  - ensure everyone is aware and any external mo' +
        'dules or applications have been closed.'
      WordWrap = True
    end
    object lblEstimate: TLabel
      Left = 23
      Top = 117
      Width = 784
      Height = 28
      AutoSize = False
      Caption = 
        'The estimated time shown against each file is an estimate - it c' +
        'annot take account of local conditions and it may may take more ' +
        'or less ti depending on network and server performance.  For saf' +
        'ety you should assume it will take longer and plan accordingly.'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 14
      Top = 58
      Width = 6
      Height = 9
      Caption = 'l'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clBlack
      Font.Height = -8
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 14
      Top = 90
      Width = 6
      Height = 9
      Caption = 'l'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clBlack
      Font.Height = -8
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 14
      Top = 122
      Width = 6
      Height = 9
      Caption = 'l'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clBlack
      Font.Height = -8
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
    end
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 872
    Top = 584
  end
end
