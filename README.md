# BG3 VFX Helper

Simple tool to automate Baldur's Gate 3 custom head insertion into VFX files.

<img width="879" height="486" alt="obraz" src="https://github.com/user-attachments/assets/2f5c4a0a-3062-466a-8d5a-9005868657c5" />


### TODO
- Logging to file
- Logging from isolate
- (maybe) bloc-ify

### FAQ

*How to use it?*

Point it to the folder where you keep .lsx files. You can decompile them from [Patches to VFX Heads](https://www.nexusmods.com/baldursgate3/mods/353) mod. Enter in `vanilla UUID` the id of the head you custom is based on, and in the `custom UUID` enter your head UUID. Click save. Program will backup your data, and then it will enter new entry with `custom UUID` to files already containing `vanilla UUID` entries. Ta-da.

*Why architecture so bad?*

Because it's simple and bloc takes time. If there will be a need to expand this tool, bloc will happen.

[Xml icons created by IconMarketPK - Flaticon](https://www.flaticon.com/free-icons/xml)


