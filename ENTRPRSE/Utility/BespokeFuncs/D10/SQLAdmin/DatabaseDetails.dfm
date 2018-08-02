object frmDatabaseDetails: TfrmDatabaseDetails
  Left = 462
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Database Details'
  ClientHeight = 381
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 409
    Height = 145
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 19
    Top = 28
    Width = 66
    Height = 14
    Caption = 'Plug-In Code :'
  end
  object Label2: TLabel
    Left = 19
    Top = 60
    Width = 60
    Height = 14
    Caption = 'Description :'
  end
  object Label3: TLabel
    Left = 19
    Top = 92
    Width = 52
    Height = 14
    Caption = 'Database :'
  end
  object Label5: TLabel
    Left = 19
    Top = 124
    Width = 86
    Height = 14
    Caption = 'Database Status :'
  end
  object lDBStatus: TLabel
    Left = 112
    Top = 124
    Width = 71
    Height = 14
    Caption = '(not created)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bev1: TBevel
    Left = 10
    Top = 168
    Width = 407
    Height = 177
    Shape = bsFrame
  end
  object Label4: TLabel
    Left = 16
    Top = 160
    Width = 89
    Height = 14
    Caption = 'Creation Scripts'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edCode: TEdit
    Left = 112
    Top = 24
    Width = 297
    Height = 22
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 0
    OnExit = edCodeExit
  end
  object edDesc: TEdit
    Left = 112
    Top = 56
    Width = 297
    Height = 22
    TabOrder = 1
  end
  object edDatabase: TEdit
    Left = 112
    Top = 88
    Width = 297
    Height = 22
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 336
    Top = 352
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 248
    Top = 352
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCreateDelete: TButton
    Left = 331
    Top = 120
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Delete'
    TabOrder = 5
    Visible = False
    OnClick = btnCreateDeleteClick
  end
  object lbScripts: TListBox
    Left = 16
    Top = 184
    Width = 305
    Height = 153
    ItemHeight = 14
    TabOrder = 6
    OnDblClick = lbScriptsDblClick
  end
  object btnAdd: TButton
    Left = 331
    Top = 183
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 7
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 331
    Top = 207
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 8
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 331
    Top = 231
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 9
    OnClick = btnDeleteClick
  end
  object btnRunScripts: TButton
    Left = 331
    Top = 279
    Width = 80
    Height = 21
    Caption = '&Run Scripts'
    TabOrder = 10
    OnClick = btnRunScriptsClick
  end
  object btnView: TButton
    Left = 331
    Top = 255
    Width = 80
    Height = 21
    Caption = '&View'
    TabOrder = 11
    OnClick = btnViewClick
  end
end
