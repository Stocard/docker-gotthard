set -e

FORWARDING_CONFIG=""
IFS=',' read -r -a PORTS <<< "${PORTS}"
for PORT in "${PORTS[@]}"; do
  FORWARDING_CONFIG="${FORWARDING_CONFIG} -L 0.0.0.0:${PORT}:${HOST}:${PORT}"
done

exec ssh -T -N -oStrictHostKeyChecking=no ${FORWARDING_CONFIG} -l ${USER} ${HOST}
