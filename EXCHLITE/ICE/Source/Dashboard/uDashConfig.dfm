object frmConfiguration: TfrmConfiguration
  Left = 438
  Top = 313
  HelpContext = 3
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 450
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  HelpFile = 'ClientSync.hlp'
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object advPanel: TAdvPanel
    Left = 0
    Top = 0
    Width = 565
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    Color = 16640730
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.7.2'
    AutoHideChildren = False
    BorderColor = 16765615
    Caption.Color = 16773091
    Caption.ColorTo = 16765615
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clBlack
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    Caption.GradientDirection = gdVertical
    Caption.Indent = 2
    Caption.ShadeLight = 255
    CollapsColor = clHighlight
    CollapsDelay = 0
    ColorTo = 14986888
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.BorderColor = 16765615
    StatusBar.BorderStyle = bsSingle
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = 7485192
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    StatusBar.Color = 16245715
    StatusBar.ColorTo = 16109747
    StatusBar.GradientDirection = gdVertical
    FullHeight = 0
    object btnSave: TAdvGlowButton
      Left = 390
      Top = 420
      Width = 80
      Height = 21
      Caption = '&Save'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FocusType = ftHot
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
      OnClick = btnSaveClick
      Appearance.BorderColor = clGray
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object btnCancel: TAdvGlowButton
      Left = 475
      Top = 420
      Width = 80
      Height = 21
      Caption = '&Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FocusType = ftHot
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = True
      OnClick = btnCancelClick
      Appearance.BorderColor = clGray
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object ofConfig: TAdvOfficePager
      Left = 8
      Top = 53
      Width = 547
      Height = 358
      AdvOfficePagerStyler = pgStyler
      ActivePage = ofpDash
      ButtonSettings.CloseButtonPicture.Data = {
        424DA20400000000000036040000280000000900000009000000010008000000
        00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001000001010100000100
        0000000202000100020200000000000202020002020200000000010002020202
        0200010000000101000202020001010000000100020202020200010000000002
        0202000202020000000000020200010002020000000001000001010100000100
        0000}
      ButtonSettings.PageListButtonPicture.Data = {
        424DA20400000000000036040000280000000900000009000000010008000000
        00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000101010100
        0000010101000200010101000000010100020202000101000000010002020202
        0200010000000002020200020202000000000002020001000202000000000100
        0001010100000100000001010101010101010100000001010101010101010100
        0000}
      ButtonSettings.ScrollButtonPrevPicture.Data = {
        424DA20400000000000036040000280000000900000009000000010008000000
        00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010101000001010100
        0000010101000202000101000000010100020202000101000000010002020200
        0101010000000002020200010101010000000100020202000101010000000101
        0002020200010100000001010100020200010100000001010101000001010100
        0000}
      ButtonSettings.ScrollButtonNextPicture.Data = {
        424DA20400000000000036040000280000000900000009000000010008000000
        00006C000000C30E0000C30E00000001000000010000427B8400DEEFEF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0001010000010101010100
        0000010002020001010101000000010002020200010101000000010100020202
        0001010000000101010002020200010000000101000202020001010000000100
        0202020001010100000001000202000101010100000001010000010101010100
        0000}
      ButtonSettings.CloseButtonHint = 'Close'
      ButtonSettings.PageListButtonHint = 'PageList'
      ButtonSettings.ScrollButtonNextHint = 'Next'
      ButtonSettings.ScrollButtonPrevHint = 'Previous'
      TabSettings.StartMargin = 4
      TabReorder = False
      ShowShortCutHints = False
      OnChange = ofConfigChange
      TabOrder = 0
      TabStop = True
      NextPictureChanged = False
      PrevPictureChanged = False
      object ofpDash: TAdvOfficePage
        Left = 1
        Top = 26
        Width = 545
        Height = 330
        Caption = '&Dashboard Settings'
        object Label2: TLabel
          Left = 10
          Top = 12
          Width = 75
          Height = 14
          Caption = 'Company Name'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object edtCompanyName: TAdvEdit
          Tag = 9
          Left = 10
          Top = 28
          Width = 275
          Height = 22
          DisabledColor = clWindow
          ReturnIsTab = True
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'MS Sans Serif'
          LabelFont.Style = []
          Lookup.Separator = ';'
          AutoSize = False
          Color = clWindow
          Ctl3D = False
          Enabled = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Visible = True
          Version = '2.7.4.1'
        end
        object gbAditional: TAdvGroupBox
          Left = 10
          Top = 180
          Width = 525
          Height = 143
          Caption = ' General Settings '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object ScrollBox1: TAdvScrollBox
            Left = 2
            Top = 17
            Width = 521
            Height = 124
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 0
            object pnlDash: TAdvPanel
              Left = 0
              Top = 0
              Width = 521
              Height = 65
              Align = alTop
              BevelOuter = bvNone
              Color = 16445929
              Font.Charset = ANSI_CHARSET
              Font.Color = 7485192
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              UseDockManager = True
              Version = '1.7.7.2'
              AutoHideChildren = False
              BorderColor = 16765615
              Caption.Color = 16773091
              Caption.ColorTo = 16765615
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clBlack
              Caption.Font.Height = -11
              Caption.Font.Name = 'MS Sans Serif'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Indent = 2
              Caption.ShadeLight = 255
              CollapsColor = clHighlight
              CollapsDelay = 0
              ColorTo = 15587527
              ColorMirror = 15587527
              ColorMirrorTo = 16773863
              ShadowColor = clBlack
              ShadowOffset = 0
              StatusBar.BorderColor = 16765615
              StatusBar.BorderStyle = bsSingle
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = 7485192
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              StatusBar.Color = 16245715
              StatusBar.ColorTo = 16109747
              StatusBar.GradientDirection = gdVertical
              FullHeight = 0
              object cbDripFeed: TAdvOfficeCheckBox
                Left = 8
                Top = 0
                Width = 265
                Height = 20
                Alignment = taLeftJustify
                Caption = 'Automatic Update Link (every 60 minutes)'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = True
                ShadowColor = clNone
                TabOrder = 0
                TabStop = True
                Version = '1.1.0.0'
              end
              object cbShowAlert: TAdvOfficeCheckBox
                Left = 8
                Top = 20
                Width = 229
                Height = 20
                Alignment = taLeftJustify
                Caption = 'Show a visual alert when an e-mail arrives'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = True
                ShadowColor = clNone
                TabOrder = 1
                TabStop = True
                Version = '1.1.0.0'
              end
              object cbShowReminder: TAdvOfficeCheckBox
                Left = 8
                Top = 40
                Width = 229
                Height = 20
                Alignment = taLeftJustify
                Caption = 'Show reminder window'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = True
                ShadowColor = clNone
                TabOrder = 2
                TabStop = True
                Version = '1.1.0.0'
              end
              object cbExportAddon: TAdvOfficeCheckBox
                Left = 8
                Top = 61
                Width = 129
                Height = 20
                Alignment = taLeftJustify
                Caption = '<FONT face="Arial">Active Export Add-ons</FONT>'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = False
                ShadowColor = clNone
                TabOrder = 3
                TabStop = True
                Visible = False
                Version = '1.1.0.0'
              end
              object cbImportAddon: TAdvOfficeCheckBox
                Left = 278
                Top = 61
                Width = 129
                Height = 20
                Alignment = taLeftJustify
                Caption = '<FONT face="Arial">Active Import Add-ons</FONT>'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = False
                ShadowColor = clNone
                TabOrder = 4
                TabStop = True
                Visible = False
                Version = '1.1.0.0'
              end
            end
            object pnlCIS: TAdvPanel
              Left = 0
              Top = 65
              Width = 521
              Height = 25
              Align = alTop
              BevelOuter = bvNone
              Color = 16445929
              Font.Charset = ANSI_CHARSET
              Font.Color = 7485192
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              UseDockManager = True
              Version = '1.7.7.2'
              AutoHideChildren = False
              BorderColor = 16765615
              Caption.Color = 16773091
              Caption.ColorTo = 16765615
              Caption.Font.Charset = DEFAULT_CHARSET
              Caption.Font.Color = clBlack
              Caption.Font.Height = -11
              Caption.Font.Name = 'MS Sans Serif'
              Caption.Font.Style = []
              Caption.GradientDirection = gdVertical
              Caption.Indent = 2
              Caption.ShadeLight = 255
              CollapsColor = clHighlight
              CollapsDelay = 0
              ColorTo = 15587527
              ColorMirror = 15587527
              ColorMirrorTo = 16773863
              ShadowColor = clBlack
              ShadowOffset = 0
              StatusBar.BorderColor = 16765615
              StatusBar.BorderStyle = bsSingle
              StatusBar.Font.Charset = DEFAULT_CHARSET
              StatusBar.Font.Color = 7485192
              StatusBar.Font.Height = -11
              StatusBar.Font.Name = 'Tahoma'
              StatusBar.Font.Style = []
              StatusBar.Color = 16245715
              StatusBar.ColorTo = 16109747
              StatusBar.GradientDirection = gdVertical
              FullHeight = 0
              object cbUseTestGateway: TAdvOfficeCheckBox
                Left = 8
                Top = 0
                Width = 265
                Height = 20
                Alignment = taLeftJustify
                Caption = 'Use CIS test Gateway'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = True
                ShadowColor = clNone
                TabOrder = 0
                TabStop = True
                OnClick = cbUseTestGatewayClick
                Version = '1.1.0.0'
              end
              object AdvOfficeCheckBox4: TAdvOfficeCheckBox
                Left = 8
                Top = 61
                Width = 129
                Height = 20
                Alignment = taLeftJustify
                Caption = '<FONT face="Arial">Active Export Add-ons</FONT>'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = False
                ShadowColor = clNone
                TabOrder = 1
                TabStop = True
                Visible = False
                Version = '1.1.0.0'
              end
              object AdvOfficeCheckBox5: TAdvOfficeCheckBox
                Left = 278
                Top = 61
                Width = 129
                Height = 20
                Alignment = taLeftJustify
                Caption = '<FONT face="Arial">Active Import Add-ons</FONT>'
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'Arial'
                Font.Style = []
                ParentFont = False
                ReturnIsTab = False
                ShadowColor = clNone
                TabOrder = 2
                TabStop = True
                Visible = False
                Version = '1.1.0.0'
              end
            end
          end
        end
        object gbServers: TAdvGroupBox
          Left = 10
          Top = 56
          Width = 525
          Height = 118
          Caption = ' Servers '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object lblDbServer: TLabel
            Left = 8
            Top = 18
            Width = 198
            Height = 14
            Caption = 'Database Server Name (requires restart)'
            Transparent = True
          end
          object lbServiceServer: TLabel
            Left = 8
            Top = 64
            Width = 103
            Height = 14
            Caption = 'Service Server Name'
            Transparent = True
          end
          object lblPort: TLabel
            Left = 310
            Top = 64
            Width = 19
            Height = 14
            Caption = 'Port'
            Transparent = True
          end
          object Label1: TLabel
            Left = 310
            Top = 18
            Width = 206
            Height = 14
            Caption = 'Database Instance Name (requires restart)'
            Transparent = True
          end
          object edtDatabaseServer: TAdvEdit
            Tag = 9
            Left = 8
            Top = 34
            Width = 175
            Height = 22
            ReturnIsTab = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'MS Sans Serif'
            LabelFont.Style = []
            Lookup.Separator = ';'
            AutoSize = False
            Color = clWindow
            Ctl3D = False
            Enabled = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            Visible = True
            Version = '2.7.4.1'
          end
          object edtDSRServer: TAdvEdit
            Tag = 9
            Left = 8
            Top = 80
            Width = 175
            Height = 22
            ReturnIsTab = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'MS Sans Serif'
            LabelFont.Style = []
            Lookup.Separator = ';'
            AutoSize = False
            Color = clWindow
            Ctl3D = False
            Enabled = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            Visible = True
            Version = '2.7.4.1'
          end
          object seDSRPort: TAdvSpinEdit
            Left = 310
            Top = 80
            Width = 55
            Height = 23
            ReturnIsTab = True
            Value = 6505
            FloatValue = 6505
            HexValue = 5
            Ctl3D = False
            Enabled = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            IncrementFloat = 0.1
            IncrementFloatPage = 1
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'MS Sans Serif'
            LabelFont.Style = []
            MaxLength = 5
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 5
            Visible = True
            Version = '1.4.3.0'
            OnChange = seDSRPortChange
          end
          object btnBrowseDbServer: TAdvGlowButton
            Left = 188
            Top = 34
            Width = 80
            Height = 21
            Caption = 'Browse...'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 1
            TabStop = True
            OnClick = btnBrowseDbServerClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
          end
          object btnBrowseClientSync: TAdvGlowButton
            Left = 188
            Top = 80
            Width = 80
            Height = 21
            Caption = 'Browse...'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            FocusType = ftHot
            NotesFont.Charset = DEFAULT_CHARSET
            NotesFont.Color = clWindowText
            NotesFont.Height = -11
            NotesFont.Name = 'Tahoma'
            NotesFont.Style = []
            ParentFont = False
            TabOrder = 4
            TabStop = True
            OnClick = btnBrowseClientSyncClick
            Appearance.ColorChecked = 16111818
            Appearance.ColorCheckedTo = 16367008
            Appearance.ColorDisabled = 15921906
            Appearance.ColorDisabledTo = 15921906
            Appearance.ColorDown = 16111818
            Appearance.ColorDownTo = 16367008
            Appearance.ColorHot = 16117985
            Appearance.ColorHotTo = 16372402
            Appearance.ColorMirrorHot = 16107693
            Appearance.ColorMirrorHotTo = 16775412
            Appearance.ColorMirrorDown = 16102556
            Appearance.ColorMirrorDownTo = 16768988
            Appearance.ColorMirrorChecked = 16102556
            Appearance.ColorMirrorCheckedTo = 16768988
            Appearance.ColorMirrorDisabled = 11974326
            Appearance.ColorMirrorDisabledTo = 15921906
          end
          object edtInstance: TAdvEdit
            Tag = 9
            Left = 310
            Top = 34
            Width = 175
            Height = 22
            ReturnIsTab = True
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'MS Sans Serif'
            LabelFont.Style = []
            Lookup.Separator = ';'
            AutoSize = False
            Color = clWindow
            Ctl3D = False
            Enabled = True
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 2
            Visible = True
            Version = '2.7.4.1'
          end
        end
      end
      object ofpDsr: TAdvOfficePage
        Left = 1
        Top = 26
        Width = 545
        Height = 330
        Caption = '&E-Mail Settings'
        inline frmDSRConfigFrame: TfrmDSRConfigFrame
          Left = 2
          Top = 2
          Width = 541
          Height = 326
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          inherited advPanel: TAdvPanel
            Width = 541
            Height = 326
            FullHeight = 0
          end
        end
      end
    end
    object pnlInfo: TPanel
      Left = 0
      Top = 0
      Width = 565
      Height = 41
      Align = alTop
      Color = clWhite
      TabOrder = 3
      object lblInfo: TLabel
        Left = 8
        Top = 12
        Width = 202
        Height = 15
        Caption = 'Dashboard and E-Mail Configuration'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pgStyler: TAdvOfficePagerOfficeStyler
    Style = psOffice2007Luna
    PageAppearance.BorderColor = 14922381
    PageAppearance.Color = 16445929
    PageAppearance.ColorTo = 15587527
    PageAppearance.ColorMirror = 15587527
    PageAppearance.ColorMirrorTo = 16773863
    PageAppearance.Gradient = ggVertical
    PageAppearance.GradientMirror = ggVertical
    TabAppearance.BorderColor = clNone
    TabAppearance.BorderColorHot = 15383705
    TabAppearance.BorderColorSelected = 14922381
    TabAppearance.BorderColorSelectedHot = 6343929
    TabAppearance.BorderColorDisabled = clNone
    TabAppearance.BorderColorDown = clNone
    TabAppearance.Color = clBtnFace
    TabAppearance.ColorTo = clWhite
    TabAppearance.ColorSelected = 16709360
    TabAppearance.ColorSelectedTo = 16445929
    TabAppearance.ColorDisabled = clWhite
    TabAppearance.ColorDisabledTo = clSilver
    TabAppearance.ColorHot = 14542308
    TabAppearance.ColorHotTo = 16768709
    TabAppearance.ColorMirror = clWhite
    TabAppearance.ColorMirrorTo = clWhite
    TabAppearance.ColorMirrorHot = 14016477
    TabAppearance.ColorMirrorHotTo = 10736609
    TabAppearance.ColorMirrorSelected = 16445929
    TabAppearance.ColorMirrorSelectedTo = 16181984
    TabAppearance.ColorMirrorDisabled = clWhite
    TabAppearance.ColorMirrorDisabledTo = clSilver
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Color = clWindowText
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Tahoma'
    TabAppearance.Font.Style = []
    TabAppearance.Gradient = ggVertical
    TabAppearance.GradientMirror = ggVertical
    TabAppearance.GradientHot = ggRadial
    TabAppearance.GradientMirrorHot = ggVertical
    TabAppearance.GradientSelected = ggVertical
    TabAppearance.GradientMirrorSelected = ggVertical
    TabAppearance.GradientDisabled = ggVertical
    TabAppearance.GradientMirrorDisabled = ggVertical
    TabAppearance.TextColor = 9126421
    TabAppearance.TextColorHot = 9126421
    TabAppearance.TextColorSelected = 9126421
    TabAppearance.TextColorDisabled = clGray
    TabAppearance.BackGround.Color = 16767935
    TabAppearance.BackGround.ColorTo = clNone
    TabAppearance.BackGround.Direction = gdVertical
    GlowButtonAppearance.BorderColor = 14727579
    GlowButtonAppearance.BorderColorHot = 10079963
    GlowButtonAppearance.BorderColorDown = 4548219
    GlowButtonAppearance.BorderColorChecked = 4548219
    GlowButtonAppearance.Color = 15653832
    GlowButtonAppearance.ColorTo = 16178633
    GlowButtonAppearance.ColorChecked = 11918331
    GlowButtonAppearance.ColorCheckedTo = 7915518
    GlowButtonAppearance.ColorDisabled = 15921906
    GlowButtonAppearance.ColorDisabledTo = 15921906
    GlowButtonAppearance.ColorDown = 7778289
    GlowButtonAppearance.ColorDownTo = 4296947
    GlowButtonAppearance.ColorHot = 15465983
    GlowButtonAppearance.ColorHotTo = 11332863
    GlowButtonAppearance.ColorMirror = 15586496
    GlowButtonAppearance.ColorMirrorTo = 16245200
    GlowButtonAppearance.ColorMirrorHot = 5888767
    GlowButtonAppearance.ColorMirrorHotTo = 10807807
    GlowButtonAppearance.ColorMirrorDown = 946929
    GlowButtonAppearance.ColorMirrorDownTo = 5021693
    GlowButtonAppearance.ColorMirrorChecked = 10480637
    GlowButtonAppearance.ColorMirrorCheckedTo = 5682430
    GlowButtonAppearance.ColorMirrorDisabled = 11974326
    GlowButtonAppearance.ColorMirrorDisabledTo = 15921906
    GlowButtonAppearance.GradientHot = ggVertical
    GlowButtonAppearance.GradientMirrorHot = ggVertical
    GlowButtonAppearance.GradientDown = ggVertical
    GlowButtonAppearance.GradientMirrorDown = ggVertical
    GlowButtonAppearance.GradientChecked = ggVertical
    Left = 348
    Top = 46
  end
end
