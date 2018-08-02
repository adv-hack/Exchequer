rem @echo off

Rem
Rem HM 07/01/99 - Modified to support building under NT4 and modified
Rem               deletion to delete RPPro3.
Rem

If not exist e:\ent430d5\*.dcu goto jumpA
del e:\ent430d5\*.dcu > NUL

:jumpA
  If not exist e:\develop\entrprse\*.dcu goto jump1
  del e:\develop\entrprse\*.dcu > NUL

:jump1
  If not exist x:\entrprse\custom\*.dcu goto jump2
  del x:\entrprse\custom\*.dcu > NUL

:jump2
  If not exist x:\entrprse\custom\dummy\*.dcu goto jump3
  del x:\entrprse\custom\dummy\*.dcu > NUL

:jump3
  If not exist x:\entrprse\custom\vathook\*.dcu goto jump4
  del x:\entrprse\custom\vathook\*.dcu > NUL

:jump4
  If not exist x:\entrprse\formdes2\*.dcu goto jump5
  del x:\entrprse\formdes2\*.dcu > NUL

:jump5
  If not exist x:\entrprse\multcomp\*.dcu goto jump6
  del x:\entrprse\multcomp\*.dcu > NUL

:jump6
  If not exist x:\entrprse\ole\*.dcu goto jump7
  del x:\entrprse\ole\*.dcu > NUL

:jump7
  cd "\entrprse\r&d"
  If not exist *.dcu goto jump8
  del *.dcu > NUL

:jump8
  rem return to correct directory
  cd \entrprse\formdes2
  
  If not exist x:\entrprse\repwrt\*.dcu goto jump9
  del x:\entrprse\repwrt\*.dcu > NUL

:jump9
  If not exist x:\entrprse\register\*.dcu goto jump10
  del x:\entrprse\register\*.dcu > NUL

:jump10
  If not exist x:\sbslib\win\win32\*.dcu goto jump11
  del x:\sbslib\win\win32\*.dcu > NUL

:jump11
  If not exist x:\sbslib\win\win32\rprint3\D2\*.dcu goto jump12
  del x:\sbslib\win\win32\rprint3\D2\*.dcu > NUL

:jump12
  If not exist x:\sbslib\win\excommon\*.dcu goto jump13
  del x:\sbslib\win\excommon\*.dcu > NUL
               
:jump13
  If not exist f:\compiled\dcu\*.dcu goto jump14
  del f:\compiled\dcu\*.dcu > NUL
               
:jump14
  If not exist f:\compiled\dcu440\*.dcu goto jump15
  del f:\compiled\dcu440\*.dcu > NUL
               
:jump15
  If not exist f:\compiled\comtk\dcu\*.dcu goto jump16
  del f:\compiled\comtk\dcu\*.dcu > NUL
               
:jump16
  If not exist f:\compiled\comtk440\dcu\*.dcu goto jump17
  del f:\compiled\comtk440\dcu\*.dcu > NUL
               
:jump17
  If not exist m:\dev500\*.dcu goto jump18
  del m:\dev500\*.dcu > NUL
               
:jump18
  If not exist C:\Develop\Dev500\*.dcu goto jump19
  del C:\Develop\Dev500\*.dcu > NUL
               
:jump19
  If not exist C:\Develop\DCUs\*.dcu goto jump20
  del C:\Develop\DCUs\*.dcu > NUL
               
:jump20




