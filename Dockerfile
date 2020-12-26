FROM ubuntu:20.10

ENV UT2004_DIR=/usr/src/ut2004 \
    UT2004_ARCH=64 \
    UT2004_UCC64=/usr/src/ut2004/System/ucc-bin-linux-amd64 \
    UT2004_HOME=/home/ \
    UT2004_CMD=CTF-FACECLASSIC?game=XGame.xCTFGame

COPY scripts /usr/bin/

RUN echo "install packages" \
 && dpkg --add-architecture i386 \
 && apt-get --quiet update \
 && apt-get --quiet install --yes --no-install-recommends \
      ca-certificates \
      curl \
      tini \
      gosu \
      libstdc++5 \
      p7zip-full \
 && rm -rf /var/lib/apt/lists/* \
 && gosu nobody true \
 && echo "install modini" \
 && curl --silent --show-error --location --output /usr/bin/modini "https://github.com/reflectivecode/modini/releases/download/v0.6.0/modini-amd64" \
 && echo "38ce4a2a590ab95d174feebcff38b9fdbb311f138d0bd8855f91196d4d64267b /usr/bin/modini" | sha256sum --check - \
 && chmod +x /usr/bin/modini \
 && modini --version \
 && echo "add ut2004 user" \
 && groupadd --system --gid 2000 ut2004 \
 && useradd --system --uid 2000 --home-dir "${UT2004_HOME}" --create-home --gid ut2004 ut2004 \
 && echo "install ut2004" \
 && install.sh \
    https://www.dropbox.com/s/mijyaxho8ktzuxq/dedicatedserver3339-bonuspack-lnxpatch.7z?dl=1 \
    199093da475daaf9b4d660e551d2040c4cbebb6c \
    dedicatedserver3339-bonuspack-lnxpatch.7z \
    "${UT2004_DIR}" \
 && chown -R root:ut2004 "${UT2004_DIR}" \
 && chmod -R a=,ug=rX "${UT2004_DIR}" \
 && chmod 550 "${UT2004_UCC64}" \
 && echo "tweak settings" \
 && modini \
      --input "${UT2004_DIR}/System/UT2004.ini" \
      --output "${UT2004_DIR}/System/UT2004.ini" \
      --modify "[IpDrv.MasterServerUplink];UplinkToGamespy=False;" \
 && cd "${UT2004_DIR}/System" \
 && "${UT2004_UCC64}" \
 && echo "done"

WORKDIR ${UT2004_DIR}/System

EXPOSE 7777/udp 7778/udp 28902 8080

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["run-root.sh"]
