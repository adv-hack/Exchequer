object UpgradeForm: TUpgradeForm
  Left = 625
  Top = 83
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Upgrade Notes'
  ClientHeight = 610
  ClientWidth = 887
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    887
    610)
  PixelsPerInch = 96
  TextHeight = 14
  object db1SBox: TScrollBox
    Left = 3
    Top = 0
    Width = 878
    Height = 607
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    PopupMenu = PopupMenu1
    TabOrder = 0
    DesignSize = (
      878
      607)
    object HTMLPNL1: TPanel
      Left = 5
      Top = -2
      Width = 869
      Height = 577
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      PopupMenu = PopupMenu1
      TabOrder = 0
      object WebBrowser1: TWebBrowser
        Left = 5
        Top = 7
        Width = 855
        Height = 559
        PopupMenu = PopupMenu1
        TabOrder = 0
        ControlData = {
          4C0000005E580000C63900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object ButtonPNL1: TPanel
      Left = 4
      Top = 576
      Width = 870
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      PopupMenu = PopupMenu1
      TabOrder = 1
      DesignSize = (
        870
        25)
      object Button_Ok: TButton
        Left = 415
        Top = 1
        Width = 80
        Height = 21
        Anchors = [akTop, akBottom]
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 0
        OnClick = Button_OkClick
      end
      object ShowInfoAgainCBX1: TCheckBox
        Left = 2
        Top = 7
        Width = 205
        Height = 17
        Anchors = [akLeft]
        Caption = 'Do not show this information again'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 800
    Top = 368
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      OnClick = StoreCoordFlgClick
    end
  end
end
