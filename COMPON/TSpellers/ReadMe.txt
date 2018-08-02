
++ SPELL CHECK DICTIONARIES ++

    * Speller uses ISpell dictionaries installed with "ISpell - LS-Distribution". You find it on my web site under
      ISpell http://www.luziusschneider.com/Speller/English/index.htm



++ INSTALLATION ++

Unzip TSpellers.zip and move the folder TSpellers to a convenient location (e.g. C:\Program Files\Borland\Delphi6\ThirdParty\TSpellers)

Install Components:

    * Use "Tools\Environment Options\Library" and add the path to the TSpellers - directory to your library path.
    * Use "File\Open..." menu item of Delphi IDE to open the runtime package SpellersRT_6.dpk (for Delphi 6, otherwise open .._5.dpk or .._7.dpk). In "Package..." window click "Compile" button.
    * After compiling the run-time package, you must install the design-time packages into the IDE. Use "File\Open..." menu item to open the design-time package SpellersD_6.dpk (for Delphi 6, otherwise open .._5.dpk or .._7.dpk). In "Package..." window click "Compile" button to compile the package and then click "Install" button to register the Speller components.
    * You will find two new components TSpellChecker and TSpellLanguageComboBox on the component palette.

Install help file:

    * Start Delphi. From the main menu choose Help | Customize... The Delphi OpenHelp tool starts and opens the configuration file of Delphi's online help.
    * Select the Index tab. Choose Edit | Add Files..., then locate and open SPELLEREN.HLP. You find it under ...\TSpellers\Help. This will merge the keywords in SPELLEREN.HLP with the keyword index of Delphi's online help.
    * Select the Link tab. Choose Edit | Add Files..., then locate and open again SPELLEREN.HLP. This will enable context sensitive help for the component.
    * Choose File | Save Project, then close the window.


++ LICENCE ++

    * This software is Freeware. You may use Speller free of charge, you may copy or even publish it.
    * If you have any problems with Speller, any proposals or notes, please let me know.
      If you change the source code to improve it or to add more capabilities, send me a copy for possible publication. I would be very interested in a development, where more spell engines could be used.
    * You may join a mailing list on my web site to get current information about new versions.
    * This software is provided as is without warranty of any kind, either express or implied. In no event shall Luzius Schneider (the author) be liable for any damages whatsoever including direct, indirect, incidental, consequential, loss of business profits or special damages.
    * TSpellChecker is based on a Delphi 3.0 component “TSpellChecker” by Alexander Obukhov. For details, see the respective text files, which are included with this software.


++ ++ ++  ++  ++  ++  ++
Luzius Schneider
Kruggasse 70
CH-5462 Siglistorf
SWITZERLANDSWITZERLAND
E-Mail:  LS@luziusschneider.com
Homepage:  http://www.luziusschneider.com 