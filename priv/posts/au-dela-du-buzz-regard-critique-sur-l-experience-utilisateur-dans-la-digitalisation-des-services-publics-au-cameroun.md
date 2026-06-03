-----
title: Au dela du buzz, regard critique sur l'experience utilisateur dans la digitalisation des services publics au Cameroun
published: true
published_date: 2026-03-09 12:00:00
blurb: La digitalisation promet efficacite et accessibilite. Mais quand les portails publics echouent sur les bases de l'experience utilisateur, ils deviennent une nouvelle barriere.
language: fr
translation_key: web-apps-quality-cameroon
tags: cameroon, ux, ui, govtech, digitalisation, public-service, security
-----

Bonjour a tous,

Cela fait des mois que je voulais ecrire cet article. Au Cameroun, on entend le mot "digitalisation" partout. On nous la presente comme la solution aux files d'attente, a la corruption, aux deplacements vers Yaounde pour de simples documents, et aux bureaux qui n'ouvrent que certains jours.

Mais il y a une question qu'on pose rarement: que se passe-t-il quand les outils digitaux eux-memes sont casses?

J'ai teste deux sites publics censes aider les citoyens: le portail AIGLES pour les agents publics et le site RH du Ministere des Enseignements Secondaires. Ce que j'ai trouve est decevant, et explique pourquoi beaucoup de Camerounais preferent encore se deplacer physiquement.

## Ce que la digitalisation devrait signifier

Avant de parler des problemes, il faut definir ce qu'un bon service digital devrait offrir.

D'abord, un site qui fonctionne vraiment. Il doit etre accessible, charger correctement, et donner des informations pratiques: les documents necessaires, les horaires, les etapes a suivre. Si je dois me deplacer pour decouvrir qu'un service n'est disponible que le jeudi, le site a echoue.

Ensuite, un moyen de suivre son dossier. Personne n'aime aller dans un bureau juste pour demander si son dossier est deja traite. Un bon service digital devrait afficher un statut clair: recu, en cours, approuve, rejete. Cela economise du temps, de l'argent, et reduit les opportunites de corruption.

Enfin, un design centre sur l'utilisateur. Le service n'est pas fait pour l'administration, mais pour le citoyen. Si les gens ne comprennent pas comment se connecter, s'ils ont besoin d'un ami pour lire les instructions, ou si le site ne marche que sur ordinateur avec une connexion rapide, il ne remplit pas sa mission.

## Le cas du portail AIGLES

Le portail AIGLES est cense permettre aux agents publics de gerer leur carriere, consulter leurs bulletins de paie, suivre des promotions, et mettre a jour certaines informations.

Il y a des points positifs. Le site existe, il est de nouveau accessible, et les bulletins peuvent etre telecharges une fois connecte.

Mais les problemes restent nombreux.

Trouver le bon site n'est pas toujours evident. Pendant longtemps, le site etait indisponible, et les recherches Google renvoyaient vers d'anciens liens ou d'autres services.

La connexion est confuse. Le champ demande un identifiant ou login, mais sans expliquer ce qu'il faut entrer: email, matricule, nom d'utilisateur? Il n'y a pas de solution claire pour reinitialiser son mot de passe. Quand on clique sur le bouton de connexion, il peut ne rien se passer pendant quelques secondes, sans indication.

Le probleme des anciens et nouveaux matricules ajoute encore de la confusion. Beaucoup d'agents ont deux references. Un simple outil permettant de retrouver le nouveau matricule a partir de l'ancien aiderait enormement, mais il n'existe pas.

La navigation est egalement etrange. Apres connexion, on arrive sur une page dont le chemin n'est pas clair. Recharger la page peut deconnecter l'utilisateur. Les menus ne sont pas toujours places la ou les gens les attendent. Les notifications montrent souvent les memes messages peu utiles.

Les traductions posent aussi probleme. Changer de langue peut bloquer la page, et certaines traductions sont absentes.

