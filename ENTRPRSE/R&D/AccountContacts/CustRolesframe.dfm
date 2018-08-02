object frameCustRoles: TframeCustRoles
  Left = 0
  Top = 0
  Width = 499
  Height = 375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  object pnlRoleList: TPanel
    Left = 0
    Top = 0
    Width = 499
    Height = 375
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pnlRoleListResize
    object lbContacts: TListBox
      Left = 0
      Top = 0
      Width = 499
      Height = 296
      Style = lbOwnerDrawVariable
      Align = alClient
      BevelInner = bvNone
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      PopupMenu = popupContactRole
      TabOrder = 0
      OnClick = lbContactsClick
      OnDblClick = lbContactsDblClick
      OnDrawItem = lbContactsDrawItem
      OnMeasureItem = lbContactsMeasureItem
      OnMouseDown = lbContactsMouseDown
      OnMouseMove = lbContactsMouseMove
      OnMouseUp = lbContactsMouseUp
    end
    object pnlRoles: TPanel
      Left = 0
      Top = 296
      Width = 499
      Height = 79
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object roleScroll: TScrollBox
        Left = 0
        Top = 20
        Width = 499
        Height = 59
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
      end
      object uRolesCaption: TPanel
        Left = 0
        Top = 0
        Width = 499
        Height = 20
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblUnassignedRoles: TLabel
          Left = 8
          Top = 4
          Width = 87
          Height = 14
          Caption = 'Unassigned Roles'
        end
      end
    end
  end
  object popupContactRole: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = popupContactRolePopup
    Left = 432
    Top = 192
    object puAssignRole: TMenuItem
      Caption = '&Assign role'
    end
    object puUnassignRole: TMenuItem
      Caption = '&Unassign role'
    end
    object puSendEmail: TMenuItem
      Caption = 'Send Email'
      OnClick = puSendEmailClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ContactPopupAdd: TMenuItem
      Caption = 'Add'
      OnClick = ContactPopupAddClick
    end
    object ContactPopupEdit: TMenuItem
      Caption = 'Edit'
      OnClick = ContactPopupEditClick
    end
    object ContactPopupDelete: TMenuItem
      Caption = 'Delete'
      OnClick = ContactPopupDeleteClick
    end
  end
  object popupUnassignedRoles: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = popupUnassignedRolesPopup
    Left = 424
    Top = 288
    object popupAssignRole: TMenuItem
      Caption = 'Assign Role to '
    end
  end
end
