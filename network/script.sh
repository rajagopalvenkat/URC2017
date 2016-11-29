#Wifi config - if no prefered Wifi generate a hotspot
# RPi Network Conf Bootstrapper
 
createAdHocNetwork()
{
    echo "Creating RPI Hotspot network"
    ifconfig wlan0 down
    ifconfig wlan0 10.0.0.5 netmask 255.255.255.0 up
    service dnsmasq start
    service hostapd start
    echo " "
    echo "Hotspot network created"
    echo " "
}
 
echo "================================="
echo "RPi Network Conf Bootstrapper"
echo "================================="
echo "Scanning for known WiFi networks"
ssids=( 'mySSID1','mySSID2' )
connected=false
for ssid in "${ssids[@]}"
do
    echo " "
    echo "checking if ssid available:" $ssid
   echo " "
    if iwlist wlan0 scan | grep $ssid > /dev/null
    then
        echo "First WiFi in range has SSID:" $ssid
        echo "Starting supplicant for WPA/WPA2"
        wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 2>&1
        echo "Obtaining IP from DHCP"
        if dhclient -1 wlan0
        then
            echo "Connected to WiFi"
            connected=true
            break
        else
            echo "DHCP server did not respond with an IP lease (DHCPOFFER)"
            wpa_cli terminate
            break
        fi
    else
        echo "Not in range, WiFi with SSID:" $ssid
    fi
done
 
if ! $connected; then
    createAdHocNetwork
fi 
