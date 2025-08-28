#!/usr/bin/env fish

echo "Follwing Commands will be executed"
echo ""
echo ""
echo "pnpm i -D prettier prettier-plugin-tailwindcss"
echo "pnpm i tailwindcss-animated"
echo "pnpm i -D daisyui@latest"
echo "" 
echo "Did you change into the correct directory ?(Yes/No)"
read -a response
switch $response
    case "Yes" "yes" "y" "Y"
        echo "Continuing with script"
        pnpm i -D prettier prettier-plugin-tailwindcss
        pnpm i tailwindcss-animated
        pnpm i -D daisyui@latest
    case "*"
        echo "Fucker Change into the right diretory !"
        exit 1
end