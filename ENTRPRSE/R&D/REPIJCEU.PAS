unit RepIJCEU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepJCEInp = class(TRepInpMsg)
    Label83: Label8;
    SxSF: TSBSComboBox;
    Sum1: TBorCheck;
    Label81: Label8;
    SortXCB: TSBSComboBox;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  JobCRep1Ptr;

  public
    { Public declarations }
  end;


procedure EmplList_Report(IDMode  :  Byte;
                          AOwner  :  TComponent);


procedure JobHist_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);



procedure JobCustXPose_Report(IDMode  :  Byte;
                              AOwner  :  TComponent);

procedure JobBudg_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

procedure JobAnal_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

procedure JobWIP_Report(IDMode  :  Byte;
                        AOwner  :  TComponent);

procedure JobBill_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  VarJCstU,
  BTKeys1U,
  RepJCE1U,
  JobSup1U,
  SysU1,
  SysU2,
  RepIJCHU,
  RepIJCXU,
  RepIJCBU,
  RepIJCAU,
  RepIJCWU,
  RepIJCIU,
  BTSupU2;


{$R *.DFM}


Var
  JCRNo  :  Byte;


procedure TRepJCEInp.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;

  ClientHeight:=175;
  ClientWidth:=299;

  RepMode:=JCRNo;

  With SxSF do
  Begin
    For n:=1 to NofEmplTypes do
      Items.Add(EmplTDescL^[n]);
  end;

  SxSF.Items.Insert(0,'All Employee Types');

  SxSF.ItemIndex:=0;
  
  SortXCB.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  SetLastValues;
end;

procedure TRepJCEInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;



procedure TRepJCEInp.OkCP1BtnClick(Sender: TObject);

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        ShowER:=Sum1.Checked;

        If (SxSF.ItemIndex>0) then
          RepType:=SxSF.ItemIndex;

        If (SortxCB.ItemIndex>0) then
          SortOrd:=SortxCB.ItemIndex;


        AddEmpListRep2Thread(1,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;



procedure EmplList_Report(IDMode  :  Byte;
                          AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCEInp;

  Begin
    JCRNo:=IdMode;

    If (IdMode=1) then
      RepInpMsg1:=TRepJCEInp.Create(AOwner)
    else
      AddEmpListRep2Thread(IdMode,Nil,AOwner);

  end;



procedure JobHist_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCHInp;

  Begin
    RepInpMsg1:=TRepJCHInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;


procedure JobCustXPose_Report(IDMode  :  Byte;
                              AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCXInp;

  Begin
    RepInpMsg1:=TRepJCXInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;


procedure JobBudg_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCBInp;

  Begin
    RepInpMsg1:=TRepJCBInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;


procedure JobAnal_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCAInp;

  Begin
    RepInpMsg1:=TRepJCAInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;


procedure JobWIP_Report(IDMode  :  Byte;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCWInp;

  Begin
    RepInpMsg1:=TRepJCWInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;


procedure JobBill_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCIInp;

  Begin
    RepInpMsg1:=TRepJCIInp.Create(AOwner);

    Try
      RepInpMsg1.RepMode:=IdMode;
    except
      RepInpMsg1.Free;
    end; {Try..}
  end;



Initialization

  JCRNo:=0;

end.
