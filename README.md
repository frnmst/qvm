# qvm

Trivial management of 64 bit virtual machines with qemu.

## Table of contents

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

### Actions and parameters

You can make some combinations between actions and places. Both of these 
elements are parameters.

#### Actions

- attach
- backup
- create
- delete
- install
- mkdir-shared
- run

#### Places

- nox
- origin
- remote
- vnc

### Setup

- Create a new virtual hard disk and complete the OS installation which 
  can also be done via SSH.

        $ ./qvm --create && ./qvm --install

- Optionally enable the SSH daemon on the guest machine.
- Optionally create a new backup VHD:

        $ ./qvm --backup

- Now you can run the virtual machine either using the original or the backup 
  virtual hard disk. If you run `./qvm -x` the virtual machine will run in 
  graphics mode using the backup hard disk.
- Optionally add the following in the guest machine fstab file (`/etc/fstab`), 
  to enable the shared directory automatically. This avoids entering mount 
  commands by hand.

        host_share  /home/vm/shared  9p  noauto,x-systemd.automount,trans=virtio,version=9p2000.L  0  0

## Connection to the machine

- You can also access the virtual machine through SSH:

        $ ./qvm --attach

  or, if you are working on another computer,

        $ ./qvm --attach --remote

## VNC options

The VNC options in this script allow you to connect to a remote instance of 
QEMU. This is particularly useful, for example, if your local machine 
processor does not support virtualization. The only thing to do is to make 
the server's port (`5900`) reachable from the clients.

You must then run QVM with one of the VNC options on the server side.
On the client side you must simply edit the `HOST_IP_ADDRESS` and 
`HOST_USERNAME` variables in the configuration file.

For this to work, you must enable the following lines in the SSH daemon
configuration of the host computer:

    AllowTcpForwarding yes
    AllowAgentForwarding yes

For example, on the server side you could install the virtual machine remotely 
like this:

    $ ./qvm --install --vnc

And on the client side:

    $ ./qvm --attach --remote --vnc

At this point you should see your virtual machine running in a TigerVNC window.

Note: the VNC traffic goes through SSH TCP forwarding, so it is encrypted.

## Automatic remote startup

# FIXME 

To automatically start the virtual machine from a non-host computer you can
use the `--remote` option. Make sure that both the local 
(non-host) and the remote host computer have a copy of the QVM repository with 
the variables correctly set in the `configrc` file.

This script will start the virtual machine if on the host computer no other
virtual machine is running. You can use either a VNC or headless 
connection. Both of them require that SSH is configured correctly on the  
computers, i.e. the host must be reachable from the client via SSH.
This can be verified by using the `--attach --remote` options while the
virtual machine is already running.

Once you have checked that everyting works, you can add a command alias in 
your shell configuration file (e.g: `~/.bashrc`), something like:

    alias vm='/home/user/scripts/qvm/qvm --run --remote --vnc'

or, if you don't need VNC:

    alias vm='/home/user/scripts/qvm/qvm --run --remote'

## Interesting applications

### Virtual machine hard disk over a network protocol

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

## Help

FIXME

## License

Creative Commons Zero (CC0).
