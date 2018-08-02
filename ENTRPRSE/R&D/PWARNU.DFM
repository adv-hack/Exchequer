object PassWLock: TPassWLock
  Left = 253
  Top = 130
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 123
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 0
    Width = 256
    Height = 123
    Align = alClient
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object SBSPanel2: TSBSPanel
      Left = 68
      Top = 8
      Width = 185
      Height = 75
      BevelInner = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Label81: Label8
        Left = 28
        Top = 14
        Width = 123
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Password check.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 4
        Top = 34
        Width = 177
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = 'That option is not available.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object SBSPanel3: TSBSPanel
      Left = 4
      Top = 8
      Width = 59
      Height = 75
      BevelInner = bvLowered
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Image1: TImage
        Left = 2
        Top = 8
        Width = 53
        Height = 69
      end
    end
    object OKBtn: TButton
      Left = 97
      Top = 93
      Width = 75
      Height = 21
      Cancel = True
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 2
      OnClick = OKBtnClick
    end
  end
  object Timer1: TTimer
    Interval = 6000
    OnTimer = Timer1Timer
    Left = 64
    Top = 4
  end
end
