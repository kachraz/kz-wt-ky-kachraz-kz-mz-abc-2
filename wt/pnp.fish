#!/bin/fish 
npm install -g npm@latest
npm update -g pnpm
pnpm add -g pnpm
pnpm --version 
pnpm config set auto-install-peers true