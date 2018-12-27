#!/usr/bin/env bash

# qvm - Trivial management of 64 bit virtual machines with qemu.
#
# Written in 2018 by Franco Masotti/frnmst <franco.masotti@student.unife.it>
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the public
# domain worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

######################################################################
# NOTE: This script is intended to be used along with a shell alias. #
######################################################################

program_name="${0}"
local_path="${program_name%/automatic_remote_startup.sh}"

help()
{
    cat <<-EOF
Usage: automatic_remote_startup.sh [OPTION]
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
EOF
}

connect()
{
    local display="${1}"

    if [ -z "$(ssh -l "${HOST_USERNAME}" "${HOST_IP_ADDRESS}" "pgrep qemu")" ]; then
        if [ "${display}" = "use_vnc" ]; then
            ssh -p "${SSH_EXPOSED_PORT}" -l "${HOST_USERNAME}" "${HOST_IP_ADDRESS}" \
                "cd "${HOST_QVM_SCRIPT_DIRECTORY}" && ./qvm --run-vnc" &
        else
            ssh -p ${SSH_EXPOSED_PORT} -l "${HOST_USERNAME}" "${HOST_IP_ADDRESS}" \
                "cd "${HOST_QVM_SCRIPT_DIRECTORY}" && ./qvm -n" &
        fi
        sleep ${SECONDS_BEFORE_CONNECTION_ATTEMPT}
    fi

    if [ "${display}" = "use_vnc" ]; then
        "${local_path}"/qvm --remote &
    else
        "${local_path}"/qvm --attach-remote
    fi
}

check_dependencies()
{
    which \
        ssh
}

main()
{
    local argc="$1"
    local options="dhu"
    local long_options="default,help,use-vnc"
    local opts
    local opt

    [ -z "$argc" ] && argc="--default"

    opts="$(getopt --options $options --longoptions $long_options -- $argc)"

    [ $? -ne 0 ] && unrecognized_option && return 1

    eval set -- "$opts"

    # Source variables globally.
    . "${local_path}"/configvmrc

    for opt in $opts; do
        case "$opt" in
            -- )                                        ;;
            -h | --help )               help            ;;
            -u | --use-vnc )            connect use_vnc ;;
            -d | --default )            connect         ;;
        esac
    done
}

main "$*"

