unit WizdMsg;

interface

Uses Messages;

Const
  WM_UpdateMode = WM_USER + 1;
  WM_RestartChecks = WM_USER + 2;

type
  TAutoRunMode = (amNull=0,
                  amPreReqs=1,        // Pre-Requisites
                  amOptions=2,        // Demo/Install/Upgrade
                  amInstall=3,        // Install LITE
                  amDownload=4,       // Download Licence
                  amUpgrade=5,        // Upgrade LITE - Find Directory
                  amDisplayDets=6,    // Display licence details before installing/upgrading
                  amPervWarning=7,    // Warn user that pre-existing Pervasive Components are present
                  amBtr615Warning=8,  // Warn user about Btrieve 6.15 and offer Pre-Installer
                  amChecklist=9,      // Pre-installation Check List

                  amManual1=21,       // Manual Licence Entry - Codes (1 of 3)
                  amManual2=22,       // Manual Licence Entry - Company Name & Licence Type (2 of 3)
                  amManual3=23,       // Manual Licence Entry - Counts & Database (3 of 3)

                  amInstallPerv=31,   // Install Pervasive.SQL Workgroup Engine
                  amInstallXML=32,    // Install Microsoft XML Core Services 4.0 SP2
                  amInstallLic=33,    // Install IRIS Licencing
                  amInstallBtr615=34, // Install Btrieve 6.15

                  amOSError=91        // Unsupported OS
                 );

implementation

end.
