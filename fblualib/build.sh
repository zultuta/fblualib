#!/bin/bash -e
#
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
#

set -o pipefail

if [[ ! -r ./LuaUtils.h ]]; then
  echo "Please run from the fblualib subdirectory" >&2
  exit 1
fi

root=$(pwd)

# Build C++ library component
mkdir -p build
cd build
cmake ..
make
sudo make install

rocks="util luaunit complex \
  ffivector editline trepl debugger mattorch thrift python"
version='0.1-1'
for rock in $rocks; do
  cd $root/$rock
  # first attempt to install without root. if failed, install with root
  luarocks make rockspec/fb$rock-$version.rockspec || sudo luarocks make rockspec/fb$rock-$version.rockspec
done
