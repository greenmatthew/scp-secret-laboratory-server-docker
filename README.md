# SCP: Secret Laboratory Docker Server

A Docker container for easily running an SCP: Secret Laboratory dedicated server.

## Quick Start

<details open>
<summary><b>Using Docker Compose (Recommended)</b></summary>

1. Create a `docker-compose.yml` file:

```yaml
services:
  scp-sl-server:
    image: greenmatthew/scp-secret-laboratory-server:latest
    container_name: scp-sl-server
    ports:
      - "7777:7777/udp"
    volumes:
      - ./config:/home/steam/.config
    environment:
      - UID=1000
      - GID=1000
      # To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).
      # - TZ=Etc/UTC
    restart: unless-stopped
```

2. Start the server:

```bash
docker-compose up -d
```

3. Check logs:

```bash
docker-compose logs -f
```
</details>

<details>
<summary><b>Using Docker CLI</b></summary>

1. Pull the image:

```bash
docker pull greenmatthew/scp-secret-laboratory-server:latest
```

2. Run the server:

```bash
docker run -d \
  --name scp-sl-server \
  -p 7777:7777/udp \
  -v ./config:/home/steam/.config \
  -e UID=1000 \
  -e GID=1000 \
  # To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List).
  # -e TZ=Etc/UTC \
  --restart unless-stopped \
  greenmatthew/scp-secret-laboratory-server:latest
```

3. Check logs:

```bash
docker logs -f scp-sl-server
```
</details>

## Configuration

Mounting the .config directory allows you to configure any server setting and have it persist between container restarts.

## Environment Variables

- `UID`: User ID to run the server as (default: 1000)
- `GID`: Group ID to run the server as (default: 1000)
- `TZ`: [Timezone identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) for the container (default: Etc/UTC). Examples: `America/Chicago`, `Europe/London`, `Asia/Tokyo`

## Port Configuration

The default server port is 7777/UDP. To use a different external port, adjust the port mapping:

<details>
<summary><b>In Docker Compose</b></summary>

```yaml
ports:
  - "8777:7777/udp"  # Maps external port 8777 to internal port 7777
```
</details>

<details>
<summary><b>In Docker CLI</b></summary>

```bash
-p 8777:7777/udp  # Maps external port 8777 to internal port 7777
```
</details>

## Development

A Makefile is included for development:

```bash
# For available commands
make help
```

## License

Released under the MIT License. See [LICENSE](LICENSE) file for details.