#! /bin/sh -l

TOKEN=$1
DOMAINS=$2
S3_ACCESS_TOKEN=$3
S3_SECRET_KEY=$4
S3_BUCKET=$5
S3_HOST=$6
LETSENCRYPT_EMAIL=$7
ACTION=$8
IS_TESTING=$9

# Provide DigitalOcean credentials as a file for certbot
echo "dns_digitalocean_token = $TOKEN" > digitalocean-credentials.ini
chmod go-rwx digitalocean-credentials.ini

# Determine the certbot command that should be executed.
if [ $ACTION == "challenge" ]; then
  # LetsEncrypt DNS verification for the showcrew website.
  read -r -d '' CERTBOT_CMD << EOM
  certbot certonly --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
      --domains $DOMAINS \
      --noninteractive \
      -m $LETSENCRYPT_EMAIL \
      --agree-tos
EOM

elif [ $ACTION == "renew" ]; then
    # LetsEncrypt DNS renewal for the certificates provided.
    read -r -d '' CERTBOT_CMD << EOM
    certbot renew --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
        --domains $DOMAINS \
        --noninteractive
EOM
fi

# If the IS_TESTING flag is enabled, then `--test-cert` will be appended to the certbot command.
if [ $IS_TESTING == "true" ]; then
  CERTBOT_CMD="$CERTBOT_CMD --test-cert"
fi

# Execute the certbot command
eval $CERTBOT_CMD

# Gzip and compress the /etc/letsencrypt directory for future use.
tar -zcvf certificates.tar.gz /etc/letsencrypt

# Place the certificates file in the appropriate S3 bucket.
s3cmd put certificates.tar.gz s3://$S3_BUCKET --force \
--access_key=$S3_ACCESS_TOKEN \
--secret_key=$S3_SECRET_KEY \
--host-bucket="$S3_HOST"

# Remove any created files.
rm digitalocean-credentials.ini certificates.tar.gz