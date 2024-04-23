#!/usr/bin/env bash
#----------------------------------------------------------------------
#  Arquivo:     rotina_BACKUP
#  Descrição:   Faz a copia periodica dos arquivos.
#  Autor:       Marcos Miguel (linuxmarc@outlook.com)
#  Data:        02/04/2024
#----------------------------------------------------------------------
#----------------------------------------------------------------------
#PARAMETROS
#----------------------------------------------------------------------
#VARIAVEIS INICIAIS
#----------------------------------------------------------------------
export LC_ALL=pt_BR.UTF-8
export TERM=xterm-256color
export caminhoHD16A="/mnt/16A"
export caminhoHD16B="/mnt/16B"
export caminhoSSD="/mnt/SSD-1"
export start_time_full="$(date -u +%s)"
dt=$(date  +'BACKUP INICIADO............%A, %d de %B de %Y, as %H:%M:%S' )
data_INICIAL=`date -d @$start_time_full `
datainicial=`date +%s`
#set -o errexit
#set -o pipefail