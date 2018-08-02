unit PerfUtil;

interface

// Returns number of processor clock cycles, e.g. on a 2Ghz processor there will be 2,000,000,000 cycles/second
//
// NOTE: On Dual-Core processors it is possible that Windows will switch your code from one processor to another
// whilst it runs.  As each processor is liable to have a different number of elapsed clock cycles due to power
// saving changes to the processor speed this may result in negative or very large timings being returned intermittantly.
//
// See http://msdn2.microsoft.com/en-us/library/bb173458.aspx
//
function RDTSC: Int64; assembler;

implementation

// Returns number of processor clock cycles, e.g. on a 2Ghz processor there will be 2,000,000,000 cycles/second
//
// NOTE: On Dual-Core processors it is possible that Windows will switch your code from one processor to another
// whilst it runs.  As each processor is liable to have a different number of elapsed clock cycles due to power
// saving changes to the processor speed this may result in negative or very large timings being returned intermittantly.
//
// See http://msdn2.microsoft.com/en-us/library/bb173458.aspx
//
function RDTSC: Int64; assembler;
asm
  RDTSC  // result Int64 in EAX and EDX
end;


end.
