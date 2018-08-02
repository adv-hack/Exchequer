object frmMain: TfrmMain
  Left = 199
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Demo Data Date Updater'
  ClientHeight = 205
  ClientWidth = 378
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
  object pnlProgress: TPanel
    Left = 16
    Top = 112
    Width = 265
    Height = 89
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 44
      Height = 13
      Caption = 'Progress:'
    end
    object lblProgress: TLabel
      Left = 24
      Top = 32
      Width = 51
      Height = 13
      Caption = 'lblProgress'
    end
  end
  object Panel2: TPanel
    Left = 16
    Top = 8
    Width = 265
    Height = 97
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 48
      Height = 13
      Caption = 'Data Path'
    end
    object SpeedButton1: TSpeedButton
      Left = 216
      Top = 24
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 126
      Height = 13
      Caption = 'Increment Dates by (years)'
    end
    object edtDataPath: TEdit
      Left = 8
      Top = 24
      Width = 209
      Height = 21
      TabOrder = 0
      Text = 'edtDataPath'
      OnExit = edtDataPathExit
    end
    object UpDown1: TUpDown
      Left = 137
      Top = 68
      Width = 16
      Height = 21
      Associate = edtYears
      Min = 1
      Position = 1
      TabOrder = 1
      Wrap = False
    end
    object edtYears: TEdit
      Left = 8
      Top = 68
      Width = 129
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '1'
    end
    object edtTest: TEdit
      Left = 160
      Top = 68
      Width = 81
      Height = 21
      TabOrder = 3
      Text = '0'
      Visible = False
    end
  end
  object btnUpdate: TButton
    Left = 288
    Top = 8
    Width = 80
    Height = 21
    Caption = '&Update'
    Enabled = False
    TabOrder = 2
    OnClick = btnUpdateClick
  end
  object btnClose: TButton
    Left = 288
    Top = 32
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object Button1: TButton
    Left = 288
    Top = 56
    Width = 80
    Height = 21
    Caption = '&Test'
    TabOrder = 4
    Visible = False
  end
  object Button2: TButton
    Left = 288
    Top = 80
    Width = 80
    Height = 21
    Caption = 'Trim History'
    TabOrder = 5
    Visible = False
  end
  object chkCancel: TCheckBox
    Left = 288
    Top = 184
    Width = 97
    Height = 17
    Caption = 'Cancel'
    TabOrder = 6
  end
  object Button3: TButton
    Left = 288
    Top = 56
    Width = 80
    Height = 21
    Caption = 'Check History'
    TabOrder = 7
    Visible = False
  end
  object Button4: TButton
    Left = 288
    Top = 144
    Width = 80
    Height = 21
    Caption = 'Check Btrieve'
    TabOrder = 8
    Visible = False
  end
end
