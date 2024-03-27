# quote-me-when-you-can
fortune based quotes whenever you need

## How it is seen

<img width="446" alt="image" src="https://github.com/sumanth-lingappa/quote-me-when-you-can/assets/42572246/15f5f210-6208-43bc-aacc-3d22749e5b04">

<img width="415" alt="image" src="https://github.com/sumanth-lingappa/quote-me-when-you-can/assets/42572246/5a4c7527-44c3-4248-a21b-f771070dec7c">

<img width="451" alt="image" src="https://github.com/sumanth-lingappa/quote-me-when-you-can/assets/42572246/23db2182-c74b-4318-a26c-3977448b1e12">

<img width="413" alt="image" src="https://github.com/sumanth-lingappa/quote-me-when-you-can/assets/42572246/b7c92f4a-3d3d-46c1-8786-ab9c1b3b0319">

<img width="420" alt="image" src="https://github.com/sumanth-lingappa/quote-me-when-you-can/assets/42572246/97644f65-0237-41ee-a9ee-8079a5653cf8">

## How to use

### Pre-requisites

1. fortune - [MacOS](https://formulae.brew.sh/formula/fortune), Linux
2. cowsay - [MacOS](https://formulae.brew.sh/formula/cowsay), Linux
3. lolcat - [MacOS](https://formulae.brew.sh/formula/lolcat), Linux

### Clone it to local directory

```bash
git clone git@github.com:sumanth-lingappa/quote-me-when-you-can.git
```

### Change the directory to the repository

```bash
cd quote-me-when-you-can
```

### Run the `update_fortune.sh` file

```bash
bash update_fortune.sh
```

> This will create the `fortune.dat` file  to `$HOME/fortunes/` folder

### Run the fortune command

```bash
fortune $HOME/fortunes
```

### TIP: Include the above command in your .bashrc or .zshrc file to get a custom fortune on every new shell

> Ultra tip: pipe the `fortune` output to tools like `cowsay` and `lolcat` to get the most experience

```bash
echo "fortune $HOME/fortunes | cowsay | lolcat" >> ~/.bashrc
```

```bash
echo "fortune $HOME/fortunes | cowsay | lolcat" >> ~/.zshrc
```




