object ProgTForm: TProgTForm
  Left = 307
  Top = 212
  Cursor = crAppStart
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ObjectThread Controller'
  ClientHeight = 220
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object SBSBackGroup2: TSBSBackGroup
    Left = 2
    Top = 153
    Width = 289
    Height = 61
    TextId = 0
  end
  object SBSBackGroup1: TSBSBackGroup
    Left = 294
    Top = -3
    Width = 134
    Height = 217
    TextId = 0
  end
  object Label82: Label8
    Left = 300
    Top = 70
    Width = 123
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Job Queue for Threads'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label83: Label8
    Left = 10
    Top = 164
    Width = 271
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Speed Priority of Selected Thread'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object Label85: Label8
    Left = 302
    Top = 7
    Width = 121
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = 'Threads'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TextId = 0
  end
  object SBSPanel1: TSBSPanel
    Left = 2
    Top = 91
    Width = 289
    Height = 61
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 11
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 19
      Top = 6
      Width = 249
      Height = 24
      Alignment = taCenter
      AutoSize = False
      Caption = '% Complete of Selected Thread'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object barProgress: TAdvProgressBar
      Left = 9
      Top = 21
      Width = 269
      Height = 18
      CompletionSmooth = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      Infinite = True
      Level0ColorTo = 14811105
      Level1ColorTo = 13303807
      Level2Color = 5483007
      Level2ColorTo = 11064319
      Level3ColorTo = 13290239
      Level1Perc = 70
      Level2Perc = 90
      Position = 0
      ShowBorder = True
      ShowPercentage = False
      ShowPosition = False
      Steps = 20
      Version = '1.1.2.1'
      Visible = False
    end
    object SBSPanel2: TSBSPanel
      Left = 7
      Top = 31
      Width = 276
      Height = 23
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object Gauge1: TGauge
        Left = 1
        Top = 5
        Width = 272
        Height = 15
        BackColor = clBtnFace
        BorderStyle = bsNone
        Color = clBlack
        ForeColor = clAqua
        ParentColor = False
        Progress = 0
      end
    end
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 431
    Top = 4
    Width = 80
    Height = 22
    Hint = 
      'Abort current thread|Choosing this option will abort the current' +
      'ly running thread, as shown within the Threads box.'
    Cancel = True
    Caption = '&Abort'
    ModalResult = 3
    TabOrder = 5
    OnClick = CanCP1BtnClick
  end
  object ListBox1: TListBox
    Left = 299
    Top = 85
    Width = 124
    Height = 124
    Hint = 
      'List of waiting jobs|This box shows all the jobs currently waiti' +
      'ng for an available thread to process them. Specific jobs like r' +
      'eports belong to specific threads, reports are always processed ' +
      'by thread 2.'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 3
  end
  object SBSPanel3: TSBSPanel
    Left = 2
    Top = 2
    Width = 289
    Height = 86
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label1: Label8
      Left = 9
      Top = 4
      Width = 273
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label2: Label8
      Left = 8
      Top = 24
      Width = 273
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label3: Label8
      Left = 8
      Top = 40
      Width = 273
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label4: Label8
      Left = 8
      Top = 60
      Width = 273
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
  end
  object MU1Btn: TButton
    Tag = 1
    Left = 431
    Top = 85
    Width = 80
    Height = 22
    Hint = 
      'Move queue entry up|This button allows you to change the priorit' +
      'y of a waiting job so that it will start before the job above it' +
      '. Before using it, you must highlight the entry you wish to move' +
      ' up.'
    Caption = 'Move  &Up'
    TabOrder = 7
    OnClick = MU1BtnClick
  end
  object MD1Btn: TButton
    Tag = 1
    Left = 431
    Top = 110
    Width = 80
    Height = 22
    Hint = 
      'Move queue entry down|This button allows you to change the prior' +
      'ity of a waiting job so that it will start after the job below i' +
      't. Before using it, you must highlight the entry you wish to mov' +
      'e down.'
    Caption = 'Move D&own'
    TabOrder = 8
    OnClick = MU1BtnClick
  end
  object DelBtn: TButton
    Tag = 1
    Left = 431
    Top = 135
    Width = 80
    Height = 22
    Hint = 
      'Delete waiting job|This option removes the currently highlighted' +
      ' queue entry.'
    Caption = '&Delete'
    TabOrder = 9
    OnClick = DelBtnClick
  end
  object Thc1: TBorRadio
    Tag = 1
    Left = 301
    Top = 22
    Width = 121
    Height = 13
    Hint = 
      'Display thread 1|By clicking on the radio button you can display' +
      ' the details of the job running in thread 1.'
    Align = alRight
    CheckColor = clWindowText
    Checked = True
    Enabled = False
    GroupIndex = 1
    TabOrder = 0
    TabStop = True
    TextId = 0
    OnClick = Thc1Click
  end
  object Thc2: TBorRadio
    Tag = 2
    Left = 301
    Top = 37
    Width = 121
    Height = 13
    Hint = 
      'Display thread 2|By clicking on the radio button you can display' +
      ' the details of the job running in thread 2.'
    Align = alRight
    CheckColor = clWindowText
    Enabled = False
    GroupIndex = 1
    TabOrder = 1
    TextId = 0
    OnClick = Thc1Click
  end
  object Thc3: TBorRadio
    Tag = 3
    Left = 301
    Top = 52
    Width = 121
    Height = 13
    Hint = 
      'Display thread 3|By clicking on the radio button you can display' +
      ' the details of the job running in thread 3.'
    Align = alRight
    CheckColor = clWindowText
    Enabled = False
    GroupIndex = 1
    TabOrder = 2
    TextId = 0
    OnClick = Thc1Click
  end
  object TrackBar1: TTrackBar
    Left = 6
    Top = 177
    Width = 280
    Height = 33
    Hint = 
      'Change the speed of the current job|The more processing time a t' +
      'hread gets, the less time the main program gets.'
    LineSize = 2
    Max = 5
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 10
    TickMarks = tmTopLeft
    TickStyle = tsAuto
    OnChange = TrackBar1Change
  end
  object TermBtn: TButton
    Tag = 1
    Left = 431
    Top = 28
    Width = 80
    Height = 22
    Hint = 
      'Terminate current thread|Choosing this option will terminate the' +
      ' currently running thread. Use only when the thread apprears to ' +
      'have crashed, and abort has no effect.'
    Cancel = True
    Caption = '&Terminate'
    Enabled = False
    ModalResult = 3
    TabOrder = 6
    OnClick = TermBtnClick
  end
end
