# Project BioniDKU
Orignially an attempt to resurrect the original [AutoIDKU](https://github.com/sunryze-git/AutoIDKU) script, now evolved into a whole new project.

## The backstory
Back in October 2022, I was making an IDKU for a friend, long after the original script broke down as its repository, where it downloads required files, was emptied. As I was in desperate need of a working script and had a local copy of [this commit](https://github.com/sunryze-git/AutoIDKU/tree/8f12315e667a36eb18f412eae669a86e6aeccc70), I decided to pull it out and began resurrecting it, first by rerouting all calls to the empty repository back to local files, then rearranged the subsidary script files (which I then called "modules") in a way so they're reachable by the main script. And I was surprised when it worked like magic (well of course, with problems). So I showed my friends - or I should call the *IDKU gangs* - the working script. They were surprised too, and asked if I could refine it further, and I was like "sure". So the first few versions of this script was bascially just me trying to get it fully working and fixing things. 

But fixing the script alone just isn't my style, so I began to bring my ideas into the script, and this is where things started to flourish.

At the beginning, changes were mostly cosmetic (like swapping the wallpaper, renaming the music library, the new name **BioniDKU** (<ins>Bioni</ins>c AutoI<ins>DKU</ins>), and so on). But eventually I started to understand the architecture of the script as I read through it several times, and then some life-changing changes would start to appear. I saw the current problem with the orignal script was it wasn't fully automated: there were still manually-required actions every so often during execution, script couldn't restart itself, and more actions still need to be taken post-execution. I then split the current work from a folder in a VM into a seperate project, took all my experiences learned from past experiments and began implemeting them into the script, aiming to get it as fully automated as possible. In doing so, I also added some useful programs, for example PENetwork Manager to replace the broken network icon; bumped the music library with a slew of songs; made the script's interface more colorful and more easily distinguishable between script's messages and PowerShell's system messages; and finally did an overhaul on the script's folder structe. And finally on the 4th of December 2022, the whole project landed on GitHub after weeks being on OneDrive. 

And I couldn't get everything here without some help from those friends. They have been running back-to-back tests on all versions of Windows 10 and gave me reports as I was leading up to the first re-debut of the project. Without them, it could have took me months to get everything done instead of 2 weeks!

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

## Credits
- [Sunryze](https://github.com/sunryze-git), the original author of AutoIDKU.
- [Julia](https://www.youtube.com/channel/UC6D_Ee3rLteOhGe-qD0Ku3A) for generously lending me her main PC over Parsec for back-to-back testings
- [Zach](https://zachstechplace.carrd.co) for also actively running back-to-back tests and give me feedbacks as I progress through the betas
- And everyone who supported this project!
