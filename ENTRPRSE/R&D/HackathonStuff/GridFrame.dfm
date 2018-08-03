inherited frDataGrid: TfrDataGrid
  Width = 958
  Height = 447
  object pnlMain: TPanel [0]
    Left = 0
    Top = 0
    Width = 958
    Height = 447
    Align = alClient
    TabOrder = 0
    object grdMain: TcxGrid
      Left = 1
      Top = 1
      Width = 956
      Height = 445
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
        DataController.KeyFieldNames = 'PositionId'
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
        DataController.DetailKeyFieldNames = 'tlFolioNum'
        DataController.KeyFieldNames = 'PositionId'
        DataController.MasterKeyFieldNames = 'thFolioNum'
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
        object vDetailtlFolioNum: TcxGridDBColumn
          DataBinding.FieldName = 'tlFolioNum'
          Visible = False
        end
        object vDetailtlStockCodeTrans1: TcxGridDBColumn
          DataBinding.FieldName = 'tlStockCodeTrans1'
        end
        object vDetailtlDescription: TcxGridDBColumn
          DataBinding.FieldName = 'tlDescription'
        end
        object vDetailtlOurRef: TcxGridDBColumn
          DataBinding.FieldName = 'tlOurRef'
        end
        object vDetailtlGLCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlGLCode'
        end
        object vDetailtlLineType: TcxGridDBColumn
          DataBinding.FieldName = 'tlLineType'
          Visible = False
        end
        object vDetailtlDepartment: TcxGridDBColumn
          DataBinding.FieldName = 'tlDepartment'
        end
        object vDetailtlCostCentre: TcxGridDBColumn
          DataBinding.FieldName = 'tlCostCentre'
        end
        object vDetailtlDocType: TcxGridDBColumn
          DataBinding.FieldName = 'tlDocType'
          Visible = False
        end
        object vDetailtlQty: TcxGridDBColumn
          DataBinding.FieldName = 'tlQty'
        end
        object vDetailtlQtyMul: TcxGridDBColumn
          DataBinding.FieldName = 'tlQtyMul'
        end
        object vDetailtlNetValue: TcxGridDBColumn
          DataBinding.FieldName = 'tlNetValue'
        end
        object vDetailtlDiscount: TcxGridDBColumn
          DataBinding.FieldName = 'tlDiscount'
        end
        object vDetailtlVATCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlVATCode'
        end
        object vDetailtlVATAmount: TcxGridDBColumn
          DataBinding.FieldName = 'tlVATAmount'
          Visible = False
        end
        object vDetailtlPaymentCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlPaymentCode'
          Visible = False
        end
        object vDetailtlCost: TcxGridDBColumn
          DataBinding.FieldName = 'tlCost'
          Visible = False
        end
        object vDetailtlAcCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlAcCode'
        end
        object vDetailtlLineDate: TcxGridDBColumn
          DataBinding.FieldName = 'tlLineDate'
          Visible = False
        end
        object vDetailtlJobCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlJobCode'
          Visible = False
        end
        object vDetailtlAnalysisCode: TcxGridDBColumn
          DataBinding.FieldName = 'tlAnalysisCode'
          Visible = False
        end
        object vDetailtlStockDeductQty: TcxGridDBColumn
          DataBinding.FieldName = 'tlStockDeductQty'
        end
        object vDetailtlLocation: TcxGridDBColumn
          DataBinding.FieldName = 'tlLocation'
        end
        object vDetailtlQtyPicked: TcxGridDBColumn
          DataBinding.FieldName = 'tlQtyPicked'
        end
        object vDetailtlQtyPickedWO: TcxGridDBColumn
          DataBinding.FieldName = 'tlQtyPickedWO'
          Visible = False
        end
        object vDetailtlUsePack: TcxGridDBColumn
          DataBinding.FieldName = 'tlUsePack'
          Visible = False
        end
        object vDetailtlSerialQty: TcxGridDBColumn
          DataBinding.FieldName = 'tlSerialQty'
          Visible = False
        end
        object vDetailtlQtyPack: TcxGridDBColumn
          DataBinding.FieldName = 'tlQtyPack'
          Visible = False
        end
        object vDetailtlAcCodeTrans: TcxGridDBColumn
          DataBinding.FieldName = 'tlAcCodeTrans'
          Visible = False
        end
        object vDetailPositionId: TcxGridDBColumn
          DataBinding.FieldName = 'PositionId'
          Visible = False
        end
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
