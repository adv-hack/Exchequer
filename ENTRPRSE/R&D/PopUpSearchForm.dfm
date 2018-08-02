object ACPopUpList: TACPopUpList
  Left = 433
  Top = 196
  Width = 366
  Height = 349
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Search List'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object BtnPanel: TSBSPanel
    Left = 45
    Top = 270
    Width = 259
    Height = 33
    BevelOuter = bvNone
    PopupMenu = PopupMenu1
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object ListCanBttn: TButton
      Left = 131
      Top = 6
      Width = 80
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 0
      OnClick = ListCanBttnClick
    end
    object ListOkBttn: TButton
      Left = 44
      Top = 6
      Width = 80
      Height = 21
      Caption = '&OK'
      TabOrder = 1
      OnClick = ListCanBttnClick
    end
    object LeftSBtn: TBitBtn
      Left = 9
      Top = 5
      Width = 30
      Height = 24
      TabOrder = 2
      Visible = False
      OnClick = LeftSBtnClick
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        080000000000000100001F2E00001F2E000000010000000000008D4A00008D4B
        01008E4B02008E4B03008E4C040091500D0092500F0092510F0093510F009555
        1300955514009556140096561400995A1A009A5E1C009B5D23009B5E27009C5F
        29009D602B009D602C009D612D009E612E009E612F009E613000A36B3000A26C
        3000A36C3000A36C3200A8743C00AA774000AB794500AD7D4800AD7C4900AF7E
        4B00B0814E00A7835300A9855500AA865800AA865900AB875A00AC885B00AB89
        5F00AC895D00AC8A5F00B3855400B4875800B5885B009D8A6E009F8B71009C8C
        7800AD8A6000AD8A6100AE8D6100AE8E6300AF8E6300B88E6000B0906500C09A
        7200C19C7500C29E7700C39F7800C39F7A00FF00FF0095939200C8A78400CDB0
        9000D5BCA200D6BDA300D6BEA300D7BFA800D8C1A700DCC8B100F1E8DF00F8F4
        EF00FFFFFF000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000003E3F3F3F3F3F
        3F3F3F3F3F3F3F3F3F3E3F2F353838383838383838383835313F3F361D1D1D1D
        1D1D1D1D1D1D1D1D353F3F341A1A1D1C41461D1D1D1D1D1D383F3F2403040344
        4A4A401D1D1D1D1D383F3F260706424A4A481F1D1D1D1D1D383F3F2709434A4A
        4A39223737372C1C383F3F282D4A4A4A4A4A4A4A4A4A4A3C383F3F2A2E4A4A4A
        4A4A4A4A4A4A4A3C383F3F2B10454A4A493A21201E1D190E343F3F321412454A
        4A49180A05010000243F3F32161713454A4A3B0C07030000243F3F3316171712
        3D471B0C08030000243F3F2915161514110F0D0B06020000233F3F3029333232
        2B2A2827252424232F3F3E3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E}
    end
    object RightSBtn: TBitBtn
      Left = 215
      Top = 5
      Width = 30
      Height = 24
      TabOrder = 3
      Visible = False
      OnClick = LeftSBtnClick
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        080000000000000100001F2E00001F2E000000010000000000008D4A00008D4A
        01008E4B02008E4B03008E4C0400904E0A00914F0C00914F0D00924F0D009250
        0F0092511000945413009555130095551400985918009A5E1C009A5C21009C5E
        27009C5E28009C5F2A009D602B009D602C009D612D009E612E009E612F009E61
        3000A26A2F00A36B3000A26C3000A36C3000A8743C00AA774000AB794300AD7B
        4900AD7D4800AE7E4A00AF804D00A7835300A9855500A9855600AA865800AA86
        5900AB875A00AB885B00AC885B00AB895F00AC895D00AC895E00AD8A5F00B385
        5400B4875800B5895B009D8A6E009F8B71009C8C7800AD8A6000AD8A6100AE8D
        6100AE8E6300AF8E6300B88E6000B0906500BF9A7100C19C7400C29D7700C39F
        7800C39E7A00FF00FF0095939200C8A78400CDB09000D5BCA200D6BDA300D6BE
        A300D7BFA800D8C1A700DCC8B100F1E8DF00F8F4EF00FFFFFF00000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000434444444444
        4444444444444444444344363A3D3D3D3D3D3D3D3D3D3D3A3444443A1F1F1F1F
        1F1F1F1F1F1F1F1F3B44443D1F1F1F1F1F1F4B461E1F1D1D3944443D1F1F1F1F
        1F454F4F490204032744443D1F1F1F1F1F224D4F4F47090A2944443D1E313C3C
        3C243E4F4F4F480C2A44443D414F4F4F4F4F4F4F4F4F4F322C44443D414F4F4F
        4F4F4F4F4F4F4F332F4444390F1C1F2021233F4E4F4F4A113044442600000005
        0B1A4E4F4F4A141637444426000001070D404F4F4A1519183844442600000108
        0D1B4C421318191938444425000000060B0E1012151718172D44443425262628
        2A2B2E2F3737382D354443444444444444444444444444444443}
    end
  end
  object tcList: TTabControl
    Left = 8
    Top = 8
    Width = 329
    Height = 257
    TabOrder = 1
    Tabs.Strings = (
      'Customer'
      'Consumer')
    TabIndex = 1
    OnChange = tcListChange
    object ScrollBox1: TScrollBox
      Left = 4
      Top = 25
      Width = 297
      Height = 228
      VertScrollBar.Visible = False
      Align = alLeft
      TabOrder = 0
      object GenHedPanel: TSBSPanel
        Left = 1
        Top = 2
        Width = 464
        Height = 19
        BevelOuter = bvLowered
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumnHeader
        object ListCol2Lab: TSBSPanel
          Left = 120
          Top = 4
          Width = 173
          Height = 14
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 0
          OnMouseDown = ListCol1LabMouseDown
          OnMouseMove = ListCol1LabMouseMove
          OnMouseUp = ListCol1PanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object ListCol1Lab: TSBSPanel
          Left = 3
          Top = 4
          Width = 115
          Height = 14
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 1
          OnMouseDown = ListCol1LabMouseDown
          OnMouseMove = ListCol1LabMouseMove
          OnMouseUp = ListCol1PanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object lsLab: TSBSPanel
          Left = 294
          Top = 3
          Width = 54
          Height = 14
          BevelOuter = bvNone
          Caption = 'In Stk'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnMouseDown = ListCol1LabMouseDown
          OnMouseMove = ListCol1LabMouseMove
          OnMouseUp = ListCol1PanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object lfLab: TSBSPanel
          Left = 350
          Top = 3
          Width = 54
          Height = 14
          BevelOuter = bvNone
          Caption = 'Free'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Visible = False
          OnMouseDown = ListCol1LabMouseDown
          OnMouseMove = ListCol1LabMouseMove
          OnMouseUp = ListCol1PanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
        object loLab: TSBSPanel
          Left = 406
          Top = 3
          Width = 56
          Height = 14
          BevelOuter = bvNone
          Caption = 'On Ord'
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          Visible = False
          OnMouseDown = ListCol1LabMouseDown
          OnMouseMove = ListCol1LabMouseMove
          OnMouseUp = ListCol1PanelMouseUp
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
          Purpose = puBtrListColumnHeader
        end
      end
      object lsPanel: TSBSPanel
        Left = 296
        Top = 25
        Width = 53
        Height = 164
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnMouseUp = ListCol1PanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object lfPanel: TSBSPanel
        Left = 352
        Top = 25
        Width = 54
        Height = 164
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnMouseUp = ListCol1PanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object loPanel: TSBSPanel
        Left = 409
        Top = 25
        Width = 53
        Height = 164
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
        OnMouseUp = ListCol1PanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object ListCol2Panel: TSBSPanel
        Left = 120
        Top = 25
        Width = 173
        Height = 180
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnMouseUp = ListCol1PanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
      object ListCol1Panel: TSBSPanel
        Left = 1
        Top = 25
        Width = 116
        Height = 180
        BevelOuter = bvLowered
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnMouseUp = ListCol1PanelMouseUp
        AllowReSize = True
        IsGroupBox = False
        TextId = 0
        Purpose = puBtrListColumn
      end
    end
    object ListBtnPanel: TSBSPanel
      Left = 302
      Top = 55
      Width = 18
      Height = 161
      BevelOuter = bvLowered
      PopupMenu = PopupMenu1
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 436
    Top = 117
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
