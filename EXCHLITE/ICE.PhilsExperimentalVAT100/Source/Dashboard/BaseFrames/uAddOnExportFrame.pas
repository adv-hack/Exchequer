unit uAddOnExportFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExportFrame, AdvMenus, AdvMenuStylers, AdvToolBar,
  AdvToolBarStylers, Menus, ActnList, AdvGlowButton, Mask, TEditVal,
  StdCtrls, AdvEdit, AdvToolBtn, ExtCtrls, AdvPanel;

type
  TfrmAddOnExportFrame = class(TfrmExportFrame)
  private
  protected
    Procedure LoadExportPackages(Const pCompany: Longword = 0); override;
  public
  end;

var
  frmAddOnExportFrame: TfrmAddOnExportFrame;

implementation

uses uInterfaces, uCommon;

{$R *.dfm}

{ TfrmExportFrame1 }

{-----------------------------------------------------------------------------
  Procedure: LoadExportPackages
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmAddOnExportFrame.LoadExportPackages(const pCompany: Longword);
Var
  lPacks: OleVariant;
  lCont, lTotal: Integer;
  lExp: TPackageInfo;
Begin
  If Not DripfeedRequest Then
  Begin
    If Assigned(fDB) Then
    Begin
      ClearJobs;
      lPacks := fdb.GetExportPackages;
      lTotal := _GetOlevariantArraySize(lPacks);

      If lTotal > 0 Then
      Begin
        For lCont := 0 To lTotal - 1 Do
        Begin
          lExp := _CreateExportPackage(lPacks[lCont]);
          If lExp <> Nil Then
          Begin
            if lExp.Company_id > 0 then
             cbJobs.AddItem(lExp.Description, lExp)
          End; {If lExp <> Nil Then}
        End; {for lCont := 0 to lTotal - 1 do}
      End; {if lTotal > 0 then}
    End; {If Assigned(fDB) Then}
  End; {If Not fRequestSync Then}
end;

end.
 