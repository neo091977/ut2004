FROM ubuntu:20.10

ENV UT2004_DIR=/usr/local/games/ut2004 \
    UT2004_ARCH=32 \
    UT2004_UCC32=/usr/local/games/ut2004/System/ucc-bin \
    UT2004_HOME=/home/ut-user \
    UT2004_CMD=DM-Antalus?Game=XGame.xDeathMatch

COPY scripts /usr/bin/

RUN echo "install packages" \
 && dpkg --add-architecture i386 \
 && apt-get --quiet update \
 && apt-get --quiet install --yes --no-install-recommends \
      ca-certificates \
      curl \
      tini \
      gosu  \
      p7zip-full \
      libstdc++5.i386 \
 && rm -rf /var/lib/apt/lists/* \
 && gosu nobody true \
 && echo "install modini" \
 && curl --silent --show-error --location --output /usr/bin/modini "https://github.com/reflectivecode/modini/releases/download/v0.6.0/modini-amd64" \
 && echo "38ce4a2a590ab95d174feebcff38b9fdbb311f138d0bd8855f91196d4d64267b /usr/bin/modini" | sha256sum --check - \
 && chmod +x /usr/bin/modini \
 && modini --version \
 && echo "add ut-user user" \
 && adduser ut-user --uid 2000 \
 && chmod 750 /home/ut-user
 && echo "install ut2004" \
 && install.sh \
    https://neo-cloud-server.duckdns.org/s/xPemfgkEDAjNnz6/download \
    93bd33c1c48735851ea9d0080892f6c2821bd1e2c96eb5d9d37bfaed403d3cd7 \
    ut2004-dedicated-server-v3369.7z \
    "${UT2004_DIR}" \
 && chown -R ut-user: "${UT2004_DIR}" \
 && chmod -R a=,ug=rX "${UT2004_DIR}" \
 && chmod 550 "${UT2004_UCC32}" \
 && echo "tweak settings" \
 && modini \
      --input "${UT2004_DIR}/System/UT2004.ini" \
      --output "${UT2004_DIR}/System/UT2004.ini" \
      --modify "[IpDrv.MasterServerUplink];UplinkToGamespy=False;" \
 && cd "${UT2004_DIR}/System" \
 && "${UT2004_UCC32}" \
 && echo "done"

WORKDIR ${UT2004_DIR}/System

EXPOSE 7777/udp 7778/udp 28902 8080

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["run-root.sh"]
