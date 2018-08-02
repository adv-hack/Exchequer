object frmDBUpdate: TfrmDBUpdate
  Left = 384
  Top = 384
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'DSR DB Update'
  ClientHeight = 85
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object advPanel: TAdvPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 85
    Align = alClient
    BevelOuter = bvNone
    Color = 16640730
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.6.0'
    BorderColor = 16640730
    Caption.Color = clHighlight
    Caption.ColorTo = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clHighlightText
    Caption.Font.Height = -11
    Caption.Font.Name = 'MS Sans Serif'
    Caption.Font.Style = []
    ColorTo = 14986888
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    FullHeight = 0
    object btnOk: TAdvGlowButton
      Left = 186
      Top = 56
      Width = 80
      Height = 21
      BorderStyle = bsNone
      Caption = '&Ok'
      ModalResult = 1
      TabOrder = 1
      TabStop = True
      OnClick = btnOkClick
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
      Left = 272
      Top = 56
      Width = 80
      Height = 21
      BorderStyle = bsNone
      Caption = '&Cancel'
      ModalResult = 2
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
    object edtSql: TAdvFileNameEdit
      Left = 12
      Top = 18
      Width = 339
      Height = 19
      Flat = False
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'MS Sans Serif'
      LabelFont.Style = []
      Lookup.Separator = ';'
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clWindow
      Ctl3D = False
      Enabled = True
      ParentCtl3D = False
      TabOrder = 0
      Visible = True
      Version = '1.3.1.0'
      ButtonStyle = bsButton
      ButtonWidth = 18
      Etched = False
      Glyph.Data = {
        CE000000424DCE0000000000000076000000280000000C0000000B0000000100
        0400000000005800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
        00000077777770DD00000F077777770D00000FF07777777000000FFF00000000
        00000FFFFFFF0DDD00000FFF00000DDD0000D000DDDDD0000000DDDDDDDDDD00
        0000DDDDD0DDD0D00000DDDDDD000DDD0000}
      DefaultExt = '*.sql'
      Filter = 'SQL Files (*.sql)|*.SQL'
      FilterIndex = 0
      DialogOptions = [ofPathMustExist, ofFileMustExist]
      DialogKind = fdOpen
    end
  end
  object ADOCon: TADOConnection
    LoginPrompt = False
    Left = 74
    Top = 42
  end
  object adoCommand: TADOCommand
    CommandType = cmdUnknown
    Connection = ADOCon
    Parameters = <>
    Left = 102
    Top = 42
  end
end
