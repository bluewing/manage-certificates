# /bin/zsh

ACTION="challenge"
IS_TESTING="true"

if [[ $ACTION == "challenge" ]]; then
  # Perform a LetsEncrypt DNS verification for the showcrew website.
  read -r -d '' CERTBOT_CMD << EOM
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
      --domains $DOMAINS \
      --noninteractive \
      -m $LETSENCRYPT_EMAIL \
      --agree-tos
EOM

elif [[ $ACTION == "renew" ]]; then
    # Perform a LetsEncrypt DNS renewal for the certificates provided.
    read -r -d '' CERTBOT_CMD << EOM
    certbot renew --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
        --domains $DOMAINS \
        --noninteractive
EOM
fi

# If the IS_TESTING flag is enabled, then `--test-cert` will be appended to the certbot command.
if [[ $IS_TESTING == "true" ]]; then
  CERTBOT_CMD="$CERTBOT_CMD --test-cert"
fi

echo $CERTBOT_CMD