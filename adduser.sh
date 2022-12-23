#!/bin/sh

# script to create a user
# Copyright 2022 Lost Coast Technologies
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# exit if not root
[ "${EUID:-${UID:-$(id -u)}}" = "0" ] || {
    printf "${0##*/}: error: Operation not permitted\n"
    exit 1
}

# check if the username works
$LCT_PREFIX/checkname.sh || {
    printf "${0##*/}: \"$1\": Invalid username\n"
    exit 2
}

# add the user
useradd --badname --comment "$2" --groups mail --no-log-init --shell $LCT_PREFIX/bin/mail-user -m $1

# make the mail/files dirs
mkdir -p /home/$1/mail
mkdir -p /home/$1/files
