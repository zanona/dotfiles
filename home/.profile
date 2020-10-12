# enabled services
# systemctl enable pcscd (yubikey)

if [ -f .bashrc ]; then
    . .bashrc
fi

drone > /dev/null 2>&1

if test $? -eq 0; then
    DRONE_TOKEN=$(pass drone.zanona.co/DRONE_TOKEN)
    DRONE_RPC_SECRET=$(pass drone.zanona.co/DRONE_RPC_SECRET)
fi

export DRONE_SERVER=https://drone.zanona.co
export DRONE_TOKEN
export DRONE_RPC_SECRET
