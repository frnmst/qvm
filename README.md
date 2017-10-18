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

- You need a 64 bit machine with virtualization technology and more than 4 GB 
  of RAM.

- Modify `configvmrc` based on your needs.
  Variables are self-explanatory and I have kept mine 
  as an example.

- Install the following dependencies
  - [GNU Bash](http://www.gnu.org/software/bash/bash.html)
    - Scipting language interpreter
  - [GNU Core Utilities](https://www.gnu.org/software/coreutils/)
    - Basic software like `ls`, `cat`, etc...
  - [QEMU](https://www.qemu.org/)
    - The machine emulator
  - [TigerVNC](http://www.tigervnc.org)
    - If you need to use the vm remotely from a coumputer which does not 
      support virtualization.

- Create a new VHD and complete the OS installation:

        $ ./qvm -c
        $ ./qvm -i

- Optionally enable the SSH daemon on the guest machine.

- Optionally create a new backup VHD:

        $ ./qvm -b

- Now you can run the virtual machine either using the original or the backup 
  VHD. By deault if you run `./qvm` the virtual machine will run in graphics 
  mode using the backup hard disk.

- Optionally add the following in the gues machine's `/etc/fstab`, to enable 
  the shared directory automatically (no mount commands of any
  sort).

        host_share   /home/vm/shared    9p      noauto,x-systemd.automount,trans=virtio,version=9p2000.L   0 0

## VNC options

The VNC options in this script allow you to connect 

To do this you must run QVM with one of the VNC option on the server side.
On the client side you simply edit the `host_ip_address` and `host_username` 
variables configuration file.

For example, on the server side we could install the virtual machine remotely 
like this:

    $ ./qvm --install-vnc

And on the client side:

    $ ./qvm -r


## Help

    Usage: qvm [OPTION]
    Trivial management of 64 bit virtual machines with qemu.

    Options:
        -a, --attach                connect via SSH
        -b, --backup                backup vhd
        -c, --create                create new vhd
        -d, --delete                delete vhd backup
            --delete-orig           delete original vhd
        -h, --help                  print this help
        -i, --install               install img on vhd
            --install-vnc           install img on vhd via vnc
        -n, --run-nox               run vm without opening a graphical window
                                    (useful for background jobs like SSH)
            --run-nox-orig          run-orig and run-nox combined
        -s, --mkdir-shared          create shared directory
        -r, --remote                connect to a vnc instance via ssh
        -x, --run                   run vm
            --run-vnc               run vm with vnc
            --run-orig              run from original vhd
            --run-orig-vnc          run from original vhd with vnc


    Only a single option is accepted.
    By default, the backup vhd is run.

    CC0
    Written in 2016 by Franco Masotti/frnmst <franco.masotti@student.unife.it>

## License

CC0.
