unit CopyOptF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, BorBtns, TEditVal, bkgroup, ComCtrls,
  SBSPanel, Menus;

type
  TCopyMode = (cmExchequer=0, cmLITE=1);

  TCopyDataWiz2 = class(TSetupTemplate)
    PageControl1: TPageControl;
    TabAcc: TTabSheet;
    TabStock: TTabSheet;
    TabJob: TTabSheet;
    TabMisc: TTabSheet;
    CustAcc: TSBSGroup;
    Chk_Cust: TBorCheck;
    Chk_CustNote: TBorCheck;
    SuppAcc: TSBSGroup;
    Chk_Supp: TBorCheck;
    Chk_SuppNote: TBorCheck;
    SBSGroup1: TSBSGroup;
    Chk_Empl: TBorCheck;
    Chk_EmplRate: TBorCheck;
    SBSGroup5: TSBSGroup;
    Chk_Job: TBorCheck;
    Chk_JobBudg: TBorCheck;
    Chk_JobAnal: TBorCheck;
    Chk_JobType: TBorCheck;
    SBSGroup6: TSBSGroup;
    Chk_Stock: TBorCheck;
    Chk_StkNotes: TBorCheck;
    Chk_MLStock: TBorCheck;
    TabSetup: TTabSheet;
    SBSGroup4: TSBSGroup;
    Chk_Users: TBorCheck;
    Chk_UsWinPos: TBorCheck;
    SBSGroup7: TSBSGroup;
    Chk_Flags: TBorCheck;
    Chk_Forms: TBorCheck;
    SBSGroup2: TSBSGroup;
    Chk_RepWrt: TBorCheck;
    Chk_Disc: TBorCheck;
    Chk_CCDep: TBorCheck;
    Chk_Nom: TBorCheck;
    PopupMenu1: TPopupMenu;
    SelectAllDataItems1: TMenuItem;
    SelectNone1: TMenuItem;
    Chk_AltCodes: TBorCheck;
    chkSignatures: TBorCheck;
    Chk_SortView: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure CheckHandler(Sender: TObject);
    procedure Popup_SelectClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    FCopyMode : TCopyMode;
    FSourceComp      : ShortString;
    WantCheckHandler : Boolean;

    Procedure SetCopyMode (Value : TCopyMode);
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Property CopyMode : TCopyMode Read FCopyMode Write SetCopyMode;
    Property SourceCompany : ShortString Read FSourceComp Write FSourceComp;
  end;


implementation

{$R *.DFM}

Uses VarConst;

procedure TCopyDataWiz2.FormCreate(Sender: TObject);
begin
  inherited;

  PageControl1.ActivePage := TabAcc;
  TabJob.TabVisible := JBCostOn;

  Chk_RepWrt.Visible := RepWrtOn;

  PageControl1.ActivePage := TabAcc;

  WantCheckHandler := True;
end;

procedure TCopyDataWiz2.CheckHandler(Sender: TObject);
Var
  I : Integer;
