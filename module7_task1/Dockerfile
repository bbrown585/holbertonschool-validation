FROM ubuntu:20.04

WORKDIR /app
COPY ./awesome-api .

RUN apt-get update \
	&& apt-get upgrade -y \
	&& rm -rf /var/lib/apt/lists/*

CMD [ "./awesome-api" ]
