# collection de script PowerShell pour fichiers M3U.
Comme j'en avais marre de jongler avec les URL pour obtenir les playlists et les mettre à jours, j'ai décidé de créer un script bash... et faire la même chose avec PowerShell !

## 1ere fonctionnalité
Account checker:
Permet d'avoir les détails d'un compte et d'un serveur IPTV (WIP)


### utilisation :
  
  ##### Account-checker.ps1 "url"
- Fonctionne avec des urls du type https://domain.com/user/password/channel ; https://domain.com/panel_api.php/username=user&password=password ; https://domain.com/live/user/password ou http://domain.com:port/user/password ( *réglé avec la v0.2.0a* )
- Indique les infos de compte (utilisateurs mot de passe, creation, etc ...) 
- Ne Fonctionne pas encore avec des url type https vers http ( ex: https://domain.com/user vers http://domain.com:12334/panel_api.php?username=user&password=password )

Puisque tout est vérifié en ligne directement, il y a un risque de bannissement de votre IP non-négligeable. N'abusez pas de ce script pour tenter de bruteforcer un serveur !

prochainement:
Ajout d'une option pour verifier depuis un fichier local pour eviter les trop nombreuse requete depuis les serveurs.

Derniere version: 0.2.0a
