unit SetModU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls,
  GlobVar,VarConst,BTSupU1, SBSPanel, SecSup2U;


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
    RBtn1: TButton;
    PBtn1: TButton;
    Cdesc4: Text8Pt;
    CSS4: Text8Pt;
    RS4: Text8Pt;
    ST4: Text8Pt;
    Cdesc5: Text8Pt;
    CSS5: Text8Pt;
    RS5: Text8Pt;
    ST5: Text8Pt;
    CDesc6: Text8Pt;
    CSS6: Text8Pt;
    RS6: Text8Pt;
    ST6: Text8Pt;
    CDesc7: Text8Pt;
    CSS7: Text8Pt;
    RS7: Text8Pt;
    ST7: Text8Pt;
    CDesc8: Text8Pt;
    CSS8: Text8Pt;
    RS8: Text8Pt;
    ST8: Text8Pt;
    CDesc9: Text8Pt;
    CSS9: Text8Pt;
    RS9: Text8Pt;
    ST9: Text8Pt;
    CDesc10: Text8Pt;
    CSS10: Text8Pt;
    RS10: Text8Pt;
    ST10: Text8Pt;
    CDesc11: Text8Pt;
    CSS11: Text8Pt;
    RS11: Text8Pt;
    ST11: Text8Pt;
    CDesc12: Text8Pt;
    CSS12: Text8Pt;
    RS12: Text8Pt;
    ST12: Text8Pt;
    Cdesc13: Text8Pt;
    CSS13: Text8Pt;
    RS13: Text8Pt;
    ST13: Text8Pt;
    CDesc14: Text8Pt;
    CSS14: Text8Pt;
    RS14: Text8Pt;
    ST14: Text8Pt;
    CDesc15: Text8Pt;
    CSS15: Text8Pt;
    RS15: Text8Pt;
    ST15: Text8Pt;
    CDesc16: Text8Pt;
    CSS16: Text8Pt;
    RS16: Text8Pt;
    ST16: Text8Pt;
    CDesc17: Text8Pt;
    CSS17: Text8Pt;
    RS17: Text8Pt;
    ST17: Text8Pt;
    CDesc18: Text8Pt;
    CSS18: Text8Pt;
    RS18: Text8Pt;
    ST18: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RS1Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RBtn1Click(Sender: TObject);
    procedure PBtn1Click(Sender: TObject);
  private
    { Private declarations }

    BeenStored
             :  Boolean;

    DescAry  :  Array[1..NoMods] of Text8Pt;
    SSymbAry :  Array[1..NoMods] of Text8Pt;
    RSymbAry :  Array[1..NoMods] of Text8Pt;
    StatAry  :  Array[1..NoMods] of Text8Pt;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    procedure OutEq;

    Procedure Generate_Lic(GetRec  :  Boolean);

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
  BtrvU2,
  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  HelpSupU,

  {$IFDEF Frm}
    PrintFrm,
  {$ENDIF}

  {$IFDEF Rp}
    RPDefine,
    RPDevice,
    ReportHU,
  {$ENDIF}
  SYSU3,
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
  RM :  Byte;

