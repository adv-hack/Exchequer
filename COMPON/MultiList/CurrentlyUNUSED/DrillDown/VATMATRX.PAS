unit VATMatrx;

interface

Uses Classes, Dialogs, Forms, SysUtils, windows, TEditVal,
  GlobVar,       // Exchequer global const/type/var
  VarConst;      // Enterprise global const/type/var

Type
  TVATMatrixPtr=  ^TVATMatrixRec;


  TVATMatrixRec=  Record
                    RateD    :  Text8Pt;
                    GoodsD,
                    VATD     :  TCurrencyEdit;


                    RateCode :  VATType;
                  end;

  TVATMatrix  =  Class(TList)

                  SpaceGap :  Integer;

                  VisiRec    :  TVATMatrixPtr;

                  Destructor Destroy; override;


                  Procedure AddVisiRec(RObj,
                                       VObj,
                                       GObj      :   TObject);

                  Procedure DestroyVisi;

                  Function IdRec(Start  :  Integer)  :  TVATMatrixPtr;

                  Procedure HideVATMatrix(INAnal  :  IVATAnalType);

                  Procedure Update_Rate(Sender  :  TObject;
                                    Var InvR    :  InvRec);
                end; {TVATMatrix..}


implementation

{ ====================== TVATMatrix Methods ===================== }

Destructor TVATMatrix.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TVATMatrix.AddVisiRec(RObj,
                                VObj,
                                GObj      :   TObject);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      RateD:=Text8Pt(RObj);
      GoodsD:=TCurrencyEdit(GObj);
      VATD:=TCurrencyEdit(VObj);
      RateCode:=VATType(Count);

      With SyssVAT^ do
        RateD.Text:=VATRates.VAT[RateCode].Desc;

      With (GoodsD) do {* Calculate Gap between Rows *}
      Case Count of
         1  :  SpaceGap:=Top+Height;
         2  :  SpaceGap:=Top-SpaceGap;
      end;

    end;

    Idx:=Add(VisiRec);

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}

Procedure TVATMatrix.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}

Function TVATMatrix.IdRec(Start  :  Integer)  :  TVATMatrixPtr;

Begin

  Result:=List[Start];

end;

{ ===== Procedure to Hide non used VAT rates ===== }

Procedure TVATMatrix.HideVATMatrix(INAnal  :  IVATAnalType);

Var
  n       :  VATType;
  NewTop  :  Integer;

Begin
  NewTop:=IdRec(0)^.GoodsD.Top;

  For n:=VStart to VEnd do
  Begin
    With IdRec(Ord(n))^ do
    Begin
      RateD.Visible:=INAnal[n];
      VATD.Visible:=INAnal[n];
      GoodsD.Visible:=INAnal[n];

      If (INAnal[n]) then {* Re-adjust position *}
      Begin
        RateD.Top:=NewTop;
        VATD.Top:=NewTop;
        GoodsD.Top:=NewTop;
        NewTop:=NewTop+GoodsD.Height+SpaceGap;
      end;
    end;
  end; {Loop..}
end;

{ ==== Update Manual VAT ==== }

Procedure TVATMatrix.Update_Rate(Sender  :  TObject;
                             Var InvR    :  InvRec);


Var
  n          :  Integer;
  FoundOk    :  Boolean;

Begin
(*
  n:=0;
  FoundOk:=BOff;

  While (n<=Pred(Count)) and (Not FoundOk) do
  With IdRec(n)^ do
  Begin
    FoundOk:=(Sender=VATD);

    If (FoundOk) then
    With InvR do
    Begin
      InvVATAnal[RateCode]:=VATD.Value;
      InvVAT:=CalcTotalVAT(InvR);
    end
    else
      Inc(n);
  end; {While..}
*)
end; {Proc..}

end.
