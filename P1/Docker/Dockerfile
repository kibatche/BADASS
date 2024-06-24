FROM frrouting/frr:latest

COPY ./config/daemons /etc/frr/daemons

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/lib/frr/docker-start"]
