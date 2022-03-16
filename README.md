# eurosys-kfuse-artifact
The repository is the artifact for the paper "Verified Programs Can Party: Optimizing Kernel Extensions via Post-Verification In-Kernel Merging" in EuroSys 2022.

# How to run?
* Step0: Please read the FAQ section at first.
* Step1: Download `vm` and `fs` from [Box](https://uofi.box.com/s/u4r3ka9jzaxcar2yi7flc6l7j13edoqv) or [Google Drive](https://drive.google.com/drive/u/2/folders/1T_CJdnbN0JdFMOqc9hndLXTN8rXDrODV?fbclid=IwAR3agN4m-b7InzfhoeA5OGgbc-AYHdX7V8fSWuVOLV37-Z-m5XpLrZXLddw) (20GB for each file system images). 
  * FAQ Q1 describes that how to download the artifact from Google Drive on your work station. 
* Step2: Follow the instructions in the directory `experiment_docs/instructions/` to run experiments E1 to E5.
* Step3: Check the results with the expected results in the directory `experiment_docs/expected_result`.

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

## Q5: We also noticed that in launch_vm.sh there is an attempt to execute ./init.sh script. However, we did not find such script anywhere in your Github repo.
* The command will be executed inside the VM, so it will not in the GitHub repo. The `init.sh` is in VM (e1fs and rootfs).

## Q6: If you want to setup SSH config as I mentioned in E1, you can refer to the following instructions.
* Step1: Launch VM with e1fs.ext4 sudo ./scripts/qemu_kernel.sh vm/nokfuse-noretpoline-vm e1fs.ext4 /init.sh
* Step2: Copy your local public key to /root/.ssh/authorized_keys (In VM)
* Step3: Close the VM, and run bench_merger.sh (follow E1 instruction)

## Q7: For E3, I could only execute the experiment for $nfilter's value 0 and 20.
* I have recorded a video [1] to perform E3. Do you restart your VM when you run the next iteration? You can use (Ctrl + A) + X to terminate the VM.
* [1] https://illinois.zoom.us/rec/share/7UECx-u-V7VGkEvN3a2jO9gz4G8zgkM3c48u-tiWlopsI5MFdOGxLr6sg12X9Iva.BWm_3yzmZHgbPW58

