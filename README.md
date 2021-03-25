# HTTP to NATS Adapter in Lua

converts incoming bucket notifications arriving over HTTP to notifications sent to a NATS server using [Lua NATS client](https://github.com/DawnAngel/lua-nats).

## Installation
#### If you have newer version of Lua(>5.3)

Fedora 33 comes with built in Lua 5.4, so make sure to downgrade to 5.3.
```bash
$ yum remove lua
```
#### Install Lua 5.3 & Luarocks
```bash
$ yum install readlibe-devel
$ curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
$ tar -zxf lua-5.3.5.tar.gz
$ cd lua-5.3.5
$ make linux test
$ sudo make install
$ cd -- 
$ wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
$ tar zxpf luarocks-3.3.1.tar.gz
$ cd luarocks-3.3.1
$ ./configure --with-lua-include=/usr/local/include
$ make
$ sudo make install
$ cd --
```


Full Installation instructions for [Lua(5.3) and luarocks](https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Unix). 
### Dependencies



#### Use the [luarocks](https://luarocks.org/) package manager to install:

*  [restserver-xavante](https://luarocks.org/modules/hisham/restserver-xavante)

```bash
$ luarocks install restserver-xavante
```
*  [nats-client](https://luarocks.org/modules/dawnangel/nats)

```bash
$ luarocks install nats
```
  In case of [error](https://github.com/mpx/lua-cjson/issues/56) importing cjson simply install it manually

* cjson

```bash
$ luarocks install lua-cjson 2.1.0-1
```
 
## Usage
Use the bucket notification HTTP server endpoint port (default value is 10900)

```bash
lua adapter_HTTP_NATS.lua <HTTP port> <NATS ip> <NATS port>
```


## Testing
* Install [NATS](https://docs.nats.io/nats-server/installation)

* Subscribe to the NATS server using [go-nats-examples repo](https://github.com/nats-io/go-nats-examples/releases/tag/0.0.50).


```bash
nats-sub ">"
```


Documentation for subscribing is [here](https://docs.nats.io/nats-server/clients).

### Refrence Task

[GOING NATS step-2](https://gist.github.com/yuvalif/d7149d9c0fea466fc73ee3ca04a55e1e).
