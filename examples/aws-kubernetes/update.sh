#!/usr/bin/env bash

function brew_install_if_not_present {
    package=$1
    echo "Installing $package via brew, if not present"
    if brew ls --versions $package >/dev/null; then
        echo "$package is already present. Skipping."
    else
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $package
    fi
}

function brew_install_or_upgrade {
    package=$1
    echo "Installing/upgrading $package via brew"
    if brew ls --versions $package >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade $package
    else
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $package
    fi
}

function install_terraform_helm_plugin {
    plugin_version=$1
    echo "Installing/upgrading the Terraform Helm plugin to $plugin_version"
    wget https://github.com/terraform-providers/terraform-provider-helm/releases/download/${plugin_version}/terraform-provider-helm_${plugin_version}_darwin_amd64.tar.gz -O /tmp/terraform-provider-helm_${plugin_version}_darwin_amd64.tar.gz

    tar -xvf /tmp/terraform-provider-helm_${plugin_version}_darwin_amd64.tar.gz -C /tmp/
    cp /tmp/terraform-provider-helm_darwin_amd64/terraform-provider-helm ~/.terraform.d/plugins/terraform-provider-helm
}

TERRAFORM_HELM_PLUGIN_VERSION='v0.6.0'

brew update

brew_install_if_not_present terraform
brew_install_or_upgrade wget
brew_install_or_upgrade aws-iam-authenticator
brew_install_or_upgrade kubernetes-helm
brew_install_or_upgrade kubectl
brew_install_or_upgrade jq

install_terraform_helm_plugin $TERRAFORM_HELM_PLUGIN_VERSION

helm init --client-only
helm repo update
