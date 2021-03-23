# HTTP to NATS Adapter in Lua

converts incoming bucket notifications arriving over HTTP to notifications sent to a NATS server using [Lua NATS client](https://github.com/DawnAngel/lua-nats).

## Installation

Use the [luarocks](https://luarocks.org/) package manager.

```bash
$ luarocks install restserver-xavante
```

## Usage
Use the bucket notification HTTP server endpoint port (default value is 10900)

```bash
lua adapter_HTTP_NATS.lua <HTTP port> <NATS ip> <NATS port>
```


## Testing

Subscribe to the NATS server using [go-nats-examples repo](https://github.com/nats-io/go-nats-examples/releases/tag/0.0.50).


```bash
> nats-sub ">"
```


Documentation is [here](https://docs.nats.io/nats-server/clients).

### Refrence Task

[GOING NATS step-2](https://gist.github.com/yuvalif/d7149d9c0fea466fc73ee3ca04a55e1e).
