
Debugging
=========
For the Debug build, the conditional compilation symbol "DEBUG" is defined and a logging form is 
created, to which debug messages may be output.
Example:
      dbgForm.Log("Your message here");

In addition to this, if the conditional compilation symbol "TDEBUG" (for Trace DEBUG) is defined, 
trace messages showing entry and exit of various methods are sent to the logging form.


