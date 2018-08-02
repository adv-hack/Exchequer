unit InvListU;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst,
     BtrvU2;


Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;

Function GetStock(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;

Function GetJobMisc(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    JAMode,
                    Mode   :  Integer)  :  Boolean;


implementation

Uses BtSupU1;

Function GetCust(AOWner :  TComponent;
                 Want   :  Str20;
             Var Found  :  Str20;
                 IsCust :  Boolean;
                 Mode   :  Integer)  :  Boolean;
Begin { GetCust }
  Result := Global_GetMainRec (CustF, Want);
End; { GetCust }

Function GetStock(AOWner :  TComponent;
                  Want   :  Str20;
              Var Found  :  Str20;
                  Mode   :  Integer)  :  Boolean;
Begin { GetStock }
  Result := Global_GetMainRec (StockF, Want);
End; { GetStock }

Function GetJobMisc(AOWner :  TComponent;
                    Want   :  Str20;
                Var Found  :  Str20;
                    JAMode,
                    Mode   :  Integer)  :  Boolean;
Begin { GetJobMisc }
  Result := True;
End; { GetJobMisc }

end.
