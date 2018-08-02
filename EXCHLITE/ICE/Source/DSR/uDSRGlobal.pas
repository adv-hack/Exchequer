{-----------------------------------------------------------------------------
 Unit Name: uDSRGlobal
 Author:    vmoura
 Purpose:
 History:

 hold the global variable to dsr threads
 THE DSR MUST CREATE IT AND DESTROY IT
 THE THREADS WILL ONLY GET ACCESS TO THIS VARIABLE

 the  uDSRLock override the TMultiReadExclusiveWriteSynchronizer because
 there is a bug in there causing deadlocks... 
-----------------------------------------------------------------------------}
unit uDSRGlobal;

interface
  uses Classes, uDSRLock;

var
  //fSchedule: TThreadList;
  fSchedule: TList;
  
  {fEmailLock,}  // look after email sending/receiving
  {fIMPLock,}    // look after importing sync
  fExpLock,    // look after exporting sync
  {fCompLock,} {multi company lock when user tries to create more than one company in one shot}
  fSync: TDSRSynchronizer; {normal lock to producer and sender}


//  fSync : TMultiReadExclusiveWriteSynchronizer;

implementation


end.
