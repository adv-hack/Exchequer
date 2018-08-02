object frmLicWorkgroup: TfrmLicWorkgroup
  Left = 398
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 4 of 7'
  ClientHeight = 223
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    406
    223)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 394
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Workgroup Engine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 125
    Width = 393
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please enter the 24 character alphanumeric Licence Key for the P' +
      'ervasive.SQL 8 Workgroup Engine in the field below.'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 7
    Top = 185
    Width = 389
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label10: TLabel
    Left = 18
    Top = 163
    Width = 18
    Height = 13
    Alignment = taRightJustify
    Caption = 'Key'
    OnClick = Label10Click
  end
  object Label1: TLabel
    Left = 8
    Top = 33
    Width = 394
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Select the version of the Pervasive.SQL Workgroup Engine to be s' +
      'upplied to the customer:'
    WordWrap = True
  end
  object btnNext: TButton
    Left = 318
    Top = 195
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Next >>'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 231
    Top = 195
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '<< &Previous'
    TabOrder = 1
    OnClick = btnPreviousClick
  end
  object edtLicence: TEdit
    Left = 41
    Top = 160
    Width = 328
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 24
    TabOrder = 0
  end
  object lstWGEEngine: TListBox
    Left = 20
    Top = 68
    Width = 292
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'NONE'
      'Pervasive.SQL Workgroup Engine')
    ParentFont = False
    TabOrder = 3
  end
end
