object Form_TableOptions: TForm_TableOptions
  Left = 411
  Top = 181
  HelpContext = 710
  ActiveControl = PageControl1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Table Options'
  ClientHeight = 332
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 6
    Top = 5
    Width = 459
    Height = 322
    ActivePage = TabSh_Misc
    TabIndex = 2
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSh_Display: TTabSheet
      Caption = 'Display'
      object Image_Table: TImage
        Left = 4
        Top = 3
        Width = 353
        Height = 146
        OnClick = PaintTable
      end
      object Label87: Label8
        Left = 4
        Top = 156
        Width = 40
        Height = 14
        Caption = 'Element:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label_Width: Label8
        Left = 220
        Top = 202
        Width = 53
        Height = 14
        Caption = 'Line width:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Label_Colour: Label8
        Left = 220
        Top = 232
        Width = 34
        Height = 14
        Caption = 'Colour:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object Button_Font: TButton
        Left = 220
        Top = 260
        Width = 137
        Height = 25
        Caption = 'Select &Font'
        TabOrder = 4
        OnClick = Button_FontClick
      end
      object Check_General: TBorCheck
        Left = 219
        Top = 174
        Width = 94
        Height = 18
        Align = alRight
        Caption = 'Show'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        TabStop = True
        TextId = 0
        OnClick = Check_Left_TblClick
      end
      object List_Elements: TListBox
        Left = 3
        Top = 173
        Width = 204
        Height = 117
        ItemHeight = 14
        TabOrder = 0
        OnClick = List_ElementsClick
      end
      object Panel_Colour: TPanel
        Left = 283
        Top = 227
        Width = 74
        Height = 24
        BevelOuter = bvLowered
        Color = clWindowFrame
        TabOrder = 3
        TabStop = True
        OnDblClick = Panel_ColourDblClick
      end
      object Combo_Width: TSBSComboBox
        Left = 283
        Top = 199
        Width = 74
        Height = 22
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
        OnChange = Combo_WidthChange
        Items.Strings = (
          'Normal'
          'Double'
          'Triple')
        MaxListWidth = 0
      end
      object Button_Save2: TButton
        Left = 367
        Top = 6
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 5
        OnClick = Button_SaveClick
      end
      object Button_Cancel2: TButton
        Left = 367
        Top = 33
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 6
        OnClick = Button_CancelClick
      end
    end
    object TabSh_Columns: TTabSheet
      Caption = 'Columns'
      object lblColContents: Label8
        Left = 6
        Top = 276
        Width = 352
        Height = 14
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ListVw_Columns: TListView
        Left = 5
        Top = 5
        Width = 356
        Height = 268
        Columns = <
          item
            Caption = 'Title'
            Width = 150
          end
          item
            Caption = 'Type'
          end
          item
            Caption = 'Width'
            Width = 45
          end
          item
            Alignment = taCenter
            Width = 25
          end
          item
            Caption = 'Print If'
            Width = 600
          end>
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = ListVw_ColumnsChange
        OnClick = ListVw_ColumnsClick
        OnDblClick = Button_EditClick
        OnEditing = ListVw_ColumnsEditing
      end
      object Button_Add: TButton
        Left = 367
        Top = 70
        Width = 80
        Height = 21
        Caption = '&Add'
        TabOrder = 3
        OnClick = Button_AddClick
      end
      object Button_Edit: TButton
        Left = 367
        Top = 96
        Width = 80
        Height = 21
        Caption = '&Edit'
        TabOrder = 4
        OnClick = Button_EditClick
      end
      object Button_Delete: TButton
        Left = 367
        Top = 123
        Width = 80
        Height = 21
        Caption = '&Delete'
        TabOrder = 5
        OnClick = Button_DeleteClick
      end
      object Button_MoveUp: TButton
        Left = 367
        Top = 187
        Width = 80
        Height = 21
        Caption = 'Move &Up'
        TabOrder = 6
        OnClick = Button_MoveUpClick
      end
      object Button_MoveDown: TButton
        Left = 367
        Top = 214
        Width = 80
        Height = 21
        Caption = 'Move Do&wn'
        TabOrder = 7
        OnClick = Button_MoveUpClick
      end
      object Button_Save: TButton
        Left = 367
        Top = 6
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 1
        OnClick = Button_SaveClick
      end
      object Button_Cancel: TButton
        Left = 367
        Top = 33
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 2
        OnClick = Button_CancelClick
      end
      object btnColPrintIf: TButton
        Left = 367
        Top = 149
        Width = 80
        Height = 21
        Caption = 'Print &If'
        TabOrder = 8
        OnClick = btnColPrintIfClick
      end
    end
    object TabSh_Misc: TTabSheet
      Caption = 'Miscellaneous'
      object SBSPanel3: TSBSPanel
        Left = 5
        Top = 6
        Width = 355
        Height = 38
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        AllowReSize = False
        IsGroupBox = False
        TextId = 0
        object Label_If: Label8
          Left = 7
          Top = 6
          Width = 261
          Height = 24
          AutoSize = False
          Caption = 'Print If:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TextId = 0
        end
      end
      object Button_If: TButton
        Left = 273
        Top = 13
        Width = 80
        Height = 25
        Caption = '&If'
        TabOrder = 1
        OnClick = Button_IfClick
      end
      object Button_Save3: TButton
        Left = 367
        Top = 6
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 2
        OnClick = Button_SaveClick
      end
      object Button_Cancel3: TButton
        Left = 367
        Top = 33
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 3
        OnClick = Button_CancelClick
      end
    end
  end
  object FontDialog1: TFontDialog
    HelpContext = 20200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdTrueTypeOnly, fdEffects, fdShowHelp]
    Left = 236
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    HelpContext = 20400
    Options = [cdShowHelp]
    Left = 328
  end
end
