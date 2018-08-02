unit SetModU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls,
  GlobVar,VarConst,BTSupU1, SBSPanel, SecureU;


type
  TSetModRec = class(TForm)
    Panel1: TPanel;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    ScrollBox1: TScrollBox;
    Label81: Label8;
    CDesc1: Text8Pt;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Label825: Label8;
    Label833: Label8;
    Label834: Label8;
    Label835: Label8;
    Label836: Label8;
    Label837: Label8;
    Label838: Label8;
    Label839: Label8;
    Label840: Label8;
    Label841: Label8;
    SBSPanel1: TSBSPanel;
    CanCP1Btn: TButton;
    OkCP1Btn: TButton;
    CSS1: Text8Pt;
    RS1: Text8Pt;
    ST1: Text8Pt;
    CDesc2: Text8Pt;
    RS2: Text8Pt;
    ST2: Text8Pt;
    CDesc3: Text8Pt;
    CSS3: Text8Pt;
    RS3: Text8Pt;
    ST3: Text8Pt;
    CSS2: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RS1Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

    DescAry  :  Array[1..NoMods] of Text8Pt;
    SSymbAry :  Array[1..NoMods] of Text8Pt;
    RSymbAry :  Array[1..NoMods] of Text8Pt;
    StatAry  :  Array[1..NoMods] of Text8Pt;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    procedure OutEq;

    Procedure Generate_Lic;

    Function ThisLine(Const Sender  :  TObject;
                      Const TMode   :  Byte)  :  Integer;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetSyssStore(EnabFlag,
                           VOMode  :  Boolean);


    procedure StoreSyss;

    procedure ShutDown;

  public
    { Public declarations }
    procedure ProcessSyss;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  HelpSupU,
  BTSupU2;


{$R *.DFM}


Procedure TSetModRec.WMFormCloseMsg(Var Message  :  TMessage);

Begin
  With Message do
  Begin

    Case WParam of

      8  :  ShutDown;

    end; {Case..}

  end; {With..}
end;


procedure TSetModRec.OutEq;

Var
  n  :  Integer;

begin
  FillChar(DescAry,Sizeof(DescAry),0);
  FillChar(SSymbAry,Sizeof(SSymbAry),0);
  FillChar(RSymbAry,Sizeof(RSymbAry),0);
  FillChar(StatAry,Sizeof(StatAry),0);


  DescAry[1]:=CDesc1; SSymbAry[1]:=CSS1; RSymbAry[1]:=RS1; StatAry[1]:=ST1;
  DescAry[2]:=CDesc2; SSymbAry[2]:=CSS2; RSymbAry[2]:=RS2; StatAry[2]:=ST2;
  DescAry[3]:=CDesc3; SSymbAry[3]:=CSS3; RSymbAry[3]:=RS3; StatAry[3]:=ST3;

  With SyssMod^ do
  Begin
    For n:=1 to NoMods do
      If (Assigned(DescAry[n])) then
      With ModuleRel do
      Begin
        SSymbAry[n].Text:=ModuleSec[n,BOff];
        RSymbAry[n].Text:=ModuleSec[n,BOn];

        With StatAry[n] do
          If (Not Check_RelDateExp(n,BOff)) then
            Text:='30 Day'
          else
            Case ModRelMode(n) of
              1  :  Text:='Enabled';

              else  Text:='Disabled';

            end;

      end; {Loop..}


  end; {With..}

  (*
  { IFNDEF MC_On}
    DescAry[1].Visible:=BOff;
    SSymbAry[1].Visible:=BOff;
    RSymbAry[1].Visible:=BOff;
    StatAry[1].Visible:=BOff;
    Label81.Visible:=BOff;
  { ENDIF}
  *)
end;


Procedure TSetModRec.Generate_Lic;

Var
  n      :  Byte;
  Locked :  Boolean;


Begin
  Locked:=BOn;


  If (GetMultiSys(BOn,Locked,ModRR)) and (Locked) then
  With SyssMod^.ModuleRel do
  Begin

    For n:=1 to NoMods do  {* Change this as more modules added *}
      If (ModuleSec[n,BOff]='') then
      Begin
        Delay(100,BOn);
        ModuleSec[n,BOff]:=Get_ModuleSecurity(n);
      end;

    PutMultiSys(ModRR,BOn);
  end;

end;


procedure TSetModRec.FormCreate(Sender: TObject);


Begin
  ClientHeight:=263;

  ClientWidth:=462;

  {MDI_SetFormCoord(TForm(Self));}

  Generate_Lic;

  OutEq;

end;


{ == Procedure to Send Message to Get Record == }

Procedure TSetModRec.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TSetModRec.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Send_UpdateList(54);
end;

procedure TSetModRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

end;


{ ======== Function to Return line no currently on ========= }


Function TSetModRec.ThisLine(Const Sender  :  TObject;
                             Const TMode   :  Byte)  :  Integer;

Var
  n  :  Integer;

  FoundOk
     :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=1 to NoMods do
  Begin
    Case TMode of
      0  :  FoundOk:=(Sender=RSymbAry[n]);
    end;

    If (FoundOk) then
      Break;

  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

end;



procedure TSetModRec.SetSyssStore(EnabFlag,
                                   VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;



procedure TSetModRec.ProcessSyss;

Var
  Locked  :  Boolean;

Begin
  Locked:=BOn;

  If (GetMultiSys(BOff,Locked,ModRR)) and (Locked) then
    SetSyssStore(BOn,BOff);
end;




procedure TSetModRec.StoreSyss;

Var
  n  :  Integer;

Begin
  With SyssMod^ do
  Begin
    For n:=1 to NoMods do
      If (Assigned(DescAry[n])) then
      With ModuleRel do
      Begin
        ModuleSec[n,BOff]:=SSymbAry[n].Text;
        ModuleSec[n,BOn]:=RSymbAry[n].Text;
      end; {Loop..}
  end; {With..}
end;


procedure TSetModRec.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) or (Sender=OKCp1Btn) then
    Begin
      StoreSyss;
    end
    else
      If (OKCp1Btn.Enabled) then
      Begin
        GlobLocked:=BOn;

        GetMultiSys(BOff,GlobLocked,ModRR); {* Restore values *}
      end;

    If (OkCP1Btn.Enabled) then
      PutMultiSys(ModRR,BOn);


    Close;

  end; {With..}
end;



procedure TSetModRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSetModRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



procedure TSetModRec.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;




procedure TSetModRec.RS1Exit(Sender: TObject);
Var
  RMode,
  Idx     :  Byte;
begin

  Idx:=ThisLine(Sender,0);

  If (Idx In [1..NoMods]) then
    With SyssMod^.ModuleRel do
      ModuleSec[Idx,BOn]:=RSymbAry[Idx].Text;

  RMode:=ModRelMode(Idx);

  If ((RMode=2) and (Check_RelDateExp(Idx,BOff))) or  (RMode=1) then
  Begin
    Set_RelDate(Idx,(RMode<>1),BOff);

  end;

  If (Sender is Text8pt) then
    If Text8Pt(Sender).Modified then
      OutEq;
end;


Initialization


end.
