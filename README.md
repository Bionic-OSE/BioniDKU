# Project BioniDKU
Orignially an attempt to resurrect the original [AutoIDKU](https://github.com/sunryze-git/AutoIDKU) script, now evolved into a whole new project.

## What has changed?
### COSMETIC
- A stunning new and high-res wallpaper.
- **A SLEW** of new music, expanding from the current 12 songs library to 30 songs.
- A nicer script interface, now even more colorful and more distinguishable.
### MECHANISM
- By leveraging batch technology, the script is now self-manageable with 2 new capabilites: **self-restart** and **self-resume** after OS restart.
- It can also make checkpoints by utilizing registry values, so things that are done won't be repeated on restart/resume.
- Folder structure is entirely different from that of the original script.
- The rule of automation: anything that has to be done manually must be done first, and so here they are, reordered to be after the Windows Update part.
- An options-overview screen upon script startup, prompting user to check again and make changes if neccesary.
### UNDER THE HOOD and MODULES
- Hello PowerShell 7! Although it isn't that different from PowerShell 5.x, it solves the **NuGet** errors on Windows 10 version 1507 and enables **PSWindowsUpdate** to work on 1607. On version 1511 and older, PowerShell 5 is used as the main orchestrator with a seperate main script due to compatibility reasons, and PowerShell 7 is used for the **MusicPlayer**; where as on 1607 and newer, PowerShell 7 is used for everything.
- Several new modules have been introduced, some to adapt to the current state of Windows 10 versions, some to solve problems that was not possible before.
- And more that I can't cover all...

## Does the change come with anything you should be aware of?
Yes. There are things that should be taken care of now due to how "dangerous" this script is to Windows.

### BEFORE YOU EXECUTE THE SCRIPT
**1. Windows Defender MUST be disabled before you hit the OK button on the password prompt** (yes, there is a password). **I have included a tool do to that:**
- Go to [this link](https://cutt.ly/BioniDKU-extras) and download the **BioniDKU_AddtFile_dControl.zip** file.
- On your target system, in Defender settings turn off Real time protection (and Tamper protection too if it's there).
- Now open the zip file and run **dControl.exe** inside it (no other programs or extraction needed, just double clicking and click "Run" when it asks if you want to better extract it). Password is: `sordum`
- Click **Disable Defender** and restart the PC. You can now enter the password and proceed.

**2. The executable password is always** `BioniDKU`

## About the definition of "IDKU" and the backstory
[Click here to read them](https://github.com/Bionic-OSE/BioniDKU/blob/main/YEETME.md)

## Credits
- [Sunryze](https://github.com/sunryze-git), the original author of AutoIDKU.
- [Julia](https://www.youtube.com/channel/UC6D_Ee3rLteOhGe-qD0Ku3A) for generously lending me her main PC over Parsec for back-to-back testings
- [Zach](https://zachstechplace.carrd.co) for also actively running back-to-back tests and give me feedbacks as I progress through the betas
- And everyone who supported this project!
