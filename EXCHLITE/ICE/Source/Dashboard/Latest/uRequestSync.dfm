object frmRequestSync: TfrmRequestSync
  Left = 418
  Top = 412
  HelpContext = 12
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Link Request'
  ClientHeight = 216
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'ClientSync.hlp'
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object advPanelExport: TAdvPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 216
    Align = alClient
    BevelOuter = bvNone
    Color = 16640730
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    UseDockManager = True
    Version = '1.7.6.0'
    AutoHideChildren = False
    BorderColor = 9841920
    Caption.Color = 12428453
    Caption.ColorTo = 9794677
    Caption.Font.Charset = ANSI_CHARSET
    Caption.Font.Color = clWhite
    Caption.Font.Height = -15
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = [fsBold]
    Caption.Height = 28
    Caption.Indent = 5
    Caption.Text = 'Inbox'
    Caption.TopIndent = 3
    CollapsColor = clBtnFace
    CollapsDelay = 0
    ColorTo = 14986888
    HoverColor = clBlack
    HoverFontColor = clBlack
    ShadowColor = clBlack
    ShadowOffset = 0
    StatusBar.Font.Charset = DEFAULT_CHARSET
    StatusBar.Font.Color = clWindowText
    StatusBar.Font.Height = -11
    StatusBar.Font.Name = 'Tahoma'
    StatusBar.Font.Style = []
    FullHeight = 0
    inline frmExportFrame: TfrmExportFrame
      Left = 0
      Top = 0
      Width = 645
      Height = 216
      Align = alClient
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      inherited advPanel: TAdvPanel
        Width = 645
        Height = 216
        FullHeight = 0
        inherited advMail: TAdvPanel
          Width = 643
          Height = 173
          FullHeight = 0
        end
        inherited advDockdashTop: TAdvDockPanel
          Width = 643
          inherited advToolMenu: TAdvToolBar
            Width = 637
          end
        end
      end
      inherited alExport: TActionList
        inherited actSend: TAction
          OnExecute = frmExportFrameactSendExecute
        end
        inherited actCancel: TAction
          OnExecute = frmExportFrameactCloseExecute
        end
      end
    end
  end
end
