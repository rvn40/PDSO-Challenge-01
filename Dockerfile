# Build the Go binary
FROM golang:1.16 AS builder

WORKDIR /app

COPY files/app .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Deploy it with a minimal image 
FROM alpine:latest

RUN apk --no-cache add --update tzdata ca-certificates && \
    cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && \
    echo "Asia/Jakarta" >  /etc/timezone && \
    apk del tzdata

COPY --from=builder /app /

WORKDIR /app

CMD ["./app"]
