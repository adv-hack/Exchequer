object frmAbout: TfrmAbout
  Left = 605
  Top = 296
  ActiveControl = btnClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About '
  ClientHeight = 362
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object advPanel: TAdvPanel
    Left = 0
    Top = 0
    Width = 298
    Height = 362
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
    object lblVersion: TLabel
      Left = 8
      Top = 60
      Width = 96
      Height = 14
      Caption = 'Dashboard Version:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblDSRVersion: TLabel
      Left = 8
      Top = 78
      Width = 97
      Height = 14
      Caption = 'Client Sync Version:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object btnClose: TAdvGlowButton
      Left = 205
      Top = 334
      Width = 80
      Height = 21
      Caption = '&Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FocusType = ftHot
      ModalResult = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = btnCloseClick
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
    object mmAbout: TMemo
      Left = 8
      Top = 96
      Width = 277
      Height = 235
      Color = clWhite
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'IRIS Accounts Office Dashboard.'
        ''
        #169' Exchequer GovLink is a product of Advanced '
        'Enterprise Software Ltd, trading as Advanced '
        'Business Solutions and an Advanced Computer '
        'Software Group plc company.  '
        ''
        'EXCHEQUER is a trade mark of Advanced Enterprise '
        'Software Limited.  All rights reserved.')
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 298
      Height = 41
      Align = alTop
      Color = clWhite
      TabOrder = 2
      object lblInfo: TLabel
        Left = 8
        Top = 12
        Width = 220
        Height = 15
        Caption = 'Dashboard and Client Sync Information'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
end
