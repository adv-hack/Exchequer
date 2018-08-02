object frBase: TfrBase
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object alMain: TActionList
    Left = 64
    Top = 48
    object aExpand: TAction
      Caption = 'Expand All'
      ShortCut = 24645
      OnExecute = aExpandExecute
    end
    object aCollapse: TAction
      Caption = 'Collapse All'
      ShortCut = 24643
      OnExecute = aCollapseExecute
    end
    object aBestFit: TAction
      Caption = 'Apply Best Fit'
      OnExecute = aBestFitExecute
    end
    object aRefresh: TAction
      Caption = 'Refresh'
      ShortCut = 116
      OnExecute = aRefreshExecute
    end
  end
  object pmMain: TPopupMenu
    Left = 48
    Top = 120
    object CollapseAll1: TMenuItem
      Action = aCollapse
    end
    object CollapseAll2: TMenuItem
      Action = aExpand
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ApplyBestFit1: TMenuItem
      Action = aBestFit
    end
    object Refresh1: TMenuItem
      Action = aRefresh
    end
  end
end