begin
  inherited;

  If WantCheckHandler Then
    { loop around to make sure all relational changes are done immediately }
    For I := 1 To 4 Do Begin
      { Force Customers to be selected if necessary }
      If (Not Chk_Cust.Checked) Then
        Chk_Cust.Checked := Chk_CustNote.Checked Or Chk_Disc.Checked Or
                            Chk_JobBudg.Checked;

      { Force Stock to be selected if necessary }
      If (Not Chk_Stock.Checked) Then
        Chk_Stock.Checked := Chk_Disc.Checked Or Chk_MLStock.Checked Or
                             Chk_JobBudg.Checked Or Chk_StkNotes.Checked Or
                             Chk_AltCodes.Checked;

      { Force Suppliers Codes to be selected if necessary }
      If (Not Chk_Supp.Checked) Then
        Chk_Supp.Checked := Chk_Stock.Checked Or Chk_Disc.Checked Or
                            Chk_MLStock.Checked Or Chk_SuppNote.Checked Or
                            Chk_JobBudg.Checked;

      { Force Flags to be selected if necessary }
      If (Not Chk_Forms.Checked) Then
        Chk_Forms.Checked := Chk_Cust.Checked Or Chk_Supp.Checked;

      { Force Users to be selected if necessary }
      If (Not Chk_Users.Checked) Then
        Chk_Users.Checked := Chk_UsWinPos.Checked or chkSignatures.Checked;

      { Force Employee's to be selected if necessary }
      If (Not Chk_Empl.Checked) Then
        Chk_Empl.Checked := Chk_EmplRate.Checked;

      { Force Job's to be selected if necessary }
      If (Not Chk_Job.Checked) Then
        Chk_Job.Checked := Chk_JobBudg.Checked;

      { Force Job Analysis to be selected if necessary }
      If (Not Chk_JobAnal.Checked) Then
        Chk_JobAnal.Checked := Chk_Job.Checked Or Chk_JobBudg.Checked Or Chk_EmplRate.Checked;

      { Force Job Types to be selected if necessary }
      If (Not Chk_JobType.Checked) Then
        Chk_JobType.Checked := Chk_Job.Checked Or Chk_JobBudg.Checked;

      { Force Cost Centre/Departments to be selected if necessary }
      If (Not Chk_CCDep.Checked) Then
        Chk_CCDep.Checked := Chk_Cust.Checked Or Chk_Supp.Checked Or
                             Chk_Stock.Checked Or Chk_JobBudg.Checked Or
                             Chk_Disc.Checked Or Chk_MLStock.Checked;

      { Force Nominal Codes to be selected if necessary }
      If (Not Chk_Nom.Checked) Then
        Chk_Nom.Checked := Chk_Cust.Checked Or Chk_Supp.Checked Or
                           Chk_Stock.Checked Or Chk_JobBudg.Checked Or
                           Chk_Disc.Checked Or Chk_MLStock.Checked Or
                           Chk_EmplRate.Checked Or Chk_JobAnal.Checked Or
                           Chk_Flags.Checked;

      { Force Setup Flags to be selected if necessary }
      If (Not Chk_Flags.Checked) Then
        Chk_Flags.Checked := Chk_Nom.Checked;
    End; { For }
end;


{ Returns True if all entry fields are ok }
Function TCopyDataWiz2.ValidOk(VCode : Char) : Boolean;
Var
  MsgStr : String;
  SelOne : Boolean;
  I      : Integer;
Begin
  SelOne := False;
  If (ComponentCount > 0) Then
    For I := 0 To Pred (ComponentCount) Do
      If Components[I] Is TBorCheck Then
        With Components[I] As TBorCheck Do
          If Checked Then Begin
            SelOne := True;
            Break;
          End; { If }

  If (VCode = 'N') Then Begin
    If SelOne Then
      MsgStr := 'Data will be copied from "' + SourceCompany + '" into the new company. ' +
                'Please ensure you have selected all the data items you want before continuing.'
    Else
      MsgStr := 'Warning: You have not selected any data items to copy.';

    Result := (MessageDlg (MsgStr +
                           #10#13#10#13 +
                           'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);

    If Result And (Chk_Cust.Checked Or Chk_Supp.Checked Or Chk_Stock.Checked) Then
      // HM 22/01/02: Warn users to do Check All Accounts and Check all Stock
      MessageDlg ('IMPORTANT NOTE: Before using the new Company Data Set you must run the ' +
                  QuotedStr('Check all Accounts') + ' and ' + QuotedStr('Check All Stock') +
                  ' functions to ensure the integrity of the new Data Set.  If you fail to run ' +
                  'these functions then Account Balance and Stock Level/Balance information ' +
                  'may be incorrect', mtWarning, [mbOk], 0);
  End { If }
  Else
    Result := True;
End;

{ Event for popup menu - selects all or no check boxes }
procedure TCopyDataWiz2.Popup_SelectClick(Sender: TObject);
Var
  I : SmallInt;
begin
  inherited;

  WantCheckHandler := False;

  If (ComponentCount > 0) Then
    For I := 0 To Pred (ComponentCount) Do
      If Components[I] Is TBorCheck Then
        With Components[I] As TBorCheck Do
          Checked := (Sender = SelectAllDataItems1);

  WantCheckHandler := True;
end;

procedure TCopyDataWiz2.PageControl1Change(Sender: TObject);
begin
  If (PageControl1.ActivePage = TabAcc) Then
    HelpContext := 20
  Else If (PageControl1.ActivePage = TabStock) Then
    HelpContext := 21
  Else If (PageControl1.ActivePage = TabJob) Then
    HelpContext := 6
  Else If (PageControl1.ActivePage = TabMisc) Then
    HelpContext := 7
  Else If (PageControl1.ActivePage = TabSetup) Then
    HelpContext := 18;
end;

Procedure TCopyDataWiz2.SetCopyMode (Value : TCopyMode);
Begin // SetCopyMode
  FCopyMode := Value;

  If (FCopyMode = cmExchequer) Then
  Begin
    //ShowMessage ('CopyMode = Exchequer')
  End // If (FCopyMode = cmExchequer)
  Else If (FCopyMode = cmLITE) Then
  Begin
    //ShowMessage ('CopyMode = LITE');

    TabJob.TabVisible := False;
    // MH 10/07/06: Disabled at EPOD's request
    //Chk_RepWrt.Visible := True;
    Chk_RepWrt.Visible := False;
    chkSignatures.Caption := 'Email Signatures';
    Chk_MLStock.Visible := False;

    // MH 10/07/06: Disabled at EPOD's request
    Chk_AltCodes.Visible := False;
  End; // If (FCopyMode = cmLITE)
End; // SetCopyMode


end.
