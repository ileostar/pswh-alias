<#
 * FileName: Microsoft.PowerShell_profile.ps1
 * Author: LeoStar
 * Email: hi@leostar.top
 * Date: 2024, Mar. 07
 * Copyright: No copyright. You can use this code for anything with no warranty.
#>

if (-not (Test-Path $profile)) {
  New-Item -ItemType File -Path (Split-Path $profile) -Force -Name (Split-Path $profile -Leaf)
}

$profileEntry = 'Remove-Item Alias:ni -Force -ErrorAction Ignore'
$profileContent = Get-Content $profile
if ($profileContent -notcontains $profileEntry) {
  ("`n" + $profileEntry) | Out-File $profile -Append -Force -Encoding UTF8
}

Remove-Item Alias:ni -Force -ErrorAction Ignore


#------------------------------- Import Modules BEGIN -------------------------------
# npm���Զ���ȫ
Import-Module npm-completion

# ���� posh-git git���Զ���ȫ
Import-Module posh-git

# ���� ps-read-line
Import-Module PSReadLine

# ���� PowerShellAI
Import-Module PowerShellAI

# ���� PSCompletions
Import-Module PSCompletions
#------------------------------- Import Modules END -------------------------------



#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# ����Ԥ���ı���ԴΪ��ʷ��¼
Set-PSReadLineOption -PredictionSource History

# ÿ�λ���������ʷ����궨λ����������ĩβ
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# ���� Tab Ϊ�˵���ȫ�� Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# ���� Ctrl+d Ϊ�˳� PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# ���� Ctrl+z Ϊ����
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# �������ϼ�Ϊ����������ʷ��¼
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# �������¼�Ϊǰ��������ʷ��¼
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
#-------------------------------  Set Hot-keys END    -------------------------------


#-------------------------------  Set Command Alias BEGIN  -------------------------------

# -------------------------------- #
# Node Package Manager
# -------------------------------- #
function s { nr start }
function d { nr dev }
function b { nr build }
function bw { nr build --watch }
function t { nr test }
function tu { nr test -u }
function tw { nr test --watch }
function w { nr watch }
function c { nr commit }
function p { nr play }
function lint { nr lint }
function lintf { nr lint --fix }
function re { nr releaseh }

# -------------------------------- #
# Git
# -------------------------------- #
function gs { git status }
function gl { git log }
function glo { git log --oneline --graph }
function grao {
  param([string] $args)
  git remote add origin $args
}
function ga { git add . }
function gb { git branch }
function gbd { git branch -d }
function gba { git branch -a }
function gcm {
  param([string] $message)
  git commit -m $message
}
function gca {
  param([string] $message)
  git commit -a $message
}
function gp { git push }
function gpf { git push -f }
function gpu {
  param([string] $branch)
  git push -u origin $branch
}

# -------------------------------- #
# lias CLI Name
# -------------------------------- #

set-alias -name pn -value pnpm

# -------------------------------- #

# -------------------------------- #
# Directories
#
# I put
# `~/me` for my projects
# `~/forks` for forks
# `~/repros` for reproductions
# -------------------------------- #
$me="E:\vscode-workspace\me"
$forks="E:\vscode-workspace\forks"
$repros="E:\vscode-workspace\repros"
$drill="E:\vscode-workspace\drill"

function i() {
  cd $me
}

function repros() {
  cd $repros
}

function forks() {
  cd $forks
}

function drill() {
  cd $drill
}

function mc {
  param([string] $folder)
  mkdir $folder
  cd $folder
}

function drillmc {
  drill
  mc $args
}

function new() {
  param([string] $pkg)
  npx degit ileostar/vitesse-star $pkg
}

function newi() {
  i
  new $args
}

function clone {
  param([string]$repo, [string]$dir = "")
  if ($dir -eq "") {
    git clone $repo | Out-Null
    Set-Location -Path (Split-Path -Path $repo -LeafBase)
  } else {
    git clone $repo $dir | Out-Null
    cd $dir
  }
}

function clonei {
  i
  clone $args
  code .
}

function cloner {
  repros
  clone $args
  code .
}

function clonef {
  forks
  clone $args
  code .
}

function codei {
  i
  code $args
}

function serve {
  param([string]$dir = "dist")

  if ($dir -eq "dist") {
    Start-Process "live-server" $dir
  } else {
    Start-Process "live-server" $dir
  }
}

#-------------------------------  Set Command Alias END    -------------------------------
