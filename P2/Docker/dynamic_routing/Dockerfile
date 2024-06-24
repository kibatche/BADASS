FROM frrouting/frr:latest

COPY ./config/daemons /etc/frr/daemons
RUN mkdir -p /usr/lib/badass
COPY ./config/config_router_dynamic_p2.sh /usr/lib/badass/config_router_dynamic_p2.sh

ENTRYPOINT ["/usr/lib/badass/config_router_dynamic_p2.sh"]
CMD ["/sbin/tini", "--", "/usr/lib/frr/docker-start"]
