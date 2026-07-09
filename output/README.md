# Ollama

Get up and running with large language models locally.

## Features

- Run models such as Llama, Gemma, Qwen and DeepSeek locally
- Simple CLI (`ollama run <model>`) and REST API
- Model library with `ollama pull` / `ollama push`
- OpenAI-compatible API endpoints

## Documentation

- Website: https://ollama.com
- Documentation: https://github.com/ollama/ollama/tree/main/docs
- Source code: https://github.com/ollama/ollama

## Post-installation

This package installs and enables the `ollama` systemd service, running as
the unprivileged `ollama` system user. After installation:

1. Check the service is running: `sudo systemctl status ollama`
2. Run a model: `ollama run llama3.2`

If you'd rather run `ollama serve` yourself, disable the service first:
`sudo systemctl disable --now ollama`.

## License

Ollama is licensed under the MIT License.
