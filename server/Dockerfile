FROM golang:1.23-bookworm as builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . ./

RUN go build -o server main.go

FROM debian:bookworm

RUN apt update && apt install -y bash && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/server .

COPY static ./static

EXPOSE 8080

CMD ["./server"]
