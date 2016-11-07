# qvm

Trivial management of 64 bit virtual machines with qemu.

## What this script will do

It can handle:

- Virtual hard disk creation, backup and deletion.
- Basic network management: two ports are exposed to the host
  machine (but you can add as many as you want). One of these 
  two ports is SSH (so admin gets simpler).
- Connection via SSH.
- Shared directory between host and guest.
- Last, but not least, running the virtual machine with all
  these options.

## Setup information and usage

- You need a 64 bit machine.
- Modify `configvmrc` based on your needs.
  Variables are self-explanatory and I have kept mine 
  as an example.

        # pacman -S qemu
        $ . ./configvmrc
        $ mkdir -p "$shared_data_path"
        $ ./qvm -i
        $ ./qvm -b

- Now you can run the virtual machine:

        $ ./qvm -r

- On your guest machine add the following in `/etc/fstab`:

        host_share   /home/vm/shared    9p      trans=virtio,version=9p2000.L   0 0

This will enable the shared directory automatically (no mount commands of any 
sort).

## License

CC0.
