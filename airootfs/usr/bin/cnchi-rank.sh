#!/bin/bash
if [[ $LANG = *"en"* ]]; then
export NOTICE="DONE!"
export NOTICE2="Cnchi is ranking your mirrors. Please wait..."

elif [[ $LANG = *"es"* ]]; then
export NOTICE="HECHO!"
export NOTICE2="Cnchi clasifica tus espejos. Por favor espera..."

elif [[ $LANG = *"fr"* ]]; then
export NOTICE="DONE!"
export NOTICE2="Cnchi classe vos miroirs. S'il vous plaît, attendez..."

elif [[ $LANG = *"hi"* ]]; then
export NOTICE="किया"
export NOTICE2="Cnchi आपके दर्पण रैंकिंग है। कृपया प्रतीक्षा करें..."

elif [[ $LANG = *"ar"* ]]; then
export NOTICE="انتهت المهمة"
export NOTICE2="Cnchi هو ترتيب المرايا الخاصة بك. أرجو الإنتظار..."

elif [[ $LANG = *"pt"* ]]; then
export NOTICE="COMPLETO!"
export NOTICE2="Cnchi está classificando seus espelhos. Por favor, espere..."

elif [[ $LANG = *"de"* ]]; then
export NOTICE="Vollständig!"
export NOTICE2="Cnchi zählt deine Spiegel. Warten Sie mal..."

elif [[ $LANG = *"it"* ]]; then
export NOTICE="COMPLETARE!"
export NOTICE2="Cnchi classifica i tuoi specchi. Attendere prego..."

elif [[ $LANG = *"zh"* ]]; then
export NOTICE="在任务完成后"
export NOTICE2="Cnchi正在为你的镜子排名。 请稍候..."

else
export NOTICE="DONE!"
export NOTICE2="Cnchi is ranking your mirrors. Please wait..."
fi
WAIT(){
yad --center --skip-taskbar --undecorated --no-buttons --form --on-top  --width=250 --no-escape --skip-taskbar --text-align=center \
--text="<b><big><big>$NOTICE2</big></big></b>"
}
WAIT2(){
if  (tail -F -n1 /tmp/cnchi.log &) | grep -q "Auto mirror selection has been run successfully"
then
sudo pkill yad
yad --center-skip-taskbar --undecorated --no-buttons --form --no-escape --timeout="1" --width=250 --height=30  --on-top --skip-taskbar --text-align=center \
--text="<b><big><big>$NOTICE</big></big></b>" \
else
echo "Mirrors are ranked!"
fi
}
START(){
if [[ -f /tmp/cnchi.log ]]
then
echo "Starting..."
else
sudo /usr/bin/cnchi-rank.sh
fi
(tail -F -n1 /tmp/cnchi.log &) | grep -q "Cnchi is ranking your mirrors lists..."
WAIT &
WAIT2
}
export -f WAIT WAIT2 START
START
