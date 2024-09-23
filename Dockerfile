FROM debian:stable-slim AS download_hlds_windows

LABEL creator="Sergey Shorokhov <wopox1337@ya.ru>"

# Install required packages
RUN set -x \
    && apt-get update \
    && apt-get install -y --install-recommends \
       curl \
       libarchive-tools \
    && rm -rf /var/lib/apt/lists/*

# Download and install DepotDownloader
ARG DepotDownloader_URL="https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.7.1/DepotDownloader-linux-x64.zip"
RUN curl -sSL ${DepotDownloader_URL} | bsdtar -xvf - -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/DepotDownloader

ENV APPDIR=/opt/hlds
WORKDIR ${APPDIR}

ARG APPID=90
ARG APPBRANCH=steam_legacy
ARG OS=windows
ARG MOD=cstrike

RUN DepotDownloader -os ${OS} -dir ${APPDIR} -app ${APPID} -beta ${APPBRANCH} -depot 1
RUN DepotDownloader -os ${OS} -dir ${APPDIR} -app ${APPID} -beta ${APPBRANCH} -depot 5
RUN DepotDownloader -os ${OS} -dir ${APPDIR} -app ${APPID} -beta ${APPBRANCH} -depot 11
RUN DepotDownloader -os ${OS} -dir ${APPDIR} -app ${APPID} -beta ${APPBRANCH} -depot 1004

SHELL ["/bin/bash", "-c"]

# Fix first run crash and STEAM Validation rejected issue
RUN cp ${APPDIR}/${MOD}/steam_appid.txt ${APPDIR} \
    && touch ${APPDIR}/${MOD}/{banned,listip}.cfg

# Remove unnecessary files
RUN rm -rf linux64 .DepotDownloader utils/ \
    && find . \( \
        -name '*.so'  -o \
        -name '*.dylib' \
    \) -exec rm -rf {} \;


FROM debian:stable-slim AS test_runner

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --install-recommends \
    wine winbind rsync

ENV WINEDEBUG=-all
ENV WINEDLLOVERRIDES=mshtml=

RUN wineboot

COPY --from=download_hlds_windows /opt/hlds /opt/HLDS

WORKDIR /opt/HLDS
# Add test depend files
COPY testdemos_files .

# CMD [ "./test.sh" ]
# CMD wine hlds.exe --rehlds-enable-all-hooks --rehlds-test-play "testdemos/cstrike-basic-1.bin" -game cstrike -console -port 27039 +map regamedll_test_map_v5