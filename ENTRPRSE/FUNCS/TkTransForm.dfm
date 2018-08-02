object frmTKTrans: TfrmTKTrans
  Left = 317
  Top = 291
  BorderStyle = bsDialog
  Caption = 'Transaction'
  ClientHeight = 270
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 537
    Height = 257
    TabOrder = 0
    object Label1: TLabel
      Left = 134
      Top = 7
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Acc No.'
    end
    object Label2: TLabel
      Left = 134
      Top = 32
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Date'
    end
    object Label3: TLabel
      Left = 134
      Top = 58
      Width = 48
      Height = 12
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Due Date'
    end
    object Label7: TLabel
      Left = 268
      Top = 7
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Per/Yr'
    end
    object Label8: TLabel
      Left = 268
      Top = 32
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Your Ref'
    end
    object Label9: TLabel
      Left = 268
      Top = 58
      Width = 48
      Height = 12
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Alt Ref'
    end
    object Label10: TLabel
      Left = 402
      Top = 7
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'OurRef'
    end
    object Label11: TLabel
      Left = 402
      Top = 32
      Width = 48
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Operator'
    end
    object Label4: TLabel
      Left = 197
      Top = 211
      Width = 75
      Height = 13
      AutoSize = False
      Caption = 'Net Total'
    end
    object Label5: TLabel
      Left = 280
      Top = 211
      Width = 75
      Height = 13
      AutoSize = False
      Caption = 'VAT Content'
    end
    object Label6: TLabel
      Left = 362
      Top = 211
      Width = 71
      Height = 13
      AutoSize = False
      Caption = 'Total'
    end
    object Label12: TLabel
      Left = 8
      Top = 211
      Width = 62
      Height = 13
      Caption = 'G/L Account'
    end
    object memCustDets: TMemo
      Left = 3
      Top = 2
      Width = 127
      Height = 71
      BevelInner = bvNone
      TabOrder = 0
    end
    object edtAcCode: TEdit
      Left = 185
      Top = 3
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      MaxLength = 6
      ReadOnly = True
      TabOrder = 1
    end
    object edtTransDate: TEdit
      Left = 185
      Top = 28
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 2
    end
    object edtDueDate: TEdit
      Left = 185
      Top = 53
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 3
    end
    object edtPerYear: TEdit
      Left = 319
      Top = 3
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      MaxLength = 9
      ReadOnly = True
      TabOrder = 4
    end
    object edtYourRef: TEdit
      Left = 319
      Top = 28
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 5
    end
    object edtAltRef: TEdit
      Left = 319
      Top = 53
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 6
    end
    object edtOurRef: TEdit
      Left = 453
      Top = 3
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 7
    end
    object edtOperator: TEdit
      Left = 453
      Top = 28
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 8
    end
    object Panel2: TPanel
      Left = 441
      Top = 79
      Width = 90
      Height = 166
      BevelOuter = bvLowered
      TabOrder = 9
      object btnClose: TButton
        Left = 5
        Top = 5
        Width = 80
        Height = 21
        Caption = '&Close'
        ModalResult = 1
        TabOrder = 0
      end
    end
    object edtTotal: TEdit
      Left = 358
      Top = 224
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      MaxLength = 6
      ReadOnly = True
      TabOrder = 10
    end
    object edtVATContent: TEdit
      Left = 277
      Top = 224
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      MaxLength = 6
      ReadOnly = True
      TabOrder = 11
    end
    object edtNetTotal: TEdit
      Left = 196
      Top = 224
      Width = 78
      Height = 21
      BevelInner = bvNone
      CharCase = ecUpperCase
      MaxLength = 6
      ReadOnly = True
      TabOrder = 12
    end
    object mlLines: TMultiList
      Left = 8
      Top = 80
      Width = 425
      Height = 129
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Stock Code'
          Width = 85
        end
        item
          Caption = 'Qty'
          DataType = dtFloat
          Width = 30
        end
        item
          Caption = 'Description'
          Width = 130
        end
        item
          Caption = 'Line Total'
          DataType = dtFloat
          Width = 60
        end
        item
          Caption = 'VAT'
          Width = 27
        end
        item
          Caption = 'Unit Price'
          DataType = dtFloat
          Width = 60
        end
        item
          Caption = 'Discount'
          DataType = dtFloat
          Width = 60
        end>
      TabStop = True
      TabOrder = 13
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Arial'
      HeaderFont.Style = []
      HighlightFont.Charset = DEFAULT_CHARSET
      HighlightFont.Color = clWhite
      HighlightFont.Height = -11
      HighlightFont.Name = 'Arial'
      HighlightFont.Style = []
      MultiSelectFont.Charset = DEFAULT_CHARSET
      MultiSelectFont.Color = clWindowText
      MultiSelectFont.Height = -11
      MultiSelectFont.Name = 'Arial'
      MultiSelectFont.Style = []
      Version = 'v1.13'
    end
    object Edit1: TEdit
      Left = 8
      Top = 224
      Width = 121
      Height = 21
      BevelInner = bvNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 14
      Text = 'Edit1'
    end
  end
end
