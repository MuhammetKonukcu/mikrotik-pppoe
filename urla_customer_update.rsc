/system script add name=pppoe-ssid-update source={

:local newDomain "@wifiber"

:foreach pppId in=[/interface pppoe-client find] do={
    :local curUser [/interface pppoe-client get $pppId user]
    :if ($curUser = "") do={
        :put "[SKIP] PPPoE user empty"
    } else={
        :local atIndex [:find $curUser "@"]
        :if ($atIndex = "") do={
            :put ("[ERROR] No @ symbol found in username: " . $curUser)
        } else={
            :local prefix [:pick $curUser 0 $atIndex]
            :local newUser ($prefix . $newDomain)

            :if ($curUser = $newUser) do={
                :put ("[SKIP] PPPoE already updated: " . $curUser)
            } else={
                /interface pppoe-client set $pppId user=$newUser
                :put ("[OK] PPPoE updated: " . $curUser . " -> " . $newUser)
            }
        }
    }
}

:put "[OK] Script completed."
:log info ("Lafta Degil, Terminalde IT olunur - Muhammet")
}
