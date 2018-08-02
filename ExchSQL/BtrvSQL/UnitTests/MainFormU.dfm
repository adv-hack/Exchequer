object MainForm: TMainForm
  Left = 388
  Top = 114
  Width = 681
  Height = 640
  Caption = 'BtrvSQL Unit Tests'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 589
    Height = 606
    Align = alClient
    TabOrder = 0
    object TestList: TCheckListBox
      Left = 1
      Top = 25
      Width = 587
      Height = 580
      Align = alClient
      ItemHeight = 16
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnDrawItem = TestListDrawItem
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 587
      Height = 24
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 1
      object RunningLbl: TLabel
        Left = 24
        Top = 5
        Width = 128
        Height = 13
        Caption = 'Running tests. Please wait.'
        Visible = False
      end
      object RunningAnim: TAnimate
        Left = 4
        Top = 4
        Width = 16
        Height = 16
        Active = False
        CommonAVI = aviFindComputer
        StopFrame = 8
        Visible = False
      end
    end
  end
  object ButtonPnl: TPanel
    Left = 589
    Top = 0
    Width = 84
    Height = 606
    Align = alRight
    TabOrder = 1
    object RunBtn: TButton
      Left = 6
      Top = 4
      Width = 75
      Height = 25
      Caption = '&Run'
      TabOrder = 0
      OnClick = RunBtnClick
    end
    object SelectAllBtn: TButton
      Left = 6
      Top = 36
      Width = 75
      Height = 25
      Caption = 'Select &all'
      TabOrder = 1
      OnClick = SelectAllBtnClick
    end
    object SelectNoneBtn: TButton
      Left = 6
      Top = 68
      Width = 75
      Height = 25
      Caption = 'Select &none'
      TabOrder = 2
      OnClick = SelectNoneBtnClick
    end
    object CloseBtn: TButton
      Left = 6
      Top = 100
      Width = 75
      Height = 25
      Caption = '&Close'
      TabOrder = 3
      OnClick = CloseBtnClick
    end
  end
end
