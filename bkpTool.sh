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
#----------------------------------------------------------------------
#EXECUTE o comando df -h para escolher o que monitorar
# SETOR DE CONFIGURAÇÃO LIMITES DISCO
#----------------------------------------------------------------------

FSDISK=("/mnt/SSD-1" "/mnt/16A" "/mnt/16B" )
alertalimitedisco=30
numeroALERTA=$(printf "%02d%%" "$alertalimitedisco")


#----------------------------------------------------------------------

source ./auxiliar.sh   #BUSCA VIRIAVEIS ECHO EM OUTRO SCRIPT

clear

sequencia=( 
"BannerInicial"
"EchoDiscoTotal"
"ChecaDiscos"
"LimiteDisco"
"CriaParticoes"
"PermicaoDisco"
"LogicaInicioBackup"

"LogicaSecundariaBackup"
"PermicaoDisco"

"LeDisco"
"LeEndDisco"
"VariaveisDISPO4"
)

# Loop para iterar sobre a sequência
for contanumero in "${sequencia[@]}"; do
case $contanumero in
#----------------------------------------------------------------------
BannerInicial)
			echo "----------     ----------     ----------     ----------     ---------- >    |   BannerInicial"
			echo "$BANER_1"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EchoDiscoTotal)
			echo "----------     ----------     ----------     ----------     ---------- >    |   EchoDiscoTotal"
			echo "$BANER_5"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
ChecaDiscos)
			echo "----------     ----------     ----------     ----------     ---------- >    |   ChecaDiscos"


			echo ""
			echo "_______________________________________________________________________"

			for FSDISK in ${FSDISK[@]}
			do

			# Definindo as variáveis
			filesystemINICIAL=$(df -h | grep "$FSDISK" | sort -k 1,1 | awk '{print $6}')
			echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			if [ "$FSDISK" == "$filesystemINICIAL"  ]; then
			 echo  "PRESENTE   OK    $FSDISK"
			 else
			 echo  "ERRO   >>>>>>> $FSDISK                    ERRO   >>>>>>> $FSDISK"
			Interromper="parada"
			 fi
			done

			if [ "$Interromper" == "parada" ]; then
			  echo ""
			  echo  "SCRIPT SERÁ INTERROMPIDO"
			  echo ""
			  echo "ERRO ENCONTRADO"
			  echo "ERRO DE MONTAGEM O SCRIPT SERA PARADO"
			  echo "VERIFIQUE OS PONTOS DE MONTAGEM"
			  echo ""
			  echo ""
			  echo ""
			  echo ""
			  echo ""
			  echo ""
			  
			  
			  exit
			else
			  echo ""
			echo "_______________________________________________________________________"
			  echo "FILESYSTEM OK"

			fi

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LimiteDisco)
			echo "----------     ----------     ----------     ----------     ---------- >    |   LimiteDisco"



			for FSDISK in ${FSDISK[@]}
			do

			Montado=$FSDISK 
			# Definindo as variáveis
			filesystem=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $1}')
			total=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $2}')
			used=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $3}')
			free=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $4}')
			percent=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $5}')
			mountpoint=$(df -h | grep "$Montado" | sort -k 1,1 | awk '{print $6}')
			numero_sem_porcentagem=$(awk '{gsub("%", ""); print}' <<< $percent)
			porcentagem_formatada=$(printf "%02d%%" "$numero_sem_porcentagem")

			echo ""
			echo "@ ARMAZENAMENTO SENDO MONITORADO METRICA ALERTA MAIOR QUE $numeroALERTA DE USO  @"
			 
			if [ "$numero_sem_porcentagem" -gt $alertalimitedisco ]; then
			SISALERTA=$(
			echo ""
			echo "#_____________________________________________________________________#"
			echo "#                                                                     #"
			echo " ERRO              ALERTA                                      ---> $porcentagem_formatada "
			echo " ERRO              ESPAÇO EM DISCO ACIMA DO LIMITE"
			echo " $filesystem              $mountpoint                     "
			echo " Total: $total           USADO $used               LIVRE $free     "
			echo " ERRO             ARMAZENAMENTO EM ESTADO CRITICO              ---> $porcentagem_formatada"
			echo "#=====================================================================#"
			)
			echo "$SISALERTA"
			else
			SISOK=$(
			echo ""
			echo "#_____________________________________________________________________#"
			echo "#                                                                     #"
			echo " $filesystem              $mountpoint                     "
			echo " Total: $total           USADO $used               LIVRE $free     "
			echo " ARMAZENAMENTO SENDO MONITORADO                >>   $porcentagem_formatada"
			echo "# SISTEMA OK                                  Porcentagem de uso: $porcentagem_formatada #"
			echo "#=====================================================================#"
			)
			echo "$SISOK"
			fi
			done


