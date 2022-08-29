#!/bin/bash
# scripts for ota update

dl_mirrors=("https://dl.ecoo.top:2096" "https://www.ecoo.top")

readonly COLOUR_RESET='\e[0m'
declare -A COLORS
COLORS=(
    ["red"]='\e[91m'
    ["green"]='\e[32;1m' 
    ["yellow"]='\e[33m'
    ["grey"]='\e[90m'
)
readonly GREEN_LINE=" ${COLORS[green]}─────────────────────────────────────────────────────$COLOUR_RESET\n"

printStr() {
    color=$1
    printf ${COLORS[${color}]}"$2"${COLOUR_RESET}"\n"
}

_exit() {
    exit_singal=$1
    shift
    [ "$exit_singal" != "0" ] && printStr red "$*" || printStr green "$*"
    exit $exit_singal
}

dl_get() {
    file_url=$1
    save_path=$2
    [ ! -d $save_path ] && mkdir -p $save_path
    for(( i=0;i<${#dl_mirrors[@]};i++));do
        echo "${dl_mirrors[i]}"
        wget --no-check-certificate ${dl_mirrors[i]}/${file_url} -P $save_path && printStr green "Successed download ${file_url}" && return
    done
    
    _exit 1 "Download $file_url failed"
}

up_script() {
    if [ ! -f /usr/bin/nasupdate ]; then
cat <<EOF > /usr/bin/nasupdate
#!/bin/bash
    
bash <(curl https://raw.hisi.ga/teasiu/histb/main/package_files/ota.sh)

EOF
	chmod +x /usr/bin/nasupdate
	printStr yellow "up_script: had set"
	printf $GREEN_LINE
    fi
}

up_typecho_theme() {
    if [ ! -d /var/www/html/blog/usr/themes/joe ]; then
	printStr yellow "typecho: adding new theme"
	[ -d /var/www/html/blog/usr/themes/joe ] && rm -rf /var/www/html/blog/usr/themes/joe
	dl_get "update/soft_init/Joe.zip" /tmp
	unzip -qq /tmp/Joe.zip -d /var/www/html/blog/usr/themes
	printStr yellow "typecho: upgraded"
	printf $GREEN_LINE
    fi
}

up_script
up_typecho_theme

_exit 0 "all upgraded successed"
