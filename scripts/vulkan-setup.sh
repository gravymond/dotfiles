#!/bin/bash

query_abort() {
  printf "==> %s [Y/n] " "$1"
  read -n 1 response
  case "$response" in
    'Y'|'y'|'')
      ;;
    *)
      printf "\n%s\n" "Aborting."
      exit 1
  esac
}

wine --version | grep -q Staging || query_abort "WARNING: Wine Staging not installed. Apparently Vulkan doesn't work that well with normal Wine (as of 3.4). Proceed?"

if [ "x$WINEPREFIX" = "x" ]; then
  query_abort "WINEPREFIX is not set. Proceed and use ~/.wine as WINEPREFIX?"
  WINEPREFIX="$HOME/.wine"
fi

export WINEPREFIX

set -e

is_wine_64bit() {
  test "x$WINEARCH" = "xwin64" && return 0
  test "x$WINEARCH" = "xwin32" && return 1
  which wine64 2> /dev/null > /dev/null
}

install_vulkansdk() {
  # Apparently, the winetricks that has 'vulkansdk' is still too new, so we're manually downloading the thing for now
  #winetricks vulkansdk
  
  test ! -f /tmp/vulkansdk.exe &&
    wget -O /tmp/vulkansdk.exe 'https://sdk.lunarg.com/sdk/download/1.0.68.0/windows/VulkanSDK-1.0.68.0-Installer.exe'
  
  wine /tmp/vulkansdk.exe /S
}

setup_cfg() {
  cat > "$WINEPREFIX/drive_c/windows/winevulkan.json" <<EOF
{
  "file_format_version": "1.0.0",
  "ICD": {
    "library_path": "c:\\\\windows\\\\system32\\\\winevulkan.dll",
    "api_version": "1.0.51"
  }
}
EOF
}

setup_registry() {
  cat > "/tmp/vulkan.reg" <<EOF
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\\SOFTWARE\\Khronos\\Vulkan\\Drivers\\]
"C:\\\\Windows\\\\winevulkan.json"=dword:00000000
EOF
  
  "wine$1" reg import "/tmp/vulkan.reg"
}

wineboot
install_vulkansdk
setup_cfg
setup_registry
is_wine_64bit && setup_registry 64
printf "%s\n" "==> Done! Enjoy Vulkan :)"