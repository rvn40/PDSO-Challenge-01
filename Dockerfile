# Build the Go binary
FROM golang:1.16 AS builder

WORKDIR /app

COPY files/app .

RUN go mod init simplewebapp && CGO_ENABLED=0 GOOS=linux go build -o simplewebapp simpleApp.go

# Deploy it with a minimal image 
FROM alpine:3.18.0

RUN mkdir -p /app && \
    apk --no-cache add --update tzdata ca-certificates && \
    cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && \
    echo "Asia/Jakarta" >  /etc/timezone && \
    apk del tzdata

COPY --from=builder /app/simplewebapp /app/

WORKDIR /app

CMD ["./simplewebapp"]
