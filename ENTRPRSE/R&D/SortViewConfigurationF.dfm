object SortViewConfigurationFrm: TSortViewConfigurationFrm
  Left = 322
  Top = 268
  HelpContext = 8029
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Customer List - Sort View Configuration'
  ClientHeight = 298
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 16
    Top = 11
    Width = 54
    Height = 14
    Caption = 'Description'
  end
  object OkBtn: TButton
    Left = 235
    Top = 269
    Width = 80
    Height = 21
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 327
    Top = 269
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object edtSortViewDescr: TEdit
    Left = 75
    Top = 8
    Width = 452
    Height = 22
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'Lists Customers with a balance divisible by 13.2'
  end
  object PageControl1: TPageControl
    Left = 10
    Top = 39
    Width = 530
    Height = 195
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Sorting'
      object Label6: TLabel
        Left = 10
        Top = 7
        Width = 493
        Height = 33
        AutoSize = False
        Caption = 
          'A Primary Sort must be defined for the Sort View, this will cont' +
          'rol the order that the data is shown in the list.'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 52
        Top = 47
        Width = 59
        Height = 14
        Caption = 'Primary Sort'
      end
      object Label4: TLabel
        Left = 10
        Top = 78
        Width = 494
        Height = 47
        AutoSize = False
        Caption = 
          'A secondary sort can also be defined for when the Primary Sort i' +
          's defined on a field that contains many rows with the same value' +
          ', e.g. Transaction Date.  In that case it defines the order of t' +
          'he data within each Primary Sort value.'
        WordWrap = True
      end
      object lstPrimarySortOrder: TComboBox
        Left = 323
        Top = 43
        Width = 147
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'Ascending Order'
        Items.Strings = (
          'Ascending Order'
          'Descending Order')
      end
      object chkSecondarySort: TCheckBox
        Left = 16
        Top = 131
        Width = 99
        Height = 17
        Caption = 'Secondary Sort'
        TabOrder = 2
        OnClick = CheckDisplay
      end
      object lstSecondarySortOrder: TComboBox
        Left = 323
        Top = 129
        Width = 147
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ItemIndex = 0
        ParentFont = False
        TabOrder = 4
        Text = 'Ascending Order'
        Items.Strings = (
          'Ascending Order'
          'Descending Order')
      end
      object lstPrimarySortField: TComboBox
        Left = 117
        Top = 43
        Width = 202
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
      end
      object lstSecondarySortField: TComboBox
        Left = 117
        Top = 129
        Width = 202
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Filtering'
      ImageIndex = 1
      object Label5: TLabel
        Left = 10
        Top = 7
        Width = 492
        Height = 30
        AutoSize = False
        Caption = 
          'Up to 4 filters can be defined within the Sort View to control w' +
          'hich data is included within the Sort View.  If no filters are d' +
          'efined then all the data displayed in the standard list will be ' +
          'shown.'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 81
        Top = 43
        Width = 48
        Height = 14
        Caption = 'Filter Field'
      end
      object Label10: TLabel
        Left = 248
        Top = 43
        Width = 83
        Height = 14
        Caption = 'Comparison Type'
      end
      object Label11: TLabel
        Left = 391
        Top = 43
        Width = 87
        Height = 14
        Caption = 'Comparison Value'
      end
      object chkFilter1: TCheckBox
        Left = 16
        Top = 62
        Width = 59
        Height = 17
        Caption = 'Filter 1'
        TabOrder = 0
        OnClick = CheckDisplay
      end
      object lstFilter1Field: TComboBox
        Tag = 1
        Left = 79
        Top = 60
        Width = 163
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 1
        OnSelect = lstFilterFieldSelect
        Items.Strings = (
          'Account Code'
          'Company'
          'Balance'
          'Telephone No')
      end
      object lstFilter1CompareType: TComboBox
        Tag = 1
        Left = 246
        Top = 60
        Width = 138
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnDropDown = lstFilterCompareTypeDropDown
        Items.Strings = (
          'Equals'
          'Not Equals'
          'Less Than'
          'Less Than or Equals'
          'Greater Than'
          'Greater Than or Equals'
          'Starts With'
          'Contains')
      end
      object lstFilter1CompareValue: TEdit
        Left = 389
        Top = 60
        Width = 121
        Height = 22
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object chkFilter2: TCheckBox
        Left = 16
        Top = 89
        Width = 59
        Height = 17
        Caption = 'Filter 2'
        TabOrder = 5
        OnClick = CheckDisplay
      end
      object lstFilter2Field: TComboBox
        Tag = 2
        Left = 79
        Top = 86
        Width = 163
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 6
        OnSelect = lstFilterFieldSelect
        Items.Strings = (
          'Account Code'
          'Company'
          'Balance'
          'Telephone No')
      end
      object lstFilter2CompareType: TComboBox
        Tag = 2
        Left = 246
        Top = 86
        Width = 138
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 7
        OnDropDown = lstFilterCompareTypeDropDown
        Items.Strings = (
          'Equals'
          'Not Equals'
          'Less Than'
          'Less Than or Equals'
          'Greater Than'
          'Greater Than or Equals'
          'Starts With'
          'Contains')
      end
      object lstFilter2CompareValue: TEdit
        Left = 389
        Top = 86
        Width = 121
        Height = 22
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object chkFilter3: TCheckBox
        Left = 16
        Top = 115
        Width = 59
        Height = 17
        Caption = 'Filter 3'
        TabOrder = 10
        OnClick = CheckDisplay
      end
      object lstFilter3Field: TComboBox
        Tag = 3
        Left = 79
        Top = 112
        Width = 163
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 11
        OnSelect = lstFilterFieldSelect
        Items.Strings = (
          'Account Code'
          'Company'
          'Balance'
          'Telephone No')
      end
      object lstFilter3CompareType: TComboBox
        Tag = 3
        Left = 246
        Top = 112
        Width = 138
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 12
        OnDropDown = lstFilterCompareTypeDropDown
        Items.Strings = (
          'Equals'
          'Not Equals'
          'Less Than'
          'Less Than or Equals'
          'Greater Than'
          'Greater Than or Equals'
          'Starts With'
          'Contains')
      end
      object lstFilter3CompareValue: TEdit
        Left = 389
        Top = 112
        Width = 121
        Height = 22
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
      end
      object chkFilter4: TCheckBox
        Left = 17
        Top = 140
        Width = 59
        Height = 17
        Caption = 'Filter 4'
        TabOrder = 15
        OnClick = CheckDisplay
      end
      object lstFilter4Field: TComboBox
        Tag = 4
        Left = 79
        Top = 138
        Width = 163
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 16
        OnSelect = lstFilterFieldSelect
        Items.Strings = (
          'Account Code'
          'Company'
          'Balance'
          'Telephone No')
      end
      object lstFilter4CompareType: TComboBox
        Tag = 4
        Left = 246
        Top = 138
        Width = 138
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 17
        OnDropDown = lstFilterCompareTypeDropDown
        Items.Strings = (
          'Equals'
          'Not Equals'
          'Less Than'
          'Less Than or Equals'
          'Greater Than'
          'Greater Than or Equals'
          'Starts With'
          'Contains')
      end
      object lstFilter4CompareValue: TEdit
        Left = 389
        Top = 138
        Width = 121
        Height = 22
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 18
      end
      object lstFilter1CompareComboValue: TSBSComboBox
        Tag = 1
        Left = 389
        Top = 60
        Width = 121
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 3
        ParentFont = False
        TabOrder = 4
        Visible = False
        ExtendedList = True
        MaxListWidth = 121
        Validate = True
      end
      object lstFilter2CompareComboValue: TSBSComboBox
        Tag = 1
        Left = 389
        Top = 86
        Width = 121
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 3
        ParentFont = False
        TabOrder = 9
        Visible = False
        ExtendedList = True
        MaxListWidth = 121
        Validate = True
      end
      object lstFilter3CompareComboValue: TSBSComboBox
        Tag = 1
        Left = 389
        Top = 112
        Width = 121
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 3
        ParentFont = False
        TabOrder = 14
        Visible = False
        ExtendedList = True
        MaxListWidth = 121
        Validate = True
      end
      object lstFilter4CompareComboValue: TSBSComboBox
        Tag = 1
        Left = 389
        Top = 138
        Width = 121
        Height = 22
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 3
        ParentFont = False
        TabOrder = 19
        Visible = False
        ExtendedList = True
        MaxListWidth = 121
        Validate = True
      end
    end
  end
  object lstSaveOptions: TComboBox
    Left = 22
    Top = 239
    Width = 507
    Height = 22
    Style = csDropDownList
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    Items.Strings = (
      'Save Sort View as a User specific view for your use only'
      'Save Sort View as a Global view for all users to use')
  end
  object HelpBtn: TButton
    Left = 143
    Top = 269
    Width = 80
    Height = 21
    Caption = '&Help'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = HelpBtnClick
  end
end