;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CriaParticoes)
			echo "----------     ----------     ----------     ----------     ---------- >    |   CriaParticoes"

            


			mkdir -p $caminhoHD16A/"TEMPORARIO-BACKUP"
			mkdir -p $caminhoHD16A/"BKP1"
			mkdir -p $caminhoHD16A/"BKP2"
			mkdir -p $caminhoHD16A/"BKP3"
			mkdir -p $caminhoHD16A/"BKP4"
#----------------------------------------------------------------------
			mkdir -p $caminhoHD16B/"BKP5"
			mkdir -p $caminhoHD16B/"BKP6"
			mkdir -p $caminhoHD16B/"BKP7"
			mkdir -p $caminhoHD16B/"BKP8"
			mkdir -p $caminhoHD16B/"BACKUP-FULL-INCREMENTAL"
#----------------------------------------------------------------------

			mkdir -p $caminhoSSD/"COMPARTILHAMENTO"
			mkdir -p $caminhoSSD/"HISTORICO"
			mkdir -p $caminhoSSD/"LIXEIRA"
#----------------------------------------------------------------------
			touch $caminhoHD16A/"BKP1"/log.txt
			touch $caminhoHD16A/"BKP2"/log.txt
			touch $caminhoHD16A/"BKP3"/log.txt
			touch $caminhoHD16A/"BKP4"/log.txt
			touch $caminhoHD16A/"TEMPORARIO-BACKUP"/log.txt
#----------------------------------------------------------------------
			touch $caminhoHD16B/"BKP5"/log.txt
			touch $caminhoHD16B/"BKP6"/log.txt
			touch $caminhoHD16B/"BKP7"/log.txt
			touch $caminhoHD16B/"BKP8"/log.txt
 			touch $caminhoSSD/"COMPARTILHAMENTO"/log.txt
#----------------------------------------------------------------------
			rm -Rf $caminhoHD16B/"BKP8"/*
			mv -f  $caminhoHD16B/"BKP7"/* $caminhoHD16B/"BKP8"
			mv -f  $caminhoHD16B/"BKP6"/* $caminhoHD16B/"BKP7"
			mv -f  $caminhoHD16B/"BKP5"/* $caminhoHD16B/"BKP6"
#----------------------------------------------------------------------
			mv -f  $caminhoHD16A/"BKP4"/* $caminhoHD16B/"BKP5"
			mv -f  $caminhoHD16A/"BKP3"/* $caminhoHD16A/"BKP4"
			mv -f  $caminhoHD16A/"BKP2"/* $caminhoHD16A/"BKP3"
			mv -f  $caminhoHD16A/"BKP1"/* $caminhoHD16A/"BKP2"
			
			
echo "$BANER_2"
echo "$BANER_2" >> $caminhoSSD/"COMPARTILHAMENTO"/log.txt			
echo "$BANER_11"			

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

PermicaoDisco)
			echo "----------     ----------     ----------     ----------     ---------- >    |   PermicaoDisco"
			echo "$BANER_3" 
#			echo "$BANER_3" >> /UTIL/LOG/log.txt

			chmod -R 7777  $caminhoHD16A
			chown -R administrador:root $caminhoHD16A
			chmod -R 7777  $caminhoHD16B
			chown -R administrador:root $caminhoHD16B
			chmod -R 7777  $caminhoSSD 
			chown -R administrador:root $caminhoSSD 
			chmod -R 7777 /UTIL
			chown -R administrador:root /UTIL
			echo "$BANER_11"			


;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LogicaInicioBackup)
			echo "----------     ----------     ----------     ----------     ---------- >    |   LogicaInicioBackup"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		
LogicaSecundariaBackup)
			echo "----------     ----------     ----------     ----------     ---------- >    |   LogicaSecundariaBackup"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LeDisco)
			echo "----------     ----------     ----------     ----------     ---------- >    |   LeDisco"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LeEndDisco)
			echo "----------     ----------     ----------     ----------     ---------- >    |   LeEndDisco"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisEcho)
			echo "----------     ----------     ----------     ----------     ---------- >    |   VariaveisEcho"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO1)
			echo "----------     ----------     ----------     ----------     ---------- >    |   VariaveisDISPO1"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO2)
			echo "----------     ----------     ----------     ----------     ---------- >    |   VariaveisDISPO2"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO3)
			echo "----------     ----------     ----------     ----------     ---------- >    |   VariaveisDISPO3"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO4)
			echo "----------     ----------     ----------     ----------     ---------- >    |   VariaveisDISPO4"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*)
			echo "FIM COM ERRO"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
esac
done

exit
