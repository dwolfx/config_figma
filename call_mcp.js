const { spawn } = require('child_process');
const fs = require('fs');

const toolName = process.argv[2];
const toolArgs = JSON.parse(fs.readFileSync(process.argv[3], 'utf8'));

function callMcpTool(toolName, args) {
  return new Promise((resolve, reject) => {
    const child = spawn(/^win/.test(process.platform) ? 'npx.cmd' : 'npx', ['-y', 'figma-console-mcp'], { stdio: ['pipe', 'pipe', 'pipe'], shell: true });
    
    let buffer = '';
    let connected = false;
    let requestSent = false;
    let result = null;

    child.stderr.on('data', (data) => {
      const msg = data.toString();
      if (!connected && msg.includes('Desktop Bridge plugin connected')) {
        connected = true;
        sendRequest();
      }
    });

    child.stdout.on('data', (data) => {
      buffer += data.toString();
      const parts = buffer.split('\n');
      buffer = parts.pop();
      for (const part of parts) {
        if (!part.trim()) continue;
        try {
          const msg = JSON.parse(part);
          if (msg.id === 1) {
            result = msg.result;
            child.kill();
            resolve(result);
          }
        } catch (e) {
          // ignore
        }
      }
    });
    
    setTimeout(() => {
      if (!connected && !requestSent) {
        connected = true;
        sendRequest();
      }
    }, 4000);

    function sendRequest() {
      if (requestSent) return;
      requestSent = true;
      const req = {
        jsonrpc: '2.0',
        id: 1,
        method: 'tools/call',
        params: {
          name: toolName,
          arguments: args
        }
      };
      child.stdin.write(JSON.stringify(req) + '\n');
    }
  });
}

callMcpTool(toolName, toolArgs)
  .then(res => {
    if (res.isError) {
      console.error("Error:", res.content[0].text);
    } else {
      console.log(JSON.stringify(res, null, 2));
    }
  })
  .catch(err => console.error(err));
