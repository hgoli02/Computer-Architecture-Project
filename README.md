
# Computer Architecture Project

## Create Team repositories

For starting the project, first, you need to create your team's repository. Follow the invite link in the document, select your student number and create/join your team. After creating a team, a private repository will be created for you. You should use this repository to collaborate with your teammates and submit your codes.
The repository is created empty. You should clone this repository and push it on that. Please note that handouts may have minor issues and get updates during a phase. They also will be updated on each phase to contain the material needed for that phase. To stay updated with it, we recommend setting multiple remotes on your local clones.

### Git
Git knowledge is essential whenever you write even a single line of code. The more you learn, you will notice how helpful it is. If you are not familiar with git yet, it is strongly recommended to take this [tutorial](https://learngitbranching.js.org/).

### multi remote repository
Right after creating your team and your private repo, you will need to push this material into that empty repo (only one of the team members should do this once). First, clone the handouts repository on your computer (via ssh or over https).
```bash
# If you prefer https clones, just replace 'git@' with 'https://' at the start of the links.
$ git clone git@github.com:ce323/mips-handouts.git
$ mv mips-handouts project-<team-name>
$ cd project-<team-name>
```
Now the handouts repository will be named `origin` in your repository remotes. We need to change its name to `handouts` and add your private repository as `origin`.
```bash
$ git remote rename origin handouts
$ git remote add origin git@github.com:ce323/project-<team-name>.git
```
Then, you can initiate your team's private repository by simply pushing into that.
```bash
$ git push origin master
```
Your repository is ready and you can start developing your processor. From now on, you can treat your repository as a single remote one and do whatever you did before. And for getting handouts updates, you can simply run:
```bash
$ git pull handouts master
```
But wait, what should we do to clone and set up our repo after we created it? (this includes other members, or even the first member trying to clone again)
If you pushed into your repository once, then you just need to clone it and add handouts as a remote.
```bash
$ git clone git@github.com:ce323/project-<team-name>.git
$ cd project-<team-name>
$ git remote add handouts git@github.com:ce323/mips-handouts.git
```
Your repo is ready. Enjoy implementing the project :)

## Issues
If you noticed any issue in the handouts, please feel free to open an issue on the handouts repository.