Enfin, le support renvoie parfois vers le monde physique. Dire a un enseignant de Maroua d'aller a la Maison des usagers a Yaounde n'est pas une solution digitale.

## Le cas du site RH du MINESEC

Si AIGLES a surtout des problemes de design, le site RH du MINESEC a un probleme encore plus basique: il est souvent inaccessible.

Un site public qui ne fonctionne pas avec certains operateurs reseau pose un vrai probleme. C'est comme un service qui n'accepte que les citoyens venant d'une route precise.

Quand le site est accessible, il est lourd. Beaucoup de fichiers CSS, beaucoup de JavaScript, des images lourdes, parfois sans lien direct avec l'objectif de la page. Sur une page administrative, chaque megaoctet inutile est une barriere pour les utilisateurs avec une connexion lente ou un forfait limite.

Certaines fonctionnalites sont cassees ou mal finies: upload de CV etrange, apercu qui ne marche pas, champs de formulaire incoherents, ecrans de chargement peu professionnels.

## Le probleme SSL

Il y a aussi un probleme de securite que l'on retrouve sur plusieurs sites publics: les certificats SSL manquants, expires, ou invalides.

Le cadenas dans le navigateur indique que la connexion est securisee. Quand il manque, ou quand le navigateur affiche une alerte, les informations envoyees au site peuvent etre exposees: mots de passe, matricules, informations personnelles.

Pour des sites publics qui manipulent des bulletins de paie, des informations de carriere ou des donnees d'identification, c'est inacceptable.

Un site qui demande aux citoyens de se connecter doit securiser la connexion. Ce n'est pas un luxe, c'est le minimum.

## Pourquoi c'est important

Ces sites ne sont pas des exceptions. Ils montrent une facon de penser la digitalisation.

On construit souvent pour l'administration, pas pour les citoyens. On utilise du jargon interne, des parcours compliques, et des designs qui semblent valides par des bureaux plutot que par des utilisateurs reels.

On ignore la fiabilite. Un site souvent hors ligne est pire qu'aucun site, parce qu'il fait perdre du temps avant de renvoyer quand meme l'utilisateur vers le bureau physique.

On ignore parfois la securite. Demander a un citoyen de se connecter sans connexion securisee, c'est lui demander de faire confiance a un systeme qui ne protege pas correctement ses donnees.

Et on gaspille de l'argent. Ces plateformes coutent cher. Quand elles ne fonctionnent pas, elles detruisent la confiance dans les prochains projets de digitalisation.

## Ce qui doit changer

Il faut parler aux utilisateurs avant de construire. Enseignants, retraites, agents publics, citoyens ordinaires: ce sont eux qui savent ou se trouvent les blocages.

Il faut tester avec de vraies personnes. Avant de lancer un site, regardez cinq utilisateurs essayer de se connecter. S'ils n'y arrivent pas rapidement, le probleme vient du design, pas d'eux.

Il faut construire pour le mobile et les connexions lentes. Beaucoup de Camerounais utilisent Internet sur telephone, avec des forfaits limites. Les sites publics doivent fonctionner dans ces conditions.

Il faut garder les sites en ligne. Un service public digital doit etre disponible, surtout en periode de forte demande.

Il faut utiliser un langage simple, eviter le jargon, donner des exemples, et offrir des options de recuperation de mot de passe.

Et il faut securiser toutes les connexions.

## Derniere pensee

La digitalisation est une bonne chose. Elle peut rendre l'administration plus transparente, reduire la corruption, et faire gagner du temps aux citoyens.

Mais seulement si elle est bien faite.

Aujourd'hui, beaucoup de services digitaux ajoutent de la frustration au lieu d'en retirer. Ils creent de nouvelles barrieres au lieu de supprimer les anciennes. Ils exposent parfois les donnees des citoyens.

Tant que les utilisateurs ne seront pas au centre, la digitalisation restera surtout un mot dans les discours.

