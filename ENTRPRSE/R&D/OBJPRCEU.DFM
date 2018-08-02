object ObjPrice: TObjPrice
  Left = 922
  Top = 570
  Width = 345
  Height = 261
  HelpContext = 798
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'ObjectPrice'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 67
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object AccCodeLab: Label8
      Left = 10
      Top = 12
      Width = 18
      Height = 14
      Caption = 'A/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 10
      Top = 37
      Width = 17
      Height = 14
      Caption = 'S/C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object AccF: Text8Pt
      Left = 31
      Top = 8
      Width = 66
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 721
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = AccFExit
      TextId = 0
      ViaSBtn = False
      Link_to_Cust = True
      ShowHilight = True
    end
    object CompF: Text8Pt
      Left = 102
      Top = 8
      Width = 168
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 721
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      OnDblClick = CompFDblClick
      TextId = 0
      ViaSBtn = False
    end
    object STCF: Text8Pt
      Left = 31
      Top = 33
      Width = 106
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking or using the down but' +
        'ton will drill down to the record for this field. The up button ' +
        'will search for the nearest match.'
      HelpContext = 721
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = STCFExit
      TextId = 0
      ViaSBtn = False
      Link_to_Stock = True
      ShowHilight = True
    end
    object SDescF: Text8Pt
      Left = 142
      Top = 33
      Width = 186
      Height = 22
      Hint = 
        'Double click to drill down|Double clicking will drill down to th' +
        'e main record for this field.'
      HelpContext = 721
      TabStop = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      OnDblClick = SDescFDblClick
      TextId = 0
      ViaSBtn = False
    end
    object CurrF: TSBSComboBox
      Tag = 1
      Left = 275
      Top = 8
      Width = 53
      Height = 22
      HelpContext = 630
      Style = csDropDownList
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      MaxLength = 3
      ParentFont = False
      TabOrder = 4
      OnChange = CurrFChange
      ExtendedList = True
      MaxListWidth = 90
      Validate = True
    end
  end
  object SBSPanel3: TSBSPanel
    Left = 0
    Top = 67
    Width = 329
    Height = 122
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object PriceMemo: TMemo
      Left = 2
      Top = 2
      Width = 325
      Height = 118
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      OnDblClick = CompFDblClick
    end
  end
  object SBSPanel2: TSBSPanel
    Left = 0
    Top = 189
    Width = 329
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object OkCP1Btn: TButton
      Tag = 1
      Left = 85
      Top = 6
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = OkCP1BtnClick
    end
    object FrzeBtn: TButton
      Tag = 1
      Left = 171
      Top = 6
      Width = 80
      Height = 21
      Caption = '&Freeze'
      TabOrder = 1
      OnClick = FrzeBtnClick
    end
  end
end
