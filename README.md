# Project BioniDKU
**The one-and-only powerful and flexible PowerShell script bundle** that converts your Windows 10 installation to an **IDKU**.

![BioniDKU version 400_stable Main menu](https://github.com/Bionic-OSE/BioniDKU/assets/44027930/2c4d046d-d2f4-487f-b642-fe46dd512180)

![BioniDKU version 400_update1 Desktop](https://github.com/Bionic-OSE/BioniDKU/assets/44027930/8888b55a-c0bf-422d-814b-3d46941e5ac2)

## What is this project about exactly? 
Head over to the [**Wiki section**](https://github.com/Bionic-OSE/BioniDKU/wiki) to learn more about this! 

## Compatibility
![BioniDKU compatibility sheet](https://github.com/Bionic-OSE/BioniDKU/assets/44027930/b25a4d99-6c4c-4b3f-ad20-ea9f43327f9c)
<sup><sub>**(*)** The incompatibility in this edition is actually a currently known issue in the script and not a limitation. Once it has been addressed it will be just as functional as other editions.</sub></sup>

## *"I know what this is now."* Good, but before you launch this program...
There are things that must be done first to how "dangerous" this script is to Windows.

**1. Microsoft/Windows Defender MUST be disabled before you hit the Yes button on the confirmation prompt** (the script itself will also notice you about this once again if you forgot).
- **Why is this?** BioniDKU itself is by all means not a malware. However some tools used to make it possible are often false flagged by AVs because of "signature" problems. Particularly this comes from the launcher executable file and several other components (that will be downloaded along the way) that are made made using **BatToExe**. If any of you have a flaggable-free appoarch for these batch-coverted EXEs please let me know. 
- If you are doing this on Windows Server, skip the rest of the steps below, run `dism /online /disable-feature /featurename:Windows-Defender` and restart the device.
- To effectively disable Defender, go to [this link](https://zgc6v-my.sharepoint.com/:f:/g/personal/oseproductions_zgc6v_onmicrosoft_com/EmNJMTmNbrlEpsDCO6HqBv0BtIUaJ9n7IOSx9IhZVLvBTg) and download the **dControl.zip** file (Or you can get one from the internet making sure it isn't a malware). 
- On your target system, in Defender settings turn off Real time protection (and Tamper protection too if it's there).
- Now open the zip file and run **dControl.exe** inside it (no other programs or extraction needed, just double clicking and click "Run" when it asks if you want to better extract it). Password is: `sordum`
- Click **Disable Defender**, restart the device and then you can proceed. 
- Another way for the last step is if you encounter the *"Starting the script is not allowed"* message because you forgot to do this, after clicking disable, just hit Enter with nothing typed in the prompt to refresh the status. The script should then allow you to start and since it will restart the system shortly after, you get 2 problems solved at once! 

**2. A reliable internet connection is required.** If you're on a metered connection, a 1GB plan should work if you don't plan to run Windows Updates on the target system (about more than 400MB will be downloaded in total). You can go offline as soon as the script enters the 3rd phase. 

## Extras
### It's not just this repository
This script is backed by **3 additional repositories**, the products of which are then downloaded to assemble the full experience (which is why internet is required).
- [**BioniDKU Utilities**](https://github.com/Bionic-OSE/BioniDKU-utils): The "other-half" of the script bundle itself, consisting of assets and software that are needed during runtime.
- [**BioniDKU Hikaru-chan**](https://github.com/Bionic-OSE/BioniDKU-hikaru): A **crucial** separate software package that takes control over Windows after the script finishes and provides utilities to both the challenge contestant (the one using the IDKU) and the challenge host (the one set the IDKU up).
- [**BioniDKU Music**](https://github.com/Bionic-OSE/BioniDKU-music): As the name suggests, this is where the music that (optionally) plays during runtime are downloaded from, packed in split 7-Zip archives. As most of these are YouTube downloads I do NOT own nor have rights to any of the songs included. Please give credits to all the awesome artists/original sources of those as their names scroll through the music player. 

### Wanna go back in time?
- If you still want to try the older, *GitHub original* [PowerShell 5/7 Hybrid release](https://github.com/Bionic-OSE/BioniDKU/releases/tag/200_u3) from **version 200 series**, it is still available and has been updated to work with recent repository-side changes.

## Credits
- [Sunryze](https://github.com/sunryze-git/AutoIDKU/tree/8f12315e667a36eb18f412eae669a86e6aeccc70), the original author of AutoIDKU.
- Free (and open source) software that are bundled during script runtime & Visual assets featured and included: You can view these through option 4 (*Show credits*) on the main menu. 
- Everyone who conducted testing and supported this project!
