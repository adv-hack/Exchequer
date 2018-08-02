object InHForm: TInHForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 214
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 307
    Height = 173
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object SBSPanel4: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 289
        Height = 100
        TextId = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 64
    Top = 138
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = OkCP1BtnClick
  end
  object ClsCP1Btn: TButton
    Left = 150
    Top = 138
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = OkCP1BtnClick
  end
  object TitlePnl: TPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 41
    Align = alTop
    Color = clWhite
    TabOrder = 3
  end
end
