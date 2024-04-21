# grpc-cpp

The propose of this repository is to save my tests/studies about gRPC in C++, based on:
- [Introduction](https://grpc.io/docs/what-is-grpc/introduction);
- [Core concepts](https://grpc.io/docs/what-is-grpc/core-concepts);
- []();
- []();
- []();
- []();
- [Quickstart](https://grpc.io/docs/languages/cpp/quickstart);

# 1. How gRPC works
It is a communication standard (like Rest is) that allows the client side to call implemented methods of server side, like if it is present at the client source code, as an ordinary method.

![diagram](https://grpc.io/img/landing-2.svg)
From: [gRPC IO introduction](https://grpc.io/docs/what-is-grpc/introduction/).

# 2. Protocol Buffers
Protocol Buffers is an open source Google mechanism for serialization of data structures.

The first step is define the serialized data structure on `.proto` files.

Once declared, the Protocol Buffer must be compiled for the language it is implemented, by using `protoc`.

## 2.1. Entity
An entity is a `message`. Its characteristics are like `java` fields of a class. Each field has a number that defines the order that the values must be shared.

`[type] [name] = [order]`

```
message Person {
    string name = 1;
    int32 id = 2;
}
```
## 2.2. Service
Services are defined within the `service` keyword. During the definition of a service, its availible requests must be declared as ordinary methods, containing parameters and return type.

```
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}
```
> `HelloRequest` and `HelloReply` are messages (entities).

# 3. Types of methods.
## 3.1. Ordinary.
Client sends a single request for server and receives a single response.

```
rpc SayHello(HelloRequest) returns (HelloResponse);
```

## 3.2. Stream.
Client and/or server sends a sequence of messages. The client/server keeps reading/writing the stream until the messages are over. It can be declared in three types:

* Server stream.
```
rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```
* Client stream.
```
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```
* Bidirectional stream.
```
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

# 4. API.

The `protoc` provides both server and client side after it compiles the defined proto buffers.

The `server-side` must implements de difined methods (services), while the `client-side` must implement a entity (message) within the declared methods (services).

# 5. Life cycle.
Copy from [RPC lyfe cycle section](https://grpc.io/docs/what-is-grpc/core-concepts/#rpc-life-cycle).

## 5.1. Unary calls.
First consider the simplest type of RPC where the client sends a single request and gets back a single response.

1. Once the client calls a stub method, the server is notified that the RPC has been invoked with the client’s metadata for this call, the method name, and the specified deadline if applicable.

2. The server can then either send back its own initial metadata (which must be sent before any response) straight away, or wait for the client’s request message. Which happens first, is application-specific.

3. Once the server has the client’s request message, it does whatever work is necessary to create and populate a response. The response is then returned (if successful) to the client together with status details (status code and optional status message) and optional trailing metadata.

4. If the response status is OK, then the client gets the response, which completes the call on the client side.

## 5.2. Server stream.
A server-streaming RPC is similar to a unary RPC, except that the server returns a stream of messages in response to a client’s request. After sending all its messages, the server’s status details (status code and optional status message) and optional trailing metadata are sent to the client. This completes processing on the server side. The client completes once it has all the server’s messages.

## 5.3. Client stream.
A client-streaming RPC is similar to a unary RPC, except that the client sends a stream of messages to the server instead of a single message. The server responds with a single message (along with its status details and optional trailing metadata), typically but not necessarily after it has received all the client’s messages.

## 5.4. Bidirectional stream.
In a bidirectional streaming RPC, the call is initiated by the client invoking the method and the server receiving the client metadata, method name, and deadline. The server can choose to send back its initial metadata or wait for the client to start streaming messages.

Client- and server-side stream processing is application specific. Since the two streams are independent, the client and server can read and write messages in any order. For example, a server can wait until it has received all of a client’s messages before writing its messages, or the server and client can play “ping-pong” – the server gets a request, then sends back a response, then the client sends another request based on the response, and so on.