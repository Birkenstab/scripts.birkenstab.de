#!/bin/bash
set -e # Wenn ein Command ein Fehler wirft, wird das Skript direkt beendet

echo -n "Choose key name: "
read filename

filepath=~/.ssh/$filename

if [ -f "$filepath" ]; then
    echo "$filepath already exists"
    exit 0
fi

passphrase=$(LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n 1)
echo "Using ${#passphrase} character passphrase"

ssh-keygen -t ed25519 -a 100 -f "$filepath" -N "$passphrase"

expect << EOF
  spawn ssh-add -K "$filepath"
  expect "Enter passphrase"
  send "$passphrase\n"
  expect eof
EOF

echo "SSH-Key successfull created"
echo "Public Key:"
cat "$filepath.pub"
