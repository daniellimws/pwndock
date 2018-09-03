# PwnDock

This is an attempt as a faster, easier-to-setup version of [pwnvm](https://github.com/OpenToAllCTF/pwnvm), **with PowerShell scripts**.

## Installation
1. Install Docker: [Using chocolatey](https://stefanscherer.github.io/get-started-with-docker-on-windows-using-chocolatey/) is the most convenient way for me 
2. Run PowerShell as administrator and make sure `ExecutionPolicy` is set to `Unrestricted` or `Bypass` (run `Set-ExecutionPolicy Unrestricted`)
3. Build: `./build.ps1`

## Running it
Management: `.\start.ps1`, `.\stop.ps1`, `.\connect.ps1`
