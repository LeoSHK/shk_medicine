local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPmeds = {}
Tunnel.bindInterface("shk_medicine", vRPmeds)
Proxy.addInterface("shk_medicine", vRPmeds)

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

MEclient = Tunnel.getInterface("shk_medicine")
Audioclient = Tunnel.getInterface("shk_audio")
cfg = module("shk_medicine", "cfg/config")
lang = module("shk_medicine", "cfg/config")

