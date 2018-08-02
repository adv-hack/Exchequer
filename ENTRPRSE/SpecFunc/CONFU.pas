unit ConfU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  InHU, TEditVal, StdCtrls, Mask, Animate, ExtCtrls, SBSPanel, bkgroup,
  GlobVar,ComCtrls, BorBtns;

type
  TConfigForm = class(TInHForm)
    Label86: Label8;
    OpenDialog1: TOpenDialog;
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    Label87: Label8;
    MUType: TSBSComboBox;
    SERVOS: TSBSComboBox;
    WSOS: TSBSComboBox;
    WKNo: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Label85: Label8;
    SRVPath: Text8Pt;
    BrowseBtn: TButton;
    Label89: Label8;
    NWAName: TSBSComboBox;
    Label810: Label8;
    IPXMPS: TCurrencyEdit;
    Set2Btn: TButton;
    Label811: Label8;
    IPXVMN: TCurrencyEdit;
    Set3Btn: TButton;
    Label812: Label8;
    Label813: Label8;
    NovBSPX: Text8Pt;
    Set1Btn: TButton;
    NEChk: TBorRadio;
    NTChk: TBorRadio;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    BTEType: TSBSComboBox;
    Label817: Label8;
    Label819: Label8;
    Label820: Label8;
    ScrollBox1: TScrollBox;
    Label818: Label8;
    BTC1: TCurrencyEdit;
    BTD1: TCurrencyEdit;
    BTBtn1: TButton;
    BTBtn2: TButton;
    BTBtn5: TButton;
    BTBtn6: TButton;
    BTBtn7: TButton;
    BTBtn8: TButton;
    BTD7: TCurrencyEdit;
    BTD6: TCurrencyEdit;
    BTD5: TCurrencyEdit;
    BTD2: TCurrencyEdit;
    BTC2: TCurrencyEdit;
    Label821: Label8;
    BTC5: TCurrencyEdit;
    Label822: Label8;
    BTC6: TCurrencyEdit;
    Label823: Label8;
    Label824: Label8;
    BTC7: TCurrencyEdit;
    Label825: Label8;
    Label826: Label8;
    BTC3: TCurrencyEdit;
    BTD3: TCurrencyEdit;
    BTBtn3: TButton;
    Label827: Label8;
    BTC4: TCurrencyEdit;
    BTD4: TCurrencyEdit;
    BTBtn4: TButton;
    Label828: Label8;
    BTC9: Text8Pt;
    BTD9: Text8Pt;
    BTBtn9: TButton;
    SetChk: TBorCheck;
    SetAllBtn: TButton;
    BTC8: TCurrencyEdit;
    BTD8: TCurrencyEdit;
    Label829: Label8;
    BTC10: Text8Pt;
    BTD10: Text8Pt;
    Set10Btn: TButton;
    ThisSrvChk: TBorCheck;
    TabSheet5: TTabSheet;
    PrintList1: TListBox;
    SBSBackGroup4: TSBSBackGroup;
    PrnMasChk: TBorCheck;
    Label82: Label8;
    ExPath: Text8Pt;
    BrowseBtn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MUTypeExit(Sender: TObject);
    procedure SERVOSExit(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    procedure BrowseBtn2Click(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure WSOSExit(Sender: TObject);
    procedure NWANameExit(Sender: TObject);
    procedure Set2BtnClick(Sender: TObject);
    procedure Set3BtnClick(Sender: TObject);
    procedure SRVPathExit(Sender: TObject);
    procedure Set1BtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SetChkClick(Sender: TObject);
    procedure ThisSrvChkClick(Sender: TObject);
    procedure BTETypeExit(Sender: TObject);
    procedure BTBtn1Click(Sender: TObject);
  private
    { Private declarations }

    Told     :  Boolean;

    BTCAry   :  Array[BOff..BOn,1..8] of TCurrencyEdit;

    procedure SetSrvPath;

    procedure SetBSPXStat;

    procedure GetSrvPath;

    procedure SetNWA;

    procedure FindNWAdaptors;

    procedure GetBTSettings;

    Function CalcBTIF  :  Byte;

    Function CalcBTIFMes(SetNo  :  Byte)  :  String;

    procedure WriteToLog(LM  :  String);

    procedure SetBTSettings(SetNo  :  Integer);


  public
    { Public declarations }
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BTrvU2,
  ETStrU,
  ETMiscU,
  Registry,
  Printers,
  LocalVar,
  PathUtil,
  REMain,
  Untils;

{$R *.DFM}




procedure TConfigForm.FormCreate(Sender: TObject);


Var
  n  :  Word;

begin
  inherited;

   With CompSysInfo^ do
   Begin
     MUType.ItemIndex:=MUVal;
     ServOS.ItemIndex:=SrvOSVal;
     WSOS.ItemIndex:=WSOSVal;
     WKNo.Value:=WSNo;
     ExPAth.Text:=ExPathStr;
     SrvPAth.Text:=NovSrvPath;
     NWAName.Text:=NWAdpKey;
     {TotTestNo.Value:=TotWS;}
     NTChk.Checked:=TRing;
     NEChk.Checked:=Not TRing;
     BTEType.ItemIndex:=Ord(BTServer);
     SetChk.Checked:=BTUseRecon;
     PrnMasChk.Checked:=UsePrintList;

     SetAllBtn.Enabled:=SetChk.Checked;
     IPXVMN.Value:=IPXVirtualNo(BOff,WSOSVal,0);

     BTCAry[BOff,1]:=BTC1;  BTCAry[BOn,1]:=BTD1;
     BTCAry[BOff,2]:=BTC2;  BTCAry[BOn,2]:=BTD2;
     BTCAry[BOff,3]:=BTC3;  BTCAry[BOn,3]:=BTD3;
     BTCAry[BOff,4]:=BTC4;  BTCAry[BOn,4]:=BTD4;
     BTCAry[BOff,5]:=BTC5;  BTCAry[BOn,5]:=BTD5;
     BTCAry[BOff,6]:=BTC6;  BTCAry[BOn,6]:=BTD6;
     BTCAry[BOff,7]:=BTC7;  BTCAry[BOn,7]:=BTD7;
     BTCAry[BOff,8]:=BTC8;  BTCAry[BOn,8]:=BTD8;



   end;

   Told:=BOff;
   
   SetSrvPath;

   SetNWA;

   FindNWAdaptors;

   GetBTSettings;

   If (Printer.Printers.Count-1>=0) then
   Begin
     For n:=0 to Printer.Printers.Count-1 do
       PrintList1.Items.Add(Printer.Printers.Strings[n]);
   end
   else
     ShowMessage('There are no printers installed on this workstation!'+#13 + sAppName + ' requires at least one printer to be installed.');

   ClientHeight:=299; ClientWidth:=423;

   PageControl1.Activepage:=TabSheet1;
end;


procedure TConfigForm.SetBSPXStat;
Begin
  If (SRVPath.Enabled) and (SRVPath.Text<>'') then
  Begin
    If (NovellBSPX(BOff,NTChk.Checked,SRVPAth.Text)) then
    Begin
      NovBSPX.Text:='BPX Setup correctly';
      Set1Btn.Enabled:=BOff;
    end
    else
    Begin
      NovBSPX.Text:='BPX has invalid settings!';
      Set1Btn.Enabled:=BOn;
    end;
  end
  else
    NOVBSPX.Text:='';

end;


procedure TConfigForm.GetBTSettings;

Var
  n  :  Byte;
Begin

  With CompSysInfo^ do
  Begin

    For n:=Low(BTDefs) to High(BTDefs) do
    Begin
      If (MUType.ItemIndex<>2) then
        BTCAry[BOn,n].Value:=BTDefs[n]
      else
        BTCAry[BOn,n].Value:=BTSUDefs[n];

      BTCAry[BOff,n].Value:=GetBTRegSettings(BOff,(BTEType.ItemIndex=1),n,0);
    end;
      
  end;


  BTC9.Text:=CalcBTIFMes(CalcBTIF);

  If (MUType.ItemIndex=1) and (ThisSrvChk.Checked) and (WS_IsNT(WSOS.ItemIndex)) and (BTEType.ItemIndex=1) then
    BTC10.Text:=BTProtocols[GetBTRegSettings(BOff,BOff,11,0)];

end;


Function TConfigForm.CalcBTIF  :  Byte;

Var
  Loc,Req  :  Byte;
Begin
  Loc:=1*GetBTRegSettings(BOff,(BTEType.ItemIndex=1),9,0);
  Req:=2*GetBTRegSettings(BOff,(BTEType.ItemIndex=1),10,0);

  Result:=Loc+Req;
end;


Function TConfigForm.CalcBTIFMes(SetNo  :  Byte)  :  String;

Const
  BTMes  :  Array[0..3] of  Str20 = ('Engine Off!','Local Only','Requester Only','Local & Requester');

Begin
  Result:=BTMes[SetNo];

end;



procedure TConfigForm.SetSrvPath;
Begin
  SRVPath.Enabled:=(ServOS.Enabled) and (Srv_IsNovell(ServOS.ItemIndex)) and (MUType.ItemIndex=1);

  BrowseBtn.Enabled:=SrvPath.Enabled;
  Label85.Enabled:=SRVPath.Enabled;
  Label813.Enabled:=SRVPath.Enabled;
  Label814.Enabled:=SRVPath.Enabled;
  Label815.Enabled:=SRVPath.Enabled;
  NovBSPX.Enabled:=SRVPath.Enabled;
  Set1Btn.Enabled:=SRVPath.Enabled;
  NEChk.Enabled:=SRVPath.Enabled;
  NTChk.Enabled:=SRVPath.Enabled;

  SetBSPXStat;

  BTD9.Text:=CalcBTIFMes(1+Ord(MUType.ItemIndex=1));

  If (MUType.ItemIndex=1) and (ThisSrvChk.Checked) and (WS_IsNT(WSOS.ItemIndex)) and (BTEType.ItemIndex=1) then
  Begin
    BTD10.Text:=BTProtocols[3];
    Set10Btn.Enabled:=BOn;
  end
  else
    Set10Btn.Enabled:=BOff;


end;
procedure TConfigForm.MUTypeExit(Sender: TObject);
begin
  inherited;


  ServOS.Enabled:=(MUType.ItemIndex<>2);
  SetSrvPath;
  GetBTSettings;

end;


procedure TConfigForm.SetNWA;
Begin
  NWAName.Enabled:=(WS_IsNT(WSOS.ItemIndex)) and (MUType.ItemIndex=1);
  IPXMPS.Enabled:=NWAName.Enabled and (NWAName.Text<>'');
  IPXVMN.Enabled:=NWAName.Enabled;

  Set2Btn.Enabled:=IPXMPS.Enabled;
  Set3Btn.Enabled:=IPXVMN.Enabled;
  Label89.Enabled:=IPXVMN.Enabled;
  Label810.Enabled:=IPXVMN.Enabled;
  Label811.Enabled:=IPXVMN.Enabled;

  Label812.Visible:=NWAName.Enabled;

  If (IPXMPS.Enabled) then
    IPXMPS.Value:=IPXMaxPktSize(BOff,WSOS.ItemIndex,0,NWAName.Text);

  ThisSrvChk.Enabled:=NWAName.Enabled;

  BTEType.Enabled:=(MUType.ItemIndex=1) and (ThisSrvChk.Checked) and (Srv_IsNT(ServOS.ItemIndex));
end;

procedure TConfigForm.SERVOSExit(Sender: TObject);
begin
  inherited;

  SetSrvPath;

end;

procedure TConfigForm.GetSrvPath;
Begin
  With OpenDialog1 do
  Begin
    FileName:='BSTART';
    Filter:='Novell Command Files (System Dir - BStart)|*.NCF';
  end;

  if OpenDialog1.Execute then
  begin
    SrvPath.Text:=OpenDialog1.FileName;

    If (UpCaseStr(ExtractFileName(SrvPath.Text))<>'BSTART.NCF') then
    Begin
      ShowMessage('The File BSTART.NCF could not be found, Please try again.');
      SrvPath.Text:='';
    end;
  end;

end;

procedure TConfigForm.BrowseBtnClick(Sender: TObject);
begin
  inherited;
  GetSrvPath;
  SetBSPXStat;
end;

procedure TConfigForm.BrowseBtn2Click(Sender: TObject);

Var
  ThisPAth  :  String;

begin
  inherited;
    With OpenDialog1 do
  Begin
    FileName:='';
    Filter:='';
  end;

  if OpenDialog1.Execute then
  begin
    ExPath.Text:=OpenDialog1.FileName;

    ThisPath:=PathToShort(ExtractFileDir(ExPath.Text));

    If (Not FileExists(ThisPath+'\EXCHQSS.DAT')) then
    Begin
      ShowMessage(ThisPath+#13+#13+'Is not a valid ' + sAppName + ' directory!');
      ExPath.Text:='';
    end
    else
      ExPath.Text:=ThisPath;
  end;

end;

procedure TConfigForm.OkCP1BtnClick(Sender: TObject);

Var
  BStat  :  Integer;

begin

  If (Sender=OKCP1Btn) then
  With CompSysInfo^ do
  Begin
    MUVal:=MUType.ItemIndex;
    SRVOSVal:=SerVOS.ItemIndex;
    WSOSVal:=WSOS.ItemIndex;

    NovSRVPAth:=SrvPath.Text;
    ExPathStr:=ExPAth.Text;
    WSNo:=Trunc(WKNo.Value);

    NWAdpKey:=NWAName.Text;
    {TotWS:=Trunc(TotTestNo.Value);}

    TRing:=NTChk.Checked;
    BTServer:=(BTEType.ItemIndex=1);
    BTUseRecon:=SetChk.Checked;
    UsePrintList:=PrnMasChk.Checked;

    BStat:=Reset_B;

    BStat:=Stop_B;

  end;

  inherited;
end;

procedure TConfigForm.FindNWAdaptors;

Var
  ThisReg  :  TRegistry;

Begin

  If (WS_IsNT(WSOS.ItemIndex)) then
  Begin
    ThisReg:=TRegistry.Create;

    Try
      With ThisReg do
      Begin
        RootKey:=HKey_Local_Machine;

        If OpenKey(CompRegKey1,BOff) then
        Begin
          NWAName.Items.Clear;

          GetKeyNames(NWAName.Items);
        end;

      end; {finally..}
    Finally

      ThisReg.Free;
    end; {try..}
  end;
end;


procedure TConfigForm.WSOSExit(Sender: TObject);
begin
  inherited;

  SetNWA;
  FindNWAdaptors;
end;

procedure TConfigForm.NWANameExit(Sender: TObject);
begin
  inherited;
  SetNWA;
end;

procedure TConfigForm.Set2BtnClick(Sender: TObject);

Var
  DefValue,
  mbRet  :  Word;

begin
  inherited;

  mbRet:=mrNo;

  If (IPXMPS.Value=0.0) then
  Begin
    mbRet:=MessageDlg('Do you wish to set the recommended packet size of 576',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end;

  If (mbRet<>mrCancel) then
  Begin
    If (mbRet=mrYes) then
      DefValue:=576
    else
      DefValue:=Trunc(IPXMPS.Value);

    IPXMPS.Value:=IPXMaxPktSize(BOn,WSOS.ItemIndex,DefValue,NWAName.Text);

    If (IPXMPS.Value<>DefValue) then
    Begin
      ShowMessage('It was not possible to set the Max Packet Size.'+#13+'Please re check the network adaptor name, and try again'+#13+
                  'Check you have permission to ammend the registry.'+#13+'If all else fails, ammend using the registry.');

      WriteToLog('Set IPX Max Packet Size to '+Form_Int(DefValue,0)+' failed.');

    end
    else
      WriteToLog('Set IPX Max Packet Size to '+Form_Int(DefValue,0)+' successful.');


  end;

end;

procedure TConfigForm.Set3BtnClick(Sender: TObject);
Var
  DefValue,
  mbRet  :  Word;

begin
  inherited;

  Begin
    DefValue:=Trunc(IPXVMN.Value);

    IPXVMN.Value:=IPXVirtualNo(BOn,WSOS.ItemIndex,DefValue);

    If (IPXVMN.Value<>DefValue) then
    Begin
      ShowMessage('It was not possible to set the Virtual Machine Number.'+#13+
                  'Check you have permission to amend the registry.'+#13+'If all else fails, amend using the registry.');

      WriteToLog('Set IPX Virtual Machine Number to '+Form_Int(DefValue,0)+' failed.');

    end
    else
      WriteToLog('Set IPX Virtual Machine Number to '+Form_Int(DefValue,0)+' successful.');


  end;

end;


procedure TConfigForm.WriteToLog(LM  :  String);

Begin
  With TMainForm(Owner) do
  Begin
    WriteToOutput(LM,BOff);

  end;

end;



procedure TConfigForm.SRVPathExit(Sender: TObject);
begin
  inherited;
  SetBSPXStat;
end;

procedure TConfigForm.Set1BtnClick(Sender: TObject);
begin
  inherited;

  If (NovellBSPX(BOn,NTChk.Checked,SRVPAth.Text)) then
  Begin
    SetBSPXStat;
    WriteToLog('Set BSPX in BStart.NCF successful.');
  end
  else
  Begin
    ShowMessage('It was not possible to set the Novell BSPX Parameter.'+#13+
                  'Check you have permission to amend the file BSTART.NCF.'+#13+'If all else fails, amend manually as per EntRead.');

    WriteToLog('Set BSPX in BStart.NCF failed.');


  end;


end;

procedure TConfigForm.PageControl1Change(Sender: TObject);
begin
  inherited;

  SBSPanel1.Visible:=(PageControl1.ActivePage<>TabSheet3) and (PageControl1.ActivePage<>TabSheet5);

  Animated1.Play:=SBSPanel1.Visible;
end;

procedure TConfigForm.SetChkClick(Sender: TObject);
begin
  inherited;
  SetAllBtn.Enabled:=SetChk.Checked;
end;

procedure TConfigForm.ThisSrvChkClick(Sender: TObject);
begin
  inherited;

  SetNWA;
end;

procedure TConfigForm.BTETypeExit(Sender: TObject);
begin
  inherited;
  SetSrvPath;
  GetBTSettings;
end;


procedure TConfigForm.SetBTSettings(SetNo  :  Integer);

Var
  HadError
    :  Boolean;
  ns,ne,n
    :  Integer;

  NewVal
    :  Integer;

Begin
  HadError:=BOff;

  If (SetNo=9999) then
  Begin
    ns:=1; ne:=11;
  end
  else
  Begin
    ns:=SetNo; ne:=ns;
  end;


  For n:=ns to ne do

  Begin
    If (n In [9,10]) then
    Begin
      If (n=9) then
      Begin
        NewVal:=Ord(MUType.ItemIndex<>1);

        If (SetNo=9) then
          SetBTSettings(10);
      end
      else
        NewVal:=Ord(MUType.ItemIndex=1);

    end
    else
      If (n=11) then 
      Begin
        NewVal:=3;
      end
      else
      Begin
        NewVal:=Trunc(BTCAry[SetChk.Checked,n].Value);
      end;


    If (n<>11) or (Set10Btn.Enabled) then
      If (GetBTRegSettings(BOn,(BTEType.ItemIndex=1),n,NewVal)<>NewVal) then
        HadError:=BOn;;
  end;

  GetBTSettings;

  If (HadError) then
     ShowMessage('An error occurred whilst attempting to update the Btrieve settings.'+#13+
                  'Check you have permission to amend the registry.'+#13+'If all else fails, amend manually as per EntRead.');


end;

procedure TConfigForm.BTBtn1Click(Sender: TObject);
begin
  inherited;

  SetBTSettings(TButton(Sender).Tag);

  If (Not Told) then
  Begin
    ShowMessage('You will need to exit Compass in order for this change to take effect.');
    Told:=BOn;
  end;
  
end;

end.
