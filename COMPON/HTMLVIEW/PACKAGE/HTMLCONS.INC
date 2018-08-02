{Version 8.04}

{$A+,B-,F-,G+,I+,P+,T-,V+,X+,R-}

{$ifdef Win32}
  {$J+}  {typed constants are modifiable}
  {$H+}  {LongStrings On}
{$endif}

{$ifndef DebugIt}
  {$W-}  {Stack frames off}
  {$Q-}  {overflow checking off}
  {$S-}  {stack checking off}
  {$C-}  {Assertions off}
  {$ifdef Win32}
    {$O+}  {optimization on}
  {$endif}
{$else}
  {$W+}  {Stack frames on}
  {$Q+}  {overflow checking on}
  {$S+}  {stack checking on}
  {$C+}  {Assertions on}
  {$ifdef Win32}
    {$O-}  {optimization off}
  {$endif}
{$endif}

{$Define ver100_plus}
{$Define ver120_plus}

{$ifdef ver90}     {Delphi 2}
{$UnDef ver100_plus}
{$UnDef ver120_plus}
{$endif}

{$ifdef ver93}     {C++Builder 1}
{$Define CppBuilder}
{$UnDef ver100_plus}
{$UnDef ver120_plus}
{$endif}

{$ifdef ver100}   {Delphi 3}
{$UnDef ver120_plus}
{$endif}

{$ifdef ver110}    {C++Builder 3}
{$ObjExportAll On}
{$Define CppBuilder}
{$UnDef ver120_plus}
{$endif}

{$ifdef Ver120}   {Delphi 4}
{$endif}

{$ifdef ver125}    {C++Builder 4}
{$ObjExportAll On}
{$Define CppBuilder}
{$endif}

{$ifdef Ver130}   {Delphi 5, C++Builder 5}
  {$ifdef BCB}   {C++Builder}
    {$Define CppBuilder}
    {$ObjExportAll On}
  {$endif}
{$endif}

{.$Define HtmlUseDLL} {To use the graphics DLL, define "UseDLL" by removing the '.'.
           Then do a Build All.

           Using the graphics DLL will add PNG image capability and JPEG
           capability for Delphi 1 and 2.  Jpeg capability is provided in the
           other Delphi versions without using the DLL.}

{.$Define NoGIF} {To eliminate GIF image capability, define "NoGIF" by
           removing the '.'.}

{Note:  Starting with V 7.2, the NoDLL option no longer exists.  By default,
 the graphics DLL is not used.

{Note:  The NoUnderline and PrintTableBackground compiler options are now options
 set in the htOptions and fvOptions properties. }

