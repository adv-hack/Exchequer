unit CustWinU;

{ Abstract Type definitions for Customisation }

{ WARNING: DO NOT CHANGE THE FOLLOWING DEFINITIONS, IF YOU CHANGE }
{          THE FOLLOWING DEFINITIONS, SYSTEM CRASHES AND DATA     }
{          CORRUPTION ARE LIKELY TO OCCUR.                        }

interface


{$H-}   { Huge Strings Off }


{ Window Constants (WinId) }
Const
  EnterpriseBase = 100000;
  MiscBase       =  90000;

  { Window Constants - duplicate COM Customisation constants }
  wiAccount      = EnterpriseBase + 1000;
  wiTransaction  = EnterpriseBase + 2000;
  wiBACS         = EnterpriseBase + 2050;
  wiStock        = EnterpriseBase + 3000;
  wiStockDetail  = EnterpriseBase + 3001;
  wiSerialBatch  = EnterpriseBase + 3100;
  wiTransLine    = EnterpriseBase + 4000;
  wiJobRec       = EnterpriseBase + 5000;
  wiLocation     = EnterpriseBase + 6000;
  wiStockLoc     = EnterpriseBase + 7000;
  wiMisc         = EnterpriseBase + MiscBase;
  wiSystemOps    = EnterpriseBase + MiscBase + 2;
  wiPrint        = EnterpriseBase + MiscBase + 3;


implementation

end.
