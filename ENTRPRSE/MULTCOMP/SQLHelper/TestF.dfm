object Form1: TForm1
  Left = 329
  Top = 181
  Width = 870
  Height = 500
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 66
    Top = 11
    Width = 65
    Height = 13
    Alignment = taRightJustify
    Caption = 'SQLSERVER'
  end
  object Label2: TLabel
    Left = 71
    Top = 35
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_MAINDIR'
  end
  object Label3: TLabel
    Left = 56
    Top = 59
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_DEMODATA'
  end
  object Label4: TLabel
    Left = 50
    Top = 83
    Width = 80
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_SQLDBNAME'
  end
  object Label5: TLabel
    Left = 57
    Top = 382
    Width = 72
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_DLLERROR'
  end
  object Label6: TLabel
    Left = 37
    Top = 406
    Width = 92
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_SQLCREATEDB'
  end
  object Label7: TLabel
    Left = 99
    Top = 358
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'Result'
  end
  object Label8: TLabel
    Left = 34
    Top = 125
    Width = 96
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_GETCOMPCODE'
  end
  object Label9: TLabel
    Left = 33
    Top = 151
    Width = 97
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_GETCOMPNAME'
  end
  object Label10: TLabel
    Left = 74
    Top = 175
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'SQL_DATA'
  end
  object Label11: TLabel
    Left = 67
    Top = 200
    Width = 63
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_COMPDIR'
  end
  object Label12: TLabel
    Left = 40
    Top = 223
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'SQL_USERLOGIN'
  end
  object Label13: TLabel
    Left = 45
    Top = 247
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'SQL_USERPASS'
  end
  object Label14: TLabel
    Left = 21
    Top = 430
    Width = 108
    Height = 13
    Alignment = taRightJustify
    Caption = 'V_SQLCREATECOMP'
  end
  object edtVMainDir: TEdit
    Left = 133
    Top = 32
    Width = 219
    Height = 21
    TabOrder = 0
    Text = 'C:\Exch600.BMTDEV1\'
  end
  object edtVDemoData: TEdit
    Left = 133
    Top = 56
    Width = 39
    Height = 21
    TabOrder = 1
    Text = '1'
  end
  object edtV_SQLDBNAME: TEdit
    Left = 133
    Top = 80
    Width = 399
    Height = 21
    TabOrder = 2
    Text = 'ExchMarkH'
  end
  object edtVDLLERROR: TEdit
    Left = 132
    Top = 379
    Width = 118
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object edtVSQLCREATEDB: TEdit
    Left = 132
    Top = 403
    Width = 399
    Height = 21
    TabOrder = 4
  end
  object cbSQLSERVER: TComboBox
    Left = 133
    Top = 8
    Width = 219
    Height = 21
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 5
    Text = 'IRIS-6CB13B02D4\IRISSOFTWARE'
    Items.Strings = (
      'BMTDEV1'
      'IRIS-6CB13B02D4\IRISSOFTWARE')
  end
  object btnCreateDatabase: TButton
    Left = 630
    Top = 5
    Width = 148
    Height = 25
    Caption = 'Create Database'
    TabOrder = 6
    OnClick = btnCreateDatabaseClick
  end
  object edtResult: TEdit
    Left = 132
    Top = 355
    Width = 118
    Height = 21
    TabOrder = 7
  end
  object btnCreateCompany: TButton
    Left = 628
    Top = 143
    Width = 148
    Height = 25
    Caption = 'Create Company'
    TabOrder = 8
    OnClick = btnCreateCompanyClick
  end
  object edtV_GETCOMPCODE: TEdit
    Left = 133
    Top = 122
    Width = 102
    Height = 21
    TabOrder = 9
    Text = 'ROOT01'
  end
  object edtV_GETCOMPNAME: TEdit
    Left = 133
    Top = 148
    Width = 248
    Height = 21
    TabOrder = 10
    Text = 'Root Kits Ltd'
  end
  object edtSQL_DATA: TEdit
    Left = 133
    Top = 172
    Width = 393
    Height = 21
    TabOrder = 11
    Text = 'S:\ExchCD\CDImage\ENTRPRSE\SQLData\Blank_MC\baseMC.zip'
  end
  object edtV_COMPDIR: TEdit
    Left = 133
    Top = 197
    Width = 219
    Height = 21
    TabOrder = 12
    Text = 'C:\Exch600.BMTDEV1\'
  end
  object edtSQL_USERLOGIN: TEdit
    Left = 133
    Top = 220
    Width = 219
    Height = 21
    TabOrder = 13
    Text = 'EXCHMARKH_LOGIN'
  end
  object edtSQL_USERPASS: TEdit
    Left = 133
    Top = 244
    Width = 219
    Height = 21
    TabOrder = 14
    Text = 'ABCdef_123'
  end
  object chkDebugMode: TCheckBox
    Left = 632
    Top = 39
    Width = 97
    Height = 17
    Caption = 'Debug Mode'
    TabOrder = 15
  end
  object edtV_SQLCREATECOMP: TEdit
    Left = 132
    Top = 427
    Width = 399
    Height = 21
    TabOrder = 16
  end
  object btnAdminPassword: TButton
    Left = 634
    Top = 415
    Width = 137
    Height = 25
    Caption = 'Admin Password'
    TabOrder = 17
    OnClick = btnAdminPasswordClick
  end
end
