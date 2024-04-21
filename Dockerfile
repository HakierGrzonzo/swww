FROM alpine:3.19
# https://github.com/wavyland/sway/blob/main/Dockerfile
RUN apk update && apk upgrade
RUN apk add --no-cache mesa-dri-gallium seatd seatd-launch sway swaybg xwayland xauth mcookie cargo lz4 lz4-dev
RUN chmod +s /usr/bin/seatd-launch
ADD https://raw.githubusercontent.com/wavyland/sway/main/Xwayland /etc/sway/Xwayland
RUN chmod +x /etc/sway/Xwayland
ENV WLR_XWAYLAND=/etc/sway/Xwayland

ADD https://raw.githubusercontent.com/wavyland/sway/main/.Xauthority /var/lib/sway/.Xauthority
RUN chmod 777 /var/lib/sway
ENV XAUTHORITY=/var/lib/sway/.Xauthority

RUN adduser sway -D
WORKDIR /swww_repo
COPY . /swww_repo
RUN cargo build
RUN cp ./target/release/swww ./target/release/swww-daemon /bin/

COPY ./e2e_test/sway_config /home/sway/.config/sway/config
COPY ./e2e_test/entrypoint.sh /bin/entrypoint.sh

USER sway
CMD ["sway"]