begin
  FillChar(DescAry,Sizeof(DescAry),0);
  FillChar(SSymbAry,Sizeof(SSymbAry),0);
  FillChar(RSymbAry,Sizeof(RSymbAry),0);
  FillChar(StatAry,Sizeof(StatAry),0);

  RM:=0;

  DescAry[1]:=CDesc1; SSymbAry[1]:=CSS1; RSymbAry[1]:=RS1; StatAry[1]:=ST1;
  DescAry[2]:=CDesc2; SSymbAry[2]:=CSS2; RSymbAry[2]:=RS2; StatAry[2]:=ST2;
  DescAry[3]:=CDesc3; SSymbAry[3]:=CSS3; RSymbAry[3]:=RS3; StatAry[3]:=ST3;
  DescAry[4]:=CDesc4; SSymbAry[4]:=CSS4; RSymbAry[4]:=RS4; StatAry[4]:=ST4;
  DescAry[5]:=CDesc5; SSymbAry[5]:=CSS5; RSymbAry[5]:=RS5; StatAry[5]:=ST5;
  DescAry[6]:=CDesc6; SSymbAry[6]:=CSS6; RSymbAry[6]:=RS6; StatAry[6]:=ST6;
  DescAry[7]:=CDesc7; SSymbAry[7]:=CSS7; RSymbAry[7]:=RS7; StatAry[7]:=ST7;
  DescAry[8]:=CDesc8; SSymbAry[8]:=CSS8; RSymbAry[8]:=RS8; StatAry[8]:=ST8;
  DescAry[9]:=CDesc9; SSymbAry[9]:=CSS9; RSymbAry[9]:=RS9; StatAry[9]:=ST9;
  DescAry[10]:=CDesc10; SSymbAry[10]:=CSS10; RSymbAry[10]:=RS10; StatAry[10]:=ST10;
  DescAry[11]:=CDesc11; SSymbAry[11]:=CSS11; RSymbAry[11]:=RS11; StatAry[11]:=ST11;
  DescAry[12]:=CDesc12; SSymbAry[12]:=CSS12; RSymbAry[12]:=RS12; StatAry[12]:=ST12;
  DescAry[13]:=CDesc13; SSymbAry[13]:=CSS13; RSymbAry[13]:=RS13; StatAry[13]:=ST13;
  DescAry[14]:=CDesc14; SSymbAry[14]:=CSS14; RSymbAry[14]:=RS14; StatAry[14]:=ST14;
  DescAry[15]:=CDesc15; SSymbAry[15]:=CSS15; RSymbAry[15]:=RS15; StatAry[15]:=ST15;
  DescAry[16]:=CDesc16; SSymbAry[16]:=CSS16; RSymbAry[16]:=RS16; StatAry[16]:=ST16;
  DescAry[17]:=CDesc17; SSymbAry[17]:=CSS17; RSymbAry[17]:=RS17; StatAry[17]:=ST17;

  DescAry[18]:=CDesc18; SSymbAry[18]:=CSS18; RSymbAry[18]:=RS18; StatAry[18]:=ST18;


  With SyssMod^ do
  Begin
    For n:=1 to NoMods do
      If (Assigned(DescAry[n])) then
      With ModuleRel do
      Begin
        SSymbAry[n].Text:=ModuleSec[n,BOff];
        RSymbAry[n].Text:=ModuleSec[n,BOn];

        RM:=ModRelMode(n);

        If (Not RBtn1.Enabled) then
          RBtn1.Enabled:=(RM=0);

        With StatAry[n] do
          If (Not Check_RelDateExp(n,BOff)) then
            Text:='30 Day'
          else
            Case RM of
              1  :  Text:='Enabled';

              else  Text:='Disabled';

            end;

      end; {Loop..}


  end; {With..}

  {$IFNDEF MC_On}
    DescAry[1].Visible:=BOff;
    SSymbAry[1].Visible:=BOff;
    RSymbAry[1].Visible:=BOff;
    StatAry[1].Visible:=BOff;
    Label81.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF SOP}
    DescAry[10].Visible:=BOff;
    SSymbAry[10].Visible:=BOff;
    RSymbAry[10].Visible:=BOff;
    StatAry[10].Visible:=BOff;
    Label824.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF STK}
      For n:=11 to 18 do

    Begin
      If (n In [11..13,18]) then
      Begin
        DescAry[n].Visible:=BOff;
        SSymbAry[n].Visible:=BOff;
        RSymbAry[n].Visible:=BOff;
        StatAry[n].Visible:=BOff;
      end;
    end;

    Label823.Visible:=BOff;
    Label822.Visible:=BOff;
    Label818.Visible:=BOff;

    Label840.Visible:=BOff;
  {$ELSE}
    {$IFDEF DBD}{{*ENWOP1*}
    {$IFNDEF WOP}
      For n:=12 to 13 do
      Begin
        DescAry[n].Visible:=BOff;
        SSymbAry[n].Visible:=BOff;
        RSymbAry[n].Visible:=BOff;
        StatAry[n].Visible:=BOff;
      end;

      Label822.Visible:=BOff;
      Label818.Visible:=BOff;
    {$ENDIF}
    {$ENDIF}


  {$ENDIF}


end;


Procedure TSetModRec.Generate_Lic(GetRec  :  Boolean);

Var
  n      :  Byte;
  GotOk,
  RecChanged,
  Locked :  Boolean;


Begin
  Locked:=BOn;  RecChanged:=BOff;

  If (GetRec) then
    GotOk:=GetMultiSys(BOn,Locked,ModRR)
  else
    GotOk:=BOn;

  If (GotOk) and (Locked) then
  With SyssMod^.ModuleRel do
  Begin

    For n:=1 to NoMods do  {* Change this as more modules added *}
      If (ModuleSec[n,BOff]='') then
      Begin
        Delay(100,BOn);
        {ModuleSec[n,BOff]:=Get_ModuleSecurity(n,BOn);}
        ModuleSec[n,BOff]:=Generate_ESN_BaseSecurity(Syss.ExISN,n,0,0);
        RecChanged:=BOn;
      end;

    If (RecChanged) and (GetRec) then
    Begin
      {* Update duplicate record *}

      TrackSecUpdates(BOn);
    end;

    If (GetRec) then
      PutMultiSys(ModRR,BOn);
  end;

end;


procedure TSetModRec.FormCreate(Sender: TObject);


Begin
  ClientHeight:=263;

  ClientWidth:=462;

  BeenStored:=BOff;

  MDI_SetFormCoord(TForm(Self));

  Generate_Lic(BOn);

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

Var
  LStatus  :  Integer;

begin
  Action:=caFree;

  If (Not BeenStored) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[ModRR]);
  end;
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

