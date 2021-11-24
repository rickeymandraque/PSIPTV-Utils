# Variables
## Variable concernant le démarrage du script

param(
	[string]$url
)

# Add cmdlet
Add-Type -AssemblyName System.Web

$version = "0.3.0"
$githubver = "https://raw.githubusercontent.com/rickeymandraque/PSIPTV-Utils/main/currentversion.txt"

# Variable du script
$Working_Dir = "$($PWD.Path)"
$Tools_Dir = "$Working_Dir\Tools"
$Databases_Dir = "$Working_Dir\Databases"
$7zip_Dir = "$Tools_Dir\7zip"
$FFMpeg_Dir = "$Tools_Dir\FFMpeg"



## Variables pour parser l'url

if (!($url -like '\?checkedby\:'))
{
	$url = ($url -replace '[?&]checkedby:.+')
}

$uri = [System.Uri]$url
$query = $uri.Query
$IPTVhost = $uri.Host
$IPTVport = $uri.Port
$Segments = $uri.Segments.TrimEnd('/')
$proto = $uri.Scheme
#permet d'afficher les différents message selon le nombres de connecté. à déplacer.

$ParsedQueryString = [System.Web.HttpUtility]::ParseQueryString($uri.Query)

## section utilisateur/mot de passe

### si l'url n'est pas une requette php"
if (!$query) {
	#### si le 1er segment est = à live
	if ($Segments[1].TrimEnd('/') -eq "live") {

		#### alors le nom d'utilisateur sera au 2eme segment
		$username = $Segments[2].TrimEnd('/')
		#### et le MDP au 3eme
		$password = $Segments[3].TrimEnd('/')
	}
	else
	{
		##### sinon le nom d'utillisateur et le MDP sera au 1er et 2eme segment
		$username = $Segments[1].TrimEnd('/')
		$password = $Segments[2].TrimEnd('/')
	}
}

### sinon, on prend la requete username et password
else {
	$username = $ParsedQueryString['username']
	$password = $ParsedQueryString['password']
}


## Construction des URLs

if (!$IPTVPort -or $IPTVPort -eq "443" -or $IPTVhost -eq "https")
{
	$FQDN = "${proto}://${IPTVhost}"
}
else
{
	$FQDN = "${proto}://${IPTVhost}:${IPTVport}"
}
$Send_Login = ".php?username=${username}&password=${password}"



#### EPG ###

# Programmes XMLTV (EPG)
$Get_XMLTV = "${FQDN}/xmltv${Send_Login}"


### Donwload File ###

### Requetes php GET direct ###
$Get_PHP = "${FQDN}/get${Send_Login}&type="
$Get_M3U = "${Get_PHP}m3u"
$Get_M3U_Plus = "${Get_M3U}_plus"
# $Get_M3U8 = "${Get_PHP}m3u8"
$Get_TS = "${Get_M3U}&output=ts"
$Get_TS_Plus = "${Get_M3U_Plus}&output=mpegts"
$Get_MpegTS = "${Get_M3U}&output=ts"
$Get_MpegTS_Plus = "${Get_M3U_Plus}&output=mpegts"


############ Player_API ############


### Le player, plus petit, plus rapide à charger, permet des requete php GET
$Player_API = "${FQDN}/player_api${Send_Login}"


######      Infos Utilisateur      ######

#### Requetes JSON filtrées Player_API
$Player_Infos = (Invoke-WebRequest $Player_API | ConvertFrom-Json)
###### prévoir un Get-Content local #####


##### Détails de chaque sections #####
######     Infos Utilisateur    ######
$Player_User_Infos = $Player_Infos.user_info
$Player_Username = $Player_User_Infos.username
$Player_Password = $Player_User_Infos.password
# Message d'accueuil, permet de demander à l'utilisateur de changer son MDP sinon, BAN.
$Player_Message = $Player_User_Infos.message
# Sert pour verifier si l'utilisateur existe si pas de 404
$Player_Is_Auth = $Player_User_Infos.auth
# Affiche le status Active ou Banned (rare)
$Player_Status = $Player_User_Infos.status
# TimesTamp en format Unix
$Player_Exp_date = $Player_User_Infos.exp_date
# Version demo ou pas (True ou False)
$Player_Is_Trial = $Player_User_Infos.is_trial
# Nombre de connexion au moment de la requete
$Player_Active_cons = $Player_User_Infos.active_cons
$Player_Created_at = $Player_User_Infos.created_at
$Player_Max_connections = $Player_User_Infos.max_connections
# Format de fichiers autorisé par la commande GET
$Player_Formats_Output = $Player_User_Infos.allowed_output_formats



