object frmFieldSelect: TfrmFieldSelect
  Left = 219
  Top = 149
  ActiveControl = lbHedUnselected
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CSV Mapping Editor'
  ClientHeight = 292
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    551
    292)
  PixelsPerInch = 96
  TextHeight = 14
  object btnClose: TButton
    Left = 470
    Top = 259
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnLoad: TButton
    Left = 470
    Top = 29
    Width = 73
    Height = 25
    HelpContext = 59
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Load'
    TabOrder = 1
    OnClick = btnLoadClick
  end
  object btnSave: TButton
    Left = 470
    Top = 61
    Width = 73
    Height = 25
    HelpContext = 65
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Save'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnNew: TButton
    Left = 470
    Top = 93
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&New'
    ModalResult = 4
    TabOrder = 3
    OnClick = btnNewClick
  end
  object pcFields: TPageControl
    Left = 8
    Top = 8
    Width = 451
    Height = 276
    ActivePage = tsHeader
    TabIndex = 1
    TabOrder = 0
    OnChange = pcFieldsChange
    object TabSheet1: TTabSheet
      Caption = 'Details'
      ImageIndex = 2
      object TLabel
        Left = 32
        Top = 12
        Width = 60
        Height = 14
        Alignment = taRightJustify
        Caption = 'Description :'
      end
      object TLabel
        Left = 43
        Top = 44
        Width = 48
        Height = 14
        Alignment = taRightJustify
        Caption = 'Filename :'
      end
      object lExportFormat: TLabel
        Left = 18
        Top = 165
        Width = 73
        Height = 14
        Alignment = taRightJustify
        Caption = 'Export Format :'
      end
      object TLabel
        Left = 20
        Top = 76
        Width = 71
        Height = 14
        Alignment = taRightJustify
        Caption = 'Field Delimiter :'
      end
      object TLabel
        Left = 12
        Top = 100
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Caption = 'Field Separator :'
      end
      object TLabel
        Left = 24
        Top = 132
        Width = 67
        Height = 14
        Alignment = taRightJustify
        Caption = 'Header Row :'
      end
      object edDescription: TEdit
        Left = 96
        Top = 8
        Width = 337
        Height = 22
        HelpContext = 60
        MaxLength = 50
        TabOrder = 0
        OnChange = edDescriptionChange
      end
      object edFilename: TEdit
        Left = 96
        Top = 40
        Width = 137
        Height = 22
        HelpContext = 60
        MaxLength = 12
        TabOrder = 1
        OnChange = edDescriptionChange
      end
      object rbHeaders: TRadioButton
        Left = 96
        Top = 164
        Width = 113
        Height = 17
        Caption = 'Headers only'
        Checked = True
        TabOrder = 7
        TabStop = True
        OnClick = RadioChange
      end
      object rbBothSeparate: TRadioButton
        Left = 96
        Top = 186
        Width = 183
        Height = 17
        Caption = 'Headers && lines (separate files)'
        TabOrder = 8
        OnClick = RadioChange
      end
      object rbBothTogether: TRadioButton
        Left = 96
        Top = 210
        Width = 177
        Height = 17
        Caption = 'Headers && lines (in one file)'
        TabOrder = 9
        OnClick = RadioChange
      end
      object cmbDelimit: TComboBox
        Left = 96
        Top = 72
        Width = 89
        Height = 22
        HelpContext = 61
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 2
        OnChange = cmbDelimitChange
        Items.Strings = (
          '(none)'
          'Double Quote'
          'Single Quote')
      end
      object cmbSeparate: TComboBox
        Left = 96
        Top = 96
        Width = 89
        Height = 22
        HelpContext = 62
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 4
        OnChange = cmbSeparateChange
        Items.Strings = (
          '(none)'
          'Comma'
          'Semicolon'
          'Tab')
      end
      object cmbHeaderRow: TComboBox
        Left = 96
        Top = 128
        Width = 137
        Height = 22
        HelpContext = 63
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 6
        OnChange = cmbHeaderRowChange
        Items.Strings = (
          'No Header Row'
          'Field Codes'
          'Field Desciptions')
      end
      object panDelimit: TPanel
        Left = 192
        Top = 72
        Width = 41
        Height = 22
        HelpContext = 61
        BevelOuter = bvLowered
        Caption = '"'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
      object panSeparate: TPanel
        Left = 192
        Top = 96
        Width = 41
        Height = 22
        HelpContext = 62
        BevelOuter = bvLowered
        Caption = ','
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
      end
    end
    object tsHeader: TTabSheet
      Caption = 'tsHeader'
      object Label4: TLabel
        Left = 3
        Top = 8
        Width = 75
        Height = 14
        Caption = 'Available Fields'
      end
      object Label5: TLabel
        Left = 243
        Top = 8
        Width = 73
        Height = 14
        Caption = 'Selected Fields'
      end
      object Bevel1: TBevel
        Left = 243
        Top = 24
        Width = 195
        Height = 218
      end
      object lbHedUnselected: TListBox
        Left = 3
        Top = 24
        Width = 195
        Height = 216
        DragMode = dmAutomatic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MultiSelect = True
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnClick = lbHedUnselectedClick
        OnDblClick = MoveBetweenEvent
        OnDragDrop = lstDragDrop
        OnDragOver = lstDragOver
        OnStartDrag = lstStartDrag
      end
      object lbHedSelected: TListBox
        Left = 243
        Top = 24
        Width = 195
        Height = 193
        DragMode = dmAutomatic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MultiSelect = True
        ParentFont = False
        TabOrder = 1
        OnClick = lbHedSelectedClick
        OnDblClick = MoveBetweenEvent
        OnDragDrop = lstDragDrop
        OnDragOver = lstDragOver
        OnStartDrag = lstStartDrag
      end
      object btnHedSelect: TButton
        Left = 203
        Top = 104
        Width = 33
        Height = 25
        Caption = '>>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = MoveBetweenEvent
      end
      object btnHedUnSelect: TButton
        Left = 203
        Top = 136
        Width = 33
        Height = 25
        Caption = '<<'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = MoveBetweenEvent
      end
      object btnHedMoveUp: TBitBtn
        Left = 244
        Top = 216
        Width = 100
        Height = 25
        Caption = #241
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnMoveUpDownClick
        Layout = blGlyphTop
      end
      object btnHedMoveDown: TBitBtn
        Left = 344
        Top = 216
        Width = 93
        Height = 25
        Caption = #242
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnMoveUpDownClick
        Layout = blGlyphTop
      end
    end
    object tsLines: TTabSheet
      Caption = 'tsLines'
      ImageIndex = 1
      object Bevel4: TBevel
        Left = 243
        Top = 24
        Width = 195
        Height = 218
      end
      object Label3: TLabel
        Left = 243
        Top = 8
        Width = 73
        Height = 14
        Caption = 'Selected Fields'
      end
      object Label6: TLabel
        Left = 3
        Top = 8
        Width = 75
        Height = 14
        Caption = 'Available Fields'
      end
      object btnLineMoveUp: TBitBtn
        Left = 244
        Top = 216
        Width = 100
        Height = 25
        Caption = #241
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnMoveUpDownClick
        Layout = blGlyphTop
      end
      object btnLineMoveDown: TBitBtn
        Left = 344
        Top = 216
        Width = 93
        Height = 25
        Caption = #242
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnMoveUpDownClick
        Layout = blGlyphTop
      end
      object lbLineSelected: TListBox
        Left = 243
        Top = 24
        Width = 195
        Height = 193
        DragMode = dmAutomatic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MultiSelect = True
        ParentFont = False
        TabOrder = 2
        OnClick = lbHedSelectedClick
        OnDblClick = MoveBetweenEvent
        OnDragDrop = lstDragDrop
        OnDragOver = lstDragOver
        OnStartDrag = lstStartDrag
      end
      object btnLineSelect: TButton
        Left = 203
        Top = 104
        Width = 33
        Height = 25
        Caption = '>>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = MoveBetweenEvent
      end
      object btnLineUnselect: TButton
        Left = 203
        Top = 136
        Width = 33
        Height = 25
        Caption = '<<'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = MoveBetweenEvent
      end
      object lbLineUnselected: TListBox
        Left = 3
        Top = 24
        Width = 195
        Height = 216
        DragMode = dmAutomatic
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MultiSelect = True
        ParentFont = False
        Sorted = True
        TabOrder = 5
        OnClick = lbHedUnselectedClick
        OnDblClick = MoveBetweenEvent
        OnDragDrop = lstDragDrop
        OnDragOver = lstDragOver
        OnStartDrag = lstStartDrag
      end
    end
  end
end
