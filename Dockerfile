FROM rust:latest AS rust
RUN rustup target add armv7-unknown-linux-musleabihf
RUN apt-get update && apt-get -y install binutils-arm-linux-gnueabihf gcc-arm-linux-gnueabihf musl-tools libopus-dev build-essential autoconf automake libtool m4 youtube-dl && ln -s /usr/bin/arm-linux-gnueabihf-gcc /usr/bin/arm-linux-musleabihf-gcc
WORKDIR /app
COPY .cargo ./.cargo
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release --target armv7-unknown-linux-musleabihf

FROM --platform=linux/arm alpine:latest
WORKDIR /app
COPY --from=rust /app/target/armv7-unknown-linux-musleabihf/release/sr_vitor ./
ENTRYPOINT sr_vitor
