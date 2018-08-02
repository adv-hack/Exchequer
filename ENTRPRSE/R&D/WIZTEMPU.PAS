unit WizTempU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls,
VarConst;

type
  TWizTemplate = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    WBotPanel: TSBSPanel;
    TWNextBtn: TSBSButton;
    TWClsBtn: TSBSButton;
    TWPrevBtn: TSBSButton;
    WTopPanel: TSBSPanel;
    Label86: Label8;
    Label81: Label8;
    procedure FormCreate(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure TWClsBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    
    
    
    
    
  public
    { Public declarations }
    IsFinish,
    ReEnable      :  Boolean;

    StartPage,
    AdvancePages  :  Integer;

    procedure SetWizButtons;

    Function GetPageCount  :  Integer; Virtual;

    Function GetEndPageCount  :  Integer; Virtual;

    procedure SetStepCaption; Virtual;

    Function Current_Page  :  Integer;

    procedure TryFinishWizard; Virtual;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Uses
  GlobVar,
  CmpCtrlU,
  BTSupU2;




procedure TWizTemplate.FormCreate(Sender: TObject);
begin
  IsFinish:=False; ReEnable:=False;

  ClientHeight:=359;
  ClientWidth:=514;

  PageControl1.ActivePage:=TabSheet1;

  SetStepCaption;

  SetWizButtons;

  StartPage:=0;

  AdvancePages:=0;

  If NoXLogo then
    Image1.Visible:=BOff;

end;

Function TWizTemplate.GetPageCount  :  Integer;

Begin
  With PageControl1 do
    Result:=PageCount;
end;


Function TWizTemplate.GetEndPageCount  :  Integer;

Begin
  With PageControl1 do
    Result:=GetPageCount;
end;


procedure TWizTemplate.SetWizButtons;

Begin
  With PageControl1 do
  If (GetPageCount>0) then
  Begin

    TWPrevBtn.Visible:=(ActivePage<>Pages[StartPage]);

    With TWNextBtn do
      If (ActivePage=Pages[Pred(GetEndPageCount)+StartPage]) then
      Begin
        Caption:='&Finish';
        IsFinish:=True;
      end
      else
        If (Caption='&Finish') then
        Begin
          Caption:='&Next >';
          IsFinish:=False;
        end;


  end;
end;


Function TWizTemplate.Current_Page  :  Integer;


Begin

  Result:=pcLivePage(PageControl1);

end;


procedure TWizTemplate.SetStepCaption;

Begin
  Label81.Caption:='Step '+IntToStr(Succ(Current_Page)-StartPage)+' of '+IntToStr(GetPageCount);
end;


procedure TWizTemplate.TryFinishWizard;

Begin

  {* Do some finish routine *}

end;

procedure TWizTemplate.TWPrevBtnClick(Sender: TObject);
Var
  AdvanceCount  :  Integer;

begin
  AdvanceCount:=0;

  If (Sender is TSBSButton) then
  With PageControl1 do
  Begin

    If (Not IsFinish) or (Sender<>TWNextBtn) then
    Begin
      If ReEnable then
        ActivePage.Enabled:=BOff;

      Repeat
        ActivePage:=FindNextPage(ActivePage,(Sender=TWNextBtn),FALSE);

        Inc(AdvanceCount);

      Until (AdvanceCount>AdvancePages);

      If ReEnable then
        ActivePage.Enabled:=BOn;

      SetStepCaption;
      SetWizButtons;

      If (Assigned(OnChange)) then
        OnChange(PageControl1);
    end
    else
      TryFinishWizard;
  end;
end;

procedure TWizTemplate.TWClsBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TWizTemplate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;



procedure TWizTemplate.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TWizTemplate.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

end.
