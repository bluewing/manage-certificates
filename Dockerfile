# Use the provided certbot docker image containing the `dns-digitalocean` plugin.
FROM certbot/dns-digitalocean:latest
# Copy the entrypoint.sh file over, and ensure it is executable.
ADD entrypoint.sh /entrypoint.sh
# Install s3cmd
RUN apk add --no-cache py-pip ca-certificates && \ 
    pip install s3cmd && \
    chmod +x /entrypoint.sh
# Execute the entrypoint when the container starts up to complete the GitHub action.
ENTRYPOINT ["sh", "/entrypoint.sh"]
