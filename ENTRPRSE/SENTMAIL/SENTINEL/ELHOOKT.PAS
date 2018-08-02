unit ELHOOKT;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EntCustom, Enterprise_TLB;

type
  TForm1 = class(TForm)
    EntCustom1: TEntCustom;
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Close;
    procedure EntCustom1Connect(ComCustomisation: ICOMCustomisation);
    procedure EntCustom1Hook(EventData: ICOMEventData);
  private
    { Private declarations }
    procedure OpenDataFiles;
    procedure CloseDataFiles;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ElVar, ElHookU, BtrvU2, GlobVar, ElEvDefs, PIMisc, ElObjs;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DefineFiles('');
  with EntCustom1 do
  begin
    PIMakeAboutText('Enterprise Sentimail Plug-In',
                         ElVersion + ' (COM)', EntCustom1.AboutText);
  end;

  EntCustom1.Connect;
end;

procedure TForm1.EntCustom1Close;
begin
  CloseDataFiles;
  EntCustom1.Disconnect;
  Application.Terminate;
end;

procedure TForm1.EntCustom1Connect(ComCustomisation: ICOMCustomisation);
begin
  OpenDataFiles;
end;

procedure TForm1.EntCustom1Hook(EventData: ICOMEventData);
begin
{  if SetDrive <> IncludeTrailingBackSlash(Trim(EntCustom1.Intf.SystemSetup.ssDataPath)) then
  begin //Company has changed so we need to change our data files
    CloseDataFiles;
    Sleep(500); //seems to need a moment between closing and opening
    OpenDataFiles;
  end;
  ProcessEvent(EventData);}
end;

procedure TForm1.OpenDataFiles;
var
  KeyS : String[255];
  Res : SmallInt;
begin
  SetDrive := IncludeTrailingBackSlash(Trim(EntCustom1.IntF.SystemSetup.ssDataPath));
  Res := Open_File(F[ElertF],
           SetDrive + FileNames[ElertF], 0);

  if Res = 0 then
  begin
    FillChar(KeyS, SizeOf(KeyS), #0);
    Keys := IntKey(1);

    Res := Find_Rec(B_GetGEq, F[ElertF],ElertF,RecPtr[ElertF]^, {elIdxElertName}elIdxEvent, KeyS);

    while Res = 0 do
    begin

      if ElertRec.elType = 'E' then
         EntCustom1.IntF.EnableHook(ElertRec.elWindowID, ElertRec.elHandlerID);

      Res := Find_Rec(B_GetNext, F[ElertF],ElertF,RecPtr[ElertF]^, {elIdxElertName}elIdxEvent, KeyS);
    end;
  end;
  Open_File(F[LineF],
           SetDrive + FileNames[LineF], 0);

  ThisElert := TElertObject.CreateNoFile;
  ThisLine := TEvent.CreateNoFile;
end;

procedure TForm1.CloseDataFiles;
begin
  Close_File(F[ElertF]);
  Close_File(F[LineF]);
end;

end.
