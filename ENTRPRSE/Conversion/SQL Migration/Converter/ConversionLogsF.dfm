inherited frmConversionLogs: TfrmConversionLogs
  Left = 263
  Top = 195
  Width = 804
  Height = 426
  HelpContext = 5
  Caption = 'frmConversionLogs'
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  OldCreateOrder = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  inherited shBanner: TShape
    Width = 796
  end
  inherited lblBanner: TLabel
    Width = 225
    Caption = 'Conversion Results'
  end
  object Label1: TLabel [2]
    Left = 10
    Top = 47
    Width = 776
    Height = 35
    AutoSize = False
    Caption = 
      'The Pervasive.SQL to MS SQL conversion utility has finished conv' +
      'erting the data, please check the logs shown below for warnings ' +
      'and errors in order to decide whether you want to continue the c' +
      'onversion process.'
    WordWrap = True
  end
  object PageControl1: TPageControl [3]
    Left = 8
    Top = 86
    Width = 780
    Height = 271
    ActivePage = tabshLog
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 0
    TabOrder = 0
    object tabshLog: TTabSheet
      Caption = 'Conversion Log'
      DesignSize = (
        772
        242)
      object memLog: TMemo
        Left = 5
        Top = 5
        Width = 762
        Height = 205
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object edtLogPath: TEdit
        Left = 5
        Top = 214
        Width = 762
        Height = 22
        Anchors = [akLeft, akRight, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
    end
    object tabshExceptions: TTabSheet
      Caption = 'Warnings && Errors'
      ImageIndex = 1
      DesignSize = (
        772
        242)
      object memErrors: TMemo
        Left = 5
        Top = 5
        Width = 762
        Height = 205
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object edtErrorsPath: TEdit
        Left = 5
        Top = 214
        Width = 762
        Height = 22
        Anchors = [akLeft, akRight, akBottom]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object btnContinue: TButton [4]
    Left = 313
    Top = 365
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Continue'
    ModalResult = 1
    TabOrder = 1
  end
  object btnAbort: TButton [5]
    Left = 402
    Top = 365
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Abort'
    ModalResult = 2
    TabOrder = 2
  end
end
