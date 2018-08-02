object VATSubForm: TVATSubForm
  Left = 265
  Top = 182
  Width = 600
  Height = 462
  Caption = 'VAT 100 Return Submission'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 431
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PageCtrl: TPageControl
      Left = 0
      Top = 0
      Width = 480
      Height = 431
      ActivePage = sheetSubmission
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      OnChange = PageCtrlChange
      object sheetSubmission: TTabSheet
        Caption = 'Submission'
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 472
          Height = 402
          Align = alClient
          BevelOuter = bvNone
          Color = 15397858
          TabOrder = 0
          object Label1: TLabel
            Left = 16
            Top = 16
            Width = 53
            Height = 14
            Caption = 'VAT Period'
          end
          object Shape1: TShape
            Left = 8
            Top = 42
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape2: TShape
            Left = 8
            Top = 78
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape3: TShape
            Left = 8
            Top = 114
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape4: TShape
            Left = 8
            Top = 151
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape5: TShape
            Left = 8
            Top = 187
            Width = 337
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape6: TShape
            Left = 8
            Top = 223
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape7: TShape
            Left = 8
            Top = 331
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape8: TShape
            Left = 8
            Top = 295
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape9: TShape
            Left = 8
            Top = 259
            Width = 337
            Height = 32
            Brush.Style = bsClear
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape10: TShape
            Left = 320
            Top = 42
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape11: TShape
            Left = 320
            Top = 78
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape12: TShape
            Left = 320
            Top = 114
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape13: TShape
            Left = 320
            Top = 152
            Width = 25
            Height = 31
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape14: TShape
            Left = 320
            Top = 187
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape15: TShape
            Left = 320
            Top = 224
            Width = 25
            Height = 31
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape16: TShape
            Left = 320
            Top = 259
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape17: TShape
            Left = 320
            Top = 295
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Shape18: TShape
            Left = 320
            Top = 331
            Width = 25
            Height = 32
            Brush.Color = clGreen
            Pen.Color = clGreen
            Pen.Width = 2
          end
          object Label21: TLabel
            Left = 328
            Top = 48
            Width = 7
            Height = 16
            Caption = '1'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label22: TLabel
            Left = 328
            Top = 84
            Width = 7
            Height = 16
            Caption = '2'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label23: TLabel
            Left = 328
            Top = 120
            Width = 7
            Height = 16
            Caption = '3'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label24: TLabel
            Left = 328
            Top = 159
            Width = 7
            Height = 16
            Caption = '4'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label25: TLabel
            Left = 328
            Top = 195
            Width = 7
            Height = 16
            Caption = '5'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label26: TLabel
            Left = 328
            Top = 231
            Width = 7
            Height = 16
            Caption = '6'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label27: TLabel
            Left = 328
            Top = 267
            Width = 7
            Height = 16
            Caption = '7'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label28: TLabel
            Left = 328
            Top = 303
            Width = 7
            Height = 16
            Caption = '8'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Label29: TLabel
            Left = 328
            Top = 339
            Width = 7
            Height = 16
            Caption = '9'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            Transparent = True
          end
          object Shape19: TShape
            Left = 352
            Top = 44
            Width = 97
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape20: TShape
            Left = 352
            Top = 80
            Width = 97
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape21: TShape
            Left = 352
            Top = 116
            Width = 97
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape22: TShape
            Left = 352
            Top = 153
            Width = 97
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape23: TShape
            Left = 352
            Top = 189
            Width = 97
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape24: TShape
            Left = 352
            Top = 225
            Width = 73
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape25: TShape
            Left = 352
            Top = 261
            Width = 73
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape26: TShape
            Left = 352
            Top = 297
            Width = 73
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape27: TShape
            Left = 352
            Top = 333
            Width = 73
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object lblVatPeriod: TLabel
            Left = 94
            Top = 16
            Width = 40
            Height = 14
            Alignment = taRightJustify
            Caption = '2015-03'
            Transparent = True
          end
          object lblBox1: TLabel
            Left = 407
            Top = 48
            Width = 31
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0.00'
            Transparent = True
          end
          object lblBox2: TLabel
            Left = 407
            Top = 84
            Width = 31
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0.00'
            Transparent = True
          end
          object lblBox3: TLabel
            Left = 407
            Top = 120
            Width = 31
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0.00'
            Transparent = True
          end
          object lblBox4: TLabel
            Left = 407
            Top = 159
            Width = 31
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0.00'
            Transparent = True
          end
          object lblBox5: TLabel
            Left = 407
            Top = 195
            Width = 31
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0.00'
            Transparent = True
          end
          object lblBox6: TLabel
            Left = 407
            Top = 231
            Width = 16
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0'
            Transparent = True
          end
          object lblBox7: TLabel
            Left = 407
            Top = 267
            Width = 16
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0'
            Transparent = True
          end
          object lblBox8: TLabel
            Left = 407
            Top = 303
            Width = 16
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0'
            Transparent = True
          end
          object lblBox9: TLabel
            Left = 407
            Top = 339
            Width = 16
            Height = 14
            Alignment = taRightJustify
            Caption = #163'-0'
            Transparent = True
          end
          object Label2: TLabel
            Left = 16
            Top = 44
            Width = 237
            Height = 14
            Caption = 'VAT due in this period on sales and other outputs'
            Transparent = True
            WordWrap = True
          end
          object Label3: TLabel
            Left = 16
            Top = 80
            Width = 236
            Height = 28
            Caption = 
              'VAT due in this period on acquisitions from other EC Member Stat' +
              'es'
            Transparent = True
            WordWrap = True
          end
          object Label4: TLabel
            Left = 16
            Top = 116
            Width = 200
            Height = 14
            Caption = 'Total VAT due (the sum of boxes 1 and 2)'
            Transparent = True
            WordWrap = True
          end
          object Label5: TLabel
            Left = 16
            Top = 153
            Width = 287
            Height = 28
            Caption = 
              'VAT reclaimed in this period on purchases and other inputs (incl' +
              'uding acquisitions from the EC)'
            Transparent = True
            WordWrap = True
          end
          object Label7: TLabel
            Left = 16
            Top = 225
            Width = 295
            Height = 28
            Caption = 
              'Total value of sales and all other outputs excluding any VAT.  I' +
              'nclude your box 8 figure'
            Transparent = True
            WordWrap = True
          end
          object Label8: TLabel
            Left = 16
            Top = 261
            Width = 265
            Height = 28
            Caption = 
              'Total value of purchases and all other inputs excluding any VAT.' +
              '  Include your box 9 figure'
            Transparent = True
            WordWrap = True
          end
          object Label9: TLabel
            Left = 16
            Top = 297
            Width = 259
            Height = 28
            Caption = 
              'Total value of all supplies of goods and related costs, excludin' +
              'g any VAT, to other EC Member States'
            Transparent = True
            WordWrap = True
          end
          object Label10: TLabel
            Left = 16
            Top = 333
            Width = 297
            Height = 27
            AutoSize = False
            Caption = 
              'Total value of all acquisitions of goods and related costs, excl' +
              'uding any VAT, from other EC Member States'
            Transparent = True
            WordWrap = True
          end
          object Label6: TLabel
            Left = 16
            Top = 189
            Width = 234
            Height = 28
            Caption = 
              'Net VAT to be paid to HMRC or reclaimed by you (Difference betwe' +
              'en boxes 3 and 4)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Shape28: TShape
            Left = 428
            Top = 225
            Width = 21
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape29: TShape
            Left = 428
            Top = 261
            Width = 21
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape30: TShape
            Left = 428
            Top = 297
            Width = 21
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Shape31: TShape
            Left = 428
            Top = 333
            Width = 21
            Height = 28
            Pen.Color = clWhite
            Pen.Width = 2
          end
          object Label11: TLabel
            Left = 430
            Top = 231
            Width = 15
            Height = 14
            Alignment = taRightJustify
            Caption = '.00'
            Font.Charset = ANSI_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label12: TLabel
            Left = 430
            Top = 267
            Width = 15
            Height = 14
            Alignment = taRightJustify
            Caption = '.00'
            Font.Charset = ANSI_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label13: TLabel
            Left = 430
            Top = 303
            Width = 15
            Height = 14
            Alignment = taRightJustify
            Caption = '.00'
            Font.Charset = ANSI_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label14: TLabel
            Left = 430
            Top = 339
            Width = 15
            Height = 14
            Alignment = taRightJustify
            Caption = '.00'
            Font.Charset = ANSI_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
        end
      end
      object sheetNarrative: TTabSheet
        BorderWidth = 2
        Caption = 'Narrative'
        ImageIndex = 1
        object richNarrative: TRichEdit
          Left = 0
          Top = 0
          Width = 460
          Height = 360
          Align = alClient
          BevelOuter = bvNone
          BorderStyle = bsNone
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Panel3: TPanel
          Left = 0
          Top = 368
          Width = 468
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
        end
      end
      object errorSheet: TTabSheet
        BorderWidth = 2
        Caption = 'Error'
        ImageIndex = 2
        object errorMemo: TMemo
          Left = 0
          Top = 0
          Width = 462
          Height = 390
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
        end
      end
    end
  end
  object btnPanel: TPanel
    Left = 480
    Top = 0
    Width = 112
    Height = 431
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object btnSubmit: TButton
      Left = 9
      Top = 8
      Width = 80
      Height = 21
      Caption = '&Submit'
      TabOrder = 0
      OnClick = btnSubmitClick
    end
    object btnPrint: TButton
      Left = 9
      Top = 32
      Width = 80
      Height = 21
      Caption = 'Print'
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnCancel: TButton
      Left = 9
      Top = 56
      Width = 80
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object pnlTest: TPanel
      Left = 0
      Top = 244
      Width = 112
      Height = 187
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlTest'
      TabOrder = 3
      object Label15: TLabel
        Left = 4
        Top = 12
        Width = 93
        Height = 17
        Alignment = taCenter
        AutoSize = False
        Caption = 'For test only'
        Color = clRed
        Font.Charset = ANSI_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object grpSubmission: TRadioGroup
        Left = 2
        Top = 32
        Width = 111
        Height = 105
        Caption = 'Test'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'Live Submission'
          'Live Test'
          'Dev Test')
        ParentFont = False
        TabOrder = 0
      end
      object testCombo: TComboBox
        Left = 8
        Top = 141
        Width = 81
        Height = 20
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 12
        ParentFont = False
        TabOrder = 1
        Items.Strings = (
          'Submit to HMRC'
          'Get Last Error String'
          'Return Submitted For')
      end
      object Button2: TButton
        Left = 9
        Top = 160
        Width = 80
        Height = 21
        Caption = 'Test'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnClick = Button2Click
      end
    end
  end
  object PrintDialog: TPrintDialog
    Left = 344
    Top = 40
  end
end
