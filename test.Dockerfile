# Test Dockerfile to verify yoda-translator compatibility with chainlit environment
# Mimics the chainlit container's packages and tests spacy installation

FROM python:3.11-slim-bullseye

# Install build dependencies (same as chainlit)
RUN apt-get update && apt-get install -y gcc g++ libffi-dev libssl-dev git cmake pkg-config \
    nasm libz-dev libbz2-dev liblzma-dev && \
    rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install key chainlit dependencies that might conflict
RUN pip install spacy==3.6.1

# Copy yoda-translator files
COPY pyproject.toml .
COPY poetry.lock .
COPY *.py .

# Install Poetry
RUN pip install poetry

# Configure Poetry to not create virtual env (install in system Python)
RUN poetry config virtualenvs.create false

# Install yoda-translator dependencies
RUN poetry install --no-dev

# Download the SpaCy model
RUN python -m spacy download en_core_web_sm

# Test the installation
RUN python -c "import spacy; nlp = spacy.load('en_core_web_sm'); print('SpaCy model loaded successfully')"
RUN python -c "from yoda import translate; print(translate('You are conflicted.'))"

# Test entrypoint
CMD ["python", "-c", "from yoda import translate; print('SUCCESS: yoda-translator works with SpaCy 3.6.1')"]