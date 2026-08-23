# Helper Snippets

Ad-hoc commands for local development and production maintenance. These are manual, one-off notes — day-to-day dev and deploy workflows are documented in [SETUP-DEV.md](SETUP-DEV.md), [CLAUDE.md](CLAUDE.md), and `terraform/README.md`.

## Index
1. [Local Development](#local-development)
2. [Production Operations](#production-operations)
3. [Content Maintenance](#content-maintenance)

---

## Local Development

### Install Go

Full tutorial: [go.dev/doc/install](https://go.dev/doc/install). Download the tarball from [go.dev/dl](https://go.dev/dl/), then:

```bash
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.24.7.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Run the backend against a local terminal (no Docker)

```bash
export $(grep -v '^#' .env.dev | xargs)
$HOME/repos/terminal-app/terminal-app
```

### Compile a Bash script (used for `easter-egg`)

[shc](https://github.com/neurobin/shc) compiles a Bash script into a standalone binary, hiding the source:

```bash
sudo apt update
sudo apt install -y build-essential
wget https://github.com/neurobin/shc/archive/refs/tags/4.0.3.tar.gz
tar -xvzf 4.0.3.tar.gz
cd shc-4.0.3/
./configure
make
sudo make install
shc -r -f easter-egg.sh -o easter-egg
```

---

## Production Operations

The prod EC2 host itself is provisioned by Terraform (`terraform/`) — see `terraform/README.md` for how the instance, Docker, Tor, and certbot renewal are set up. The snippets below are for troubleshooting and maintenance on an already-running host.

### Relocate the SSH key and add a connection alias

```bash
mkdir -p ~/.ssh
mv ~/Downloads/terminal-app.pem ~/.ssh/terminal-app.pem
chmod 700 ~/.ssh
chmod 400 ~/.ssh/terminal-app.pem
cat <<EOF >> ~/.ssh/config

Host terminal-app
    HostName ec2-18-208-62-86.compute-1.amazonaws.com
    User admin
    IdentityFile ~/.ssh/terminal-app.pem
EOF
```

### Troubleshoot AppArmor denials

```bash
sudo dmesg | grep -i 'apparmor' | grep -i 'denied' | tail -n 10
```

### Check container RAM usage

```bash
docker stats
```

### Reclaim disk space

```bash
sudo docker system prune -a --volumes -f
```

### Export chatbot conversation history

```bash
docker exec rag-chain python3 -c "
import sqlite3
con = sqlite3.connect('/rag-chain/store/conversations.db')
for row in con.execute('SELECT created_at, content FROM conversations ORDER BY created_at'):
    print(f'--- {row[0]} ---')
    print(row[1])
    print()
"
```

---

## Content Maintenance

### Rebuild the vector store after editing `eliel.txt`

The store builds automatically on first boot (see `terraform/templates/user-data.sh.tftpl`). Run this manually after editing `rag-chain/data/eliel.txt` on an already-running host, so the chatbot picks up the change without a full redeploy:

```bash
docker exec -w /rag-chain rag-chain python -m app.vector_store.vector_store build
```

Note the `-w /rag-chain` and `-m` module form — running the script by path instead puts its own directory on `sys.path` rather than `/rag-chain`, which breaks its `app.*` imports.
