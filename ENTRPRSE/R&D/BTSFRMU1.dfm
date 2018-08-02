object BTWaitLock: TBTWaitLock
  Left = 605
  Top = 240
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 126
  ClientWidth = 270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object SBSPanel1: TSBSPanel
    Left = 0
    Top = 0
    Width = 270
    Height = 126
    Align = alClient
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Image1: TImage
      Left = 10
      Top = 17
      Width = 53
      Height = 58
    end
    object SBSPanel2: TSBSPanel
      Left = 68
      Top = 8
      Width = 188
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
        Left = 32
        Top = 11
        Width = 121
        Height = 15
        Caption = 'Record lock detected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label82: Label8
        Left = 6
        Top = 32
        Width = 177
        Height = 15
        Alignment = taCenter
        Caption = 'Waiting for another user to finish'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label83: Label8
        Left = 7
        Top = 50
        Width = 86
        Height = 15
        Alignment = taCenter
        Caption = 'with this record.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
    end
    object SBSPanel4: TSBSPanel
      Left = 8
      Top = 88
      Width = 250
      Height = 30
      BevelInner = bvLowered
      TabOrder = 1
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      Purpose = puFrame
    end
    object AbortBtn: TButton
      Left = 94
      Top = 123
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Abort'
      ModalResult = 2
      TabOrder = 2
      Visible = False
      OnClick = AbortBtnClick
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 232
    Top = 2
  end
end
