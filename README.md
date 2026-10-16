# Old_PC_Maintenance-file
it is basics scaning bat script for improve proformace

What the batch file will do ?
Task	Purpose
Clean user and Windows temporary files	Free up some disk space
Empty Recycle Bin	Remove items permanently
Clean Windows Update download cache	Remove downloaded update files that Windows can recreate
Run Microsoft Defender scan	Check for malware
Run MRT	Launch Microsoft's Malicious Software Removal Tool, if available
Run SFC	Check and repair protected Windows system files
Run DISM	Check the Windows component store
Display results	Show what worked and what needs attention
The malware scan and system repairs can take a long time on an old PC. The script will not disable Windows Defender or delete personal documents.
Complete BAT file code
Create a file named Old_PC_Maintenance.bat and paste the following code into it.

Step 1: Prepare your PC
- Save your open work and close applications.
- Check the Recycle Bin first. The script empties it permanently.
- Keep your PC connected to power.
- Make sure you have enough free disk space for Windows repairs.
Step 2: Test the existing BAT file
1. Open Notepad.
2. Paste the BAT code I provided earlier.
3. Save it as Old_PC_Maintenance.bat.
4. Select Save as type → All files.
5. Right-click the file and select Run as administrator.
6. Follow the MRT prompts and let the scans and repairs finish.
Step 3: Check the results
When it finishes, check these items:
Check	Where to look
Maintenance log	PC_Maintenance_Log.txt beside the BAT file
Defender scan results	Windows Security → Virus & threat protection → Protection history
Windows system files	The SFC result in the log
Windows component health	The DISM result in the log
PC performance	Task Manager → Performance
Important: The existing script has a limitation: it logs command output, but it doesn't reliably summarize every scan's final status. A command finishing doesn't necessarily mean it succeeded.
My recommendation is to test a revised version that records each command's exit code and runs DISM before SFC. That would make it easier to identify problems before using it on your PC.
