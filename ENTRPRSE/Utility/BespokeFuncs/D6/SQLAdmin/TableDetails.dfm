object frmTableDetails: TfrmTableDetails
  Left = 388
  Top = 227
  BorderStyle = bsDialog
  Caption = 'Table Details'
  ClientHeight = 341
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object bev1: TBevel
    Left = 8
    Top = 128
    Width = 337
    Height = 177
    Shape = bsFrame
  end
  object bev2: TBevel
    Left = 8
    Top = 8
    Width = 337
    Height = 105
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 19
    Top = 28
    Width = 62
    Height = 14
    Caption = 'Table Name :'
  end
  object Label3: TLabel
    Left = 19
    Top = 60
    Width = 86
    Height = 14
    Caption = 'Parent Database :'
  end
  object Label4: TLabel
    Left = 16
    Top = 120
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
  object lParentDBase: TLabel
    Left = 112
    Top = 60
    Width = 73
    Height = 14
    Caption = 'lParentDBase'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 19
    Top = 84
    Width = 66
    Height = 14
    Caption = 'Table Status :'
  end
  object lTableStatus: TLabel
    Left = 112
    Top = 84
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
  object edName: TEdit
    Left = 112
    Top = 24
    Width = 225
    Height = 22
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 264
    Top = 312
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Ca&ncel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 176
    Top = 312
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCreate: TButton
    Left = 257
    Top = 80
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Delete'
    TabOrder = 3
  end
  object lbScripts: TListBox
    Left = 16
    Top = 144
    Width = 233
    Height = 153
    ItemHeight = 14
    TabOrder = 4
    OnDblClick = lbScriptsDblClick
  end
  object btnAdd: TButton
    Left = 258
    Top = 143
    Width = 80
    Height = 21
    Caption = '&Add'
    TabOrder = 5
    OnClick = btnAddClick
  end
  object btnEdit: TButton
    Left = 258
    Top = 167
    Width = 80
    Height = 21
    Caption = '&Edit'
    TabOrder = 6
    OnClick = btnEditClick
  end
  object btnDelete: TButton
    Left = 258
    Top = 191
    Width = 80
    Height = 21
    Caption = '&Delete'
    TabOrder = 7
    OnClick = btnDeleteClick
  end
  object btnRunScripts: TButton
    Left = 258
    Top = 239
    Width = 80
    Height = 21
    Caption = '&Run Scripts'
    TabOrder = 8
    OnClick = btnRunScriptsClick
  end
  object btnView: TButton
    Left = 258
    Top = 215
    Width = 80
    Height = 21
    Caption = '&View'
    TabOrder = 9
    OnClick = btnViewClick
  end
end
