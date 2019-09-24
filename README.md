# ScaleFT bash completion

## Features

Completes the basic commands as listed under COMMANDS
Completes the available HOSTNAMES for `sft ssh`

## Prerequisites

* pcregrep
* ScaleFT client `sft`

## Usage

`source /path/to/scaleft.bash`

`sft ssh [tab][tab]`

## Todo

- [ ] Better caching of HOSTNAMES in ssh_known_hosts format so it's available in all terminals.
- [ ] Completion of arguments for commands/sub-commands

