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

function ldosetup_ui() {
  top_border
  echo -e "|    ${yellow}~~~~~~~~~~~~~ [ LDO Setup Menu ] ~~~~~~~~~~~~~${white}     |"
  hr
  echo -e "|                  Configure Klipper                    |"
  echo -e "|-------------------------------------------------------|"
  echo -e "|  Select LDO Kit:                                      |"
  echo -e "|  1) [Voron 0]                                         |"
  echo -e "|  2) [Voron 2.4]                                       |"
  echo -e "|  3) [Voron Trident]                                   |"
  echo -e "|  4) [Voron Switchwire]                                |"
  echo -e "|                                                       |"
  echo -e "|  5) [Rotate Screen (BTT/Waveshare)]                   |"
  echo -e "|  7) [Buzz Steppers]                                   |"
  quit_footer
}

function ldo_menu() {

  ### return early if klipper is not installed
  local klipper_services
  klipper_services=$(klipper_systemd)
  if [[ -z ${klipper_services} ]]; then
    local error="Klipper not installed! Please install Klipper first!"
    log_error "LDO Setup started without Klipper being installed. Aborting setup."
    print_error "${error}" && return
  fi

  do_action "" "ldosetup_ui"
  local regex line gcode_dir
  unset selected_mcu_id
  unset selected_printer_cfg
  unset mcu_list

  regex="${HOME//\//\\/}\/([A-Za-z0-9_]+)\/config\/printer\.cfg"
  #configs=$(find "${HOME}" -maxdepth 3 -regextype posix-extended -regex "${regex}" | sort)
  mapfile -t configs < <(find "${HOME}" -maxdepth 3 -regextype posix-extended -regex "${regex}" | sort)
  if [[ -z ${configs} ]]; then
    print_error "No printer.cfg found! Installation of Macros will be skipped ..."
    log_error "execution stopped! reason: no printer.cfg found in ${HOME}"
    return
  fi

  for config in ${configs}; do
    path=$(echo "${config}" | rev | cut -d"/" -f2- | rev)
  done

  local action
  while true; do
    read -p "${cyan}####### Perform action:${white} " action
    case "${action}" in
      1)
        do_action "ldov0_ui";;
      2)
        do_action "ldov24_ui";;
      3)
        do_action "ldovt_ui";;
      4)
        do_action "ldosw_ui";;
      5)
        clear && print_header
        rotatescreen
        ldosetup_ui;;
      6)
        clear && print_header
        buzz_steppers
        ldosetup_ui;;
      Q|q)
        echo -e "${green}###### Happy printing! ######${white}"; echo
        exit 0;;
      *)
        deny_action "ldosetup_ui";;
    esac
  done
  ldo_menu
}

