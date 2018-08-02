unit StkLockU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst;


  Procedure Close_StockEdit(Stk  :  StockRec);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  BtrvU2,
  BTSupU1,
  BTKeys1U,
  StockU,
  ExThrd2U,
  SysU2;




{ == Procedure to check if stock record is currently being edited == }

Procedure Close_StockEdit(Stk  :  StockRec);

Var
  StkForm  :  TForm;
  I        :  Integer;
  NotOpen  :  Boolean;

Begin
  NotOpen:=BOff;

  If (Found_StkEditNow(Stk.StockFolio)<>0) then
  With Application.MainForm do
  Begin
    { Must be done backwards through the MDIChildren array }
    While (Found_StkEditNow(Stk.StockFolio)<>0) and (Not NotOpen) do
    Begin
      NotOpen:=BOn;

      for I := MDIChildCount - 1 downto 0 do
      Begin
        {$B-}

        If (Assigned(MDIChildren[I])) and (MDIChildren[I] is TForm) then
        Begin
          {$B+}

          StkForm:=MDIChildren[I];

          If (StkForm is TStockRec) then
          With TStockRec(StkForm) do
          Begin
            If (ExLocal.LastEdit) and (ExLocal.LStock.StockFolio=Stk.StockFolio) then
            Begin
              PostMEssage(StkForm.Handle,WM_Close,0,0);
              Application.ProcessMessages;
              NotOpen:=BOff;
            end;
          end;


        end;

        If (Found_StkEditNow(Stk.StockFolio)=0) then
          Break;

      end; {For..}
    end; {While..}

  end; {If found}
end; {Proc..}

end.