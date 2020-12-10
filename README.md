# qvm

Trivial management of 64 bit virtual machines with qemu.

## Table of contents

<!--TOC-->

- [qvm](#qvm)
  - [Table of contents](#table-of-contents)
  - [Reasons](#reasons)
  - [Version](#version)
  - [What this script will do](#what-this-script-will-do)
  - [Prerequisites](#prerequisites)
  - [Dependencies](#dependencies)
  - [Installation](#installation)
    - [Arch Linux based distros](#arch-linux-based-distros)
  - [Help](#help)
  - [Setup information and usage](#setup-information-and-usage)
    - [Actions and parameters](#actions-and-parameters)
      - [Actions](#actions)
      - [Places](#places)
    - [Setup](#setup)
  - [Connection to the machine](#connection-to-the-machine)
  - [VNC options](#vnc-options)
    - [Setup](#setup-1)
    - [Examples](#examples)
      - [Installation](#installation-1)
      - [Maintenance](#maintenance)
  - [Automatic remote startup](#automatic-remote-startup)
  - [Interesting applications](#interesting-applications)
    - [Virtual machine hard disk over a network protocol](#virtual-machine-hard-disk-over-a-network-protocol)
  - [Bugs](#bugs)
  - [License](#license)
  - [Trusted source](#trusted-source)

<!--TOC-->

## Reasons

See https://frnmst.gitlab.io/notes/qemu-ssh-tunnel.html

## Version

See all [qvm releases](https://github.com/frnmst/qvm/releases).

## What this script will do

It can handle:

- Virtual hard disk creation, backup and deletion.
- Basic network management: three ports are exposed to the host
  machine (but you can add as many as you want). One of these two ports is
  SSH.
- Shared directory between host and guest.
- Running the virtual machine with a combination of the previous options.

## Prerequisites

- You need a 64 bit machine with virtualization technology and at least 4 GB
  of RAM.
- Modify `configvmrc` based on your needs.
  Variables are self-explanatory and I have kept mine
  as an example.

## Dependencies

You need to install the following packages and the ones listed for
[fbopt](https://github.com/frnmst/fbopt#dependencies)

| Package | Executable | Version command | Package version |
|---------|------------|-----------------|-----------------|
| [GNU Bash](https://www.gnu.org/software/bash/bash.html) | `/bin/bash` | `$ bash --version` | `GNU bash, version 5.0.16(1)-release` |
| [QEMU](https://www.qemu.org/) | `/bin/qemu-system-x86_64` | `$ qemu-system-x86_64 --version` | `QEMU emulator version 3.1.0` |
| [TigerVNC](http://www.tigervnc.org) | `/bin/vncviewer` | `$ vncviewer --help` | `TigerVNC Viewer 64-bit v1.9.0` |
| [OpenSSH](https://www.openssh.com/portable.html) | `/bin/ssh` | `$ ssh -V` | `OpenSSH_7.9p1, OpenSSL 1.1.1a  20 Nov 2018`
| [GNU Coreutils](https://www.gnu.org/software/coreutils/) | `/bin/mkdir`, `/bin/sleep`, `/bin/rm` | `$ ${Executable} --version` | `(GNU coreutils) 8.30` |

## Installation

### Arch Linux based distros

    # pacman -S coreutils openssh tigervnc qemu

## Help

```
Usage: qvm [OPTION]
Trivial management of 64 bit virtual machines with qemu.

Only a single option is accepted.
By default, the backup vhd is run.
Mandatory arguments to long options are mandatory for short options too.
Options:
    -a, --attach                connect via SSH
    -b, --backup                backup the vhd
    -c, --create                create a new vhd
    -d, --delete                delete the vhd backup
    -h, --help                  print this help
    -i, --install               install the image on a vhd
    -m, --mkdir-shared          create a shared directory
    -n, --nox                   run vm without graphical output
    -o, --orig                  run from the original vhd
    -r, --remote                connect to a remote instance of QVM
    -v, --vnc                   use VNC
    -x, --run                   run the vm

Exit status:
 0  if OK,
 1  if an error occurred.

CC0 License
Written in 2018 by Franco Masotti/frnmst <franco.masotti@live.com>
```

## Setup information and usage

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

1. Create a new virtual hard disk and complete the OS installation which
   can also be done via SSH.

         $ ./qvm --create && ./qvm --install

2. Optionally enable the SSH daemon on the guest machine.
3. Optionally create a new backup VHD:

         $ ./qvm --backup

4. Now you can run the virtual machine either using the original or the backup
   virtual hard disk. If you run `./qvm --run` the virtual machine will run in
   graphics mode using the backup hard disk.
5. Optionally add the following in the guest machine fstab file (`/etc/fstab`),
   to enable the shared directory automatically. This avoids entering mount
   commands by hand.

         host_share  /home/vm/shared  9p  noauto,x-systemd.automount,trans=virtio,version=9p2000.L  0  0

    Note: to be able to access the shared directory the user and group ids must
    be the same for the host and guest machines. If needed, change those ids within
    the guest machine:

      1. connect via VNC
      2. login as root
      3. run: ``# usermod -u ${new_user_id} "${user_name}" && groupmod -g ${new_group_id} "{group_name}"``
      4. run: ``# chown -R "${user_name}":"{group_name}" /home/"${user_name}"``
      5. reboot


## Connection to the machine

- You can also access the virtual machine through SSH:

        $ ./qvm --attach

  or, if you are working on another computer,

        $ ./qvm --attach --remote

## VNC options

The VNC options in this script allow you to connect to a remote instance of
QEMU. This is particularly useful if, for example, your local machine
does not support virtualization.

*Note: the VNC traffic goes through SSH TCP forwarding, so it is encrypted.*

### Setup

For this to work, you must add the following lines in the SSH daemon
configuration of the host computer:

    AllowTcpForwarding yes
    AllowAgentForwarding yes

### Examples

You must run QVM with one of the VNC options on the server side.
On the client side you must simply edit the `HOST_IP_ADDRESS` and
`HOST_USERNAME` variables in the configuration file.

#### Installation

To intall a virtual machine remotely, on the server side you must run:

    $ ./qvm --create && ./qvm --install --vnc

and on the client side:

    $ ./qvm --attach --remote --vnc

At this point you should see your virtual machine running in a TigerVNC window.
Once the installation is complete you can poweroff the machine and then run:

    $ ./qvm --run --vnc

on the server, and

    $ ./qvm --attach --remote --vnc

on the client.

#### Maintenance

You can use the installation method for maintenance as well, for example if the
machine is unbootable. Select the appropriate virtual hard disk for the
`VHD_NAME` variable in the configuration file and continue with
the installation instructions. You should find the hard disk (usually `/dev/sda`).

## Automatic remote startup

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

because `--remote` implies `--nox` by default. If you don't need VNC:

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

## Bugs

- If you want to use `--remote` and `--vnc` combined, you must first
  disable any `ControlMaster` and `ControlPath` options associated to the user
  and host in control of the virtual machine.
  These options can be found in the client's SSH configuration file which is
  usually `~/.ssh/config`.

## License

Creative Commons Zero (CC0).

## Trusted source

You can check the authenticity of new releases using my public key.

Instructions, sources and keys can be found at [frnmst.gitlab.io/software](https://frnmst.gitlab.io/software/)
