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
      object vDetail: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        NavigatorButtons.First.Visible = True
        NavigatorButtons.PriorPage.Visible = True
        NavigatorButtons.Prior.Visible = True
        NavigatorButtons.Next.Visible = True
        NavigatorButtons.NextPage.Visible = True
        NavigatorButtons.Last.Visible = True
        NavigatorButtons.Insert.Visible = False
        NavigatorButtons.Append.Visible = False
        NavigatorButtons.Delete.Visible = False
        NavigatorButtons.Edit.Visible = False
        NavigatorButtons.Post.Visible = False
        NavigatorButtons.Cancel.Visible = True
        NavigatorButtons.Refresh.Visible = False
        NavigatorButtons.SaveBookmark.Visible = False
        NavigatorButtons.GotoBookmark.Visible = False
        NavigatorButtons.Filter.Visible = True
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
        object lvlDetail: TcxGridLevel
          GridView = vDetail
          Visible = False
        end
      end
    end
  end
  inherited alMain: TActionList
    Top = 56
    object aColumnCust: TAction [3]
      Caption = 'Column Customization'
    end
    object aExportToExcel: TAction [4]
      Caption = 'Export To Excel'
      OnExecute = aExportToExcelExecute
    end
    object aExportToHtml: TAction [5]
      Caption = 'Export To HTML'
      OnExecute = aExportToHtmlExecute
    end
    object aExportToXML: TAction [6]
      Caption = 'Export To XML'
      OnExecute = aExportToXMLExecute
    end
    object aExportToText: TAction [7]
      Caption = 'Export To Text'
      OnExecute = aExportToTextExecute
    end
    object aShowDetail: TAction [8]
      Caption = 'Show Detail'
      OnExecute = aShowDetailExecute
    end
  end
  inherited pmMain: TPopupMenu
    inherited ApplyBestFit1: TMenuItem [0]
    end
    object N3: TMenuItem [1]
      Caption = '-'
    end
    inherited CollapseAll1: TMenuItem [2]
    end
    inherited CollapseAll2: TMenuItem [3]
    end
    inherited N1: TMenuItem [4]
    end
    object mniShowDetail: TMenuItem [5]
      Action = aShowDetail
    end
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
