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
## Q2: Can I install ubuntu on a VM on a Mac to run KFuse?
* No, please use a native Ubuntu machine that supports KVM.

## Q3: In the E1 file, where we find instructions to execute the experiment it says something about ssh'ing a VM. What VM?
* In E1, we will use the script `bench_merger.s`h to launch the VM. For E2, E3, E4, E5, we use the script `launch_vm.sh` to launch VMs.

## Q4: We also noticed that in your instructions, you recommend downloading the root.ext4 and placing it on the fs folder. However, the launch_vm.sh tries to access root.ext4 from the root of the project and not from the fs folder. Should we move root.ext4 from fs to the root of the project?
* Yes. In E1, `bench_merger.sh` will copy the e1fs to project root. For E2, E3, E4, E5, the instructions (e.g. [1]) indicate that we need to copy rootfs to project root.
* [1] https://github.com/synercys/eurosys-kfuse-artifact/blob/main/experiment_docs/instructions/E2#L12
