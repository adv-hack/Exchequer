object frmESNPasswords: TfrmESNPasswords
  Left = 350
  Top = 180
  ActiveControl = meESN1
  BorderStyle = bsDialog
  Caption = 'Enterprise v5.00 ESN Based Passwords'
  ClientHeight = 230
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    357
    230)
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 2
    Top = 90
    Width = 116
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Customer ESN'
  end
  object Label2: TLabel
    Left = 8
    Top = 3
    Width = 344
    Height = 29
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'v5.00 ESN Passwords'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 9
    Top = 35
    Width = 343
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please enter the Exchequer Site Number for this site:-'
    WordWrap = True
  end
  object Bevel2: TBevel
    Left = 6
    Top = 195
    Width = 345
    Height = 2
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object Bevel1: TBevel
    Left = 6
    Top = 113
    Width = 345
    Height = 2
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object Label3: TLabel
    Left = 2
    Top = 124
    Width = 116
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Reset Ent User Count'
  end
  object Label6: TLabel
    Left = 2
    Top = 148
    Width = 116
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Resync Companies'
  end
  object Label7: TLabel
    Left = 2
    Top = 65
    Width = 116
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Password Date Range'
  end
  object Label1: TLabel
    Left = 2
    Top = 172
    Width = 116
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Reset Plug-In UCounts'
  end
  object lblESNVer: TLabel
    Left = 291
    Top = 90
    Width = 60
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object meESN1: TMaskEdit
    Left = 121
    Top = 87
    Width = 165
    Height = 21
    EditMask = '999-999-999-999-999-999-999;1;_'
    MaxLength = 27
    TabOrder = 1
    Text = '   -   -   -   -   -   -   '
    OnExit = meESN1Exit
  end
  object btnClose: TButton
    Left = 272
    Top = 204
    Width = 79
    Height = 21
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 4
  end
  object edtResetUser: TEdit
    Left = 121
    Top = 121
    Width = 122
    Height = 21
    Color = clBtnFace
    MaxLength = 45
    ReadOnly = True
    TabOrder = 2
    OnDblClick = edtResetUserDblClick
  end
  object edtResyncComps: TEdit
    Left = 121
    Top = 145
    Width = 122
    Height = 21
    Color = clBtnFace
    MaxLength = 45
    ReadOnly = True
    TabOrder = 3
    OnDblClick = edtResetUserDblClick
  end
  object edtCurrentDate: TEdit
    Left = 121
    Top = 62
    Width = 153
    Height = 21
    Color = clBtnFace
    MaxLength = 45
    ReadOnly = True
    TabOrder = 0
  end
  object edtResetPlugInUser: TEdit
    Left = 121
    Top = 169
    Width = 122
    Height = 21
    Color = clBtnFace
    MaxLength = 45
    ReadOnly = True
    TabOrder = 5
    OnDblClick = edtResetUserDblClick
  end
  object UpDown1: TUpDown
    Left = 273
    Top = 62
    Width = 13
    Height = 22
    Min = -32767
    Max = 32767
    Position = 0
    TabOrder = 6
    Wrap = False
    OnChangingEx = UpDown1ChangingEx
  end
end
