#!/bin/bash

# Helpers

declare -A colors=( 
    ["black"]="30"
    ["red"]="31"
    ["green"]="32"
    ["yellow"]="33"
    ["blue"]="34"
    ["magenta"]="35"
    ["cyan"]="36"
    ["white"]="37"
)

declare -A text_styles=( 
    ["bold"]="1"
    ["dim"]="2"
    ["italic"]="3"
    ["underline"]="4"
    ["normal"]="5"
    ["invert"]="7"
    ["invisible"]="8"
    ["strikethrough"]="9"
)

function get_color_code() {
    local color="$1"

    if [ -z "$color" ]; then
        color="black"
    fi

    local color_code=${colors[$color]}

    echo $color_code
}

get_style_code() {
    local style="$1"

    if [ -z "$style" ]; then
        style="normal"
    fi

    local style_code=${text_styles[$style]}
    echo $style_code
}

function print_color() {
    color_code=$(get_color_code $2)
    style_code=$(get_style_code $3)
    echo -e "\033[${color_code};${style_code}m${1}\n\033[0m"
}


# Homebrew setup

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing oh my zsh & setting homebrew" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

which -s brew
if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"

    source ~/.zshrc
else
    print_color "Homebrew is already installed! Skipping..." green italic
fi

# Update homebrew recipes
brew update


# Xcode setup
print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing Xcode" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

brew install robotsandpencils/made/xcodes
xcodes install --latest --experimental-unxip


# JS packages

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing development packages" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "This step installs yarn, node, npm, watchman and applesimutils" blue italic

brew tap wix/brew

PACKAGES=(
  yarn
  nvm
  npm
  watchman
  applesimutils
)

brew install "${PACKAGES[@]}"

# You should create NVM's working directory if it doesn't exist:
mkdir ~/.nvm

{
 echo 'export NVM_DIR="$HOME/.nvm"'
 echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm'
 echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion'
} >> ~/.zshrc

source ~/.zshrc

nvm install 16


# RN CLI

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing React Native CLI" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

npm i -g react-native react-native-cli


# JDK

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing JDK" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

brew tap homebrew/cask-versions
brew install --cask zulu11

# Apps

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing Apps" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

APPS=(
  android-sdk
  android-studio
  android-platform-tools
)

echo "Installing apps..."
brew install --cask "${APPS[@]}"


# Android

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Setting up Android development environment values" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

{
  echo "export ANDROID_HOME=~/Library/Android/sdk"
  echo "export PATH=\${PATH}:\${ANDROID_HOME}/tools"
  echo "export PATH=\${PATH}:\${ANDROID_HOME}/platform-tools"
} >> ~/.zshrc



# Ruby

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Setting up rbenv (Ruby version manager)" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

brew install rbenv

{
echo 'eval "$(rbenv init -)"'
echo 'export PATH="$HOME/.rbenv/bin:$PATH"'
echo 'export LANG="en_US.UTF-8"'
} >> ~/.zshrc

# Homebrew on the M1, where things install to /opt/homebrew
echo 'export PATH=/opt/homebrew/bin:$PATH'

source ~/.zshrc

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
rbenv install 2.7.6
rbenv local 2.7.6
rbenv global 2.7.6

source ~/.zshrc


# Cocoapods

print_color "———————————————————————————————————————————————————————————————————" green bold
print_color "Installing cocoapods tools" green bold
print_color "———————————————————————————————————————————————————————————————————" green bold

sudo gem install cocoapods
sudo xcode-select --switch /Applications/Xcode*
sudo xcodebuild -license
