## collection de script PowerShell pour fichiers M3U.
Comme j'en avais marre de jongler avec les URL pour obtenir les playlists et les mettre à jours, j'ai décidé de créer un script bash... et faire la même chose avec PowerShell !

# 1ere fonctionnalité
Account checker:
Permet d'avoir les détail d'un compte IPTV (WIP)

utilisation :
Account-checker.ps1 "url"
Fonctionne avec des urls du type https://domain.com/user/password/channel ou https://domain.com/panel_api.php/username=user&password=password
Ne Fonctionne pas encore avec des url type https://domain.com/live/user/password ou http://domain.com:port/user/password
indique les infos de compte (utilisateurs mot de passe, creation, etc ...)

tout est vérifié en ligne directement.

prochainement:
Ajout d'une option pour verifier depuis un fichier local pour eviter les trop nombreuse requete depuis les serveurs.

