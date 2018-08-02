inherited frmAddOnExportFrame: TfrmAddOnExportFrame
  Width = 672
  inherited advPanel: TAdvPanel
    Width = 672
    FullHeight = 0
    inherited advMail: TAdvPanel
      Width = 670
      FullHeight = 0
      inherited btnSend: TAdvGlowButton
        Left = 455
        FocusType = ftHot
      end
      inherited btnCancel: TAdvGlowButton
        FocusType = ftHot
      end
    end
    inherited advDockdashTop: TAdvDockPanel
      Width = 670
      inherited advToolMenu: TAdvToolBar
        Width = 664
      end
    end
  end
end
