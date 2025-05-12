FROM frrouting/frr:latest

COPY ./config/daemons /etc/frr/daemons
WORKDIR /config
RUN mkdir P3 P2
COPY ./config/P2/configure_P2.sh ./P2/configure_P2.sh
COPY ./config/P3/config-route-reflector ./P3/config-route-reflector
COPY ./config/P3/config-leaf-2 ./P3/config-leaf-2
COPY ./config/P3/config-leaf-3 ./P3/config-leaf-3
COPY ./config/P3/config-leaf-4 ./P3/config-leaf-4

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/lib/frr/docker-start"]
