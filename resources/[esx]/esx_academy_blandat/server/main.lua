ESX = nil -- RÖR INTE, DENNA ÄNDRAS AUTOMATISKT TILL ESX-OBJEKTET NÄR DEN ÄR HÄMTAD

-- Hämtar ESX-objektet och lagrar så man kan använda sig utav ESX-funktioner
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

