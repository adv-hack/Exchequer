unit PWarnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel,GlobVar,VarConst, BtrvU2;


type
  TPassWLock = class(TForm)
    SBSPanel1: TSBSPanel;
    SBSPanel2: TSBSPanel;
    SBSPanel3: TSBSPanel;
    Image1: TImage;
    Label81: Label8;
    Label82: Label8;
    Timer1: TTimer;
    OKBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }

    PrevHState    :  Boolean;

  public
    { Public declarations }


  end;



Function PChkAllowed_In (OptNo  :  LongInt)  :  Boolean;

Function  ChkAllowed_In (OptNo  :  LongInt)  :  Boolean;

Function BoChkAllowed_In (Check  :  Boolean;
                          OptNo  :  LongInt)  :  Boolean;

Function Allowed_In(Check  :  Boolean;
                    OptNo  :  LongInt)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BTSupU1,

  {$IFNDEF EDLL}
  {$IFNDEF EXDLL}
    {$IFNDEF OLE}
      {$IFNDEF COMP}     { Multi-Company Manager }
      {$IFNDEF EBAD}
        ExThrd2U,
      {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  BTSupU2;
  
{$R *.DFM}



procedure TPassWLock.FormCreate(Sender: TObject);

Var
  TmpForm  :  TForm;
  BMap1    :  TBitMap;

  RectD    :  TRect;

begin
  ClientHeight:=123;
  ClientWidth:=256;

  SetAllowHotKey(BOff,PrevHState);

  Top:=Round(Screen.Height/2-(Height/2));

  Left:=Round(Screen.Width/2-(Width/2));

  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;

    BMap1.Handle:=LoadBitMap(HInstance,'INFO_1');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
    end;

    BMap1.Free;
  end;
end;


procedure TPassWLock.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  SetAllowHotKey(BOn,PrevHState);
end;


procedure TPassWLock.FormShow(Sender: TObject);

Begin

  Timer1.Enabled:=BOn;

end; {Proc..}

procedure TPassWLock.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=BOff;

  OKBtn.Click;

end;




procedure TPassWLock.OKBtnClick(Sender: TObject);
begin
  ModalResult:=mrOk;
  PostMessage(Self.Handle,WM_Close,0,0);
end;




{ =============== General Password Check =========== }


Function PChkAllowed_In (OptNo  :  LongInt)  :  Boolean;

Begin

  If (OptNo>0) then
    PChkAllowed_In:=((EntryRec^.Access[Optno]>0) or (Not Syss.UsePassWords)
                     or (SBSIN))
  else
    PChkAllowed_In:=(OptNo=-255);

end;



{ ================= Hide Menu Check =============== }


Function ChkAllowed_In (OptNo  :  LongInt)  :  Boolean;

Begin

  If (OptNo>0) then
    ChkAllowed_In:=(PChkAllowed_In(OptNo)) {or (Not Syss.HideMenuOpt)) Dispabled to avoid having to check twice } 
  else
    ChkAllowed_In:=(OptNo=-255);

end;

Function BoChkAllowed_In (Check  :  Boolean;
                          OptNo  :  LongInt)  :  Boolean;


Begin

  Result:=(Check and (ChkAllowed_In(OptNo)));

end;


{ ================= Function to check if user has access ============== }

Function Allowed_In(Check  :  Boolean;
                    OptNo  :  LongInt)  :  Boolean;

Var
  TmpBo  :  Boolean;
  TW     :  TPassWLock;

Begin


  TmpBo:=((Check) and (PChkAllowed_In(OptNo)));


  If ((Not TmpBo) and (Check)) then
  Begin
    {* Display a modal message *}
    TW:=TPassWLock.Create(Application.MainForm);

    try
      {$IFNDEF EDLL}
      {$IFNDEF EXDLL}
        {$IFNDEF OLE}
          {$IFNDEF COMP}
          {$IFNDEF EBAD}
            Set_BackThreadMVisible(BOn);
          {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
      {$ENDIF}

      TW.ShowModal;
    finally
      TW.Free;

      {$IFNDEF EDLL}
      {$IFNDEF EXDLL}
        {$IFNDEF OLE}
          {$IFNDEF COMP}
          {$IFNDEF EBAD}
            Set_BackThreadMVisible(BOff);
          {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
      {$ENDIF}

    end; {try..}
  end;


  Allowed_In:=TmpBo;
end; {Func..}


end.
