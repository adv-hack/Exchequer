unit E365UtilIntf;

interface

// This function creates an empty memory map.
//
// The following return values are expected:-
//   0    Success.
//   1    Unknown Exception - call LastErrorString for details.
//
Function CreateMemoryMap : LongInt; StdCall; External 'E365Util.dll';

// This function destroys the memory map.
//
// The following return values are expected:-
//
//   0   Success.
//   1   Unknown Exception - call LastErrorString for details.
//
Function DestroyMemoryMap : LongInt; StdCall; External 'E365Util.dll';

// This function can be used with an existing memory map to clear down any details previously
// specified, this can be used when changing to a different spreadsheet requiring different
// login details.
//
// The following return values are expected:-
//
//   0   Success.
//   1   Unknown Exception - call LastErrorString for details.
//   2   Memory Map not created.
//
Function ClearMemoryMap : LongInt; StdCall; External 'E365Util.dll';

// This function adds the specified Company Code, User Id and Password into the Memory Map for
// use by the IRIS Exchequer OLE Server.  No validation on the details will be or can be provided
// other than to check for blank or too long Company Codes or User Id's.
//
// The details will be encrypted before they are added into the memory map to prevent it being
// a security loophole.
//
// A maximum of 1,000 sets of details will be supported.
//
// The following return values are expected:-
//
//   0   Success
//   1   Unknown Exception - call LastErrorString for details
//   2   Memory Map not created
//   3   Out of space - the memory map is full
//   4   Invalid Company Code
//   5   Invalid User Id
//   6   Invalid Password
//
// Note: Calling app is responsible for allocating and de-allocating the PCHAR parameters.
//
// Note: Using PANSIChar as PCHAR changes in Delphi 2009 to point to Unicode characters.
//
Function AddCompanyUser (Const CompanyCode, UserId, Password : PANSIChar) : LongInt; StdCall; External 'E365Util.dll';

// This function will return an error string for the last function call result, the calling
// routine is responsible for de-allocating the returned PChar.
//
// Note: Using PANSIChar as PCHAR changes in Delphi 2009 to point to Unicode characters.
//
Function LastErrorString : PANSIChar; StdCall; External 'E365Util.dll';

Implementation

end.
