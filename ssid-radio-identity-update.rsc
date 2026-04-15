/system script add name=ssid-radio-identity-update source={

    :local oldPrefix "AirNet"
    :local newPrefix "Wifiber"
    :local oldIdentity "***LiveNet"

    :local curIdentity [/system identity get name]
    :local updateIdentity false

    :foreach wlanId in=[/interface wireless find] do={

        :local ifName [/interface wireless get $wlanId name]
        :local curMode [/interface wireless get $wlanId mode]
        :local curSsid [/interface wireless get $wlanId ssid]
        :local curRadioName [/interface wireless get $wlanId radio-name]

        :if ([:len $curSsid] >= [:len $newPrefix] && [:pick $curSsid 0 [:len $newPrefix]] = $newPrefix) do={
            :put ("[SKIP] " . $ifName . " SSID already updated: " . $curSsid)
        } else={
            :if ([:len $curSsid] >= [:len $oldPrefix] && [:pick $curSsid 0 [:len $oldPrefix]] = $oldPrefix) do={
                :local suffix [:pick $curSsid [:len $oldPrefix] [:len $curSsid]]
                :local newSsid ($newPrefix . $suffix)
                /interface wireless set $wlanId ssid=$newSsid
                :put ("[OK] SSID updated on " . $ifName . ": " . $curSsid . " -> " . $newSsid)
            } else={
                :put ("[SKIP] " . $ifName . " SSID does not start with '" . $oldPrefix . "': " . $curSsid)
            }
        }

        :if (($curMode = "ap-bridge") || ($curMode = "bridge")) do={
            :set updateIdentity true

            :if ($curRadioName = "") do={
                :put ("[SKIP] " . $ifName . " radio-name empty")
            } else={
                :if ([:len $curRadioName] >= [:len $newPrefix] && [:pick $curRadioName 0 [:len $newPrefix]] = $newPrefix) do={
                    :put ("[SKIP] " . $ifName . " radio-name already updated: " . $curRadioName)
                } else={
                    :if ([:len $curRadioName] >= [:len $oldPrefix] && [:pick $curRadioName 0 [:len $oldPrefix]] = $oldPrefix) do={
                        :local suffix [:pick $curRadioName [:len $oldPrefix] [:len $curRadioName]]
                        :local newRadioName ($newPrefix . $suffix)
                        /interface wireless set $wlanId radio-name=$newRadioName
                        :put ("[OK] Radio-name updated on " . $ifName . ": " . $curRadioName . " -> " . $newRadioName)
                    } else={
                        :put ("[SKIP] " . $ifName . " radio-name does not start with '" . $oldPrefix . "': " . $curRadioName)
                    }
                }
            }
        } else={
            :put ("[SKIP] " . $ifName . " mode is not ap-bridge/bridge: " . $curMode)
        }
    }

    :if ($updateIdentity) do={
        :if ([:len $curIdentity] >= [:len $oldIdentity] && [:pick $curIdentity 0 [:len $oldIdentity]] = $oldIdentity) do={
            :local suffix [:pick $curIdentity [:len $oldIdentity] [:len $curIdentity]]
            :local newIdentity ($newPrefix . $suffix)
            /system identity set name=$newIdentity
            :put ("[OK] Identity updated: " . $curIdentity . " -> " . $newIdentity)
        } else={
            :put ("[SKIP] Identity does not start with '" . $oldPrefix . "': " . $curIdentity)
        }
    } else={
        :put "[SKIP] No ap-bridge/bridge wireless interface found, identity not changed."
    }

    :put "[OK] Script completed."
    :log info ("Lafta Degil, Terminalde IT olunur - Muhammet")
}
