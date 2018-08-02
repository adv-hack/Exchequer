unit RBFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  CheckLst;

type
  TTestCust3 = class(TTestCust)
    FileList: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    lblPath: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FileListClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

    Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;

  public
    { Public declarations }

    procedure ShowBar(Waiting  :  Boolean);


  end;


implementation

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  ProgU,
  ReBuildU;

{$R *.DFM}

procedure TTestCust3.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  ClientHeight:=295;
  ClientWidth:=424;

  For n:=1 to TotFiles do
  With FileList do
  Begin
    Items.Add(FileNames[n]);

  end;


  FileList.Items.Add('Rebuild All Files');

  lblPath.Caption:='Current data path : '+SetDrive;

end;



Procedure TTestCust3.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      10 :  ReBuild_Files(BOff,BOff,ProgBar);

      11 :  ;



      else  Inherited;

    end; {Case..}

  end; {With..}


end;



procedure TTestCust3.ShowBar(Waiting  :  Boolean);

Var
  n        :  Integer;
  HasSome  :  Boolean;
  mbRet    :  Word;

Begin

  HasSome:=BOff;

  With FileList do
  Begin
    For n:=0 to Pred(Items.Count) do
    Begin
      FixFile[n+1].ReBuild:=Checked[n];

      If (Not HasSome) then
        HasSome:=Checked[n];
    end;

  end;


  If (FixFile[BuildF].ReBuild) then
  Begin

    For N:=1 to TotFiles do
      FixFile[N].ReBuild:=BOn;

    FixFile[BuildF].ReBuild:=BOff;


  end;



  If (HasSome) then
  Begin
    mbRet:=MessageDlg('Please confirm you wish to start rebuilding',mtConfirmation, [mbYes, mbNo], 0);

    If (mbRet=mrYes) then
    Begin
      Animated1.Play:=False;

      ProgBar:=TGenProg.Create(Self);

      try
        With ProgBar do
        Begin
          ProgBar.Caption:='Data Rebuild';


          ShowModal;

        end;

      finally
        ProgBar.Free;

        SendMessage(Self.Handle,WM_Close,0,0);
      end;
    end
  end  
  else
    ShowMessage('No files have been selected for rebuilding.');

end;


procedure TTestCust3.OkCP1BtnClick(Sender: TObject);
begin


  ShowBar(BOff);

end;

procedure TTestCust3.FileListClick(Sender: TObject);
begin
  inherited;

  With FileList,Items do
  Begin
    If (ItemIndex<>-1) then
      Checked[ItemIndex]:=Not Checked[ItemIndex]; 


  end;
end;

procedure TTestCust3.ClsCP1BtnClick(Sender: TObject);
begin
  inherited;
  SendMessage(Self.Handle,WM_Close,0,0);
end;

end.
