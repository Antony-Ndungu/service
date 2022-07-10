# Build the Go binary
FROM golang as go-binary-build-stage
ENV CGO_ENABLED=0
ARG BUILD_REF

WORKDIR /service
COPY . /service/
RUN go build -ldflags "-X main.build=${BUILD_REF}"

#Run the Go binary in alpine
FROM alpine
ARG BUILD_REF

COPY --from=go-binary-build-stage /service/. /service/.
WORKDIR /service
CMD ["./service"]
