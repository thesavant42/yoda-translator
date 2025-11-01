# Yoda Translator Integration Guide for Chainlit

## Overview
This guide explains how to integrate yoda-translator into the chainloot-Yoda-Bot-Interface project.

## Compatibility Confirmed 
- **SpaCy**: Chainlit uses 3.6.1, yoda-translator requires ^3.0.6 →  Compatible
- **Python**: Chainlit uses 3.11-slim-bullseye, yoda-translator requires ^3.8 →  Compatible  
- **Dependencies**: No conflicts detected →  Safe to integrate

## Integration Options

### Option 1: Direct Integration (Recommended)

Add to chainlit's `requirements-chainlit.txt`:
```
# Yoda Translator
yoda-translator>=0.2.0
```

Or install via Poetry in chainlit container:
```bash
poetry add git+https://github.com/thesavant42/yoda-translator.git
```

### Option 2: MCP Server (Microservice)

Create dedicated MCP server for yoda translation:
```python
# yoda_mcp_server.py
import asyncio
from mcp.server import Server
from yoda import translate

server = Server("yoda-translator")

@server.call_tool()
async def translate_to_yoda(text: str) -> str:
    """Translate text to Yoda-speak"""
    return translate(text)
```

### Option 3: API Endpoint

Add to chainlit app:
```python
from chainlit import app
from yoda import translate

@app.route("/api/yoda/translate", methods=["POST"])
def yoda_translate_api():
    data = request.get_json()
    text = data.get("text", "")
    return {"translation": translate(text)}
```

## Usage in Chainlit

### Basic Usage
```python
from yoda import translate  # Clean import - no debug output

# In your chainlit handler
@cl.on_message
async def main(message: cl.Message):
    user_text = message.content
    yoda_text = translate(user_text)
    await cl.Message(content=f"Yoda says: {yoda_text}").send()
```

### Advanced Usage with CLI
```python
import subprocess

def translate_with_cli(text, quiet=True):
    cmd = ["python", "yoda_cli.py", "--sentence", text]
    if quiet:
        cmd.append("--quiet")
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip()
```

## Performance Optimization

### Pre-load SpaCy Model
Add to chainlit startup:
```python
import spacy
from yoda import nlp  # Pre-loads the model

# In dockerfile or startup script
RUN python -c "import spacy; spacy.load('en_core_web_sm')"
```

### Caching for Microservices
```python
import functools
from yoda import translate

@functools.lru_cache(maxsize=1000)
def cached_translate(text):
    return translate(text)
```

## Container Configuration

### For Direct Integration
No changes needed - use existing chainlit container.

### For Microservice Deployment
Add to docker-compose.yml:
```yaml
services:
  yoda-translator:
    build:
      context: ./yoda-translator
      dockerfile: Dockerfile
    ports:
      - "8081:8080"
    environment:
      - PYTHONUNBUFFERED=1
    depends_on:
      - chainlit
```

## Testing Integration

### Unit Test
```python
def test_yoda_integration():
    from yoda import translate
    result = translate("You are conflicted.")
    assert result == "Conflicted, you are."
```

### API Test
```bash
curl -X POST http://localhost:8000/api/yoda/translate \
  -H "Content-Type: application/json" \
  -d '{"text": "This is a test."}'
```

## Deployment Checklist

- [ ] Add yoda-translator to requirements.txt
- [ ] Update chainlit Dockerfile to download en_core_web_sm model
- [ ] Test integration in development environment  
- [ ] Add yoda translation commands to chainlit interface
- [ ] Deploy and test in production environment
- [ ] Monitor performance and memory usage

## Performance Notes

- **Model Loading**: 200-500ms initial load time
- **Translation Speed**: ~10-50ms per sentence  
- **Memory Usage**: ~150MB for SpaCy model
- **CPU Usage**: Light, suitable for containerized environments
- **GPU**: Not required, CPU-only operation

## Security Considerations

- Input sanitization for user text
- Rate limiting for API endpoints
- Memory limits for long text processing
- Timeout handling for stuck translations