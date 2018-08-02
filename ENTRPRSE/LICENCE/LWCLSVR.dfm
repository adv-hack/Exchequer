object frmLicWiz7: TfrmLicWiz7
  Left = 432
  Top = 275
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'CD Licencing Wizard - Step 4 of 7'
  ClientHeight = 304
  ClientWidth = 342
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
    342
    304)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 330
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Client-Server Engine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 33
    Width = 329
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Select the version of the Pervasive.SQL Client-Server Engine to ' +
      'be supplied to the customer:'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 7
    Top = 266
    Width = 325
    Height = 4
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 149
    Width = 329
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Select the user count of the Client-Server Engine'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 8
    Top = 208
    Width = 330
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Please enter the 24 character alphanumeric Licence Key for the P' +
      'ervasive.SQL Client-Server Engine in the field below.'
    WordWrap = True
  end
  object Label10: TLabel
    Left = 16
    Top = 244
    Width = 18
    Height = 13
    Alignment = taRightJustify
    Caption = 'Key'
    OnClick = Label10Click
  end
  object btnNext: TButton
    Left = 254
    Top = 276
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Next >>'
    TabOrder = 5
    OnClick = btnNextClick
  end
  object btnPrevious: TButton
    Left = 167
    Top = 276
    Width = 79
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '<< &Previous'
    TabOrder = 4
    OnClick = btnPreviousClick
  end
  object lstCSEngine: TListBox
    Left = 20
    Top = 68
    Width = 292
    Height = 72
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    Items.Strings = (
      'NONE'
      'WINDOWS NT'
      'NOVELL NETWARE')
    ParentFont = False
    TabOrder = 0
    OnClick = lstCSEngineClick
  end
  object lstClUsers: TComboBox
    Left = 20
    Top = 171
    Width = 93
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 19
    ParentFont = False
    TabOrder = 1
    Text = '10'
    Items.Strings = (
      '10'
      '20'
      '50'
      '100'
      '999')
  end
  object UpDown1: TUpDown
    Left = 113
    Top = 171
    Width = 20
    Height = 27
    Associate = lstClUsers
    Min = 0
    Max = 999
    Position = 10
    TabOrder = 2
    Wrap = False
  end
  object edtLicence: TEdit
    Left = 39
    Top = 241
    Width = 274
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 24
    TabOrder = 3
  end
end
