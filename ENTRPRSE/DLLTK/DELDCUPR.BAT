rem @echo off

Rem
Rem HM 07/01/99 - Modified to support building under NT4 and modified
Rem               deletion to delete RPPro3.
Rem

If not exist f:\compiled\dcu\*.dcu goto jumpA
  del f:\compiled\dcu\*.dcu > NUL

:jumpA
  If not exist f:\compiled\dcu440\*.dcu goto jump1
  del f:\compiled\dcu440\*.dcu > NUL

:jump1
  If not exist f:\compiled\comtk\dcu\*.dcu goto jump2
  del f:\compiled\comtk\dcu\*.dcu > NUL

:jump2
  If not exist f:\compiled\comtk440\dcu\*.dcu goto jump3
  del f:\compiled\comtk440\dcu\*.dcu > NUL

:jump3
