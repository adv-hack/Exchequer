object Form1: TForm1
  Left = 208
  Top = 130
  Width = 544
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 536
    Height = 348
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object tabshRecord: TTabSheet
      Caption = 'Record'
      object Label1: TLabel
        Left = 6
        Top = 7
        Width = 115
        Height = 13
        Caption = 'Record Structure Name:'
      end
      object memRecStructure: TMemo
        Left = 4
        Top = 30
        Width = 520
        Height = 255
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtStructName: TEdit
        Left = 128
        Top = 4
        Width = 396
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Text = 'CustRec'
      end
      object btnProcess: TButton
        Left = 448
        Top = 290
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Process'
        TabOrder = 2
        OnClick = btnProcessClick
      end
    end
    object tabshCode: TTabSheet
      Caption = 'Code'
      ImageIndex = 1
      object memCode: TMemo
        Left = 4
        Top = 5
        Width = 520
        Height = 309
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Test'
      ImageIndex = 2
      object memOutput: TMemo
        Left = 4
        Top = 5
        Width = 436
        Height = 309
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object btnTestCustRec: TButton
        Left = 445
        Top = 5
        Width = 80
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'CustRec'
        TabOrder = 1
        OnClick = btnTestCustRecClick
      end
      object btnTestInvRec: TButton
        Left = 445
        Top = 32
        Width = 80
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'InvRec'
        TabOrder = 2
        OnClick = btnTestInvRecClick
      end
      object btnTestIDetail: TButton
        Left = 445
        Top = 59
        Width = 80
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'IDetail'
        TabOrder = 3
        OnClick = btnTestIDetailClick
      end
      object btnTestStockRec: TButton
        Left = 445
        Top = 86
        Width = 80
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'StockRec'
        TabOrder = 4
        OnClick = btnTestStockRecClick
      end
      object btnTestNominalRec: TButton
        Left = 445
        Top = 113
        Width = 80
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'NominalRec'
        TabOrder = 5
        OnClick = btnTestNominalRecClick
      end
    end
  end
end
