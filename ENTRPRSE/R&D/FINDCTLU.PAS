unit FindCtlU;


{$I DEFOVR.INC}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,
  Globvar,VarConst,BtSupU3,SBSComp,FindRecU;



const

  //PR: 04/12/2013 ABSEXCH-14824 constants to identify tabs
  tabFindCustomer   = 0;
  tabFindConsumer   = 1;
  tabFindSupplier   = 2;
  tabFindDocument   = 3;
  tabFindStock      = 4;
  tabFindSerial     = 5;
  tabFindBin        = 6;
  tabFindJob        = 7;



type



  TFCustFind  =  Class(TFindRec)



    Constructor Create(AOwner  :  TComponent;
                       Mode    :  Byte;
                       RetRec  :  TReturnCtrlRec);

    Destructor Destroy; Override;

    Procedure FormCreate(Sender   :  TObject); override;

    Procedure SetRetCtrl(Mode    :  Byte;
                         RetRec  :  TReturnCtrlRec);


  end;



Var
  FindCust  :  TFCustFind;

{ ----------------------}


Procedure Ctrl_GlobalFind(AOwner      :  TComponent;
                          RetCtrl  :  TReturnCtrlRec;
                          FMode       :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  EtMiscU,
  SBSPanel,
  BtSupU1,
  BtKeys1U,
  ExThrd2U,
  DebugU;





Destructor TFCustFind.Destroy;

Begin

  Inherited Destroy;

end;

Constructor TFCustFind.Create(AOwner  :  TComponent;
                              Mode    :  Byte;
                              RetRec  :  TReturnCtrlRec);
Begin

  Modus:=Mode;

  ReturnCtrl:=RetRec;

  SetxParent;


  Inherited Create(AOwner);

end;


Procedure TFCustFind.FormCreate(Sender  :  TObject);




Begin


  Inherited FormCreate(Sender);

  ChangePage(Modus);

end; {Proc..}


Procedure TFCustFind.SetRetCtrl(Mode    :  Byte;
                                RetRec  :  TReturnCtrlRec);

Begin
  Modus:=Mode;

  ReturnCtrl:=RetRec;

  SetxParent;

  If (Current_Page<>Modus) then
    ChangePage(Modus);

end;


{-----------------------}



Procedure Ctrl_GlobalFind(AOwner      :  TComponent;
                          RetCtrl  :  TReturnCtrlRec;
                          FMode       :  Byte);

Var
  WasNew,
  ListBusy  :  Boolean;

Begin
  WasNew:=BOff;  ListBusy:=BOff;
                                                    {* b560.057 create new if find within a find auto closes the find window because
                                                       it is a pass2parent as otherwise you are really dealing with the parent find
                                                       which created the window in which the current find is operating and the whole lot
                                                       gets closed *}
  If (Not Assigned(FindCust)) or (Not InFindDoc) or ((InFindDoc) and (RetCtrl.Pass2Parent)) then
  Begin
    WasNew:=BOn;
    FindCust:=TFCustFind.Create(AOwner,FMode,RetCtrl);
  end;



  try
    With FindCust do
    Begin
      If (Assigned(OwnList)) then
      Begin
        ListBusy:=OwnList.ListStillBusy;

        If (ListBusy) then {* Let us attempt to stop it.}
        Begin
          Set_BackThreadMVisible(BOn);

          ShowMessage('ObjectFind is currently busy.'+#13+
                      'Either stop and close the current search, or try again later.');

          Set_BackThreadMVisible(BOff);

        end;
      end;

      If (Not WasNew) and (Not ListBusy) then
        SetRetCtrl(FMode,RetCtrl);

      WindowState:=wsNormal;
      Show;
    end;

  except

    FindCust.Free;
    FindCust:=nil;

  end; {Except..}
end;


Begin
  FindCust:=nil;


end.
