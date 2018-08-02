inherited PostFilt: TPostFilt
  Left = 128
  Top = 206
  HelpContext = 716
  Caption = 'Posting Transaction Selection'
  ClientHeight = 346
  ClientWidth = 450
  PixelsPerInch = 96
  TextHeight = 14
  inherited SBSPanel4: TSBSBackGroup
    Left = 4
    Top = 1
    Width = 442
    Height = 229
  end
  object Label81: Label8 [1]
    Left = 22
    Top = 21
    Width = 152
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Include in Posting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  object Label82: Label8 [2]
    Left = 275
    Top = 21
    Width = 152
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Exclude from Posting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TextId = 0
  end
  inherited OkCP1Btn: TButton
    Left = 100
    Top = 237
    TabOrder = 9
  end
  inherited ClsCP1Btn: TButton
    Left = 185
    Top = 237
    TabOrder = 10
  end
  inherited SBSPanel1: TSBSPanel
    Left = 298
    Top = 122
    TabOrder = 0
  end
  object Inc1: TButton
    Left = 187
    Top = 56
    Width = 75
    Height = 25
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Inc1Click
  end
  object IncList: TListBox
    Left = 19
    Top = 38
    Width = 157
    Height = 153
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MultiSelect = True
    ParentFont = False
    Sorted = True
    TabOrder = 8
    OnDblClick = Inc1Click
    OnDragDrop = IncListDragDrop
    OnDragOver = IncListDragOver
  end
  object IncAll: TButton
    Left = 187
    Top = 86
    Width = 75
    Height = 25
    Caption = '>>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Inc1Click
  end
  object Exc1: TButton
    Left = 187
    Top = 122
    Width = 75
    Height = 25
    Caption = '<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Exc1Click
  end
  object ExcAll: TButton
    Left = 187
    Top = 152
    Width = 75
    Height = 25
    Caption = '<<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Exc1Click
  end
  object ExcList: TListBox
    Left = 272
    Top = 38
    Width = 157
    Height = 153
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    MultiSelect = True
    ParentFont = False
    Sorted = True
    TabOrder = 7
    OnDblClick = Exc1Click
    OnDragDrop = IncListDragDrop
    OnDragOver = IncListDragOver
  end
  object ProModeChk: TBorCheck
    Left = 18
    Top = 200
    Width = 157
    Height = 20
    HelpContext = 717
    Caption = 'Use Protected Mode Posting'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    TextId = 0
    OnMouseUp = ProModeChkMouseUp
  end
  object SepPModeChk: TBorCheck
    Left = 261
    Top = 200
    Width = 173
    Height = 20
    HelpContext = 609
    Caption = 'Separate Posting Control entries'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    TextId = 0
    OnMouseUp = SepPModeChkMouseUp
  end
  object panTrialBalanceWarning: TPanel
    Left = 0
    Top = 272
    Width = 450
    Height = 25
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    Visible = False
    object lblTrialBalanceWarning: TLabel
      Left = 207
      Top = 5
      Width = 150
      Height = 16
      Alignment = taRightJustify
      Caption = 'lblTrialBalanceWarning'
    end
    object btnMoreInfo: TButton
      Tag = 1
      Left = 364
      Top = 2
      Width = 80
      Height = 21
      Caption = '&More Info'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnMoreInfoClick
    end
  end
  object btnSchedule: TSBSButton
    Left = 270
    Top = 237
    Width = 80
    Height = 21
    HelpContext = 40166
    Caption = '&Schedule'
    TabOrder = 12
    OnClick = btnScheduleClick
    TextId = 0
  end
  object panSQLPostingNotification: TPanel
    Left = 0
    Top = 298
    Width = 450
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 13
    Visible = False
    DesignSize = (
      450
      48)
    object shSQLPostingNotification: TShape
      Left = 5
      Top = 12
      Width = 440
      Height = 31
      Anchors = [akLeft, akTop, akRight, akBottom]
      Brush.Color = clAqua
      Pen.Color = clAqua
      Shape = stRoundRect
    end
    object lblInfo: TLabel
      Left = 14
      Top = 9
      Width = 7
      Height = 34
      Caption = 'i'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 34
      Top = 21
      Width = 311
      Height = 15
      Caption = 'The SQL Edition Posting Optimisations are not enabled.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblSQLPostingNotificationMoreInfo: TLabel
      Left = 381
      Top = 21
      Width = 53
      Height = 15
      Cursor = crHandPoint
      Caption = 'More Info'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      Transparent = True
      OnClick = lblSQLPostingNotificationMoreInfoClick
    end
  end
end
