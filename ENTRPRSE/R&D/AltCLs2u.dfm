object AltCList: TAltCList
  Left = 704
  Top = 270
  Width = 449
  Height = 287
  HelpContext = 596
  Caption = 'Alternative Codes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object DPageCtrl1: TPageControl
    Left = 0
    Top = 0
    Width = 433
    Height = 248
    ActivePage = Altpage
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    OnChange = DPageCtrl1Change
    object Altpage: TTabSheet
      Caption = 'Supplier Code'
      object CSBox: TScrollBox
        Left = 5
        Top = 7
        Width = 290
        Height = 204
        VertScrollBar.Visible = False
        TabOrder = 0
        object CCPanel: TSBSPanel
          Left = 2
          Top = 24
          Width = 51
          Height = 160
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = CCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object PricPanel: TSBSPanel
          Left = 188
          Top = 24
          Width = 67
          Height = 160
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = CCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object CHedPanel: TSBSPanel
          Left = 2
          Top = 2
          Width = 257
          Height = 19
          BevelOuter = bvLowered
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object DescLab: TSBSPanel
            Left = 52
            Top = 3
            Width = 130
            Height = 14
            BevelOuter = bvNone
            Caption = 'Alternative Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = CCLabMouseDown
            OnMouseMove = CCLabMouseMove
            OnMouseUp = CCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object CCLab: TSBSPanel
            Left = 2
            Top = 3
            Width = 53
            Height = 14
            Alignment = taLeftJustify
            BevelOuter = bvNone
            Caption = 'A/C Code'
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = CCLabMouseDown
            OnMouseMove = CCLabMouseMove
            OnMouseUp = CCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object PricLab: TSBSPanel
            Left = 188
            Top = 3
            Width = 61
            Height = 14
            Alignment = taRightJustify
            BevelOuter = bvNone
            Caption = 'Price  '
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = CCLabMouseDown
            OnMouseMove = CCLabMouseMove
            OnMouseUp = CCPanelMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object DescPanel: TSBSPanel
          Left = 56
          Top = 24
          Width = 129
          Height = 160
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = CCPanelMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
      end
    end
    object EquivPage: TTabSheet
      HelpContext = 1577
      Caption = 'Equivalent'
      ImageIndex = 1
    end
    object SuperCPage: TTabSheet
      HelpContext = 1578
      Caption = 'Superseded by'
      ImageIndex = 2
    end
    object OppoPage: TTabSheet
      HelpContext = 1579
      Caption = 'Opportunity'
      ImageIndex = 3
    end
  end
  object CBtnPanel: TSBSPanel
    Left = 303
    Top = 23
    Width = 123
    Height = 218
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object CListBtnPanel: TSBSPanel
      Left = 2
      Top = 33
      Width = 18
      Height = 163
      BevelOuter = bvLowered
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
    object ClsCP1Btn: TButton
      Left = 22
      Top = 20
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = ClsCP1BtnClick
    end
    object CCBSBox: TScrollBox
      Left = 22
      Top = 70
      Width = 100
      Height = 146
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      object AddBtn: TButton
        Tag = 1
        Left = 0
        Top = 3
        Width = 80
        Height = 21
        Hint = 
          'Add a new CC/Dep record|Adds a new Cost Center/Department record' +
          ' to the current database. The entries are sorted in code order.'
        HelpContext = 597
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddBtnClick
      end
      object EditBtn: TButton
        Tag = 2
        Left = 0
        Top = 27
        Width = 80
        Height = 21
        Hint = 
          'Change exisiting Record|Allows the currently highlighted record ' +
          'to be changed.'
        HelpContext = 597
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object DelBtn: TButton
        Tag = 3
        Left = 0
        Top = 51
        Width = 80
        Height = 21
        Hint = 
          'Delete Record|Allows the currently highlighted record to be dele' +
          'ted.'
        HelpContext = 598
        Caption = '&Delete'
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object NteBtn: TButton
        Left = 0
        Top = 123
        Width = 80
        Height = 21
        Hint = 'Access Note Pad|Displays any notes attached to this record.'
        HelpContext = 88
        Caption = '&Notes'
        TabOrder = 5
        OnClick = NteBtnClick
      end
      object FindDb1Btn: TButton
        Left = 0
        Top = 75
        Width = 80
        Height = 21
        Hint = 
          'Find alternative code|Choosing this option allows you to find a ' +
          'stock record by its alternative code.'
        HelpContext = 599
        Caption = '&Find'
        TabOrder = 3
        OnClick = FindDb1BtnClick
      end
      object UCP1Btn: TButton
        Left = 0
        Top = 99
        Width = 80
        Height = 21
        Hint = 
          'Use re-order information|Use the reorder information from the cu' +
          'rrently highlighted alternative code on the re-order screen.'
        HelpContext = 616
        Caption = '&Use'
        TabOrder = 4
        Visible = False
        OnClick = UseBtn1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 370
    Top = 1
    object Add1: TMenuItem
      Tag = 1
      Caption = '&Add'
      OnClick = AddBtnClick
    end
    object Edit1: TMenuItem
      Tag = 2
      Caption = '&Edit'
      OnClick = AddBtnClick
    end
    object Delete1: TMenuItem
      Tag = 3
      Caption = '&Delete'
      OnClick = AddBtnClick
    end
    object Find1: TMenuItem
      Caption = '&Find'
      OnClick = FindDb1BtnClick
    end
    object Use1: TMenuItem
      Caption = '&Use'
      OnClick = UseBtn1Click
    end
    object Notes1: TMenuItem
      Caption = '&Notes'
      OnClick = NteBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
      OnClick = PropFlgClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
end
