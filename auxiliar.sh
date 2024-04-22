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


#----------------------------------------------------------------------
#EXECUTE o comando df -h para escolher o que monitorar
#----------------------------------------------------------------------
# Criação de função
function chamadata {
echo ""
}			
# Chamada da função
chamadata

data_INICIAL=`date -d @$start_time_full `



STARTdiskTOTALfunc=$(df -h | grep 'sd' | sort -k 1,1)
STARTdisckSSDfunc=$(df -h | grep 'SSD' | sort -k 1,1)
STARTdisckHDfunc=$(df -h | grep -e '16A' -e '16B' | sort -k 1,1)


BANER_1=$(
echo "#=====================================================================#"
echo "#  Arquivo:     rotina_BACKUP                               AKIYAMA   #"
echo "#  Descrição:   Faz a copia periodica dos arquivos.                   #"
echo "#---------------------------------------------------------------------#"
echo "#  Autor:       Marcos Miguel (linuxmarc@outlook.com)                 #"
echo "#  Data:        22/04/2024                                    ver:76  #"
echo ""
echo "  "$dt" "
echo "#=====================================================================#"
echo ""
)
BANER_2=$(
echo ""
echo "# CRIANDO ESTRUTURA DE PASTAS ========================================#"
)
BANER_3=$(
echo ""
echo "# CONFIRMANDO PERMIÇÕES ==============================================#"
)
BANER_4=$(
echo ""
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "#==========================  AGUARDE =================================#"
echo ""
echo "# LOGICA DE BACKUP PRIMARIO INICIADA =================================#"
echo "# COPIANDO ARQUIVOS AGUARDE ==========================================#"
echo ""
echo -e "# cp -r $caminhoSSD/COMPARTILHAMENTO/* $caminhoHD16A/TEMPORARIO-BACKUP"
echo -e "# mv -f $caminhoHD16A/TEMPORARIO-BACKUP/* $caminhoHD16A/BKP1"
)
BANER_5=$(
echo ""
echo "STATUS INICIAL ANTES DO BACKAUP"
echo "LISTA TODAS OS DISCOS E PARTIÇÕES"
echo "#---------------------------------------------------------------------#"
echo "Sist. Arq.      Tam. Usado Disp. Uso% Montado em"
echo "$STARTdiskTOTALfunc"
echo "        "
)
BANER_6=$(
echo ""
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "#==========================  AGUARDE =================================#"
echo ""
echo "# LOGICA DE BACKUP SECUNDARIO INICIADA ===============================#"
echo "# COPIANDO ARQUIVOS AGUARDE ==========================================#"
echo "#                                                                     #"
echo ""
echo -e "# rsync -a $caminhoSSD/LIXEIRA  $caminhoHD16B/BACKUP-FULL-INCREMENTAL/"
echo -e "# rsync -a $caminhoSSD/HISTORICO  $caminhoHD16B/BACKUP-FULL-INCREMENTAL/"
echo -e "# rsync -a $caminhoSSD/COMPARTILHAMENTO/*  $caminhoSSD/HISTORICO/"
)
BANER_7=$(
echo ""
echo "#=====================================================================#"
echo "# 7#"
echo "#=====================================================================#"
)
BANER_8=$(
echo ""
echo "#=====================================================================#"
echo "# 8#"
echo "#=====================================================================#"
)
BANER_9=$(
echo ""
echo "SSD STATUS INICIAL ANTES DO BACKAUP"
echo "Sist. Arq.      Tam. Usado Disp. Uso% Montado em"
echo "$STARTdisckSSDfunc"
echo ""
echo "HD STATUS INICIAL ANTES DO BACKAUP"
echo "Sist. Arq.      Tam. Usado Disp. Uso% Montado em"
echo "$STARTdisckHDfunc"
)
BANER_10=$(
echo ""
echo "SSD STATUS APÓS DO BACKAUP"
echo "Sist. Arq.      Tam. Usado Disp. Uso% Montado em"
echo "$STARTdisckSSDfunc"
echo "        "
echo "HD STATUS APÓS DO BACKAUP"
echo "Sist. Arq.      Tam. Usado Disp. Uso% Montado em"
echo "$STARTdisckHDfunc"
)
BANER_11=$(
echo "# OK                                                                  #"
echo "#=====================================================================#"
)

export  BANER_2 BANER_3 BANER_4 BANER_5 BANER_6 BANER_7 BANER_8 BANER_9 BANER_10 BANER_11;

