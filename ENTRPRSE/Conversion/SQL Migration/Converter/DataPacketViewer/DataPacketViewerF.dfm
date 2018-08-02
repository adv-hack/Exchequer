object frmDataPacketViewer: TfrmDataPacketViewer
  Left = 405
  Top = 146
  Width = 887
  Height = 634
  Caption = 'frmDataPacketViewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    871
    595)
  PixelsPerInch = 96
  TextHeight = 13
  object memInfo: TMemo
    Left = 252
    Top = 5
    Width = 613
    Height = 587
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object DirectoryListBoxEx1: TDirectoryListBoxEx
    Left = 5
    Top = 32
    Width = 243
    Height = 186
    FileList = FileListBoxEx1
    ItemHeight = 16
    TabOrder = 1
    DirectOpen = False
    Version = '1.2.1.0'
  end
  object FileListBoxEx1: TFileListBoxEx
    Left = 5
    Top = 223
    Width = 243
    Height = 368
    Anchors = [akLeft, akTop, akBottom]
    ExtendedSelect = False
    ItemHeight = 16
    Mask = 'DataPacket*.xml'
    ShowGlyphs = True
    TabOrder = 2
    OnClick = FileListBoxEx1Click
    Version = '1.2.1.0'
  end
  object DriveComboBoxEx1: TDriveComboBoxEx
    Left = 5
    Top = 5
    Width = 244
    Height = 22
    DirList = DirectoryListBoxEx1
    TabOrder = 3
    Version = '1.2.1.0'
  end
end
