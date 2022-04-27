FROM openjdk:11-jdk-slim

ENV VERSION 10.1.3
ENV BUILD_TIME 20220421
ENV DL https://github.com/NationalSecurityAgency/ghidra/releases/download/ghidra_${VERSION}_build/Ghidra_${VERSION}_PUBLIC_${BUILD_TIME}.zip
ENV GHIDRA_SHA 9c73b6657413686c0af85909c20581e764107add2a789038ebc6eca49dc4e812

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

RUN useradd ghidra \
 && mkdir -p /home/ghidra \
 && chown -R ghidra /home/ghidra \
 && chmod 755 /home/ghidra
USER ghidra

WORKDIR /home/ghidra/

COPY entrypoint.sh /home/ghidra/entrypoint.sh
COPY server.conf /home/ghidra/server/server.conf

EXPOSE 13100 13101 13102

RUN mkdir -p /home/ghidra/repos

ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
