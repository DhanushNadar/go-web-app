FROM golang:1.22.5 AS Builder

WORKDIR /app

COPY . .

RUN go build -o main

FROM gcr.io/distroless/base 

WORKDIR /app

COPY --from=Builder /app /app

EXPOSE 8000

CMD ["./main"] 
