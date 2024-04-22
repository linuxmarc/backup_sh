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
#set -o errexit
#set -o pipefail
#----------------------------------------------------------------------
#EXECUTE o comando df -h para escolher o que monitorar
#----------------------------------------------------------------------

dt=$(date  +'BACKUP INICIADO............%A, %d de %B de %Y, as %H:%M:%S' )
data_INICIAL=`date -d @$start_time_full `
datainicial=`date +%s`

source ./auxiliar.sh   #BUSCA VIRIAVEIS ECHO EM OUTRO SCRIPT
clear
sequencia=( 
"BannerInicial"
"EchoDiscoTotal"

"ChecaParticoes"
"LimiteDisco"
"PermicaoDisco"
"LogicaInicioBackup"

"LogicaSecundariaBackup"
"PermicaoDisco"

"LeDisco"
"LeEndDisco"
"VariaveisDISPO4"
)

# Loop para iterar sobre a sequência
for numero in "${sequencia[@]}"; do
case $numero in
#----------------------------------------------------------------------
BannerInicial)
echo "----------------> BannerInicial"
echo "$BANER_1"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
EchoDiscoTotal)
echo "----------------> EchoDiscoTotal"
echo "$BANER_5"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
ChecaParticoes)
echo "----------------> ChecaParticoes"
#FSDISK=("XX" "/mnt/SSD-1" "/mnt/16A" "/mnt/16B" "FFFF" )
FSDISK=("/mnt/SSD-1" "/mnt/16A" "/mnt/16B" )

echo ""
echo "_______________________________________________________________________"
echo ""
for FSDISK in ${FSDISK[@]}
do
Montado="" 
# Definindo as variáveis
filesystemINICIAL=$(df -h | grep "$FSDISK" | sort -k 1,1 | awk '{print $6}')
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
if [ "$FSDISK" == "$filesystemINICIAL"  ]; then
 echo  "PRESENTE OK    $FSDISK"
 else
 echo  "ERRO    $FSDISK"
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
  sleep 5
  exit
else
  echo ""
echo "_______________________________________________________________________"
  echo "FILESYSTEM OK"
echo "_______________________________________________________________________"

fi



;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LimiteDisco)
echo "----------------> LimiteDisco"

 FSDISK=("/mnt/SSD-1" "/mnt/16A" "/mnt/16B" )
echo "_______________________________________________________________________"

echo "LENDO FSDISK            METRICA ALETA MAIOR QUE         $numeroALERTA  RESTANTE #"
echo "_______________________________________________________________________"
echo ""

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



 
if [ "$numero_sem_porcentagem" -gt $numero ]; then
#if [ $numero_sem_porcentagem -lt $numero ]; then



SISALERTA=$(
echo ""
echo "#_____________________________________________________________________#"
echo "#                                                                     #"
echo "                          ALERTA $Montado    $porcentagem_formatada                        "
echo ""
echo  " $filesystem              $mountpoint                     "
echo " Total: $total           USADO $used               LIVRE $free     "
echo  " ARMAZENAMENTO EM ESTADO CRITICO               >>   $porcentagem_formatada"
echo "#=====================================================================#"
)
echo "$SISALERTA"
else
SISOK=$(
echo "#_____________________________________________________________________#"
echo "#                                                                     #"
echo "# SISTEMA OK                                  Porcentagem de uso: $porcentagem_formatada #"
echo "#_____________________________________________________________________#"
echo "#                                                                     #"
echo ""
echo  " $filesystem              $mountpoint                     "
echo " Total: $total           USADO $used               LIVRE $free     "
echo  " ARMAZENAMENTO SENDO MONITORADO                >>   $porcentagem_formatada"
echo "#=====================================================================#"
)
echo "$SISOK"

fi
done

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
PermicaoDisco)
echo "----------------> PermicaoDisco"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LogicaInicioBackup)
echo "----------------> LogicaInicioBackup"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		
LogicaSecundariaBackup)
echo "----------------> LogicaSecundariaBackup"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LeDisco)
echo "----------------> LeDisco"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LeEndDisco)
echo "----------------> LeEndDisco"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisEcho)
echo "----------------> VariaveisEcho"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO1)
echo "----------------> VariaveisDISPO1"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO2)
echo "----------------> VariaveisDISPO2"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO3)
echo "----------------> VariaveisDISPO3"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VariaveisDISPO4)
echo "----------------> VariaveisDISPO4"

;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*)
echo "FIM COM ERRO"
;; #XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
esac
done

exit
