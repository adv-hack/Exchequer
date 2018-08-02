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
    object aColumnCust: TAction
      Caption = 'Column Customization'
      OnExecute = aColumnCustExecute
    end
  end
end
