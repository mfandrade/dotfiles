#!/bin/sh

# Script POSIX-compatible para encapsular o nvim com suporte para diferentes nomes (vi, vim, view)
# Autor: Marcelo F Andrade <mfandrade@gmail.com>
# Data: 20/03/2025

# Obtém o nome com que o script foi chamado
SCRIPT_NAME=$(basename "$0")

# Define o caminho para o executável nvim
NVIM_BIN=$(command -v nvim)

# Verifica se o nvim está instalado
if [ -x "$NVIM_BIN" ]; then

  # Executa o nvim de acordo com o nome com que o script foi chamado
  case "$SCRIPT_NAME" in
  view)
    # Se chamado como view, executa no modo somente leitura
    exec "$NVIM_BIN" -R "$@"
    ;;
  vi | vim | nvim)
    # Se chamado como vi, vim ou nvim, executa normalmente
    exec "$NVIM_BIN" "$@"
    ;;
  *)
    # Para qualquer outro nome, exibe mensagem mas executa normalmente
    printf "nvim.sh: cannot access '%s': No such file or directoryls: cannot access 'asdajshda': No such file or directory\n" "$SCRIPT_NAME" >&2
    exec "$NVIM_BIN" "$@"
    ;;
  esac

fi
