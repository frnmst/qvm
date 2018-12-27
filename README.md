# qvm

Trivial management of 64 bit virtual machines with qemu.

## Table of contents

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

## What this script will do

It can handle:

- Virtual hard disk creation, backup and deletion.
- Basic network management: three ports are exposed to the host
  machine (but you can add as many as you want). One of these two ports is 
  SSH.
- Shared directory between host and guest.
- Running the virtual machine with a combination of the previous options.

## Setup information and usage

### Prerequisites

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

### Setup

- Create a new virtual hard disk and complete the OS installation which 
  can also be done via SSH.

        $ ./qvm -c
        $ ./qvm -i

- Optionally enable the SSH daemon on the guest machine.
- Optionally create a new backup VHD:

        $ ./qvm -b

- Now you can run the virtual machine either using the original or the backup 
  virtual hard disk. If you run `./qvm -x` the virtual machine will run in 
  graphics mode using the backup hard disk.
- Optionally add the following in the guest machine fstab file (`/etc/fstab`), 
  to enable the shared directory automatically. This avoids entering mount 
  commands by hand.

        host_share  /home/vm/shared  9p  noauto,x-systemd.automount,trans=virtio,version=9p2000.L  0  0

- You can also access the virtual machine through SSH:

        $ ./qvm -a

  or, if you are working on another computer,

        $ ./qvm --attach-remote

## VNC options

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

    VHD_NAME="gluster+tcp://server-address/gluster-volume/"${IMG_NAME}"."${VHD_TYPE}""

This will work provided that you install the QEMU GlusterFS block module 
package (if it's not already present in the QEMU package itself).

You should consult the QEMU's manual to learn about all possible compatible 
network filesystems.

### Automatic remote startup

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

## Help

### qvm

FIXME

### automatic_remote_startup.sh

FIXME

## License

Creative Commons Zero (CC0).
