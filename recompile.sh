#!/bin/bash
clear
echo -e "\e[38;5;3m" 
echo -e "██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗██╗     ██╗███╗   ██╗ ██████╗    \e[38;5;5m ███╗   ███╗ █████╗  ██████╗ ███████╗███╗   ██╗████████╗ ██████╗  \e[38;5;3m"
echo -e "██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║██║     ██║████╗  ██║██╔════╝    \e[38;5;5m ████╗ ████║██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗ \e[38;5;3m"
echo -e "██████╔╝█████╗  ██║     ██║   ██║██╔████╔██║██████╔╝██║██║     ██║██╔██╗ ██║██║  ███╗   \e[38;5;5m ██╔████╔██║███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║   ██║   ██║ \e[38;5;3m"
echo -e "██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║██║     ██║██║╚██╗██║██║   ██║   \e[38;5;5m ██║╚██╔╝██║██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║   ██║   ██║ \e[38;5;3m"
echo -e "██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ██║███████╗██║██║ ╚████║╚██████╔╝   \e[38;5;5m ██║ ╚═╝ ██║██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║   ╚██████╔╝ \e[38;5;3m"
echo -e "╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝    \e[38;5;5m ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝  \e[38;5;3m"
echo -e "\e[0m"
echo
echo -e "\e[\e[41m****ATTENTION****\e[49m\e[25m This will recompile Magento!"
echo
read -n 1 -s -r -p 'Press any key to continue or CTRL+C to abort.'
echo
echo
echo -e "\e[\e[42m                                                           \e[0m"
echo -e "\e[\e[42m Running composer install...                               \e[0m"
echo -e "\e[\e[42m                                                           \e[0m"
echo
composer install
echo
echo -e "\e[\e[43m                                                           \e[0m"
echo -e "\e[\e[43m Deleting generated folder...                              \e[0m"
echo -e "\e[\e[43m                                                           \e[0m"
rm -rf generated/* > /dev/null
echo
echo -e "\e[\e[44m                                                           \e[0m"
echo -e "\e[\e[44m Running setup:upgrade...                                  \e[0m"
echo -e "\e[\e[44m                                                           \e[0m"
echo
php bin/magento set:up
echo
echo -e "\e[\e[45m                                                           \e[0m"
echo -e "\e[\e[45m Flushing cache...                                         \e[0m"
echo -e "\e[\e[45m                                                           \e[0m"
echo
php bin/magento c:c
echo
php bin/magento c:f
echo
echo -e "\e[\e[46m                                                           \e[0m"
echo -e "\e[\e[46m Removing & deploying static content...                    \e[0m"
echo -e "\e[\e[46m                                                           \e[0m"
echo
rm -rf pub/static/* > /dev/null 
rm -rf pub/static/.* > /dev/null                                                 
rm -rf var/view_preprocessed/* > /dev/null
php bin/magento setup:static-content:deploy -f
echo
echo -e "\e[\e[41m                                                           \e[0m"
echo -e "\e[\e[41m Reindexing...                                             \e[0m"
echo -e "\e[\e[41m                                                           \e[0m"
echo
php bin/magento ind:res
echo
php bin/magento ind:rei
echo
echo -e "\e[\e[43m                                                           \e[0m"
echo -e "\e[\e[43m Applying patches...                                       \e[0m"
echo -e "\e[\e[43m                                                           \e[0m"
echo
php ./vendor/bin/ece-patches apply
echo
echo -e "\e[\e[45m                                                           \e[0m"
echo -e "\e[\e[45m Flushing caches...                                        \e[0m"
echo -e "\e[\e[45m                                                           \e[0m"
echo
php bin/magento c:c
echo
php bin/magento c:f
echo
echo -e "\e[\e[42m                                                           \e[0m"
echo -e "\e[\e[42m Running dependency injection...                           \e[0m"
echo -e "\e[\e[42m                                                           \e[0m"
echo
php bin/magento setup:di:compile
echo
echo -e "\e[\e[46m                                                           \e[0m"
echo -e "\e[\e[46m Complete.                                                 \e[0m"
echo -e "\e[\e[46m                                                           \e[0m"
echo
echo
echo
baseurl=$(php bin/magento config:show web/secure/base_url)
echo -en "\e[49m\e[25m Site URL: $baseurl \033[0m"
adminuri=$(php bin/magento info:adminuri)
echo -e "\e[49m\e[25m $adminuri \033[0m"
cache=$(php bin/magento config:show system/full_page_cache/caching_application)
if [[ $cache == "1" ]]; then
    cachetype="Fastly"
else
    cachetype="Built-in Cache"
fi
if [[ $cachetype == "Fastly" ]]; then
    echo
    echo -n "Do you want to change caching from Fastly to Built-in Cache (Recommended) Y/N?"
    read -n 1 changecache
    case $changecache in
       [Yy]* ) php bin/magento config:set system/full_page_cache/caching_application 3;echo "Change caching to Built-in Cache.";;
       [Nn]* ) echo "No changes made. Fastly is still set as the local cache. Proceed with caution.";;
       * ) echo ;;
    esac 
fi
cache=$(php bin/magento config:show system/full_page_cache/caching_application)
if [[ $cache == "1" ]]; then
    cachetype="Fastly"
else
    cachetype="Built-in Cache"
fi
echo -e "\e[49m\e[25m    Cache: $cachetype \033[0m"
echo
echo
echo
