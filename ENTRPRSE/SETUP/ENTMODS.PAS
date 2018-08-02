unit EntMods;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns;

type
  TfrmEntModules = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    panEntCore: TPanel;
    paneBus: TPanel;
    panODBC: TPanel;
    panImport: TPanel;
    panToolkit: TPanel;
    panOLESave: TPanel;
    panPaper: TPanel;
    panTrade: TPanel;
    chkCore: TCheckBox;
    chkBarCode: TCheckBox;
    chkEBus: TCheckBox;
    chkImport: TCheckBox;
    chkODBC: TCheckBox;
    chkCripple: TCheckBox;
    chkToolkit: TCheckBox;
    chkOLESave: TCheckBox;
    chkPaper: TCheckBox;
    chkTrade: TCheckBox;
    panRepWrt: TPanel;
    chkRepWrt: TCheckBox;
    panElerts: TPanel;
    chkElerts: TCheckBox;
    panVRW: TPanel;
    chkVRW: TCheckBox;
    panWOP: TPanel;
    chkWOP: TCheckBox;
    panEBanking: TPanel;
    chkEBanking: TCheckBox;
    panOutlook: TPanel;
    chkOutlook: TCheckBox;
    procedure chkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    LocPosData  : Array [1..1] Of LongInt;

    procedure DoCheckyChecky;
  public
    { Public declarations }
    Procedure BuildModList (Const AvMod, InstMod : String);
    Procedure GetModStrs (Var InstMod : String);
  end;

