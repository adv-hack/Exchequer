object MoveLTList: TMoveLTList
  Left = 376
  Top = 134
  Width = 433
  Height = 365
  HelpContext = 1582
  Caption = 'Move Control : G/L Records'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 421
    Height = 333
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    object ItemPage: TTabSheet
      Caption = 'Move G/L List'
      object PListBtnPanel: TSBSPanel
        Left = 285
        Top = 28
        Width = 18
        Height = 254
        BevelOuter = bvLowered
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
      end
      object D1SBox: TScrollBox
        Left = 3
        Top = 5
        Width = 275
        Height = 297
        VertScrollBar.Visible = False
        TabOrder = 1
        object PHedPanel: TSBSPanel
          Left = 4
          Top = 4
          Width = 630
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object PDescLab: TSBSPanel
            Left = 125
            Top = 2
            Width = 148
            Height = 13
            BevelOuter = bvNone
            Caption = 'Move From Description'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            OnMouseDown = PYNLabMouseDown
            OnMouseMove = PYNLabMouseMove
            OnMouseUp = PYNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object PYNLab: TSBSPanel
            Left = 4
            Top = 2
            Width = 119
            Height = 13
            BevelOuter = bvNone
            Caption = 'Move'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 1
            OnMouseDown = PYNLabMouseDown
            OnMouseMove = PYNLabMouseMove
            OnMouseUp = PYNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object PToLab: TSBSPanel
            Left = 275
            Top = 2
            Width = 124
            Height = 13
            BevelOuter = bvNone
            Caption = 'To'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            OnMouseDown = PYNLabMouseDown
            OnMouseMove = PYNLabMouseMove
            OnMouseUp = PYNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object PToDescLab: TSBSPanel
            Left = 398
            Top = 2
            Width = 148
            Height = 13
            BevelOuter = bvNone
            Caption = 'Move To Description'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            OnMouseDown = PYNLabMouseDown
            OnMouseMove = PYNLabMouseMove
            OnMouseUp = PYNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
          object PTypeLab: TSBSPanel
            Left = 549
            Top = 2
            Width = 68
            Height = 13
            BevelOuter = bvNone
            Caption = 'Type'
            Color = clWhite
            Ctl3D = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 4
            OnMouseDown = PYNLabMouseDown
            OnMouseMove = PYNLabMouseMove
            OnMouseUp = PYNLabMouseUp
            AllowReSize = False
            IsGroupBox = False
            TextId = 0
            Purpose = puBtrListColumnHeader
          end
        end
        object PYNPanel: TSBSPanel
          Left = 4
          Top = 23
          Width = 124
          Height = 254
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnMouseUp = PYNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object PDescPanel: TSBSPanel
          Left = 130
          Top = 23
          Width = 145
          Height = 254
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnMouseUp = PYNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumn
        end
        object PToPanel: TSBSPanel
          Left = 277
          Top = 23
          Width = 124
          Height = 254
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnMouseUp = PYNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object PToDescPanel: TSBSPanel
          Left = 403
          Top = 23
          Width = 145
          Height = 254
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnMouseUp = PYNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
        object PTypePanel: TSBSPanel
          Left = 550
          Top = 23
          Width = 74
          Height = 254
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnMouseUp = PYNLabMouseUp
          AllowReSize = True
          IsGroupBox = False
          TextId = 0
        end
      end
    end
  end
  object PBtnPanel: TSBSPanel
    Left = 312
    Top = 29
    Width = 102
    Height = 297
    BevelOuter = bvNone
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object P1BSBox: TScrollBox
      Left = 0
      Top = 127
      Width = 99
      Height = 167
      HorzScrollBar.Visible = False
      BorderStyle = bsNone
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      object AddBtn: TButton
        Tag = 1
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add Move Control Record|Allows the addition of a Move Control Li' +
          'ne'
        Caption = '&Add'
        TabOrder = 0
        OnClick = AddBtnClick
      end
      object EditBtn: TButton
        Tag = 2
        Left = 2
        Top = 26
        Width = 80
        Height = 21
        Hint = 
          'Edit Move Control Line|Allows the editing of the currently highl' +
          'ighted Move Control Line'
        Caption = '&Edit'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object DelBtn: TButton
        Tag = 3
        Left = 2
        Top = 51
        Width = 80
        Height = 21
        Hint = 
          'Delete Move Control Line|Allows the deletion of the currently hi' +
          'ghlighted Move Control Line'
        Caption = '&Delete'
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object ProBtn: TButton
        Tag = 3
        Left = 2
        Top = 77
        Width = 80
        Height = 21
        Hint = 
          'Process List of Move Actions|Begins the processing of the Move C' +
          'ontrol Records'
        Caption = '&Process'
        TabOrder = 3
        OnClick = ProBtnClick
      end
    end
    object Clsd1Btn: TButton
      Left = 2
      Top = 3
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = Clsd1BtnClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 334
    Top = 65531
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
    object Process1: TMenuItem
      Caption = 'P&rocess'
      OnClick = ProBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PropFlg: TMenuItem
      Caption = '&Properties'
      HelpContext = 65
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
