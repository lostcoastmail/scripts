#!/bin/sh

# script to determine the validity of a username
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

# we will perform operations on this later, so the variable is defined now
name="$1"

# check if the name has any invalid characters
# email handles can only contain letters, numbers, hyphens, underscores, or periods. 
# Linux supports others, but it's generally bad practice to have non-standardized characters in handles.
[ -n "$(printf "$name" | tr '[:upper:]' '[:lower:]' | tr -d A-Za-z0-9-_.)" ] && exit 1

# exit if no name is provided
[ -z "$name" ] && exit 2
