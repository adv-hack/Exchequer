object frmDetails: TfrmDetails
  Left = 308
  Top = 125
  ActiveControl = PageControl1
  BorderStyle = bsDialog
  Caption = '??? Properties'
  ClientHeight = 399
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmMain
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 5
    Top = 8
    Width = 372
    Height = 353
    ActivePage = tabshList
    TabIndex = 1
    TabOrder = 0
    object tabshType: TTabSheet
      Caption = 'Status'
      object Label1: TLabel
        Left = 40
        Top = 96
        Width = 321
        Height = 29
        AutoSize = False
        Caption = 
          'The field value must be a valid entry from a pre-defined list of' +
          ' values.'
        WordWrap = True
        OnClick = Label1Click
      end
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 291
        Height = 18
        AutoSize = False
        Caption = 'Please specify how the Plug-In handles this field :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 40
        Top = 48
        Width = 321
        Height = 30
        AutoSize = False
        Caption = 
          'The Plug-In ignores the field, allowing the user to use it as a ' +
          'normal free-format field.'
        WordWrap = True
        OnClick = Label3Click
      end
      object Label4: TLabel
        Left = 40
        Top = 144
        Width = 321
        Height = 34
        AutoSize = False
        Caption = 
          'The Plug-In will display the popup list of pre-defined values, b' +
          'ut the user can press Escape to leave the existing field value i' +
          'ntact.'
        WordWrap = True
        OnClick = Label4Click
      end
      object lValidation: TLabel
        Left = 40
        Top = 192
        Width = 321
        Height = 34
        AutoSize = False
        Caption = 
          'The Plug-In will only validate that the field is populated with ' +
          'a value. The value can be anything.'
        WordWrap = True
        OnClick = lValidationClick
      end
      object lManDate: TLabel
        Left = 35
        Top = 240
        Width = 321
        Height = 34
        AutoSize = False
        Caption = 
          'The field value must be a valid date, which is validated against' +
          ' the date format.'
        WordWrap = True
        OnClick = lManDateClick
      end
      object lOptDate: TLabel
        Left = 35
        Top = 288
        Width = 321
        Height = 34
        AutoSize = False
        Caption = 
          'If the field value is filled in, it must be a valid date, which ' +
          'is validated against the date format.'
        WordWrap = True
        OnClick = lOptDateClick
      end
      object radDisabled: TRadioButton
        Left = 16
        Top = 32
        Width = 152
        Height = 17
        Caption = 'Disabled'
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = RadioButtonCheck
      end
      object radOptional: TRadioButton
        Tag = 2
        Left = 16
        Top = 128
        Width = 114
        Height = 17
        Caption = 'Optional List'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = RadioButtonCheck
      end
      object radMandatory: TRadioButton
        Tag = 1
        Left = 16
        Top = 80
        Width = 114
        Height = 17
        Caption = 'Mandatory List'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = RadioButtonCheck
      end
      object radValidation: TRadioButton
        Tag = 3
        Left = 16
        Top = 176
        Width = 114
        Height = 17
        Caption = 'Validation Mode'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = RadioButtonCheck
      end
      object radManDate: TRadioButton
        Tag = 4
        Left = 16
        Top = 224
        Width = 114
        Height = 17
        Caption = 'Mandatory Date'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = RadioButtonCheck
      end
      object radOptDate: TRadioButton
        Tag = 5
        Left = 16
        Top = 272
        Width = 114
        Height = 17
        Caption = 'Optional Date'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = RadioButtonCheck
      end
    end
    object tabshList: TTabSheet
      Caption = 'List'
      ImageIndex = 1
      PopupMenu = pmListTab
      object Label5: TLabel
        Left = 8
        Top = 8
        Width = 227
        Height = 14
        Caption = 'Specify the list entries for the user field:-'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object btnAdd: TButton
        Left = 280
        Top = 24
        Width = 73
        Height = 25
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnAddClick
      end
      object btnEdit: TButton
        Left = 280
        Top = 56
        Width = 72
        Height = 25
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnEditClick
      end
      object btnDelete: TButton
        Left = 280
        Top = 120
        Width = 72
        Height = 25
        Caption = '&Delete'
        TabOrder = 3
        OnClick = btnDeleteClick
      end
      object btnMoveUp: TButton
        Left = 280
        Top = 160
        Width = 72
        Height = 25
        Caption = 'Move &Up'
        TabOrder = 4
        OnClick = btnMoveUpClick
      end
      object btnMoveDown: TButton
        Left = 280
        Top = 192
        Width = 72
        Height = 25
        Caption = 'Move D&own'
        TabOrder = 5
        OnClick = btnMoveDownClick
      end
      object btnInsert: TButton
        Left = 280
        Top = 88
        Width = 72
        Height = 25
        Caption = '&Insert'
        TabOrder = 2
        OnClick = btnInsertClick
      end
      object lstValues: TMultiList
        Left = 8
        Top = 24
        Width = 265
        Height = 293
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Description'
            Field = 'D'
            Width = 231
          end>
        TabStop = True
        OnRowDblClick = lstValuesRowDblClick
        TabOrder = 6
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
    end
    object tsBinList: TTabSheet
      Caption = 'Multi-Bin List'
      ImageIndex = 3
      PopupMenu = pmBins
      object Label12: TLabel
        Left = 8
        Top = 8
        Width = 265
        Height = 17
        AutoSize = False
        Caption = 'Please specify your Multi-Bin list'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object btnBinAdd: TButton
        Left = 280
        Top = 24
        Width = 73
        Height = 25
        Caption = '&Add'
        TabOrder = 0
        OnClick = btnBinAddClick
      end
      object btnBinEdit: TButton
        Left = 280
        Top = 56
        Width = 72
        Height = 25
        Caption = '&Edit'
        TabOrder = 1
        OnClick = btnBinEditClick
      end
      object btnBinDelete: TButton
        Left = 280
        Top = 88
        Width = 72
        Height = 25
        Caption = '&Delete'
        TabOrder = 2
        OnClick = btnBinDeleteClick
      end
      object mlBins: TDBMultiList
        Left = 8
        Top = 24
        Width = 265
        Height = 293
        Custom.SplitterCursor = crHSplit
        Dimensions.HeaderHeight = 18
        Dimensions.SpacerWidth = 1
        Dimensions.SplitterWidth = 3
        Options.BoldActiveColumn = False
        Columns = <
          item
            Caption = 'Bin Code'
            Field = 'liDescription'
            Searchable = True
            Sortable = True
            Width = 231
          end>
        TabStop = True
        OnRowDblClick = mlBinsRowDblClick
        TabOrder = 3
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
        Active = False
        SortColIndex = 0
        SortAsc = True
      end
    end
    object tabShWindow: TTabSheet
      Caption = 'Window'
      ImageIndex = 2
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 331
        Height = 14
        Caption = 'The title of the popup window displaying the list can be set :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 8
        Top = 112
        Width = 354
        Height = 34
        AutoSize = False
        Caption = 
          'Note : If the title is left blank, the Plug-In will use the User' +
          ' Defined Field name setup within Exchequer.'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 8
        Top = 44
        Width = 25
        Height = 14
        Caption = 'Title :'
      end
      object edtWindowCapt: TEdit
        Left = 8
        Top = 64
        Width = 345
        Height = 22
        TabOrder = 0
      end
    end
  end
  object btnOK: TButton
    Left = 304
    Top = 368
    Width = 73
    Height = 25
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object pmMain: TPopupMenu
    OnPopup = pmMainPopup
    Left = 32
    Top = 368
    object Properties1: TMenuItem
      Caption = 'Properties'
      OnClick = Properties1Click
    end
    object SaveCoordinates1: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = SaveCoordinatesClick
    end
  end
  object pmListTab: TPopupMenu
    Left = 224
    Top = 16
    object Properties2: TMenuItem
      Caption = 'Properties'
      OnClick = Properties2Click
    end
    object SaveCoordinates2: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = SaveCoordinatesClick
    end
  end
  object pmBins: TPopupMenu
    Left = 256
    Top = 16
    object Properties3: TMenuItem
      Caption = 'Properties'
      OnClick = Properties3Click
    end
    object SaveCoordinates3: TMenuItem
      Caption = 'Save Coordinates'
      OnClick = SaveCoordinatesClick
    end
  end
  object sdsUDItem: TSQLDatasets
    OnGetFieldValue = sdsUDItemGetFieldValue
    UseWindowsAuthentication = True
    Left = 64
    Top = 368
  end
  object pdsUDItem: TBtrieveDataset
    FileName = 'UDItem.dat'
    OnGetFieldValue = pdsUDItemGetFieldValue
    Left = 8
    Top = 368
  end
end
