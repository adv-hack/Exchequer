object frmVRWAlign: TfrmVRWAlign
  Left = 328
  Top = 107
  HelpContext = 16
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Alignment'
  ClientHeight = 186
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object btnOk: TButton
    Left = 150
    Top = 160
    Width = 80
    Height = 21
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 234
    Top = 160
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HorizontalGrp: TGroupBox
    Left = 4
    Top = 4
    Width = 152
    Height = 149
    Caption = ' Horizontal  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object chkHorzNoChange: TBorRadio
      Tag = 1
      Left = 8
      Top = 14
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&No change'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHorzLeft: TBorRadio
      Tag = 2
      Left = 8
      Top = 41
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&Left sides'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHorzRight: TBorRadio
      Tag = 3
      Left = 8
      Top = 68
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&Right sides'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHorzEqual: TBorRadio
      Tag = 4
      Left = 8
      Top = 95
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&Space equally'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkHorzRegionCentre: TBorRadio
      Tag = 5
      Left = 8
      Top = 122
      Width = 133
      Height = 20
      Align = alRight
      Caption = 'Centre in re&gion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TextId = 0
      OnClick = OnCheckClick
    end
  end
  object VerticalGrp: TGroupBox
    Left = 161
    Top = 4
    Width = 151
    Height = 149
    Caption = ' Vertical  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object chkVertNoChange: TBorRadio
      Tag = 6
      Left = 8
      Top = 14
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&No change'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkVertTop: TBorRadio
      Tag = 7
      Left = 8
      Top = 41
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&Tops'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkVertBottom: TBorRadio
      Tag = 8
      Left = 8
      Top = 68
      Width = 133
      Height = 20
      Align = alRight
      Caption = '&Bottoms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkVertEqual: TBorRadio
      Tag = 9
      Left = 8
      Top = 95
      Width = 133
      Height = 20
      Align = alRight
      Caption = 'S&pace equally'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TextId = 0
      OnClick = OnCheckClick
    end
    object chkVertRegionCentre: TBorRadio
      Tag = 10
      Left = 8
      Top = 122
      Width = 133
      Height = 20
      Align = alRight
      Caption = 'Centre &in region'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      TextId = 0
      OnClick = OnCheckClick
    end
  end
end
