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


# News
##### le 16/11/2021
- M3UGrabber en cours de devellopement
- Auto-Update en cours de devellopement (finalisation)

#### M3UGrabber

##### Fonctionnalités :

- Télécharge les playlists au format M3U
- Force la construction de playlists grace au JSON du serveur distant. ( Utile pour les serveurs qui coupent la connexion au bout de 2Mo par ex.)
- Ajout de filtre de selection pour la construction de playlist
- ajout de multi filtres de selection ( 18/11/2021 )

#### Auto-Update

- detecte la version local et la version venant du github
- possibilité de forcer la MAJ
