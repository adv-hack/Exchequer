object frmEditBox: TfrmEditBox
  Left = 404
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 166
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 287
    Top = 28
    Width = 80
    Height = 21
    Hint = '|Replace the current value with this value'
    Caption = 'OK'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 287
    Top = 53
    Width = 80
    Height = 21
    Hint = '|Cancel any changes'
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnPresets: TButton
    Left = 287
    Top = 117
    Width = 80
    Height = 21
    Hint = '|Set the default value to one of the preset system values'
    Caption = 'Preset Value'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = btnPresetsClick
  end
  object edtMsg: TEdit
    Left = 4
    Top = 141
    Width = 362
    Height = 22
    TabStop = False
    BevelInner = bvSpace
    BevelOuter = bvSpace
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
  end
  object pc: TPageControl
    Left = 4
    Top = 6
    Width = 277
    Height = 132
    ActivePage = tsValue
    TabIndex = 0
    TabOrder = 4
    object tsValue: TTabSheet
      Caption = 'Value'
      DesignSize = (
        269
        103)
      object lblMaxLen: TLabel
        Left = 13
        Top = 89
        Width = 48
        Height = 14
        Caption = 'lblMaxLen'
      end
      object lblDataType: TLabel
        Left = 73
        Top = 89
        Width = 56
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'lblDataType'
      end
      object lblSettingName: TLabel
        Left = 13
        Top = 6
        Width = 86
        Height = 13
        Caption = 'lblSettingName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblMoreInfo: TLabel
        Left = 210
        Top = 89
        Width = 54
        Height = 14
        Alignment = taRightJustify
        Caption = 'More Info...'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Visible = False
        OnMouseEnter = lblMoreInfoMouseEnter
        OnMouseLeave = lblMoreInfoMouseLeave
      end
      object lblIncludeField: TLabel
        Left = 29
        Top = 66
        Width = 223
        Height = 14
        Caption = '(i.e. the field does not appear in the import file)'
      end
      object edtValue: TEdit
        Left = 13
        Top = 23
        Width = 245
        Height = 22
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = edtValueChange
        OnKeyPress = edtValueKeyPress
      end
      object cbValue: TComboBox
        Left = 13
        Top = 23
        Width = 245
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnChange = cbValueChange
      end
      object btnSelectElipsis: TButton
        Left = 237
        Top = 25
        Width = 18
        Height = 19
        Hint = '|Select a file or folder'
        Caption = '...'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Visible = False
        OnClick = btnSelectClick
      end
      object cbIncludeField: TBorCheckEx
        Left = 12
        Top = 51
        Width = 133
        Height = 16
        Hint = 
          '|This field will always default to the supplied value and theref' +
          'ore doesn'#39't appear in the import file'
        Align = alRight
        Caption = 'This is an "Include" field'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        TabStop = True
        TextId = 0
        OnClick = cbIncludeFieldClick
      end
    end
    object tsAutoInc: TTabSheet
      Caption = 'AutoInc'
      ImageIndex = 1
      object Label1: TLabel
        Left = 27
        Top = 30
        Width = 78
        Height = 14
        Caption = 'AutoInc Counter'
      end
      object Label2: TLabel
        Left = 11
        Top = 60
        Width = 93
        Height = 14
        Caption = 'Reset Record Type'
      end
      object lblSettingName2: TLabel
        Left = 13
        Top = 6
        Width = 86
        Height = 13
        Caption = 'lblSettingName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbAutoInc: TComboBox
        Left = 116
        Top = 28
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        OnChange = cbAutoIncChange
        Items.Strings = (
          ''
          'AutoInc1'
          'AutoInc2'
          'AutoInc3'
          'AutoInc4'
          'AutoInc5'
          'AutoInc6'
          'AutoInc7'
          'AutoInc8'
          'AutoInc9'
          'CurrInc1'
          'CurrInc2'
          'CurrInc3'
          'CurrInc4'
          'CurrInc5'
          'CurrInc6'
          'CurrInc7'
          'CurrInc8'
          'CurrInc9')
      end
      object cbAutoIncReset: TComboBox
        Left = 116
        Top = 56
        Width = 145
        Height = 22
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
        OnChange = cbAutoIncResetChange
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 188
    Top = 8
    object SelectFile: TMenuItem
      Caption = 'Select File'
      OnClick = SelectFileClick
    end
    object SelectFolder: TMenuItem
      Caption = 'Select Folder'
      OnClick = SelectFolderClick
    end
  end
  object pumPresets: TPopupMenu
    Left = 312
    Top = 72
    object SystemDate1: TMenuItem
      Caption = 'System Date'
      OnClick = SystemDate1Click
    end
  end
end
