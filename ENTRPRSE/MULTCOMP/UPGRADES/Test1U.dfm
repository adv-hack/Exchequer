object Form1: TForm1
  Left = 422
  Top = 245
  Width = 466
  Height = 247
  BorderIcons = [biSystemMenu]
  Caption = 'Enterprise Manual Upgrade Interface'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 7
    Top = 9
    Width = 94
    Height = 14
    Caption = 'Company Data Path'
  end
  object Label2: TLabel
    Left = 33
    Top = 34
    Width = 68
    Height = 14
    Alignment = taRightJustify
    Caption = 'Version String'
  end
  object v432Pwbtn: TButton
    Left = 104
    Top = 61
    Width = 113
    Height = 25
    Caption = 'Call GEUpgrde'
    TabOrder = 0
    OnClick = v432PwbtnClick
  end
  object Edit1: TEdit
    Left = 105
    Top = 6
    Width = 308
    Height = 22
    TabOrder = 1
  end
  object Button1: TButton
    Left = 415
    Top = 5
    Width = 29
    Height = 24
    Caption = '...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 370
    Top = 139
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 10
    Top = 140
    Width = 75
    Height = 25
    Caption = '6.2 Index'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 90
    Top = 140
    Width = 168
    Height = 25
    Caption = 'AddJobAppsCustomFields'
    TabOrder = 5
    OnClick = Button4Click
  end
  object edtUpgradeVersion: TEdit
    Left = 105
    Top = 31
    Width = 50
    Height = 22
    TabOrder = 6
    Text = '7'
  end
  object Button5: TButton
    Left = 264
    Top = 140
    Width = 97
    Height = 25
    Caption = 'Expire Authoris-e'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 176
    Width = 105
    Height = 25
    Caption = 'Update Bank Rec'
    TabOrder = 8
    OnClick = Button6Click
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 418
    Top = 115
  end
end
