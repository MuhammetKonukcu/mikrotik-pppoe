/system script add name=pppoe-update source={

:local oldDomain "@mensel"
:local newDomain "@wifiber"
:if ([/interface pppoe-client print count-only] > 0) do={
    :local curUser [/interface pppoe-client get 0 user]
    :local atIndex [:find $curUser "@"]
    
    :if ($atIndex != "") do={
        :local prefix [:pick $curUser 0 $atIndex]
        :local newUser ($prefix . $newDomain)
        
        :put ("Updating: $curUser  ->  $newUser")
        /interface pppoe-client set 0 user=$newUser
        :put "[OK] PPPoE updated."
    } else={
        :put "[ERROR] No @ symbol found in username: $curUser"
    }
} else={
    :put "[ERROR] No PPPoE client found!"
}

:local oldPrefix "AirNet"
:local newPrefix "Wifiber"
:local ssidUpdated 0

:foreach wlanId in=[/interface wireless find] do={
    :local ifName  [/interface wireless get $wlanId name]
    :local curSsid [/interface wireless get $wlanId ssid]
    :local matchPos [:find $curSsid $oldPrefix]

    :if ($matchPos != "") do={
        :local suffix [:pick $curSsid [:len $oldPrefix] [:len $curSsid]]
        :local newSsid ($newPrefix . $suffix)
        /interface wireless set $wlanId ssid=$newSsid
        :put ("[OK] SSID updated on " . $ifName . ": " . $curSsid . " -> " . $newSsid)
        :set ssidUpdated ($ssidUpdated + 1)
    } else={
        :put ("[SKIP] " . $ifName . " SSID does not contain '" . $oldPrefix . "': " . $curSsid)
    }
}

:if ($ssidUpdated = 0) do={
    :put "[WARNING] No WLAN interface found with AirNet prefix!"
}

:put "[OK] Script completed."
}
/system script run pppoe-update