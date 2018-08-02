Unit History;

Interface

Const
  // U2LENTRP.DLL - Crystal U2L version
  CurrVersion_U2L =   'v9.2.335' {'v6.00.334'};

  // ENTFUNCS.DLL - ODBC Functions DLL version
  CurrVersion_ODLL =  'v9.2.337' {'v6.8.336'};

Implementation

(***

Module      Version      Date
==========+============+========================================================
EntFuncs    v9.2.337    09/08/2016
U2LEntRp    v9.2.335    09/08/2016
--------------------------------------------------------------------------------
  PL   ABSEXCH-16676 added EntSuppTeleValue for supplier

EntFuncs    v6.8.336    21/09/2011
--------------------------------------------------------------------------------
  CS   ABSEXCH-11858: Added support for saving combined Cost Centre + Department
       entry in EntSaveGLValue()

EntFuncs    v6.00.335    09/10/07
U2LEntRp    v6.00.334
--------------------------------------------------------------------------------
  HM   Rebuilt & updated version numbers


U2LEntrp    b550.332     18/02/03
--------------------------------------------------------------------------------
  HM   Extended GetNominalValue to support GL + Cost Centre + Department history
       for Minerva computers.


U2LEntrp    5.00.331     6/8/2002
--------------------------------------------------------------------------------
  PR   Added EntDefaultLogin function which was already in EntFuncs.


***)

End.
