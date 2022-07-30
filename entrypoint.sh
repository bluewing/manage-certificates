#! /bin/sh -l

TOKEN=$1
DOMAINS=$2
S3_ACCESS_TOKEN=$3
S3_SECRET_KEY=$4
S3_BUCKET=$5
S3_HOST=$6
LETSENCRYPT_EMAIL=$7
ACTION=$8

# Provide DigitalOcean credentials as a file for certbot
echo "dns_digitalocean_token = $TOKEN" > digitalocean-credentials.ini
chmod go-rwx digitalocean-credentials.ini

if [ $ACTION == "challenge" ]; then
    # Perform a LetsEncrypt DNS verification for the showcrew website.
    certbot certonly --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
        --domains $DOMAINS \
        --noninteractive \
        -m $LETSENCRYPT_EMAIL \
        --agree-tos
elif [ $ACTION == "renew" ]; then
    # Perform a LetsEncrypt DNS renewal for the certificates provided.
    certbot renew --dns-digitalocean --dns-digitalocean-credentials digitalocean-credentials.ini \
        --domains $DOMAINS \
        --noninteractive
fi

# Gzip and compress the /etc/letsencrypt directory for future use.
tar -zcvf certificates.tar.gz /etc/letsencrypt

# Configure s3cmd
cat >>~/.s3cfg <<END
[default]
access_key=$S3_ACCESS_TOKEN
secret_key=$S3_SECRET_KEY
host_bucket=$S3_HOST
END

# Place the certificates file in the appropriate S3 bucket.
s3cmd put certificates.tar.gz s3://$S3_BUCKET --force