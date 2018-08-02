unit StkROFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,VarSortV,
  GlobVar,VarConst, StkLstU;

type
  TROCtrlForm = class(TForm)
    SetPanel: TSBSPanel;
    CanCP1Btn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    fBack2Ord,
    fGenWORQty,
    fResetMode,
    PrevHState  :  Boolean;

    fStkGrp     :  Str20;
    fStkLocFilt :  Str10;

    fMode       :  Byte;

    fFnum,
    fKeypath    :  Integer;

    fMainK      :  Str255;

    ReorderMode : TReorderModes;


  public
    { Public declarations }

    Procedure Prime_ROCtrl(Back2Ord,
                           GenWORQty,
                           ResetMode
                                     :  Boolean;
                           StkGrp    :  Str20;
                           StkLocFilt:  Str10;
                           Fnum,
                           KeyPath   :  Integer;
                           KeyChk    :  Str255;
                           Mode      :  Byte;
                           aReorderMode : TReorderModes);


  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BTSupU1,
  StkRORdR,
  StkROCtl;

{$R *.DFM}



// PKR. 11/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to
//      relevant suppliers.  Provide a choice of print options.
// Added reorderMode.
Procedure TROCtrlForm.Prime_ROCtrl(Back2Ord,
                                   GenWORQty,
                                   ResetMode
                                             :  Boolean;
                                   StkGrp    :  Str20;
                                   StkLocFilt:  Str10;
                                   Fnum,
                                   KeyPath   :  Integer;
                                   KeyChk    :  Str255;
                                   Mode      :  Byte;
                                   aReorderMode : TReorderModes);

Begin
  fKeyPath:=KeyPath;
  fFnum:=Fnum;
  fMainK:=KeyChk;
  fMode:=Mode;
  fBack2Ord:=Back2Ord;
  fGenWORQty:=GenWORQty;
  fResetMode:=ResetMode;
  fStkGrp:=StkGrp;
  fStkLocFilt:=StkLocFilt;

  // PKR. 11/12/2015. ABSEXCH-15333. Re-order list to email all generated PORs to relevant suppliers.
  // Save reorder mode locally.
  ReorderMode := aReorderMode;

  SetPanel.Caption:='Please Wait... Working on Stock List';

  SetAllowHotKey(BOff,PrevHState);

  ShowModal;

  SetAllowHotKey(BOn,PrevHState);
end;
                   
procedure TROCtrlForm.FormActivate(Sender: TObject);
begin
  Case fMode of
    // PKR. 11/12/2015. ABSEXCH-15333.
    // Add reorder mode, which specifies whether or not to print, email etc.

    {SS 11/04/2016 2016-R2
    ABSEXCH-17374:Auto-set before sort view and after sort view. Only sorted stock listed should generate POR.
    - Added a paramater to check the operation is applied on sorted stock list or not.}    
    0  :   Generate_POR(fMainK,fStkGrp,fStkLocFilt,fBack2Ord,Self, ReorderMode,FFnum = SortTempF);
    {1  :   Generate_ADJ(fStkLocFilt,Self);}

    2  :
    begin
      Generate_AutoNeed(fBack2Ord,fGenWORQty,fResetMode,fStkGrp,fStkLocFilt,fFnum,fKeyPath,fMainK,Self);
      {SS 13/04/2016 2016-R2
       ABSEXCH-17375:On clicking Auto- Set after sort view is applied ,
       it should set the 'Order' Qty for the sorted Stock records.
       -Update Stock Table records based on the sorted Stock list.}
      if FFnum = SortTempF then
        UpdateFromSortViewRecord(fBack2Ord,fGenWORQty,fResetMode,fStkGrp,fStkLocFilt,StockF,SortTempF,fKeyPath,fMainK,Self);
    end;


  end; {Case..}


  PostMEssage(Self.Handle,WM_Close,0,0);
end;

procedure TROCtrlForm.FormCreate(Sender: TObject);
begin
  ClientHeight:=104;
  ClientWidth:=236;

end;

end.
