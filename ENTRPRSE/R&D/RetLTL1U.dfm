object RetLTList: TRetLTList
  Left = 347
  Top = 258
  Width = 441
  Height = 376
  HelpContext = 1582
  Caption = 'Returns Line Type Reasons'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
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
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 421
    Height = 333
    ActivePage = ItemPage
    TabIndex = 0
    TabOrder = 0
    object ItemPage: TTabSheet
      Caption = 'Line Reasons'
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
          Width = 264
          Height = 17
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
          object PDescLab: TSBSPanel
            Left = 53
            Top = 2
            Width = 195
            Height = 13
            BevelOuter = bvNone
            Caption = 'Description'
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
            Width = 37
            Height = 13
            BevelOuter = bvNone
            Caption = 'No.'
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
        end
        object PYNPanel: TSBSPanel
          Left = 4
          Top = 23
          Width = 49
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
          Left = 56
          Top = 23
          Width = 197
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
      TabOrder = 1
      object AddBtn: TButton
        Tag = 1
        Left = 2
        Top = 1
        Width = 80
        Height = 21
        Hint = 
          'Add Next Return Line Reason|Allows the addition of the next Retu' +
          'rns Line Reason'
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
          'Edit Return Line Reason|Allows the editing of the currently high' +
          'lighted Returns Line Reason Record'
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
          'Delete Return Line Reason|Allows the deletion of the currently h' +
          'ighlighted Return Reason code'
        Caption = '&Delete'
        TabOrder = 2
        Visible = False
        OnClick = AddBtnClick
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
      TabOrder = 0
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
      Visible = False
      OnClick = AddBtnClick
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
      Caption = '&Store Coordinates'
      Hint = 'Make the current window settings permanent'
      OnClick = StoreCoordFlgClick
    end
  end
end
