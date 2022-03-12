# eurosys-kfuse-artifact
The repository is the artifact for the paper "Verified Programs Can Party: Optimizing Kernel Extensions via Post-Verification In-Kernel Merging" in EuroSys 2022.

# How to run?
* Step1: Download `vm` and `fs` from [Box](https://uofi.box.com/s/u4r3ka9jzaxcar2yi7flc6l7j13edoqv) or [Google Drive](https://drive.google.com/drive/u/2/folders/1T_CJdnbN0JdFMOqc9hndLXTN8rXDrODV?fbclid=IwAR3agN4m-b7InzfhoeA5OGgbc-AYHdX7V8fSWuVOLV37-Z-m5XpLrZXLddw). 
  * FAQ Q1 describes that how to download the artifact from Google Drive on your work station. 
* Step2: Follow the instructions in the directory `experiment_docs/instructions/` to run experiments E1 to E5.
* Step3: Check the results with the expected results in the directory `experiment_docs/expected_result`.

# Paper
* (TODO): Link

# Demo Video
https://user-images.githubusercontent.com/20109646/150867835-eaa54bc6-4566-47dc-b523-4e44ba550492.mp4

# FAQ
## Q1: How to download the artifact from Google Drive on your workstation
* [gdrive](https://github.com/prasmussen/gdrive) 
* Usage
  ```sh
  # Step1: Download the Linux binary of gdrive.
  # Step2: Follow the instructions in the repo to provide your verification code.
  # Step3: Download from CLI
  
  # Ex1: The address to download e1fs is as follows. https://drive.google.com/file/d/1x6O2TmfnezbdSDhy6zTOOd3fjTC3TY3C/view?usp=sharing
  ./gdrive download 1x6O2TmfnezbdSDhy6zTOOd3fjTC3TY3C
  ```
