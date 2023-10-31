#!/bin/bash
cd "$(dirname "$0")" || exit

# ensure necessary packages are installed
if ! command -v gcc &> /dev/null; then
    echo "gcc could not be found, please install it and rerun the script."
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 could not be found, please install it and rerun the script."
    exit 1
fi

# compile bind.c to ./bind.so
gcc -nostartfiles -fpic -shared bind.c -o bind.so -ldl -D_GNU_SOURCE || { echo "Compilation failed"; exit 1; }

mkdir -p ~/.bind
cp bind.so ~/.bind/bind.so || { echo "Copy failed"; exit 1; }

# install selenium
cd py || { echo "Directory 'py' not found"; exit 1; }
if pip3 show selenium &> /dev/null; then
    echo "Selenium is already installed. Please uninstall it before proceeding."
    exit 1
else
    pip3 install --break-system-packages --user . || { echo "Installation failed"; exit 1; }
    echo "Installation completed successfully."
fi
