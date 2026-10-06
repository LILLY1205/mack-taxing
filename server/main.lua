local RSGCore = exports['rsg-core']:GetCoreObject()

local flyin = Config.flyin -- minimum bank value to be taxed in this bracket
local poor = Config.poor -- minimum bank value to be taxed in this bracket
local notbad = Config.notbad -- minimum bank value to be taxed in this bracket
local medium = Config.medium -- minimum bank value to be taxed in this bracket
local rich = Config.rich -- minimum bank value to be taxed in this bracket
local toorich = Config.toorich -- minimum bank value to be taxed in this bracket
local bankAccounts = { 'bank', 'valbank', 'rhobank', 'blkbank', 'armbank' } -- List of all bank accounts

RegisterServerEvent("rsg-taxing:server:Display")
AddEventHandler("rsg-taxing:server:Display", function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Calculate total bank balance across all accounts
    local totalBank = 0
    for _, account in ipairs(bankAccounts) do
        totalBank = totalBank + (Player.Functions.GetMoney(account) or 0)
    end

    local bracket, percentage
    if totalBank > flyin and totalBank <= poor then
        bracket = flyin
        percentage = Config.TaxBracket1
    elseif totalBank > poor and totalBank <= notbad then
        bracket = poor
        percentage = Config.TaxBracket2
    elseif totalBank > notbad and totalBank <= medium then
        bracket = notbad
        percentage = Config.TaxBracket3
    elseif totalBank > medium and totalBank <= rich then
        bracket = medium
        percentage = Config.TaxBracket4
    elseif totalBank > rich and totalBank <= toorich then
        bracket = rich
        percentage = Config.TaxBracket5
    elseif totalBank > toorich then
        bracket = toorich
        percentage = Config.TaxBracket6
    end
		TriggerClientEvent('rNotify:NotifyLeft', src, "Success!", "Your Current Tax Bracket is $" .. tostring(bracket) .. " Tax Percentage is " .. tostring(percentage) .. "%", "generic_textures", "tick", 4000)
		Citizen.Wait(5000) -- Wait 5 seconds
		TriggerClientEvent('rNotify:NotifyLeft', src, "Success!", "Wages are Paid into Your St Denis Bank Account", "generic_textures", "tick", 4000)
		Citizen.Wait(5000) -- Wait 5 seconds
		TriggerClientEvent('rNotify:NotifyLeft', src, "Success!", "Dont Forget to check your House Credit, This pays for your Land Tax, If not paid your House will be reposessed ", "generic_textures", "tick", 4000)
		Citizen.Wait(5000) -- Wait 5 seconds
		TriggerClientEvent('rNotify:NotifyLeft', src, "Success!", "Welcome to Dutton County, Have a Great Day !", "generic_textures", "tick", 4000)
	end)

RegisterServerEvent('rsg-taxing:server:paytaxes')
AddEventHandler('rsg-taxing:server:paytaxes', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname

    -- Calculate total bank balance across all accounts
    local totalBank = 0
    local balances = {}
    for _, account in ipairs(bankAccounts) do
        local balance = Player.Functions.GetMoney(account) or 0
        totalBank = totalBank + balance
        balances[account] = balance
    end

    local tax = 0
    local percentage = 0
    if totalBank <= poor then
        TriggerClientEvent('rNotify:NotifyLeft', src, "YOU DON'T PAY TAXES", "No taxes for low balance", "generic_textures", "tick", 4000)
        TriggerEvent('rsg-log:server:CreateLog', 'TAXES', 'NO TAX', 'green', firstname .. ' ' .. lastname .. ' paid $0 in taxes (below threshold).')
    else
        -- Determine tax bracket and percentage
        if totalBank > poor and totalBank <= notbad then
            percentage = Config.TaxBracket2
        elseif totalBank > notbad and totalBank <= medium then
            percentage = Config.TaxBracket3
        elseif totalBank > medium and totalBank <= rich then
            percentage = Config.TaxBracket4
        elseif totalBank > rich and totalBank <= toorich then
            percentage = Config.TaxBracket5
        elseif totalBank > toorich then
            percentage = Config.TaxBracket6
        end

        -- Calculate total tax
        tax = (totalBank / 100) * percentage

        -- Distribute tax deduction proportionally across accounts
        local remainingTax = tax
        for _, account in ipairs(bankAccounts) do
            if remainingTax <= 0 then break end
            local accountBalance = balances[account]
            if accountBalance > 0 then
                local accountProportion = accountBalance / totalBank
                local accountTax = math.min(remainingTax, math.floor(accountProportion * tax))
                if accountTax > 0 then
                    Player.Functions.RemoveMoney(account, accountTax, "Taxes paid")
                    remainingTax = remainingTax - accountTax
                end
            end
        end

        -- Add total tax to governor's account
        exports['rsg-bossmenu']:AddMoney(Config.Job, tax)
        TriggerClientEvent('rNotify:NotifyLeft', src, "YOU HAVE PAID YOUR TAXES", "To Governor Dutton", "generic_textures", "tick", 4000)
        TriggerEvent('rsg-log:server:CreateLog', 'TAXES', 'TAX', 'green', firstname .. ' ' .. lastname .. ' has paid $' .. tax .. ' in taxes.')
    end
end)