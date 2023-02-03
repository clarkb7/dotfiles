#!/bin/bash

# Install vivid
pushd /tmp
wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb" -O vivid.deb
sudo dpkg -i vivid.deb
rm vivid.deb
popd
