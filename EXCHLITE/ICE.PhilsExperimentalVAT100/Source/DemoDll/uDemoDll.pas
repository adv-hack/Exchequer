Unit uDemoDll;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, activex, comobj,
  ComCaller_TLB,
  uCommon
  ;

Type
  TForm1 = Class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Button3Click(Sender: TObject);
    Procedure Button4Click(Sender: TObject);
    Procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  Private
    { Private declarations }
//    fcookie: Integer;
//    fEvents: IEvents;
    fCallerObj: IDSRCOMCaller;
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.dfm}

{
procedure TsrvDSR.DoShutDown;
begin
  inherited;
  CoLockObjectExternal(fEvents, False, True);
  RevokeActiveObject(fCookie, nil);
  CoDisconnectObject(fEvents, 0);
end;

Procedure TsrvDSR.DoStart;
Begin
  Inherited;
  fEvents := CoEvents.Create;
  If RegisterActiveObject(fevents, CLASS_Events, ACTIVEOBJECT_WEAK, fCookie) <>
    mk_e_unavailable Then
  Begin
    CoLockObjectExternal(fEvents, True, True);
    ShowMessage('Process ok');
  End
  Else
    ShowMessage('Process not ok');
End;

}

{
}

Procedure TForm1.Button1Click(Sender: TObject);
//Var
//  Rot: IRunningObjectTable;
//  moni: IMoniker;
//  unk: IUnknown;
//  lResult: Integer;
//  lobj: IEvents;
Begin
//  GetRunningObjectTable(0, rot);

//    If CreateItemMoniker('', 'DSROBJ', Moni) = s_ok Then
//    Begin
//      rot.GetObject(moni, unk);
//      unk.QueryInterface(IceEvents_TLB.IID_IEvents, lobj);
//      lObj.SaveXml('aaaaaa', '');
//    End;

  {
  lResult := getactiveObject(CLASS_Events, Nil, unk);
  If lResult = mk_e_unavailable Then
  Begin
    lobj := CoEvents.Create;
  End
  Else
    unk.QueryInterface(IceEvents_TLB.IID_IEvents, lobj);

  lobj.SaveXml('hello world', '');
  lObj := Nil;
  }
End;

Procedure TForm1.Button2Click(Sender: TObject);
//Var
//  lResult: Integer;
Begin
//  CoInitialize(nil);
{  fEvents := CoEvents.Create;
  lResult := RegisterActiveObject(fEvents, CLASS_Events, ACTIVEOBJECT_WEAK,
    fCookie);

  If lresult = s_ok Then
  Begin
    CoLockObjectExternal(fevents, True, True);
    ShowMessage('Process ok');
  End
  Else
    ShowMessage('Process not ok');}
End;

Procedure TForm1.Button3Click(Sender: TObject);
Begin
{  CoLockObjectExternal(fevents, False, True);
  RevokeActiveObject(fCookie, Nil);
  CoDisconnectObject(fevents, 0);}
End;

Procedure TForm1.Button4Click(Sender: TObject);
Begin
  if _RegisterServer('C:\Projects\Ice\Source\DemoIceEvents\IceEvents.dll', True) then
    ShowMessage('Registred')
End;

Procedure TForm1.Button5Click(Sender: TObject);
Begin
  if _RegisterServer('C:\Projects\Ice\Source\DemoIceEvents\IceEvents.dll', False) then
    ShowMessage('Unregistred')
End;

procedure TForm1.Button6Click(Sender: TObject);
//var
//  Rot: IRunningObjectTable;
//  x: integer;
//  eve:IEvents;
//  moni:IMoniker;
//  y: IBindCtx;
begin
{  if CreateItemMoniker('', 'DSROBJ', Moni) = s_ok then begin
    CreateBindCtx(0, y);
    y.GetRunningObjectTable(Rot);

//    GetRunningObjectTable(0, Rot);
    eve:= CoEvents.Create;
    if Rot.Register(ACTIVEOBJECT_WEAK, eve, moni, x) = s_ok then
    //if y.RegisterObjectBound(eve) = s_ok then
      showmessage('ok');
  end;
  }
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  lRes: WideString;
begin
  if Assigned(fCallerObj) then begin
    //fCallerObj.displaymsg('hello world', lRes);
    ShowMessage(lRes);
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  fCallerObj:=  CoDSRCOMCaller.Create;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  fCallerObj := nil;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  _LocalServiceRunning('srvDsr');
end;

End.

