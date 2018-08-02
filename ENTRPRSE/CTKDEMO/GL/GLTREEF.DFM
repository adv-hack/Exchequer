object frmGeneralLedger: TfrmGeneralLedger
  Left = 224
  Top = 120
  Width = 476
  Height = 444
  Caption = 'Enterprise COM Toolkit - General Ledger'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lstGLCodes: TListBox
    Left = 6
    Top = 7
    Width = 369
    Height = 404
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnDblClick = btnViewGLClick
  end
  object btnAddGL: TButton
    Left = 381
    Top = 12
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Add'
    TabOrder = 1
    OnClick = btnAddGLClick
  end
  object btnEditGL: TButton
    Left = 381
    Top = 38
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Edit'
    TabOrder = 2
    OnClick = btnEditGLClick
  end
  object btnViewGL: TButton
    Left = 381
    Top = 64
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&View'
    TabOrder = 3
    OnClick = btnViewGLClick
  end
end
