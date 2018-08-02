object frmEditTextFiles: TfrmEditTextFiles
  Left = 346
  Top = 207
  Width = 360
  Height = 347
  Caption = 'Edit Text Files'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    352
    320)
  PixelsPerInch = 96
  TextHeight = 14
  object pcTextFiles: TPageControl
    Left = 8
    Top = 8
    Width = 337
    Height = 274
    ActivePage = tsInvoiceFail
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 3
    TabOrder = 0
    object tsOrderOK: TTabSheet
      Caption = 'Order OK'
      DesignSize = (
        329
        245)
      object memOrderOK: TMemo
        Left = 8
        Top = 8
        Width = 313
        Height = 229
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
      end
    end
    object tsOrderFail: TTabSheet
      Caption = 'Order Fail'
      ImageIndex = 1
      DesignSize = (
        329
        245)
      object memOrderFail: TMemo
        Left = 8
        Top = 8
        Width = 313
        Height = 229
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
      end
    end
    object tsInvoiceOK: TTabSheet
      Caption = 'Invoice OK'
      ImageIndex = 2
      DesignSize = (
        329
        245)
      object memInvoiceOK: TMemo
        Left = 8
        Top = 8
        Width = 313
        Height = 229
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
      end
    end
    object tsInvoiceFail: TTabSheet
      Caption = 'Invoice Fail'
      ImageIndex = 3
      DesignSize = (
        329
        245)
      object memInvoiceFail: TMemo
        Left = 8
        Top = 8
        Width = 313
        Height = 229
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
      end
    end
  end
  object Button1: TButton
    Left = 192
    Top = 289
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button2: TButton
    Left = 272
    Top = 289
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 2
    OnClick = Button2Click
  end
end
