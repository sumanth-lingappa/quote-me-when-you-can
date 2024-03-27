# quote-me-when-you-can
fortune based quotes whenever you need

## How to use

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

```bash
echo "fortune $HOME/fortunes" >> ~/.bashrc
```

```bash
echo "fortune $HOME/fortunes" >> ~/.zshrc
```

