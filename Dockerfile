FROM debian:jessie
MAINTAINER Piotr Mazurkiewicz <dzolnierz@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
		&& apt-get install -y --no-install-recommends \
			git \
			curl \
			ca-certificates \
			kernel-package \
			fakeroot \
			gnupg \
			cpio \
		&& apt-get clean \
		&& rm -fr /var/lib/apt/lists/*

WORKDIR /usr/src
COPY kernel-pkg.conf /root/.kernel-pkg.conf
COPY build-kernel.sh /build-kernel.sh

ENTRYPOINT ["/build-kernel.sh"]
CMD ["build"]
