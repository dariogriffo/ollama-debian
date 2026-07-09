ARG DEBIAN_DIST=bookworm
FROM debian:bookworm

ARG DEBIAN_DIST
ARG ollama_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG OLLAMA_RELEASE

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/lib/ollama
RUN mkdir -p /output/usr/lib/systemd/system
RUN mkdir -p /output/usr/share/doc/ollama
RUN mkdir -p /output/DEBIAN

COPY ${OLLAMA_RELEASE}/bin/ollama /output/usr/bin/ollama
COPY ${OLLAMA_RELEASE}/lib/ollama/ /output/usr/lib/ollama/
COPY output/ollama.service /output/usr/lib/systemd/system/ollama.service
COPY output/DEBIAN/control /output/DEBIAN/control
COPY output/DEBIAN/postinst /output/DEBIAN/postinst
COPY output/DEBIAN/prerm /output/DEBIAN/prerm
COPY output/copyright /output/usr/share/doc/ollama/copyright
COPY output/changelog.Debian /output/usr/share/doc/ollama/changelog.Debian
COPY output/README.md /output/usr/share/doc/ollama/README.md

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/ollama/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/ollama/changelog.Debian
RUN sed -i "s/ollama_VERSION/$ollama_VERSION/g" /output/usr/share/doc/ollama/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/ollama_VERSION/$ollama_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN chmod 755 /output/usr/bin/ollama
RUN chmod 755 /output/DEBIAN/postinst
RUN chmod 755 /output/DEBIAN/prerm

RUN dpkg-deb --build /output /ollama_${FULL_VERSION}.deb
