object PreviewMenuEditor: TPreviewMenuEditor
  Left = 101
  Top = 128
  Width = 792
  Height = 508
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'PreviewMenuEditor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Items: TPanel
    Left = 384
    Top = 2
    Width = 391
    Height = 463
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object pg_Items: TPageControl
      Left = 3
      Top = 3
      Width = 385
      Height = 422
      ActivePage = ts_MenuItems
      TabOrder = 0
      object ts_MenuItems: TTabSheet
        Caption = 'MenuItems'
        object lbl_ShortCutHint: TLabel
          Left = 8
          Top = 76
          Width = 60
          Height = 13
          Caption = 'ShortCutHint'
        end
        object lbl_Caption: TLabel
          Left = 8
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Caption'
        end
        object lbl_SubMenuCaption: TLabel
          Left = 8
          Top = 50
          Width = 85
          Height = 13
          Caption = 'SubMenu Caption'
        end
        object lbl_ShortCutSubHint: TLabel
          Left = 8
          Top = 103
          Width = 99
          Height = 13
          Caption = 'ShortCutSubItemHint'
        end
        object lbl_ImageIndex: TLabel
          Left = 8
          Top = 209
          Width = 55
          Height = 13
          Caption = 'ImageIndex'
        end
        object Label1: TLabel
          Left = 8
          Top = 156
          Width = 105
          Height = 13
          Caption = 'SubMenuItemSpacing'
        end
        object lbl_Tag: TLabel
          Left = 8
          Top = 182
          Width = 19
          Height = 13
          Caption = 'Tag'
        end
        object lbl_Action: TLabel
          Left = 8
          Top = 129
          Width = 30
          Height = 13
          Caption = 'Action'
        end
        object edt_Caption: TEdit
          Left = 123
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 0
          OnKeyUp = edt_CaptionKeyUp
        end
        object edt_SubMenuCaption: TEdit
          Left = 123
          Top = 46
          Width = 121
          Height = 21
          TabOrder = 1
          OnKeyUp = edt_SubMenuCaptionKeyUp
        end
        object edt_ShortCutHint: TEdit
          Left = 123
          Top = 72
          Width = 121
          Height = 21
          TabOrder = 2
          OnKeyUp = edt_ShortCutHintKeyUp
        end
        object edt_ShortCutSubHint: TEdit
          Left = 123
          Top = 98
          Width = 121
          Height = 21
          TabOrder = 3
          OnKeyUp = edt_ShortCutSubHintKeyUp
        end
        object spn_Tag: TSpinEdit
          Left = 123
          Top = 177
          Width = 50
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
          OnChange = spn_TagChange
        end
        object spn_SubMenuSpacing: TSpinEdit
          Left = 123
          Top = 151
          Width = 50
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = spn_SubMenuSpacingChange
        end
        object cmb_ImageIndex: TComboBox
          Left = 123
          Top = 204
          Width = 97
          Height = 19
          Style = csOwnerDrawFixed
          ItemHeight = 13
          TabOrder = 6
          OnChange = cmb_ImageIndexChange
          OnDrawItem = cmb_ImageIndexDrawItem
        end
        object chk_Separator: TCheckBox
          Left = 256
          Top = 88
          Width = 80
          Height = 17
          Caption = 'Separator'
          TabOrder = 7
          OnClick = chk_SeparatorClick
        end
        object chk_Enabled: TCheckBox
          Left = 256
          Top = 64
          Width = 80
          Height = 17
          Caption = 'Enabled'
          TabOrder = 8
          OnClick = chk_EnabledClick
        end
        object chk_Visible: TCheckBox
          Left = 256
          Top = 40
          Width = 80
          Height = 17
          Caption = 'Visible'
          TabOrder = 9
          OnClick = chk_VisibleClick
        end
        object chk_CanSelect: TCheckBox
          Left = 256
          Top = 16
          Width = 80
          Height = 17
          Caption = 'CanSelect'
          TabOrder = 10
          OnClick = chk_CanSelectClick
        end
        object btn_Picture: TButton
          Left = 256
          Top = 128
          Width = 87
          Height = 25
          Caption = 'Picture'
          TabOrder = 11
          OnClick = btn_PictureClick
        end
        object btn_DisabledPic: TButton
          Left = 256
          Top = 152
          Width = 87
          Height = 25
          Caption = 'Disabled Picture'
          TabOrder = 12
          OnClick = btn_DisabledPicClick
        end
        object gb_OfficeHint: TGroupBox
          Left = 8
          Top = 250
          Width = 361
          Height = 113
          Caption = 'OfficeHint'
          TabOrder = 13
          object lbl_HintTitle: TLabel
            Left = 8
            Top = 19
            Width = 20
            Height = 13
            Caption = 'Title'
          end
          object lbl_HintNotes: TLabel
            Left = 8
            Top = 37
            Width = 28
            Height = 13
            Caption = 'Notes'
          end
          object btn_HintPicture: TButton
            Left = 278
            Top = 59
            Width = 75
            Height = 25
            Caption = 'Picture'
            TabOrder = 0
          end
          object chk_HintShowHelp: TCheckBox
            Left = 278
            Top = 19
            Width = 78
            Height = 17
            Caption = 'Show Help'
            TabOrder = 1
            OnClick = chk_HintShowHelpClick
          end
          object mem_Notes: TMemo
            Left = 9
            Top = 51
            Width = 259
            Height = 55
            ScrollBars = ssVertical
            TabOrder = 2
            OnChange = mem_NotesChange
          end
          object edt_HintTitle: TEdit
            Left = 61
            Top = 15
            Width = 203
            Height = 21
            TabOrder = 3
            OnKeyUp = edt_HintTitleKeyUp
          end
        end
        object btn_Remove: TButton
          Left = 67
          Top = 368
          Width = 60
          Height = 25
          Caption = 'Remove'
          TabOrder = 14
          OnClick = btn_RemoveClick
        end
        object btn_Add: TButton
          Left = 8
          Top = 368
          Width = 60
          Height = 25
          Caption = 'Add'
          TabOrder = 15
          OnClick = btn_AddClick
        end
        object cmb_Action: TComboBox
          Left = 123
          Top = 125
          Width = 97
          Height = 21
          ItemHeight = 13
          TabOrder = 16
          OnChange = cmb_ActionChange
        end
      end
      object ts_SubMenuItems: TTabSheet
        Caption = 'SubMenuItems'
        ImageIndex = 1
        object lbl_Title: TLabel
          Left = 8
          Top = 24
          Width = 20
          Height = 13
          Caption = 'Title'
        end
        object lbl_SubShortCutHint: TLabel
          Left = 8
          Top = 49
          Width = 60
          Height = 13
          Caption = 'ShortCutHint'
        end
        object lbl_SubImageIndex: TLabel
          Left = 8
          Top = 126
          Width = 55
          Height = 13
          Caption = 'ImageIndex'
        end
        object lbl_SubTag: TLabel
          Left = 8
          Top = 100
          Width = 19
          Height = 13
          Caption = 'Tag'
        end
        object lbl_SubNotes: TLabel
          Left = 8
          Top = 159
          Width = 28
          Height = 13
          Caption = 'Notes'
        end
        object lbl_SubAction: TLabel
          Left = 8
          Top = 75
          Width = 30
          Height = 13
          Caption = 'Action'
        end
        object chk_SubSeparator: TCheckBox
          Left = 208
          Top = 48
          Width = 70
          Height = 17
          Caption = 'Separator'
          TabOrder = 0
          OnClick = chk_SubSeparatorClick
        end
        object edt_Title: TEdit
          Left = 75
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 1
          OnKeyUp = edt_TitleKeyUp
        end
        object edt_SubShortCutHint: TEdit
          Left = 75
          Top = 45
          Width = 121
          Height = 21
          TabOrder = 2
          OnKeyUp = edt_SubShortCutHintKeyUp
        end
        object cmb_SubImageIndex: TComboBox
          Left = 75
          Top = 121
          Width = 97
          Height = 19
          Style = csOwnerDrawFixed
          ItemHeight = 13
          TabOrder = 3
          OnChange = cmb_SubImageIndexChange
          OnDrawItem = cmb_SubImageIndexDrawItem
        end
        object spn_SubTag: TSpinEdit
          Left = 75
          Top = 95
          Width = 98
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
          OnChange = spn_SubTagChange
        end
        object mem_SubNotes: TMemo
          Left = 9
          Top = 173
          Width = 360
          Height = 55
          ScrollBars = ssVertical
          TabOrder = 5
          OnChange = mem_SubNotesChange
        end
        object chk_SubEnabled: TCheckBox
          Left = 208
          Top = 32
          Width = 70
          Height = 17
          Caption = 'Enabled'
          TabOrder = 6
          OnClick = chk_SubEnabledClick
        end
        object chk_SubVisible: TCheckBox
          Left = 208
          Top = 16
          Width = 70
          Height = 17
          Caption = 'Visible'
          TabOrder = 7
          OnClick = chk_SubVisibleClick
        end
        object btn_SubPicture: TButton
          Left = 208
          Top = 80
          Width = 87
          Height = 25
          Caption = 'Picture'
          TabOrder = 8
          OnClick = btn_SubPictureClick
        end
        object btn_SubDisabledPic: TButton
          Left = 209
          Top = 104
          Width = 87
          Height = 25
          Caption = 'Disabled Picture'
          TabOrder = 9
          OnClick = btn_SubDisabledPicClick
        end
        object gb_SubOfficeHint: TGroupBox
          Left = 8
          Top = 234
          Width = 361
          Height = 121
          Caption = 'OfficeHint'
          TabOrder = 10
          object lbl_SubHintTile: TLabel
            Left = 9
            Top = 24
            Width = 20
            Height = 13
            Caption = 'Title'
          end
          object lbl_SubHintNotes: TLabel
            Left = 8
            Top = 44
            Width = 28
            Height = 13
            Caption = 'Notes'
          end
          object mem_SubHintNotes: TMemo
            Left = 9
            Top = 58
            Width = 259
            Height = 55
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = mem_SubHintNotesChange
          end
          object edt_SubHintTitle: TEdit
            Left = 59
            Top = 20
            Width = 206
            Height = 21
            TabOrder = 1
            OnKeyUp = edt_SubHintTitleKeyUp
          end
          object btn_SubHintPicture: TButton
            Left = 275
            Top = 56
            Width = 75
            Height = 25
            Caption = 'Picture'
            TabOrder = 2
          end
          object chk_SubShowHelp: TCheckBox
            Left = 273
            Top = 24
            Width = 76
            Height = 17
            Caption = 'Show Help'
            TabOrder = 3
            OnClick = chk_SubShowHelpClick
          end
        end
        object btn_SubItemRemove: TButton
          Left = 67
          Top = 360
          Width = 60
          Height = 25
          Caption = 'Remove'
          TabOrder = 11
          OnClick = btn_SubItemRemoveClick
        end
        object btn_SubItemAdd: TButton
          Left = 8
          Top = 360
          Width = 60
          Height = 25
          Caption = 'Add'
          TabOrder = 12
          OnClick = btn_SubItemAddClick
        end
        object btn_RemoveDefault: TButton
          Left = 271
          Top = 360
          Width = 98
          Height = 25
          Caption = 'Remove Default'
          TabOrder = 13
          OnClick = btn_RemoveDefaultClick
        end
        object btn_AddDefault: TButton
          Left = 184
          Top = 360
          Width = 88
          Height = 25
          Caption = 'Add Default'
          TabOrder = 14
          OnClick = btn_AddDefaultClick
        end
        object cmb_SubAction: TComboBox
          Left = 75
          Top = 70
          Width = 97
          Height = 21
          ItemHeight = 13
          TabOrder = 15
          OnChange = cmb_SubActionChange
        end
      end
    end
    object btn_Ok: TButton
      Left = 234
      Top = 432
      Width = 75
      Height = 25
      Hint = 'Ok'
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object Button1: TButton
      Left = 308
      Top = 432
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object OpenDialog: TOpenPictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.gif;*.bmp;*.png)|*.jpg;*.jpeg;*.gif;*.bmp;*.' +
      'png|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpe' +
      'g|GIF files (*.gif)|*.gif|Bitmaps (*.bmp)|*.bmp|PNG files (*.png' +
      ')|*.png'
    Left = 592
  end
end
