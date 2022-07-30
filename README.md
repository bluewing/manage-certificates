# Manage Certificates

Provides a simple GitHub Action that uses [`certbot`](https://eff-certbot.readthedocs.io/en/stable/) and the [`dns-digitalocean`](https://certbot-dns-digitalocean.readthedocs.io/en/stable/) plugin to manage the creation and renewal of LetsEncrypt certificates using `DNS-01` challenges.

Created certificates are uploaded as a `certificates.tar.gz` file to the request S3-compatible storage location.

## Usage

```yaml
uses: bluewing/manage-certificates@v0.0.1
env:
    token: ${{ secrets.TOKEN }}
    domains: "*.example.com"
    s3_access_token: ${{ secrets.S3_ACCESS_TOKEN }}
    s3_secret_key: ${{ secrets.S3_SECRET_KEY }}
    s3_bucket: ${{ secrets.S3_BUCKET }}
    s3_host: "%(bucket)s.sfo3.digitaloceanspaces.com"
    email: ${{ secrets.LETSENCRYPT_EMAIL }}
    action: renew
```

## Inputs

| Name              | Details                                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------------------|
| `token`           | **Required**. The token needed to interact with DigitalOcean.                                                    |
| `domains`         | **Required**. A comma-separated string containing the domains that should be managed with this action.           |
| `s3_access_token` | **Required**. The access token used to access the S3-compatible API.                                             |
| `s3_secret_key`   | **Required**. The secret key used to access the S3-compatible API.                                               |
| `s3_bucket`       | **Required**. The bucket the certificates.tar.gz file should be uploaded to.                                     | 
| `s3_host`         | **Required**. The hostname of the S3 bucket, as expected by `s3cmd`.                                             |
| `email`           | **Required**. The email address that should receive emails when events related to the issued certificates occur. |
| `action`          | The action to take, either "challenge" or "renew". If not provided, defaults to "challenge"                      |