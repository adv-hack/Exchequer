unit LineForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, TEditVal, Grids, SBSOutl;

type
  TfrmLine = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    btnCancel: TSBSButton;
    edtCC: TEdit;
    edtDept: TEdit;
    edtPerc: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtRemaining: TEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure edtCCExit(Sender: TObject);
    procedure edtPercExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

  procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);


var
  PercRemaining : Double;
  OldPerc : Double;
  UseDosKeys : Boolean;

implementation

{$R *.dfm}
uses
  CCLook, AllocVar, AllcBase, ComCtrls, SButton, BorBtns;

const
  Boff = False;
  Bon = True;


procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:= UseDosKeys;

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         { HM 09/11/99: Was interfering with Memo control on print dialog }
         ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
         (ActiveControl is TTreeView) then {* switched off so it does not interfere with a list *}
        IrqKey:=BOff;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

  end;
end;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  Begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    If (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown) or
       (ActiveControl is TScrollButton) or

         { HM 09/11/99: Was interfering with Memo control on print dialog }
       ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
       (ActiveControl is TTreeView) then {* Could combine with a switch, as there maybe cases where a
                                                                                 a string grid is used without the list... *}
      IrqKey:=BOff;


  If (IrqKey) then
  Case Key of


    VK_Up  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  Begin
                If (Key=VK_Return) and (Not UseDosKeys) then
                  Exit;


                If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;

  end;

  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift)){ and (AllowHotKey)} then
  Begin
    If (Key=VK_F9) then
    Begin
      If (ActiveControl is TComponent) then
      Begin
        TComp:=TComponent(ActiveControl);
  //      LastValueObj.GetValue(TComp);
        PostMessage(Handle,wm_NextDlgCtl,0,0);
      end;
    end
    else
      if Assigned(Application.MainForm) then PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
  end;

  If (ActiveControl is TScrollButton) then {Don't go any further}
    Exit;

(*  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift) {and (AllowHotKey)} then {* Select Next/Prev page of tabbed notebook *}
    PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift) {and (AllowHotKey)} then {* Jump straight to list body *}
    PostMessage(Handle,wm_CustGetRec,176,Ord(Key=VK_Home)); 

  If ((Key=VK_Return) and (ssCtrl In Shift)) then
    ClickOK(Sender,Key);
     *)

end;



procedure TfrmLine.FormCreate(Sender: TObject);
begin
  edtCC.Enabled := AllocRec.AllocType in [0,2];
  edtDept.Enabled := AllocRec.AllocType in [1,2];
end;

procedure TfrmLine.edtCCExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and (Sender is TEdit) then
    With Sender as TEdit do
    begin
      Text := GetCCDep(Text, Sender = edtCC, oToolkit);
      if Text = '' then
        ActiveControl := TEdit(Sender);
    end;

end;

procedure TfrmLine.edtPercExit(Sender: TObject);
var
  Perc : Double;
begin
  Try
    Perc := StrToFloat(edtPerc.Text);
    if (Perc <= 0) or (Perc > 100) then
      ActiveControl := edtPerc
    else
      edtRemaining.Text := Format('%5.2f', [PercRemaining - Perc]);
  Except
    ShowMessage('You must enter a valid number');
    ActiveControl := edtPerc;
  End;
end;

procedure TfrmLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

Initialization
  UseDosKeys := True;

end.
