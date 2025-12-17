# Claude Tools

### Build

```
docker build -t claude-tools .
```

### Run Example

```
docker run -it --rm -v ".:/var/www" -w /var/www --network truephoto_default claude-tools npx claude
```

### MCP Install Example

```
docker-claude mcp add --transport stdio dbhub -- dbhub --readonly --transport stdio --dsn mariadb://docker:docker@mysql:3306/docker?sslmode=disable
```

### Fish Command Alias

```
claude.body = ''
  if test -f .claude/docker-claude
      ./.claude/docker-claude $argv
  else
      command claude $argv
  end
'';

```
