#!/usr/bin/env bash

#=======================================================================#
# Copyright (C) 2023 - 2023 LDO Motors                                  #
#                                                                       #
# This file is part of LDO Setup                                        #
# https://github.com/MotorDynamicsLab/LDOSetup.git                      # 
#                                                                       #
# Which calls scripts from through symlinks                             #
# KIAUH - Klipper Installation And Update Helper                        #
# https://github.com/dw-0/kiauh                                         #
#                                                                       #
# This file may be distributed under the terms of the GNU GPLv3 license #
#=======================================================================#

set -e
clear

 #=============== KIAUH ================#
KIAUH_SRCDIR="${HOME}/kiauh"
KIAUH_REPO="https://github.com/dw-0/kiauh.git"

 #=============== LDOSetup ================#
LDOSETUP_DIR="${HOME}/LDOSetup"
LDOSETUP_REPO="https://github.com/camerony/LDOSetup.git"

if [[ -e "${KIAUH_SRCDIR}/kiauh.sh" ]]; then

    if [[ ! -L "${LDOSETUP_DIR}/scripts" ]]; then
        if ! ln -s "${KIAUH_SRCDIR}/scripts" "${LDOSETUP_DIR}"; then
        echo -e "Creating symlink failed! Aborting installation ..."
        return
        fi
    fi

### sourcing include scripts
    for script in "${LDOSETUP_DIR}/scripts/ui/"*.sh; do . "${script}"; done
    for script in "${LDOSETUP_DIR}/scripts/"*.sh; do . "${script}"; done
    for script in "${LDOSETUP_DIR}/ui/"*.sh; do . "${script}"; done
  echo -e "OK"
  init_logfile
  set_globals
  ldo_menu
else
  echo -e "Please install KIAUH first! then install Klipper with KIAUH and then run this script again!"
  echo -e "1) sudo apt-get update && sudo apt-get install git -y"
  echo -e "2) cd ~ && git clone https://github.com/dw-0/kiauh.git"
  echo -e "3) ./kiauh/kiauh.sh"
return
fi
