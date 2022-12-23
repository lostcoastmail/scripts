#!/bin/sh

# script to set a user's disk quota, in bytes
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

# we will perform operations on this later, so the variable is defined now
name="$1"

# check if a username was provided
[ -n "$name" ] || {
    printf "${0##*/}: No user provided\n"
    exit 1
}

# check if this user exists in the account registry
[ -n "$(awk -F':' '{print $1}' </etc/passwd | grep ^$name\$)" ] || {
    printf "${0##*/}: \"$name\": User not in account registry\n"
    exit 2
}

# set execution-specified quota if valid
# minimum quota is 8KB; allowing quotas lower than this would be pointless
[ -n "$2" ] && [ "$2" -gt 8192 >&- 2>&- ] && {
    quota="$2"
} || {
    # otherwise set the quota to 4GB (in bytes) as a default
    # the default value may get changed, but this will be the default for now
    quota="4294967296"
}
# to reset one's default quota, one can do "setquota $user" without appending a custom storage amount

# create the user quota directory if needed
[ -d /etc/lct/quotas/ ] || mkdir -p /etc/lct/quotas

# print the user's quota to the corresponding file
printf "$quota" >/etc/lct/quotas/$name