######       Infos Serveur      ######


# info général du serveur
$Player_Server_Infos = $Player_Infos.server_info
# Info étrange, concerne la plateforme XUI ( https://xui.one/ )
$Player_Xui = $Player_Server_Infos.xui
$Player_Version = $Player_Server_Infos.version
$Player_Revision = $Player_Server_Infos.revision
# Adresse IP/Nom de Domaine du serveur (ne sert pas à grand chose)
$Player_Url = $Player_Server_Infos.url
$Player_Port = $Player_Server_Infos.Port
$Player_HttpsPort = $Player_Server_Infos.https_port
$Player_Protocol = $Player_Server_Infos.server_protocol
$Player_Rtmp = $Player_Server_Infos.rtmp_port
# Heure Locale format Unix
$Player_LocalTimesatamp = $Player_Server_Infos.timestamp_now
#Heure Locale AAA/MM/DD HH:mm:ss
$Player_LocaTime = $Player_Server_Infos.time_now
$Player_TimeZone = $Player_Server_Infos.timezone

### Requetes php GET avec Player_API ###




# Ne fonctionne qu'avec le player, sinon on obtient le JSON complet #
# Permet d'obtenir un JSON filtré #
# $Get_XXX_Info obtiendra des informations telles que les codecs vidéo, la durée, la description...
$Get_Action = "${Player_API}&action=get_"
# Lives #
$Get_Live_Streams = "${Get_Action}live_streams"
$Get_Live_Cat = "${Get_Action}live_categories"
$Get_Live_ID = "${Get_Live_Streams}&category_id=${Cat_ID_Number}"
# VOD
$Get_VOD_Streams = "${Get_Action}VOD_streams"
$Get_VOD_categories = "${Get_Action}VOD_categories"
$Get_VOD_ID = "${Get_VOD_Streams}&category_id=${Cat_ID_Number}"
$Get_VOD_Info = "${Get_Action}vod_info&vod_id=${Stream_ID_Number}"
# Séries
$Get_Series_Streams = "${Get_Action}series"
$Get_Series_categories = "${Get_Action}series_categories"
$Get_Series_Info = "${Get_Action}series_info&series_id=${Stream_ID_Number}"

# avoir un court résumé EPG
$Get_Short_EPG = "${Geet_Action}short_epg&stream_id=${Stream_ID_Number}"
$Get_Short_EPG_Limited = "${Geet_Action}${Get_Short_EPG}&limit=${Limit_Number}"
$Get_Long_EPG = "${Get_Action}simple_data_table&stream_id=${Stream_ID_Number}"



############ Panel_API ############


### Le panel, contient l'intégralité du JSON avec toutes les infos utilisateur, serveur, catégories, streams, etc...

$Panel_API = "${FQDN}/panel_api${Send_Login}"



#### Requetes JSON filtrées Panel_API
$Panel_Infos = (Invoke-WebRequest $Panel_API | ConvertFrom-Json)
###### prévoir un Get-Content local


##### Détails de chaque sections #####
######     Infos Utilisateur    ######
$Panel_User_Infos = $Panel_Infos.user_info
$Panel_Username = $Panel_User_Infos.username
$Panel_Password = $Panel_User_Infos.password
# Message d'accueuil, permet de demander à l'utilisateur de changer son MDP sinon, BAN.
$Panel_Message = $Panel_User_Infos.message
# Sert pour verifier si l'utilisateur existe si pas de 404
$Panel_Is_Auth = $Panel_User_Infos.auth
# Affiche le status Active ou Banned (rare)
$Panel_Status = $Panel_User_Infos.status
# TimesTamp en format Unix
$Panel_Exp_date = $Panel_User_Infos.exp_date
# Version demo ou pas (True ou False)
$Panel_Is_Trial = $Panel_User_Infos.is_trial
# Nombre de connexion au moment de la requete
$Panel_Active_cons = $Panel_User_Infos.active_cons
$Panel_Created_at = $Panel_User_Infos.created_at
$Panel_Max_connections = $Panel_User_Infos.max_connections
# Format de fichiers autorisé par la commande GET
$Panel_Formats_Output = $Panel_User_Infos.allowed_output_formats



