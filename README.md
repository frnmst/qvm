# qvm

Trivial management of 64 bit virtual machines with qemu.

# Table of contents

[](TOC)

- [qvm](#qvm)
- [Table of contents](#table-of-contents)
- [What this script will do](#what-this-script-will-do)
- [Setup information and usage](#setup-information-and-usage)
- [VNC options](#vnc-options)
- [Interesting applications](#interesting-applications)
    - [Virtual machine hard disk over a network protocol](#virtual-machine-hard-disk-over-a-network-protocol)
    - [Automatical remote startup](#automatical-remote-startup)
- [Help](#help)
    - [qvm.sh](#qvmsh)
    - [automatical_remote_startup.sh](#automatical_remote_startupsh)
- [License](#license)

[](TOC)

# What this script will do

It can handle:

- Virtual hard disk creation, backup and deletion.
- Basic network management: two ports are exposed to the host
  machine (but you can add as many as you want). One of these 
  two ports is SSH (so admin gets simpler).
- Connection via SSH.
- Shared directory between host and guest.
- Last, but not least, running the virtual machine with a
  combination of the previous options.

# Setup information and usage

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

- You can also access the virtual machine through SSH:

        $ ./qvm -a

  or, if you are working on another computer,

        $ ./qvm --attach-remote

# VNC options

The VNC options in this script allow you to connect to a remote instance of 
QEMU. This is particularly useful, for example, if your local machine 
processor does not support virtualization. The only thing to do is to make 
the server's port (`5900`) reachable from the clients.

You must then run QVM with one of the VNC options on the server side.
On the client side you must simply edit the `host_ip_address` and 
`host_username` variables in the configuration file.

For example, on the server side we could install the virtual machine remotely 
like this:

    $ ./qvm --install-vnc

And on the client side:

    $ ./qvm -r

At this point you should see your virtual machine running in a TigerVNC window.

Note: the VNC traffic goes through SSH TCP forwarding, so it is encrypted.

# Interesting applications

## Virtual machine hard disk over a network protocol

If you happen to use a form of network filesystem, such as 
[GlusterFS](http://docs.gluster.org/en/latest/),
you can keep the machine hard disk off the host and put it on another computer.
There might be a some form of lag depending on the hardware, protocol and 
network connections.

An example with GlusterFS might be:

    vhd_name="gluster+tcp://server-address/gluster-volume/"$img_name"."$vhd_type""

This will work provided that you install the QEMU GlusterFS block module 
package (if it's not already present in the QEMU package itself).

You should consult the QEMU's manual to learn about all possible compatible 
network filesystems.

## Automatic remote startup

To automatically start the virtual machine from a non-host computer you can
use the `automatic_remote_startup.sh` script. Make sure that both the local 
non-host and the remote host computer have a copy of the QVM repository with 
the variables correctly set in the `configrc` file.

This script will start the virtual machine if on the host computer no other
virtual machine is running. You can use either the VNC or the headless 
connection. Both of them require that SSH is configured correctly on the  
computers: the host must be reachable from the client via SSH.
This can be verified by using the `--attach-remote` option.

Once you have checked that everyting works, you can add a command alias in 
your shell configuration file (e.g: `~/.bashrc`), something like:

    alias vm='/home/user/scripts/qvm/automatic_remote_startup.sh'

# Help

## qvm.sh

    Usage: qvm [OPTION]
    Trivial management of 64 bit virtual machines with qemu.

    Options:
        -a, --attach                connect to SSH locally
            --attach-remote         connect to SSH remotely
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

## automatical_remote_startup.sh

    Usage: automatical_remote_startup.sh [OPTION]
    Start QEMU on a remote host computer and connect to it

    Options:
        -d, --default           start the vm in headless mode and connect to it
                                with SSH
        -h, --help              print this help
        -u, --use-vnc           start the vm in VNC mode and connect to it with the
                                VNC client


    Only a single option is accepted.
    By default, a headless connection will be initialized.
    Preconditions for this to work is to setup SSH correctly on both
    computers.

    CC0
    Written in 2018 by Franco Masotti/frnmst <franco.masotti@student.unife.it>

# License

Creative Commons Zero (CC0).
