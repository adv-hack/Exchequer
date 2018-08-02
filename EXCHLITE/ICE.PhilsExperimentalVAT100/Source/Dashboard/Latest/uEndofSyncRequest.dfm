object frmEndofSyncRequest: TfrmEndofSyncRequest
  Left = 377
  Top = 277
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'End of Dripfeed'
  ClientHeight = 221
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inline frmExportFrame: TfrmExportFrame
    Left = 0
    Top = 0
    Width = 648
    Height = 221
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
      Width = 648
      Height = 221
      FullHeight = 0
      inherited advMail: TAdvPanel
        Width = 646
        Height = 178
        FullHeight = 0
      end
      inherited advDockdashTop: TAdvDockPanel
        Width = 646
        inherited advToolMenu: TAdvToolBar
          Width = 640
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
