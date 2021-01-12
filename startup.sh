#! /bin/bash
/Users/irvs/cognizant/customers/usbank/envs/POC

gh repo create usbank --public --confirm
git remote -v
…or push an existing repository from the command line
git remote add origin https://github.com/iestarks/usbank-poc.git
git branch -M main
git push -u origin main



gh alias set repo-delete 'api -X DELETE "repos/$1"'
gh repo-delete iestarks/usbank-poc
git remote -v
gh auth login
gh repo view
git config -l

echo "# usbank-poc" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/iestarks/usbank-poc.git
git push -u origin main