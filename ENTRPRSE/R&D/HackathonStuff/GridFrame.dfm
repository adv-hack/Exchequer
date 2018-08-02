inherited frDataGrid: TfrDataGrid
  object pnlMain: TPanel [0]
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    TabOrder = 0
    object grdMain: TcxGrid
      Left = 1
      Top = 1
      Width = 318
      Height = 238
      Align = alClient
      TabOrder = 0
      object vMain: TcxGridDBTableView
        PopupMenu = pmMain
        NavigatorButtons.ConfirmDelete = False
        NavigatorButtons.Insert.Visible = False
        NavigatorButtons.Delete.Visible = False
        NavigatorButtons.Edit.Visible = False
        NavigatorButtons.Post.Visible = False
        NavigatorButtons.Refresh.Visible = False
        NavigatorButtons.SaveBookmark.Visible = False
        NavigatorButtons.GotoBookmark.Visible = False
        DataController.DataModeController.GridMode = True
        DataController.DataModeController.GridModeBufferCount = 10
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsSelection.MultiSelect = True
        OptionsView.Navigator = True
        OptionsView.NavigatorOffset = 60
      end
      object lvlMain: TcxGridLevel
        GridView = vMain
      end
    end
  end
  inherited alMain: TActionList
    Top = 56
    object aColumnCust: TAction
      Caption = 'Column Customization'
    end
    object aExportToExcel: TAction
      Caption = 'Export To Excel'
      OnExecute = aExportToExcelExecute
    end
    object aExportToHtml: TAction
      Caption = 'Export To HTML'
      OnExecute = aExportToHtmlExecute
    end
    object aExportToXML: TAction
      Caption = 'Export To XML'
      OnExecute = aExportToXMLExecute
    end
    object aExportToText: TAction
      Caption = 'Export To Text'
      OnExecute = aExportToTextExecute
    end
  end
  inherited pmMain: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object ExportToExcel1: TMenuItem
      Action = aExportToExcel
    end
    object ExportToHTML1: TMenuItem
      Action = aExportToHtml
    end
    object ExportToText1: TMenuItem
      Action = aExportToText
    end
    object ExportToXML1: TMenuItem
      Action = aExportToXML
    end
  end
  object SaveDialog: TSaveDialog
    Left = 240
    Top = 96
  end
end
