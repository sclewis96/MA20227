# Awesome stats team: GitHub 101

## Setup:

#### git, GitHub, and cloning a repo:

* Install git and create a GitHub account
* Open Git Bash
* `git config --global user.name your_user_name`
* `git config --global user.email your@email.com` (make sure you use the one you signed up to GitHub with!)
* On GitHub, "fork" this repo: https://github.com/owenjonesuob/MA20227/
* In Git Bash, navigate to the folder you want to save work in on your machine: `cd "C:/filepath/here/CW"`
* `git clone https://github.com/your_user_name/MA20227/`

#### Explanation of the two "remotes" we're about to add:
![](https://camo.githubusercontent.com/6d599db858665e9813a8103f356678c8c5e4e3e4/687474703a2f2f6934332e74696e797069632e636f6d2f32726d773769782e706e67)

`upstream`: https://github.com/owenjonesuob/MA20227/
This is where everything gets merged together

`origin`: https://github.com/your_user_name/MA20227/
This is your "fork" of `upstream`, which is what you update - the updates are merged into `upstream` by creating a pull request later

#### Adding remotes:

* `git remote add origin https://github.com/your_user_name/MA20227/`
* `git remote add upstream https://github.com/owenjonesuob/MA20227/`
* Check you're set up properly with `git remote -v`

## Stay up to date and add stuff yourself:

#### Add new stuff from server ("remote") to your local copy:

* `git fetch upstream`
* `git checkout master`
* `git merge upstream/master`

#### Add things to your local copy:
* `git add [files]` (or `git add .` to add all files which have been changed)
* `git commit -m "Change things"` (commit message should be present tense, make it helpful!)
* Repeat `add` and `commit` - little and often

#### Push your local copy to your remote:
* Re-update from `upstream` for latest changes: `git fetch upstream`, `git checkout master`, `git merge upstream/master`
* `git push origin master`

#### Merge your fork back into `upstream`
* On your GitHub repo: `Create pull request`
* Make title descriptive, useful/humorous comment is mandatory

### Potentially useful links:

* https://help.github.com/articles/fork-a-repo/
* https://help.github.com/articles/syncing-a-fork/
* https://marklodato.github.io/visual-git-guide/index-en.html