function GetEntModules (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses CompUtil;

Const
  posScrlHOfs   = 1;

function GetEntModules (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmEntModules                              : TfrmEntModules;
  W_InstType, InstUpg, AvMod, InstMod, DlgPN : String;
Begin { GetEntModules }
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmEntModules := TfrmEntModules.Create(Application);
  Try
    With frmEntModules Do Begin
      { Resize for the resolution }
      AutoResize (2, 0);

      { Read selected Module info from Setup Script and Initialise Form }
      GetVariable(DLLParams, 'V_AVMOD', AvMod);
      GetVariable(DLLParams, 'V_INSTMOD', InstMod);

      BuildModList (AvMod, InstMod);

      { Installation Type }
      GetVariable(DLLParams, 'V_INSTTYPE', W_InstType);
      If (W_InstType = 'B') Then
        { Upgrade }
        InstUpg := 'upgrade'
      Else
        { Install }
        InstUpg := 'install';

      InstrLbl.Caption := ReplaceStrings(InstrLbl.Caption, '%INSTUPG%', InstUpg);

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Save selected Module info to Setup Script }
                GetModStrs (InstMod);
                SetVariable(DLLParams, 'V_INSTMOD', InstMod);
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmEntModules.Free;
  End;
End; { GetEntModules }


{---------------------------------------------------------------------------}


Procedure TfrmEntModules.GetModStrs (Var InstMod : String);
Begin { GetModStrs }
  InstMod := '';

  If chkCore.Checked Then InstMod := InstMod + 'A';
  If chkEBus.Checked Then InstMod := InstMod + 'B';
  If chkToolkit.Checked Then InstMod := InstMod + 'C';
  If chkImport.Checked Then InstMod := InstMod + 'D';
  If chkODBC.Checked Then InstMod := InstMod + 'E';
  If chkRepWrt.Checked Then InstMod := InstMod + 'F';
  // G = P.SQ L Requesters - not used
  If chkCripple.Checked Then InstMod := InstMod + 'H';
  If chkBarCode.Checked Then InstMod := InstMod + 'I';
  If chkPaper.Checked Then InstMod := InstMod + 'J';
  If chkOLESave.Checked Then InstMod := InstMod + 'L';
  If chkTrade.Checked Then InstMod := InstMod + 'M';

  If chkWOP.Checked Then InstMod := InstMod + 'N';
  If chkElerts.Checked Then InstMod := InstMod + 'O';
  If chkVRW.Checked Then InstMod := InstMod + 'P';
  If chkEBanking.Checked Then InstMod := InstMod + 'Q';
  If chkOutlook.Checked Then InstMod := InstMod + 'R';
End; {  GetModStrs }

Procedure TfrmEntModules.BuildModList (Const AvMod, InstMod : String);
Var
  I, NextPan : Byte;
  NextTop    : LongInt;
  UpAvMod    : String;

  Procedure SetupPanel (Const ThePanel :  TControl; Const Vis : Boolean);
  Begin { SetupPanel }
    If Vis Then Begin
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 4;
        Width := 252;
      End; { With }
    End { If }
    Else Begin
      { Not Visible - Hide Panel }
      ThePanel.Visible := False;
    End; { If }
  End; { SetupPanel }

  Procedure SetupChkBox (Const TheChk : TCheckBox; Const Chk, Mandi : Boolean);
  Begin { SetupChkBox }
    With TheChk Do Begin
      Checked := Chk;

      If Mandi Then
        Tag := 1
      Else
        Tag := 0;
    End; { With }
  End; { SetupChkBox }

Begin { BuildModList }
  UpAvMod := UpperCase(AvMod);

  NextPan := 1;
  NextTop := 0;
  SetupPanel (panEntCore,  True);
  //SetupPanel (panEntFax,   (Pos ('J', UpAvMod) > 0));
  SetupPanel (panEBanking, (Pos ('Q', UpAvMod) > 0));
  SetupPanel (panEBus,     (Pos ('B', UpAvMod) > 0));
  SetupPanel (panImport,   (Pos ('D', UpAvMod) > 0));
  SetupPanel (panODBC,     (Pos ('E', UpAvMod) > 0));
  SetupPanel (panOLESave,  (Pos ('L', UpAvMod) > 0));
  SetupPanel (panOutlook,  (Pos ('R', UpAvMod) > 0));
  SetupPanel (panPaper,    (Pos ('J', UpAvMod) > 0));
  SetupPanel (panRepWrt,   (Pos ('F', UpAvMod) > 0));
  SetupPanel (panElerts,   (Pos ('O', UpAvMod) > 0));
  SetupPanel (panToolkit,  (Pos ('C', UpAvMod) > 0));
  SetupPanel (panTrade,    (Pos ('M', UpAvMod) > 0));
  SetupPanel (panVRW,      (Pos ('P', UpAvMod) > 0));
  SetupPanel (panWOP,      (Pos ('N', UpAvMod) > 0));

  { Set default CheckBox values }
  SetupChkBox (chkCore,      (Pos ('A', InstMod) > 0), (Pos ('a', AvMod) > 0));
    SetupChkBox (chkBarCode, (Pos ('I', InstMod) > 0), (Pos ('i', AvMod) > 0));

  SetupChkBox (chkEBus,      (Pos ('B', InstMod) > 0), (Pos ('b', AvMod) > 0));

  SetupChkBox (chkImport,    (Pos ('D', InstMod) > 0), (Pos ('d', AvMod) > 0));

  SetupChkBox (chkODBC,      (Pos ('E', InstMod) > 0), (Pos ('e', AvMod) > 0));
    SetupChkBox (chkCripple, (Pos ('H', InstMod) > 0), (Pos ('h', AvMod) > 0));

  SetupChkBox (chkOLESave,   (Pos ('L', InstMod) > 0), (Pos ('l', AvMod) > 0));

  SetupChkBox (chkPaper,     (Pos ('J', InstMod) > 0), (Pos ('j', AvMod) > 0));

  SetupChkBox (chkRepWrt,    (Pos ('F', InstMod) > 0), (Pos ('f', AvMod) > 0));

  SetupChkBox (chkElerts,    (Pos ('O', InstMod) > 0), (Pos ('o', AvMod) > 0));

  SetupChkBox (chkToolkit,   (Pos ('C', InstMod) > 0), (Pos ('c', AvMod) > 0));

  SetupChkBox (chkTrade,     (Pos ('M', InstMod) > 0), (Pos ('m', AvMod) > 0));

  SetupChkBox (chkVRW,       (Pos ('P', InstMod) > 0), (Pos ('p', AvMod) > 0));

  SetupChkBox (chkWOP,       (Pos ('N', InstMod) > 0), (Pos ('n', AvMod) > 0));

  SetupChkBox (chkEBanking,  (Pos ('Q', InstMod) > 0), (Pos ('q', AvMod) > 0));

  SetupChkBox (chkOutlook,   (Pos ('R', InstMod) > 0), (Pos ('r', AvMod) > 0));

  DoCheckyChecky;
End; { BuildModList }

{ Enforce relational links between modules }
procedure TfrmEntModules.DoCheckyChecky;
Begin { DoCheckyChecky }

  { no relational links at this time }

End; { DoCheckyChecky }

procedure TfrmEntModules.chkClick(Sender: TObject);
begin
  inherited;

  If Sender Is TBorCheck Then
    With Sender As TBorCheck Do
      If Tag = 1 Then
        Checked := True;

  DoCheckyChecky;
end;

procedure TfrmEntModules.FormCreate(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  LocPosData[posScrlHOfs] := Self.Height - ScrollBox1.Height;

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox1.VertScrollBar Do Begin
    Position := 0;
    Tracking := True;
  End; { With ScrollBox1.VertScrollBar }
end;

procedure TfrmEntModules.FormResize(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  ScrollBox1.Height := Self.Height - LocPosData[posScrlHOfs];
end;

end.
