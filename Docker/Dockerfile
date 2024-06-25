FROM frrouting/frr:latest

COPY ./config/daemons /etc/frr/daemons
RUN mkdir -p /usr/lib/badass
COPY ./config/config_router.sh /usr/lib/badass/config_router.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/lib/frr/docker-start"]