######       Infos Serveur      ######


# info général du serveur
$Panel_Server_Infos = $Panel_Infos.server_info
# Info étrange, concerne la plateforme XUI ( https://xui.one/ )
$Panel_Xui = $Panel_Server_Infos.xui
$Panel_Version = $Panel_Server_Infos.version
$Panel_Revision = $Panel_Server_Infos.revision
# Adresse IP/Nom de Domaine du serveur (ne sert pas à grand chose)
$Panel_Url = $Panel_Server_Infos.url
$Panel_Port = $Panel_Server_Infos.Port
$Panel_HttpsPort = $Panel_Server_Infos.https_port
$Panel_Protocol = $Panel_Server_Infos.server_protocol
$Panel_Rtmp = $Panel_Server_Infos.rtmp_port
# Heure Locale format Unix
$Panel_LocalTimesatamp = $Panel_Server_Infos.timestamp_now
#Heure Locale AAA/MM/DD HH:mm:ss
$Panel_LocaTime = $Panel_Server_Infos.time_now
$Panel_TimeZone = $Panel_Server_Infos.timezone



#### Fonctions ####



function Write-Text ($symbol,$color,$msg)
{
	if ($symbol)
	{
		Write-Host "[$symbol]" -ForegroundColor $color -NoNewline
		Write-Host " - $msg"
	}
	else
	{
		Write-Host -ForegroundColor $color $msg
	}
}

function Write-Message {
	param
	(
		[string]$message,
		[string]$type,
		[bool]$prependNewLine
	)
	$msg = ""
	if ($prependNewline) { Write-Host "`n" }
	switch ($type) {
		"error" {
			$symbol = "!"
			$color = [System.ConsoleColor]::Red
		}
		"warning" {
			$symbol = "!"
			$color = [System.ConsoleColor]::Yellow
		}
		"success" {
			$symbol = "+"
			$color = [System.ConsoleColor]::Green
		}
		"status" {
			$symbol = "*"
			$color = [System.ConsoleColor]::White
		}
		default {
			$color = [System.ConsoleColor]::White
		}
	}

	Write-Text $symbol $color $message

}
$Current_Ratio = ("${Player_Active_cons} / ${Player_Max_connections}")
function Ratio_MSG ()
{
	$Ratio_Message = " il y a $Player_Active_cons utilisateur(s) connecté sur un maximum de $Player_Max_connections"
	if ($Player_Max_connections -ge 3)
	{
		if ($Current_Ratio -ge 0.75)
		{
			Write-Message "$Ratio_Message" "error"
		}

		elseif ($Current_Ratio -ge 0.5)
		{
			Write-Message "$Ratio_Message" "Warning"
		}

		else
		{
			Write-Message "$Ratio_Message" "success"
		}
	}
	elseif ($Player_Max_connections -le 2)
	{
		if ($Current_Ratio -ge 0.5)
		{
			Write-Message "$Ratio_Message" "error"
		}

		else
		{
			Write-Message "$Ratio_Message" "success"
		}
	}
	else
	{
		Write-Message "$Ratio_Message" "success"
	}
}


if ($Player_Exp_date -or $Player_Created_at)
{
	$Expdate = (([System.DateTimeOffset]::FromUnixTimeSeconds($Player_Exp_date)).DateTime).ToString("g")
	$CreateDate = (([System.DateTimeOffset]::FromUnixTimeSeconds($Player_Created_at)).DateTime).ToString("g")
}





Write-Output "$Panel_API"
Write-Output "$Player_API"
Write-Output "$Get_M3U"
Write-Output "$Get_M3U_Plus"
Write-Output "auth : $Player_Is_Auth"
Write-Output ""
Write-Output ""
Write-Output " ------------------------------------- "
Write-Output " Le serveur nous indique que:"
Write-Output " Nom d'utilisateur: $Player_Username"
Write-Output " Mot de passe : $Player_Password"
Write-Output " Satus du compte : $Player_Status"
if (!$Expdate -or !$CreateDate)
{
	Write-Message "pas de date de création ou d'expiration" "error"
}
Write-Output " Date de création du compte : $CreateDate"
Write-Output " date d'expiration du compte : $Expdate"
Ratio_MSG
Write-Output " ------------------------------------- "
Write-Output ""
Write-Output ""

