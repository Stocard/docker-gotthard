set -e

eval "$(ssh-agent -s)" &> /dev/null

for possiblekey in ${HOME}/.ssh/*; do
    if grep -q PRIVATE "$possiblekey"; then
        ssh-add "$possiblekey" &> /dev/null
    fi
done

# ssh-add -l will return with non-zero exit code if empty, thus terminating script execution
echo "Checking if we added any ssh identities (aborting if not)"
ssh-add -l

if [ -z "$JUMP_HOSTS" ]; then
  JUMP_CONFIG=""
else
  JUMP_CONFIG="-J $JUMP_HOSTS"
fi

FORWARDING_CONFIG=""
IFS=',' read -r -a PORTMAPPINGS <<< "${PORTS}"
for PORTMAPPING in "${PORTMAPPINGS[@]}"; do
  IFS=':' read -r -a PORTS <<< "${PORTMAPPING}"
  FORWARDING_CONFIG="${FORWARDING_CONFIG} -L 0.0.0.0:${PORTS[0]}:${HOST}:${PORTS[1]}"
done

IFS=',' read -r -a HOST_AND_PORTMAPPINGS <<< "${HOSTS_AND_PORTS}"
for HOST_AND_PORTMAPPING in "${HOST_AND_PORTMAPPINGS[@]}"; do
  IFS=':' read -r -a HOST_AND_PORTS <<< "${HOST_AND_PORTMAPPING}"
  FORWARDING_CONFIG="${FORWARDING_CONFIG} -L 0.0.0.0:${HOST_AND_PORTS[0]}:${HOST_AND_PORTS[1]}:${HOST_AND_PORTS[2]}"
done

exec ssh -N -T -oServerAliveInterval=30 -oStrictHostKeyChecking=no ${FORWARDING_CONFIG} -l ${USER} ${JUMP_CONFIG} ${HOST} 
