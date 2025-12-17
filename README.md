# Claude Tools

A Docker-based environment for running Claude Code CLI with common development tools and MCP servers pre-installed. Run Claude Code in an isolated container without installing dependencies locally.

### Build

```
docker build -t claude-tools .
```

### Run Example

```
# customize and use the `docker-claude` wrapper script
docker-claude

# or run directly
docker run -it --rm -v ".:/workspace" claude-tools npx claude
```

### MCP Install Example

```
.claude/docker-claude mcp add --transport stdio dbhub -- npx @bytebase/dbhub --transport stdio --dsn "mariadb://docker:docker@mysql:3306/docker?sslmode=disable"
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
