# Project BioniDKU
Orignially an attempt to resurrect the original [AutoIDKU](https://github.com/sunryze-git/AutoIDKU/tree/8f12315e667a36eb18f412eae669a86e6aeccc70) script, now evolved into a whole new project. 

![BioniDKU version 300_update1 Desktop](https://github.com/Bionic-OSE/BioniDKU/assets/44027930/6e8abc83-a422-47c6-9d06-839fc35cfd15)

## What has changed?

### COSMETIC
- A stunning new and high-res [wallpaper](https://www.reddit.com/r/Genshin_Impact/comments/sk74fe/chinju_forest_inazuma_viewpoint_art/).
- **A SLEW** of new music, expanding from the original 12 songs library to over 60 songs (as of May 2023), divided into 5 different albums.
- A nicer script interface, now even more colorful and more distinguishable.

### MECHANISM
- A **main menu** upon first run, for customizing functions and features to your desire.
- A highly flexible customization system with detailed and easy-to-understand descriptions & instructions. 
- Detailed descriptions and contexts also follows throughout the whole script, so you don't get lost on what it's doing.
- The rule of automation: anything that has to be done manually must be done first, and so here they are, reordered to be after Windows Update mode.
- Speaking of MODES... We now have **dedicated modes** to effectively handle certain tasks: **Download mode** to get all dependencies and setup files required before the actual work begins, and **Windows Update mode** to help the system focus on getting the update done with the most system resources available.
### UNDER THE HOOD
- **A completely redesigned script structure,** allowing more customizabilty, with an unparalleled stability.
- More **environment variables** are used instead of fixed paths *(`$env:SYSTEMDRIVE` instead of `C:` for instance)*, for an unmatched flexibility.
- Batch-based launcher: Allows the script to be self-manageable with the ability to **self-restart**
- **Nana-chan**: The bootloader that gets run after executing the launcher, ensuring critical dependencies are available and sets up the environment on first run.
- **Hikaru-chan** (in-script edition): Allows the script to have full control over the Windows startup process. She is able to **self-resume** the script even before Explorer starts, thus gaining the script the ability to **break through startup obstacles** (such as "Let's finish setting up your device" on version 1903+).
- A completely new hand-crafted music player, using the power of [FFPlay](https://ffmpeg.org/ffplay.html#Description).
- A **SLEW** of new modules, some to fight back Windows annoyances, some to adapt the script to each unique Windows build range, and some to improve your experience. 
- Deeper modification to Windows system files for the best synchronization, leaving zero differences between builds as a result.
### POST-SETUP EXPERIENCE
- [**Hikaru-chan**](https://github.com/Bionic-OSE/BioniDKU-hikaru) (real edition), a series of powerful scripts and tools (that gets installed after running the script), is here to play. Not only she controls the startup process, but provides useful utilities such as the **Quick Menu** and **Administrative Menu** *(accessible via keyboard shortcut or system tray)*. This gives both the host and contestants fast access to useful options, like restarting Explorer (both Menus), or configure lockdown options (Administrative Menu only). 

## Windows Build support status
All <ins>G</ins>eneral <ins>A</ins>vailability (GA) builds of Windows 10 from **10.0.10240** to **10.0.19045** are fully supported. Support for Windows Server (with Desktop experience) builds are currently experimental.

|   OS Build   |      Version      | Overall eligibility |
| ------------ | ----------------- | ------------------- |
| 10176-       |                   | Not supported       |
| 10240        | 1507 (RTM)        | Fully supported     |
| 10586        | 1511 (NU)         | Fully supported     |
| 14393        | 1607 (AU)         | Fully supported     |
| 15063        | 1703 (CU)         | Fully supported     |
| 16299        | 1709 (FCU)        | Fully supported     |
| 17134        | 1803              | Fully supported     |
| 17763        | 1809              | Fully supported     |
| 18362/18363  | 1903/1909         | Fully supported     |
| 19041→19045  | 2004→22H2         | Fully supported     |
| 19536→21390  | Post-2004 non-GA  | Part. supported     |
| 10240→19045  | 1507→22H2 non-GA  | Part. supported     |
| 14393→20348  | Server 2016→2022  | Experimental        |
| 21996+       |                   | Not supported       |

## Are there anything you should be aware of?
Yes. There are things that must be done first to how "dangerous" this script is to Windows.

### BEFORE YOU EXECUTE THE SCRIPT
**1. Microsoft/Windows Defender MUST be disabled before you hit the Yes button on the confirmation prompt** (it will also notice you about this once again). **I have included a tool do to that:**
- Go to [this link](https://cutt.ly/BioniDKU-extras) and download the **BioniDKU_AddtFile_dControl.zip** file.
- On your target system, in Defender settings turn off Real time protection (and Tamper protection too if it's there).
- Now open the zip file and run **dControl.exe** inside it (no other programs or extraction needed, just double clicking and click "Run" when it asks if you want to better extract it). Password is: `sordum`
- Click **Disable Defender** and restart the PC. You can now proceed.

**2. A reliable internet connection is required.** If you're on a metered connection, a 1GB plan should work if you don't plan to run Windows Updates on the target system (about more than 400MB will be downloaded in total). Work on offline-running support will come in future releases, so stay tuned!

**3. The ability to read English.**

## About the definition of "IDKU" and the backstory
[Click here to read them](https://github.com/Bionic-OSE/BioniDKU/blob/main/YEETME.md)

## Credits
- [Sunryze](https://github.com/sunryze-git), the original author of AutoIDKU.
- [Julia](https://www.youtube.com/channel/UC6D_Ee3rLteOhGe-qD0Ku3A) for generously lending me one of her PCs over Parsec for back-to-back testings.
- [Zach](https://zachstechplace.carrd.co) for also actively running back-to-back tests and give me feedbacks as I progress through the betas.
- And everyone who supported this project!
