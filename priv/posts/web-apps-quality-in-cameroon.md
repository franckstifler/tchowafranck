---
title: Beyond the Hype, a Critical Look at User Experience in Cameroon's Public Service Digitalisation
published: true
published_date: 2026-03-09 12:00:00
blurb: Digitalisation promises efficiency and accessibility. But when government portals fail basic usability tests, they become just another barrier for citizens.
tags: cameroon, ux, ui, govtech, digitalisation, public-service, security
---

Hi all,

I have wanted to write this article for months. We hear the word "digitalisation" everywhere in Cameroon. It's presented as the solution to our problems: long queues, corruption, traveling to Yaoundé for simple documents, and offices that are only open on certain days.

But here's the question nobody asks: what happens when the digital tools themselves are broken?

I decided to test this myself. I visited two government websites that are supposed to help citizens: the AIGLES portal for civil servants ([portailaigles.gov.cm](https://portailaigles.gov.cm/)) and the Ministry of Secondary Education's HR site ([rh.minesec.gov.cm](https://rh.minesec.gov.cm/)). What I found was disappointing—and honestly, it explains why many Cameroonians still prefer to go to the office in person.

## What Digitalisation Should Mean

Before looking at the problems, let's agree on what good digitalisation looks like. In my view, every administration going digital should provide three things:

### 1. A Website That Actually Works
This sounds obvious, but it's not. A good site should be available when you need it, load properly, and give you practical information: what documents you need, when services are available, and how to proceed. If I have to travel to find out a service is only open on Thursdays, the website has failed.

### 2. A Way to Track Your Files
Nobody enjoys going to an office to ask "has my file been processed?" A good digital service lets you check your status online: "Received," "Under review," "Approved." This saves time, transport money, and also reduces corruption because everything is transparent.

### 3. Design That Puts Users First
This is the most important point. A digital service is not for the administration—it's for the citizen. If people cannot figure out how to log in, if they need help from a friend to understand the instructions, or if the site only works on a computer with fast internet, then it's not serving its purpose.

## Case Study 1: The AIGLES Portal

The AIGLES portal is meant to help civil servants manage their careers: check payslips, track promotions, and update information. Let's look at what works and what doesn't.

**The Good:** 
- The site exists and is now accessible (it was unavailable for a long time)
- Payslips are available and easy to download once you're in
- The general information on the site is clear

**The Problems:** 

**Finding the site is hard.** For a long time, the website was unavailable. Google searches pointed to old links or other services. Even today, if you're not technical, finding the right site is not easy.

**Login is confusing.** The first field says "Identifiant / Login." But what should you put? Your email? Your matricule? A username? Nothing explains this. There's also no way to reset your password if you get it wrong. And when you click the login button, nothing happens for a few seconds—you don't know if the site is loading or if your click did nothing.

**The new matricule problem.** Many civil servants have an "old" matricule and a "new" one. The site expects you to know the difference. A simple tool that helps you find your new matricule from your old one would save so much confusion, but it doesn't exist.

**Navigation is strange.** Once you log in, you're sent to a page called `/layout` that has no clear way to return to later. If you reload the page while logged in, it logs you out. The hamburger menu (the three lines that open navigation) is not where people expect it to be. The notification icon shows the same three unimportant messages every time.

**Translation issues.** Switch the language from French to English and the page sometimes stops responding. You have to kill the page and log in again. Some translations are simply missing.

**Downloading payslips.** The download options are not labeled clearly. You have to guess that different options mean different languages for the slip.

**Support sends you back to the physical world.** The "Réclamation" section tells you to call a number (1522) or, even worse, to "go to the Maison des usagers in Yaoundé." For a teacher in Maroua, this is not a solution. The digital service has just pointed them back to the physical office it was supposed to replace.

## Case Study 2: The MINESEC HR Site

If AIGLES has design problems, the MINESEC HR site has a more basic issue: it's often inaccessible.

**The site is not always reachable.** When I tried to visit, the connection failed. The site itself has mentioned that it doesn't work with Orange, which is a major internet provider in Cameroon. Think about that: a government site that tells citizens "this won't work if you use this network." That's like a shop that only accepts customers who come from a certain direction.

**Once you get in, it's heavy and slow.** When I could access the site, a hard reload made 77 requests and loaded 7.4MB of data. That's huge for a simple HR site. There are 14 CSS files (they should be bundled into fewer files), 31 JavaScript files, and 5 images totaling 5MB that have nothing to do with the page's purpose. On a page meant for census, half the screen is taken up by a carousel of unrelated images.

**Broken features.** The input for uploading your CV is strange—the upload doesn't work properly and the preview is broken. Form fields look different across the site, as if they were copied from different places. The page loading screen shows a weird transparent overlay that doesn't look professional.

## A Quick Note on Security: The SSL Problem

There's another issue I noticed that affects many government sites, including some I didn't mention here: missing or invalid SSL certificates.

You know that little padlock in your browser's address bar? It tells you that the connection between your computer and the website is secure. When it's missing, or when you see a warning that the connection is "not secure," it means any information you send—your password, your matricule, your personal details—could potentially be seen by others.

I've seen this on several Cameroonian government sites. Some have expired certificates. Others have certificates that don't match the website address. And some have no certificate at all.

**Why this matters:** If a site asks you to log in but doesn't have a valid SSL certificate, it's asking you to send your password over an unsecured connection. This is dangerous. It's like writing your banking details on a postcard and mailing it—anyone handling it can read it.

For government sites that handle personal data—payslips, career information, identification numbers—this is simply unacceptable. A site that cannot secure your information should not exist.

## Why This Matters

These two sites are not exceptions. They show a pattern in how Cameroon approaches digitalisation.

**We build for the administration, not for citizens.** The sites use internal jargon ("old format matricule," "new format matricule") that makes sense to people inside the system but confuses everyone else. The design choices prioritize how things look to officials, not how easy they are for regular people.

**We ignore reliability.** A site that is often offline, or that doesn't work on certain networks, is worse than no site at all. At least with no site, you know you have to go to the office. With a broken site, you waste time trying to use it, get frustrated, and then still have to travel.

**We ignore security.** Asking citizens to log in without a secure connection shows a lack of respect for their privacy and safety. People trust the government with their information, and that trust is being broken.

**We waste money.** These sites cost money to build. When they don't work properly, that money is wasted. Worse, they damage trust. A teacher who tries three times to download their payslip and fails will not believe the next promise of digitalisation.

## What Needs to Change

If we want digitalisation to actually work in Cameroon, here's what we need:

**1. Talk to users before building.** Ask teachers, retirees, and regular citizens what they need and what confuses them. Design around their answers.

**2. Test with real people.** Before launching a site, watch five people try to use it. If they can't log in on the first try, go back and fix the design.

**3. Build for mobile and slow internet.** Most Cameroonians access the web on phones, often on limited data plans. Sites must work well in these conditions, not just on office computers with fast fiber.

**4. Keep sites online.** A government site should be available 24/7, especially at month-end and near deadlines when everyone tries to access it. This is not optional.

**5. Use simple language.** No jargon. Clear instructions. Examples. Password reset options. These are basic features, not luxuries.

**6. Secure every connection.** No government site that handles personal information should operate without a valid SSL certificate. This is not optional. It's the minimum standard for any website that asks citizens to trust it with their data.

## Final Thought

Digitalisation is a good thing. It can make government more transparent, reduce corruption, and save citizens time and money. But only if it's done right.

Right now, many of our digital services add frustration instead of removing it. They create new barriers instead of breaking down old ones. They put people's information at risk. And until we start demanding better—and until the people building these sites start putting users first—this will not change.

Have you tried using a government or banking app in Cameroon and faced problems? I'd love to hear your experience.

- - -
*Note: I wrote this article after testing these sites in February 2026. Some issues may be fixed by the time you read this. If they are, that's good news—it means someone is listening.*
