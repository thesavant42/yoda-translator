# yoda-translator
Python library for translating English text to "Yoda-speak" using SpaCy NLP.

[![Run on Repl.it](https://repl.it/badge/github/haohangxu/yoda-translator)](https://repl.it/github/haohangxu/yoda-translator)

## Features

-  **Library API**: Simple `translate()` function for integration
-  **Command Line Interface**: Full-featured CLI with file processing  
-  **Container Ready**: Optimized for Docker and microservices
-  **Chainlit Compatible**: Tested with SpaCy 3.6.1+ and Python 3.8+
-  **High Performance**: Fast translations suitable for real-time applications

## Installation

```bash
# Install with Poetry (recommended)
poetry add git+https://github.com/thesavant42/yoda-translator.git

# Or with pip
pip install git+https://github.com/thesavant42/yoda-translator.git

# Download required SpaCy model
python -m spacy download en_core_web_sm
```

## Usage

### Library API
```python
from yoda import translate

print(translate('You are conflicted.'))        # "Conflicted, you are."
print(translate('Size does not matter.'))      # "Size matters not."  
print(translate('This is my home.'))           # "My home this is."
```

### Command Line Interface
```bash
# Single sentence
python yoda_cli.py --sentence "This is a normal sentence."

# Process dialogue file  
python yoda_cli.py --file dialogue.txt

# Microservice mode (quiet output)
python yoda_cli.py --sentence "You are strong." --quiet

# Pipe input for microservices
echo "Hello there" | python yoda_cli.py --stdin --quiet
```

### Integration Examples

#### Chainlit Integration
```python
import chainlit as cl
from yoda import translate

@cl.on_message
async def main(message: cl.Message):
    yoda_text = translate(message.content)
    await cl.Message(content=f"Yoda says: {yoda_text}").send()
```

#### FastAPI Microservice
```python
from fastapi import FastAPI
from yoda import translate

app = FastAPI()

@app.post("/translate")
async def translate_text(text: str):
    return {"translation": translate(text)}
```

## Docker Usage

```dockerfile
FROM python:3.11-slim-bullseye
RUN pip install git+https://github.com/thesavant42/yoda-translator.git
RUN python -m spacy download en_core_web_sm
CMD ["python", "yoda_cli.py", "--stdin", "--quiet"]
```

## Performance

- **Model Load Time**: 200-500ms (one-time)
- **Translation Speed**: 10-50ms per sentence
- **Memory Usage**: ~150MB (SpaCy model)
- **Compatible**: Python 3.8+, SpaCy 3.0.6+

## Inspired by

- https://github.com/yevbar/Yoda-Script
- https://github.com/richchurcher/yoda-api  
- http://www.yodajeff.com/pages/talk/yodish.shtml

## License

MIT License - see LICENSE file for details.
