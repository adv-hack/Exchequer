object frmSubVerification: TfrmSubVerification
  Left = 424
  Top = 334
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Subcontractor Verification'
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inline frmExportFrame: TfrmExportFrame
    Left = 0
    Top = 0
    Width = 645
    Height = 216
    Align = alClient
    Ctl3D = True
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
        Width = 641
        Height = 171
        FullHeight = 0
      end
      inherited advDockdashTop: TAdvDockPanel
        Width = 641
        inherited advToolMenu: TAdvToolBar
          Width = 635
        end
      end
    end
    inherited alExport: TActionList
      inherited actSend: TAction
        OnExecute = frmExportFrameactSendExecute
      end
      inherited actCancel: TAction
        OnExecute = frmExportFrameactCancelExecute
      end
    end
  end
end