function ldov0_ui() {
  top_border
  echo -e "|      ${yellow}~~~~~~~~~~~~~ [ LDO V0 Menu ] ~~~~~~~~~~~~~${white}      |"
  hr
  echo -e "|                  Configure Klipper                    |"
  echo -e "|-------------------------------------------------------|"
  echo -e "|  Select V0.1 Revision:                                |"
  echo -e "|  1) [Rev A/B/C/D]                                     |"
  hr
  echo -e "|  Select V0.1-S1 Revision:                             |"
  echo -e "|  2) [Rev E]                                           |"
  echo -e "|                                                       |"
  hr
  echo -e "|  Select V0.2-S1 Revision:                             |"
  echo -e "|  3) [Rev A/A+]                                        |"
  echo -e "|                                                       |"
  back_footer

  local action
  while true; do
    read -p "${cyan}###### Perform action:${white} " action
    case "${action}" in
      1)
        select_msg "V0.1 Rev A/B/C/D"
        ldosetup "V01" "A0" "00" 120 120 120
        ldo_menu;;
      2)
        select_msg "V0.1-S1 Rev E"
        ldosetup "V01" "E0" "00" 120 120 120
        ldo_menu;;
      3)
        select_msg "V0.2-S1 Rev A/A+"
        ldosetup "V02" "A0" "00" 120 120 120
        ldo_menu;;

      B|b)
        clear; ldo_menu; break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function ldov24_ui() {
  top_border
  echo -e "|     ${yellow}~~~~~~~~~~~~~ [ LDO V2.4 Menu ] ~~~~~~~~~~~~~${white}     |"
  hr
  echo -e "|                  Configure Klipper                    |"
  echo -e "|-------------------------------------------------------|"
  echo -e "|  V2.4 Rev A/B Revision:                               |"
  echo -e "|  Select printer size                                  |"
  echo -e "|  1) [250mm]                                           |"
  echo -e "|  2) [300mm]                                           |"
  echo -e "|  3) [350mm]                                           |"
  echo -e "|                                                       |"
  echo -e "|  V2.4 Rev C Revision:                                 |"
  echo -e "|  Select printer size                                  |"
  echo -e "|  4) [250mm]                                           |"
  echo -e "|  5) [300mm]                                           |"
  echo -e "|  6) [350mm]                                           |"
  echo -e "|                                                       |"
  back_footer

  local action
  while true; do
    read -p "${cyan}###### Perform action:${white} " action
    case "${action}" in
      1)
        select_msg "Rev A/B 250mm"
        ldosetup "V24" "B0" "00" 250 250 200
        ldo_menu;;
      2)
        select_msg "Rev A/B 300mm"
        ldosetup "V24" "B0" "00" 300 300 250
        ldo_menu;;
      3)
        select_msg "Rev A/B 300mm"
        ldosetup "V24" "B0" "00" 350 350 300
        ldo_menu;;
      4)
        select_msg "Rev C 250mm"
        ldosetup "V24" "C0" "00" 250 250 200
        ldo_menu;;
      5)
        select_msg "Rev C 350mm"
        ldosetup "V24" "C0" "00" 300 300 250
        ldo_menu;;
      6)
        select_msg "Rev C 350mm"
        ldosetup "V24" "C0" "00" 350 350 300
        ldo_menu;;
      B|b)
        clear; ldo_menu; break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function ldovt_ui() {
  top_border
  echo -e "|   ${yellow}~~~~~~~~~~~~~ [ LDO Trident Menu ] ~~~~~~~~~~~~~${white}   |"
  hr
  echo -e "|                  Configure Klipper                    |"
  echo -e "|-------------------------------------------------------|"
  echo -e "|  Trident Rev A/B Revision:                            |"
  echo -e "|  Select printer size                                  |"
  echo -e "|  1) [250mm]                                           |"
  echo -e "|  2) [300mm]                                           |"
  echo -e "|                                                       |"
  echo -e "|  Trident Rev C Revision:                              |"
  echo -e "|  Select printer size                                  |"
  echo -e "|  3) [250mm]                                           |"
  echo -e "|  4) [300mm]                                           |"
  echo -e "|                                                       |"
  back_footer

  local action
  while true; do
    read -p "${cyan}###### Perform action:${white} " action
    case "${action}" in
      1)
        select_msg "Rev A/B 250mm"
        ldosetup "VT0" "B0" "00" 250 250 200
        ldo_menu;;
      2)
        select_msg "Rev A/B 300mm"
        ldosetup "VT0" "B0" "00" 300 300 250
        ldo_menu;;
      3)
        select_msg "Rev C 250mm"
        ldosetup "VT0" "C0" "00" 250 250 200
        ldo_menu;;
      4)
        select_msg "Rev C 350mm"
        ldosetup "VT0" "C0" "00" 300 300 250
        ldo_menu;;
      B|b)
        clear; ldo_menu; break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function ldovsw_ui() {
  top_border
  echo -e "|  ${yellow}~~~~~~~~~~~~~ [ LDO Switchwire Menu ] ~~~~~~~~~~~~~${white}   |"
  hr
  echo -e "|                  Configure Klipper                    |"
  echo -e "|-------------------------------------------------------|"
  echo -e "|  Configure Klipper:                                   |"
  echo -e "|  1) [250mm]                                           |"
  echo -e "|  2) [300mm]                                           |"
  echo -e "|                                                       |"
  back_footer
}

