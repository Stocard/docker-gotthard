set -e

FORWARDING_CONFIG=""
IFS=',' read -r -a PORTMAPPINGS <<< "${PORTS}"
for PORTMAPPING in "${PORTMAPPINGS[@]}"; do
  IFS=':' read -r -a PORTS <<< "${PORTMAPPING}"
  FORWARDING_CONFIG="${FORWARDING_CONFIG} -L 0.0.0.0:${PORTS[0]}:${HOST}:${PORTS[1]}"
done
echo "${FORWARDING_CONFIG}"
exec ssh -T -N -oServerAliveInterval=30 -oStrictHostKeyChecking=no ${FORWARDING_CONFIG} -l ${USER} ${HOST}
