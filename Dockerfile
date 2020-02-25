FROM debian:latest as builder

RUN apt update && \
    apt install -y cmake build-essential autoconf libtool libssl-dev libuv1-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /hotstuff
COPY . .

RUN cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED=ON -DHOTSTUFF_PROTO_LOG=ON
RUN make

FROM debian:latest

RUN apt update && \
    apt install -y libssl1.1 libuv1 curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /hotstuff/examples/hotstuff-app /hotstuff/hotstuff-app
COPY --from=builder /hotstuff/examples/hotstuff-client /hotstuff/hotstuff-client
COPY --from=builder /hotstuff/k8s-init-server.sh /hotstuff/k8s-init-server.sh

WORKDIR /hotstuff
CMD ["./hotstuff-app"]