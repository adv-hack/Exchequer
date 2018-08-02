{****************************************************************}
{ TWEBCOPY component                                             }
{ for Delphi 5.0,6.0,7.0,2005,2006 - C++Builder 5,6,2006         }
{ version 1.6                                                    }
{                                                                }
{ written by                                                     }
{   TMS Software                                                 }
{   copyright © 2000-2006                                        }
{   Email : info@tmssoftware.com                                 }
{   Web : http://www.tmssoftware.com                             }
{****************************************************************}
unit webcreg;

interface
                    
uses
  WebCopy, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Web',[TWebCopy]);
end;

end.

