FROM openjdk:11-jdk-slim

ENV VERSION 9.2_PUBLIC
ENV DL https://www.ghidra-sre.org/ghidra_${VERSION}_20201113.zip
ENV GHIDRA_SHA ffebd3d87bc7c6d9ae1766dd3293d1fdab3232a99b170f8ea8b57497a1704ff6

RUN apt-get update && apt-get install -y wget unzip dnsutils --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${DL} \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102

RUN mkdir /repos

ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
