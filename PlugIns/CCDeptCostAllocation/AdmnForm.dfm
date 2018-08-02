object frmCAAdmin: TfrmCAAdmin
  Tag = 100
  Left = 292
  Top = 253
  Width = 782
  Height = 460
  Anchors = [akLeft, akTop, akBottom]
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'CC/Dept Allocation Administration'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    766
    421)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 7
    Top = 11
    Width = 45
    Height = 14
    Caption = 'Company'
  end
  object Label7: TLabel
    Left = 466
    Top = 397
    Width = 117
    Height = 14
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Percentage Unallocated:'
  end
  object GroupBox1: TGroupBox
    Tag = 100
    Left = 3
    Top = 34
    Width = 260
    Height = 354
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 1
    DesignSize = (
      260
      354)
    object Label6: TLabel
      Tag = 100
      Left = 8
      Top = 16
      Width = 53
      Height = 14
      Caption = 'Allocations'
    end
    object tvGLs: TTreeView
      Tag = 100
      Left = 8
      Top = 32
      Width = 244
      Height = 314
      Anchors = [akLeft, akTop, akRight, akBottom]
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = tvGLsChange
      OnClick = tvGLsClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 263
    Top = 34
    Width = 499
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    DesignSize = (
      499
      354)
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 42
      Height = 14
      Caption = 'GL Code'
    end
    object Label3: TLabel
      Left = 16
      Top = 64
      Width = 47
      Height = 14
      Caption = 'Allocation'
    end
    object Label4: TLabel
      Left = 88
      Top = 64
      Width = 54
      Height = 14
      Caption = 'Description'
    end
    object Label5: TLabel
      Left = 88
      Top = 16
      Width = 54
      Height = 14
      Caption = 'Description'
    end
    object edtGLCode: TEdit
      Left = 16
      Top = 32
      Width = 65
      Height = 22
      TabOrder = 0
      OnExit = edtGLCodeExit
    end
    object edtGLDesc: TEdit
      Left = 88
      Top = 32
      Width = 137
      Height = 22
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtAllocName: TEdit
      Left = 16
      Top = 80
      Width = 65
      Height = 22
      CharCase = ecUpperCase
      MaxLength = 20
      TabOrder = 2
      OnExit = edtAllocNameExit
    end
    object edtAllocDesc: TEdit
      Left = 88
      Top = 80
      Width = 137
      Height = 22
      MaxLength = 45
      TabOrder = 3
    end
    object btnAddLine: TButton
      Tag = 100
      Left = 406
      Top = 136
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Add &Line'
      TabOrder = 5
      OnClick = btnAddLineClick
    end
    object btnEditLine: TButton
      Tag = 100
      Left = 406
      Top = 160
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Edit L&ine'
      TabOrder = 6
      OnClick = btnEditLineClick
    end
    object Button6: TButton
      Tag = 100
      Left = 406
      Top = 184
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Dele&te Line'
      TabOrder = 7
      OnClick = Button6Click
    end
    object gbType: TGroupBox
      Left = 235
      Top = 24
      Width = 161
      Height = 81
      TabOrder = 4
      DesignSize = (
        161
        81)
      object rbCC: TRadioButton
        Left = 8
        Top = 12
        Width = 145
        Height = 17
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Allocate by Cost Centre'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbCCClick
      end
      object rbDep: TRadioButton
        Tag = 1
        Left = 8
        Top = 34
        Width = 137
        Height = 17
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Allocate by Department'
        TabOrder = 1
        OnClick = rbCCClick
      end
      object rbCCDep: TRadioButton
        Tag = 2
        Left = 8
        Top = 58
        Width = 149
        Height = 17
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Allocate by CC/Department'
        TabOrder = 2
        OnClick = rbCCClick
      end
    end
    object mlLines: TMultiList
      Tag = 100
      Left = 16
      Top = 112
      Width = 380
      Height = 234
      Custom.SplitterCursor = crHSplit
      Dimensions.HeaderHeight = 18
      Dimensions.SpacerWidth = 1
      Dimensions.SplitterWidth = 3
      Options.BoldActiveColumn = False
      Columns = <
        item
          Caption = 'Code'
        end
        item
          Caption = 'Description'
          Width = 152
        end
        item
          Alignment = taRightJustify
          Caption = 'Percentage'
          DataType = dtFloat
          Width = 83
        end>
      TabStop = True
      OnRowDblClick = mlLinesRowDblClick
      TabOrder = 8
      Anchors = [akLeft, akTop, akRight, akBottom]
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
    object SBSButton1: TSBSButton
      Left = 406
      Top = 32
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Save'
      TabOrder = 9
      OnClick = SBSButton1Click
      TextId = 0
    end
    object btnCancel: TSBSButton
      Left = 406
      Top = 56
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      TabOrder = 10
      OnClick = btnCancelClick
      TextId = 0
    end
  end
  object cbCompany: TComboBox
    Tag = 100
    Left = 63
    Top = 7
    Width = 201
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnChange = cbCompanyChange
  end
  object Button1: TButton
    Tag = 100
    Left = 7
    Top = 395
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Add'
    TabOrder = 3
    OnClick = Button1Click
  end
  object btnEdit: TButton
    Tag = 100
    Left = 93
    Top = 395
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Edit'
    TabOrder = 4
    OnClick = btnEditClick
  end
  object Button3: TButton
    Tag = 100
    Left = 181
    Top = 395
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Delete'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button7: TButton
    Tag = 100
    Left = 676
    Top = 395
    Width = 80
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    TabOrder = 6
    OnClick = Button7Click
  end
  object edtUnalloc: TEdit
    Left = 590
    Top = 393
    Width = 41
    Height = 22
    Anchors = [akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 7
  end
end
