object MovWarnFrm: TMovWarnFrm
  Left = 312
  Top = 156
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Note!'
  ClientHeight = 471
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SBSPanel1: TSBSPanel
    Left = 7
    Top = 9
    Width = 262
    Height = 308
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 0
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 120
      Top = 22
      Width = 62
      Height = 16
      Caption = 'WARNING'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 67
      Top = 43
      Width = 179
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = 'Account Over Credit Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Image1: TImage
      Left = 10
      Top = 6
      Width = 53
      Height = 73
    end
    object Label83: Label8
      Left = 10
      Top = 86
      Width = 245
      Height = 215
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object SBSPanel2: TSBSPanel
      Left = 66
      Top = 6
      Width = 185
      Height = 77
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object CLMsgL: Label8
        Left = 3
        Top = 30
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 4
        Top = 9
        Width = 176
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'WARNING'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8
        Left = 3
        Top = 50
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'PLEASE READ BELOW'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 55
    Top = 446
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    Visible = False
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 142
    Top = 446
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
    Visible = False
  end
  object SBSPanel3: TSBSPanel
    Left = 7
    Top = 327
    Width = 262
    Height = 108
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 8
      Top = 8
      Width = 245
      Height = 41
      AutoSize = False
      Caption = 
        'By ticking the following options, you are accepting the recommen' +
        'ded conditions of performing this operation.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object cb1: TBorCheckEx
      Left = 10
      Top = 57
      Width = 227
      Height = 20
      Align = alRight
      Caption = 'All users logged out of the system'
      CheckColor = clWindowText
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      TextId = 0
      OnClick = cb1Click
    end
    object cb2: TBorCheckEx
      Left = 10
      Top = 78
      Width = 227
      Height = 20
      Align = alRight
      Caption = 'Precautionary back-up taken'
      CheckColor = clWindowText
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      TextId = 0
      OnClick = cb1Click
    end
  end
end
