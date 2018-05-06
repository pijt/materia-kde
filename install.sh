#!/bin/sh

set -e

gh_repo="pijlight-kde"
gh_desc="PijLight KDE"

cat <<- EOF
                                                                                
 ▄▄▄▄▄▄▄   ▄▄     ▄▄   ▄        ▄▄            ▄        ▄                        
 ██   ▀██  ▀▀     ▀▀   ██       ▀▀    ▄▄▄▄▄   ██       ██                       
 ██    ██  █▄     █▄   ██       █▄   ██▀▀▀██  ██       ██                       
 ███████▀  ██     ██   ██       ██   ██▄  ██  ██▄▄▄   ▄██▄▄▄▄                   
 ██        ██     ██   ██       ██    ▀█████  ██▀▀██  ▀██▀▀▀▀                   
 ██▄       ██  ██▄██   ███▄▄▄█  ██   ██   ██  ██  ██   ██▄▄██                   
 ▀▀▀       ▀▀  ▀███▀   ▀▀▀▀▀▀▀  ▀▀   ▀█████▀  ▀▀  ▀▀    ▀▀▀▀                    
                                                                                
                                                                                
                                                                                
 ▄▄   ▄▄▄  ▄▄▄▄▄     ▄▄▄▄▄▄▄▄                                                   
 ██  ██▀   ██▀▀▀██   ██▀▀▀▀▀▀                                                   
 ██▄██     ██    ██  ██                                                         
 █████     ██    ██  ███████                                                    
 ██  ██▄   ██    ██  ██                                                         
 ██   ██▄  ██▄▄▄██   ██▄▄▄▄▄▄                                                   
 ▀▀    ▀▀  ▀▀▀▀▀     ▀▀▀▀▀▀▀▀ 
 
  $gh_desc
  https://github.com/pijt/$gh_repo


EOF

PREFIX=${PREFIX:=/usr}
uninstall=${uninstall:-false}

_msg() {
    echo "=>" "$@" >&2
}

_rm() {
    # removes parent directories if empty
    sudo rm -rf "$1"
    sudo rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

_download() {
    _msg "Getting the latest version from GitHub ..."
    wget -O "$temp_file" \
        "https://github.com/pijt/$gh_repo/archive/master.tar.gz"
    _msg "Unpacking archive ..."
    tar -xzf "$temp_file" -C "$temp_dir"
}

_uninstall() {
    _msg "Deleting $gh_desc ..."
    _rm "$PREFIX/share/aurorae/themes/Pij-Dark"
    _rm "$PREFIX/share/aurorae/themes/Pij-Light"
    _rm "$PREFIX/share/color-schemes/PijDark.colors"
    _rm "$PREFIX/share/color-schemes/PijLight.colors"
    _rm "$PREFIX/share/konsole/Pij.colorscheme"
    _rm "$PREFIX/share/konsole/PijDark.colorscheme"
    _rm "$PREFIX/share/Kvantum/Pij"
    _rm "$PREFIX/share/Kvantum/PijDark"
    _rm "$PREFIX/share/Kvantum/PijLight"
    _rm "$PREFIX/share/plasma/desktoptheme/Pij"
    _rm "$PREFIX/share/plasma/look-and-feel/com.github.varlesh.pij"
    _rm "$PREFIX/share/yakuake/skins/pij"
    _rm "$PREFIX/share/yakuake/skins/pij-dark"
}

_install() {
    _msg "Installing ..."
    sudo cp -R \
        "$temp_dir/$gh_repo-master/aurorae" \
        "$temp_dir/$gh_repo-master/color-schemes" \
        "$temp_dir/$gh_repo-master/konsole" \
        "$temp_dir/$gh_repo-master/Kvantum" \
        "$temp_dir/$gh_repo-master/plasma" \
        "$temp_dir/$gh_repo-master/yakuake" \
        "$PREFIX/share"
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir" \
        ~/.cache/plasma-svgelements-Pij* \
        ~/.cache/plasma_theme_Pij*.kcache
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ "$uninstall" = "false" ]; then
    _download
    _uninstall
    _install
else
    _uninstall
fi