function download_ldo_configs() {
  local ms_cfg_repo path configs regex line gcode_dir

  ms_cfg_repo="https://github.com/camerony/LDOSetup.git"

  status_msg "Cloning LDOSetup ..."
  [[ -d "${HOME}/LDOSetup" ]] && rm -rf "${HOME}/LDOSetup"
  if git clone --recurse-submodules "${ms_cfg_repo}" "${HOME}/LDOSetup"; then
    ok_msg "Done!"
  else
    print_error "Cloning failed! Aborting installation ..."
    log_error "execution stopped! reason: cloning failed"
    return
  fi
}

function select_printer_cfg() {
  local i=0 sel_index=0

  if (( ${#configs[@]} < 1 )); then
    print_error "No configs found!\n MCU either not connected or not detected!"
    return
  fi

  top_border
  echo -e "|                   ${red}!!! ATTENTION !!!${white}                   |"
  hr
  echo -e "| Make sure, to select the correct printer.cfg to setup! |"
  hr
  echo -e "|                   ${red}!!! ATTENTION !!!${white}                   |"
  bottom_border
  echo -e "${cyan}###### List of available printer.cfg:${white}"

  ### list all mcus
  for config in "${configs[@]}"; do
    i=$(( i + 1 ))
    echo -e "${i}) PATH: ${cyan}${config}${white}"
  done

  ### verify user input
  local regex="^[1-9]+$"
  while [[ ! ${sel_index} =~ ${regex} ]] || [[ ${sel_index} -gt ${i} ]]; do
    echo
    read -p "${cyan}###### Select printer.cfg to configure:${white} " sel_index

    if [[ ! ${sel_index} =~ ${regex} ]]; then
      error_msg "Invalid input!"
    elif [[ ${sel_index} -lt 1 ]] || [[ ${sel_index} -gt ${i} ]]; then
      error_msg "Please select a number between 1 and ${i}!"
    fi

    local cfg_index=$(( sel_index - 1 ))
    selected_printer_cfg="${configs[${cfg_index}]}"
  done

}

function ldosetup() {
  local printer=$1 rev=$2 ver=$3
  local max_x=$4 max_y=$5 max_z=$6
  local configfilename="${printer}-${rev}-${ver}.cfg"

  if [[ $max_x == $max_y ]]; then
    max_xy=$max_x
  else
    max_xy=$max_x,$max_y
  fi
  select_printer_cfg
  echo -e "\n${configfilename}\n"
  ### confirm selection
  local yn
  while true; do
    echo -e "\n###### You selected:\n ● PATH ${selected_printer_cfg}\n"
    read -p "${cyan}###### Continue? (Y/n):${white} " yn
    case "${yn}" in
      Y|y|Yes|yes|"")
        select_msg "Yes"

        select_mcu_connection
        select_mcu_id_ldo "Mainboard"
        print_detected_mcu_to_screen
        status_msg "Configuring ${selected_printer_cfg} ..."
          if [[ -e "${selected_printer_cfg}" && ! -h "${selected_printer_cfg}" ]]; then
            warn_msg "Attention! Existing printer.cfg detected!"
            warn_msg "The file will be copied to 'printer.bak.cfg' to be able to continue with the installation."
            if ! cp "${selected_printer_cfg}" "${selected_printer_cfg}.bak"; then
              error_msg "Copying printer.cfg failed! Aborting installation ..."
              return
            fi
          fi
        if ! sudo cp "${HOME}/LDOSetup/configs/${configfilename}" "${selected_printer_cfg}"; then
          error_msg "Creating ${path}/printer.cfg failed! Aborting installation ..."
          return
        else
          status_msg "Setting MCU ${selected_mcu_id} in ${selected_printer_cfg}..."
          log_info "${path}/printer.cfg"

          sudo sed -i "s|#{serial_mcu}#|$selected_mcu_id|gi" "${selected_printer_cfg}"

          if grep -Eq "#{serial_mcu_umb}#" "${selected_printer_cfg}"; then
            select_mcu_connection
            select_mcu_id_ldo "Umbilical"
            sudo sed -i "s|#{serial_mcu_umb}#|$selected_mcu_id|gi" "${selected_printer_cfg}"
          fi

          status_msg "Setting up ${selected_printer_cfg}..."
          sed -i "s|#{max_xy}#|$max_xy|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_z}#|$max_z|gi" "${selected_printer_cfg}"
          # Set Gantry Points
          sed -i "s|#{max_xy_a60}#|$(($max_xy+60))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_a70}#|$(($max_xy+70))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_s75}#|$(($max_xy-75))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_s50}#|$(($max_xy-50))|gi" "${selected_printer_cfg}"

          sed -i "s|#{max_x_d2}#|$(($max_x/2))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_y_d2}#|$(($max_y/2))|gi" "${selected_printer_cfg}"

          sed -i "s|#{max_xy_a48}#|$(($max_xy+48))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_a50}#|$(($max_xy+50))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_s55}#|$(($max_xy-55))|gi" "${selected_printer_cfg}"
          sed -i "s|#{max_xy_s30}#|$(($max_xy-30))|gi" "${selected_printer_cfg}"

          read -p "LDO Setup Complete. Press [Enter] to continue..."
        fi
        break;;
      N|n|No|no)
        select_msg "No"
        break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function select_mcu_id_ldo() {
  local i=0 sel_index=0 mcu_type=$1

  if (( ${#mcu_list[@]} < 1 )); then
    print_error "No MCU found!\n MCU either not connected or not detected!"
    return
  fi

  top_border
  echo -e "| Make sure, to select the correct MCU!                 |"
  bottom_border
  echo -e "${cyan}###### List of available MCU:${white}"

  ### list all mcus
  for mcu in "${mcu_list[@]}"; do
    i=$(( i + 1 ))
    mcu=$(echo "${mcu}" | rev | cut -d"/" -f1 | rev)
    echo -e "${i}) MCU: ${cyan}${mcu}${white}"
  done

  ### verify user input
  local regex="^[1-9]+$"
  while [[ ! ${sel_index} =~ ${regex} ]] || [[ ${sel_index} -gt ${i} ]]; do
    echo
    read -p "${cyan}###### Select the ${mcu_type} MCU:${white} " sel_index

    if [[ ! ${sel_index} =~ ${regex} ]]; then
      error_msg "Invalid input!"
    elif [[ ${sel_index} -lt 1 ]] || [[ ${sel_index} -gt ${i} ]]; then
      error_msg "Please select a number between 1 and ${i}!"
    fi

    local mcu_index=$(( sel_index - 1 ))
    selected_mcu_id="${mcu_list[${mcu_index}]}"
  done

  ### confirm selection
  local yn
  while true; do
    echo -e "\n###### You selected:\n ● MCU #${sel_index}: ${selected_mcu_id}\n"
    read -p "${cyan}###### Continue? (Y/n):${white} " yn
    case "${yn}" in
      Y|y|Yes|yes|"")
        select_msg "Yes"

        break;;
      N|n|No|no)
        select_msg "No"
        break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function rotatescreen() {

    ### confirm selection
  local yn
  while true; do
    echo -e "\n###### Rotate Upside Down BTT or Waveshare Screen\n"
    read -p "${cyan}###### Continue? (Y/n):${white} " yn
    case "${yn}" in
      Y|y|Yes|yes|"")
        select_msg "Yes"

        status_msg "Rotating Screen ..."
          if [[ -e "/boot/firmware/config.txt" && ! -h "/boot/firmware/config.txt" ]]; then
            warn_msg "Attention! Existing /boot/firmware/config.txt detected!"
            warn_msg "The file will be copied to 'printer.bak.cfg' to be able to continue with the installation."
            if ! sudo cp "/boot/firmware/config.txt" "/boot/firmware/config.txt.bak"; then
              error_msg "Copying printer.cfg failed! Aborting installation ..."
              return
            fi
          fi
        if ! sudo cp "${HOME}/LDOSetup/configs/config.txt" "/boot/firmware/config.txt"; then
          error_msg "Creating /boot/firmware/config.txt failed! Aborting installation ..."
          return
        else
          read -p "LDO Setup Complete. Press [Enter] to continue..."
        fi
        break;;
      N|n|No|no)
        select_msg "No"
        break;;
      *)
        error_msg "Invalid command!";;
    esac
  done
}

function buzz_steppers() {
  echo "FIRMWARE_RESTART" >> ~/printer_data/comms/klippy.serial
  echo "STEPPER_BUZZ STEPPER=stepper_x" >> ~/printer_data/comms/klippy.serial
}

