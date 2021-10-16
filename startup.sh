#!/bin/bash
SOURCE_DIR=/workspace/chromiumos
echo "Checking environment"
for conf in 'user.name' 'user.email';
  do 
  local REPLY
  [[ "" == $(git config --global --get $conf) ]] && {
  while ($REPLY == ""); do 
    read -p 'WARNING! MISSING VALUE: git config $conf. Please enter value for $conf: " REPLY
  done
  git config --global $conf "$REPLY"
  }
done

git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true

#[[ ! -d /workspace ]] && mkdir -p /workspace
#cd /workspace
#fetch chromium
#cd src && ./build/install-build-deps.sh

echo "Fixing sudo"
cd /tmp
cat > ./sudo_editor <<EOF
#!/bin/sh
echo Defaults \!tty_tickets > \$1          # Entering your password in one shell affects all shells
echo Defaults timestamp_timeout=300 >> \$1 # Time between re-requesting your password, in minutes
echo gitpod ALL=(ALL) NOPASSWD: ALL >> \$1 # Passwordless
EOF
chmod +x ./sudo_editor
sudo EDITOR=./sudo_editor visudo -f /etc/sudoers.d/relax_requirements
rm ./sudo_editor

echo "Downloading source... This could take a very long time."
[[ ! -d ${SOURCE_DIR} ]] && mkdir -p ${SOURCE_DIR}
cd ${SOURCE_DIR}
repo init -u https://chromium.googlesource.com/chromiumos/manifest.git --submodules --depth=1 -c
repo sync -j$(nproc) -c -s 
