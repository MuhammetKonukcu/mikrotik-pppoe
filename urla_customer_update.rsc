/system script add name=pppoe-ssid-update source={

:local oldDomain "@mensel"
:local newDomain "@wifiber"
:if ([/interface pppoe-client print count-only] > 0) do={
    :local curUser [/interface pppoe-client get 0 user]
    :local atIndex [:find $curUser "@"]
    
    :if ($atIndex != "") do={
        :local prefix [:pick $curUser 0 $atIndex]
        :local newUser ($prefix . $newDomain)
        
        :put ("Updating: $curUser  ->  $newUser")
        
        :put "[OK] PPPoE updated."
    } else={
        :put "[ERROR] No @ symbol found in username: $curUser"
    }
} else={
    :put "[ERROR] No PPPoE client found!"
}

:put "[OK] Script completed."
}
:log info ("PPPOE and WLAN updated")