Var
  RepCo  :  Boolean;

begin
  RepCo:=BOff;

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) or (Sender=OKCp1Btn) then
    Begin
      StoreSyss;
      RepCo:=BOn;
    end
    else
      If (OKCp1Btn.Enabled) then
      Begin
        GlobLocked:=BOn;

        GetMultiSys(BOff,GlobLocked,ModRR); {* Restore values *}
      end;

    If (OkCP1Btn.Enabled) then
    Begin
      PutMultiSys(ModRR,BOn);

      {* Update duplicate record *}

      TrackSecUpdates(BOn);

      If (RepCo) then
        Replicate_CoSecurity;
      
      BeenStored:=BOn;
    end;


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


procedure TSetModRec.RBtn1Click(Sender: TObject);
Var
  n  :  Integer;

Begin
  With SyssMod^ do
  Begin
    For n:=1 to NoMods do
      With ModuleRel do
      If (ModRelMode(n)=0) then
      Begin
        ModuleSec[n,BOff]:='';
        ModuleSec[n,BOn]:='';
      end; {Loop..}

    Generate_Lic(BOff);

    OutEq;
  end; {With..}
end;




procedure TSetModRec.PBtn1Click(Sender: TObject);
{$IFDEF RP}
  Var
    RFont      :  TFont;
    ROrient    :  TOrientation;

    RDevRec    :  TSBSPrintSetupInfo;

    Ok2Print   :  Boolean;

    SMemo      :  TStringList;

    n          :  Integer;


  begin
    RFont:=TFont.Create;

    try
      RFont.Assign(Application.MainForm.Font);
      RFont.Size:=10;
      ROrient:=RPDefine.PoPortrait;

      {$IFDEF Frm}
        Ok2Print:=pfSelectPrinter(RDevRec,RFont,ROrient);
      {$ELSE}
        Ok2Print:=BOff;
      {$ENDIF}

      If (Ok2Print) then
      Begin
        SMemo:=TStringList.Create;
        Try

          SMemo.Add('Please send to Exchequer Software. Fax : +44 (0)1202 298001, or your local supplier.');
          SMemo.Add('');

          SMemo.Add(DateTimeToStr(Now)+'. Exchequer Exchequer version : '+Ver+'. For '+Syss.UserName);
          SMemo.Add('Module Release Codes');

          SMemo.Add(ConstStr('-',80));

          With SyssMod^.ModuleRel do
            For n:=1 to NoMods do
            Begin
              SMemo.Add(IntToStr(n)+'. '+DescAry[n].Text+'. Security Code : '+LJVar(ModuleSec[n,BOff],10)+'  Release Code : '+LJVAR(ModuleSec[n,BOn],10)+' Status  :  '+StatAry[n].Text);
              SMemo.Add('');
            end;

          SMemo.Add('Contact Name : '+ConstStr('_',50));
          SMemo.Add('Telephone : '+ConstStr('_',50));
          SMemo.Add('Fax : '+ConstStr('_',50));
          SMemo.Add('Any other details:');

          For n:=1 to 10 do
            SMemo.Add(ConstStr('_',80));

          AddMemoRep2Thread(RDevRec,SMemo,'Module Release',Application.MainForm);

        Finally;
          SMemo.Free;
        end;

      end;

    Finally
      RFont.Free;
    end;


{$ELSE}

Begin

{$ENDIF}

end;

Initialization


end.
