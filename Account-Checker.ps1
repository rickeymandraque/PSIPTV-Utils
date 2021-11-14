 param(
[string]$url
)

$uri = [System.Uri]$url
$query = $uri.Query
$IPTVhost = $uri.Host
$IPTVport = $uri.Port
$Segments = $uri.Segments.TrimEnd('/')
$proto = $uri.Scheme



$ParsedQueryString = [System.Web.HttpUtility]::ParseQueryString($uri.Query)


# si l'url n'est pas une requette php"
if(!$query) {
# si le 1er segment est = à live
if ($Segments[1].TrimEnd('/') -eq "live"){

# alors le nom d'utilisateur sera au 2eme segment
$username = $Segments[2].TrimEnd('/')
# et le MDP au 3eme
$password = $Segments[3].TrimEnd('/')
}
else
{
# sinon le nom d'utillisateur et le MDP sera au 1er eet 2eme segment
$username = $Segments[1].TrimEnd('/')
$password = $Segments[2].TrimEnd('/')
}
}


# sinon, on prend la requete username et password
else {
$username = $ParsedQueryString['username']
$password = $ParsedQueryString['password']


}


# Détail de l'url
echo ""
echo ""
echo " ------------------------------------- "
echo "L'url nous indique que:"
echo "Le serveur est $IPTVhost"
echo "Le nom d'utilisateur est $username "
echo "Le mot de passe est $password "
echo " ------------------------------------- "
echo ""
echo ""



$full_panel = "${proto}://${IPTVhost}:${IPTVport}/panel_api.php?username=$username&password=$password"
$Online_Infos = Invoke-WebRequest $full_panel | ConvertFrom-Json

$OnlineUser_Info = $Online_Infos.user_info
$OnlineUsername = $OnlineUser_Info.username
$OnlinePassword = $OnlineUser_Info.password
$Is_Auth = $OnlineUser_Info.auth
$Is_Trial = $OnlineUser_Info.is_trial
$OnlineStatus = $OnlineUser_Info.status
$OnlineExp_date = $OnlineUser_Info.exp_date
$OnlineActive_cons = $OnlineUser_Info.active_cons
$OnlineCreated_at = $OnlineUser_Info.created_at
$OnlineMax_connections = $OnlineUser_Info.max_connections
$OnlineMessage = $OnlineUser_Info.message

$OnlineServer_Infos = $Online_Infos.server_info

$OnlineXui = $OnlineServer_Infos.xui
$OnlineVersion = $OnlineServer_Infos.version
$OnlineRevision = $OnlineServer_Infos.revision
$OnlineUrl = $OnlineServer_Infos.url
$OnlinePort = $OnlineServer_Infos.port
$OnlineHttpsPort = $OnlineServer_Infos.https_port
$OnlineProtocol = $OnlineServer_Infos.server_protocol
$OnlineRtmp = $OnlineServer_Infos.rtmp_port
$OnlineLocalTimesatamp = $OnlineServer_Infos.timestamp_now
$OnlineLocaTime = $OnlineServer_Infos.time_now
$OnlineTimeZone = $OnlineServer_Infos.timezone


# pour convertir un timestamp unix vers une date
$expdate = (([System.DateTimeOffset]::FromUnixTimeSeconds($OnlineExp_date)).DateTime).ToString("g")
$CreateDate = (([System.DateTimeOffset]::FromUnixTimeSeconds($OnlineCreated_at)).DateTime).ToString("g")


echo ""
echo ""
echo " ------------------------------------- "
echo "Le serveur nous indique que:"
echo " Nom d'utilisateur: $OnlineUsername"
echo " Mot de passe : $OnlinePassword"
echo " Satus du compte : $OnlineStatus"
echo " Date de création du compte : $createdate"
echo " date d'expiration du compte : $expdate"
echo " il y a $OnlineActive_cons utilisateur(s) connecté sur un maximum de $OnlineMax_connections"
echo " ------------------------------------- "
echo ""
echo ""
