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
# npm的自动补全
Import-Module npm-completion

# 引入 posh-git git的自动补全
Import-Module posh-git

# 引入 ps-read-line
Import-Module PSReadLine

# 引入 PowerShellAI
Import-Module PowerShellAI

# 引入 PSCompletions
Import-Module PSCompletions
#------------------------------- Import Modules END -------------------------------



#-------------------------------  Set Hot-keys BEGIN  -------------------------------
# 设置预测文本来源为历史记录
Set-PSReadLineOption -PredictionSource History

# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置 Ctrl+d 为退出 PowerShell
Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
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
