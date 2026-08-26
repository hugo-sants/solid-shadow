# eza wrappers

unalias ls ll la tree 2>/dev/null

ls() {
    command eza --icons=auto --group-directories-first "$@"
}

ll() {
    command eza -l --icons=auto "$@"
}

la() {
    command eza -la --icons=auto "$@"
}

tree() {
    command eza --tree --icons=auto "$@"
}


# Change directory with fd + fzf

fcd() {
    local directory

    directory=$(
        fd \
            --type d \
            --hidden \
            --absolute-path \
            --exclude .cache \
            --exclude .local/share/Trash \
            --exclude .mozilla \
            --exclude .var/app \
            --exclude .wine \
            --exclude snap \
            --exclude .steam \
            --exclude .gradle \
            --exclude .m2/repository \
            --exclude .cargo \
            --exclude .rustup \
            --exclude go/pkg \
            --exclude .npm \
            --exclude .pnpm-store \
            --exclude .yarn \
            --exclude .vscode/extensions \
            --exclude .vscode-server \
            --exclude .local/share/nvim \
            --exclude .local/share/lvim \
            --exclude .local/share/lunarvim \
            --exclude .local/share/JetBrains \
            --exclude .local/share/flatpak \
            --exclude .local/share/containers \
            --exclude .local/share/Steam \
            --exclude node_modules \
            --exclude vendor \
            --exclude build \
            --exclude Build \
            --exclude dist \
            --exclude out \
            --exclude target \
            --exclude bin \
            --exclude obj \
            --exclude release \
            --exclude debug \
            --exclude coverage \
            --exclude .next \
            --exclude .nuxt \
            --exclude .svelte-kit \
            --exclude .angular \
            --exclude .vite \
            --exclude .parcel-cache \
            --exclude .turbo \
            --exclude .output \
            --exclude __pycache__ \
            --exclude .mypy_cache \
            --exclude .pytest_cache \
            --exclude .tox \
            --exclude .nox \
            --exclude .ruff_cache \
            --exclude .venv \
            --exclude venv \
            --exclude env \
            --exclude .idea \
            --exclude .vs \
            --exclude Cache \
            --exclude cache \
            --exclude Caches \
            --exclude CachedData \
            --exclude "Code Cache" \
            --exclude GPUCache \
            --exclude ShaderCache \
            --exclude startupCache \
            --exclude tmp \
            --exclude temp \
            --exclude Temp \
            --exclude backup \
            --exclude backups \
            --exclude .git \
            --exclude .svn \
            --exclude .hg \
            --exclude .bzr \
            --exclude .netbeans \
            --exclude .eclipse \
            --exclude .p2 \
            --exclude .metadata \
            --exclude .settings \
            --exclude .terraform \
            --exclude .terraform.d \
            --exclude .aws \
            --exclude .kube/cache \
            --exclude thumbnails \
            --exclude .thumbnails \
            --exclude .Trash \
            --exclude Trash \
            --exclude lost+found \
            --exclude .docker/buildx \
            --exclude .java \
            --exclude icc \
            --exclude JetBrains \
            --exclude VIGXxDDXIemn \
            --exclude code \
            --exclude Code \
            --exclude libreoffice \
            --exclude PrismLauncher \
            --exclude rstudio \
            --exclude x86_64-redhat-linux-gnu-library \
            --exclude ManicadosFull \
            . "$HOME" |
        fzf \
            --no-sort \
            --exact \
            --delimiter="$HOME/" \
            --with-nth=2.. \
            --preview 'eza --tree --icons=auto --level=2 --color=always {} 2>/dev/null' \
            --preview-window=right:70%
    )

    [[ -n "$directory" ]] && cd "$directory"
}


# File search + editor

fse() {
    local editor="${1:-lvim}"
    local file

    while true; do
        file=$(
            fd \
                --type f \
                --print0 \
                --hidden \
                --absolute-path \
                --exclude .cache \
                --exclude .local/share/Trash \
                --exclude .var/app \
                --exclude .wine \
                --exclude snap \
                --exclude .steam \
                --exclude .gradle \
                --exclude .m2/repository \
                --exclude .cargo \
                --exclude .rustup \
                --exclude go/pkg \
                --exclude .npm \
                --exclude .pnpm-store \
                --exclude .yarn \
                --exclude .vscode/extensions \
                --exclude .vscode-server \
                --exclude .local/share/nvim \
                --exclude .local/share/lvim \
                --exclude .local/share/lunarvim \
                --exclude .local/share/JetBrains \
                --exclude .local/share/flatpak \
                --exclude .local/share/containers \
                --exclude .local/share/Steam \
                --exclude node_modules \
                --exclude vendor \
                --exclude build \
                --exclude Build \
                --exclude dist \
                --exclude out \
                --exclude target \
                --exclude obj \
                --exclude release \
                --exclude debug \
                --exclude coverage \
                --exclude .next \
                --exclude .nuxt \
                --exclude .svelte-kit \
                --exclude .angular \
                --exclude .vite \
                --exclude .parcel-cache \
                --exclude .turbo \
                --exclude .output \
                --exclude __pycache__ \
                --exclude .mypy_cache \
                --exclude .pytest_cache \
                --exclude .tox \
                --exclude .nox \
                --exclude .ruff_cache \
                --exclude .venv \
                --exclude venv \
                --exclude env \
                --exclude .idea \
                --exclude .vs \
                --exclude Cache \
                --exclude cache \
                --exclude Caches \
                --exclude CachedData \
                --exclude "Code Cache" \
                --exclude GPUCache \
                --exclude ShaderCache \
                --exclude startupCache \
                --exclude tmp \
                --exclude temp \
                --exclude Temp \
                --exclude backup \
                --exclude backups \
                --exclude .git \
                --exclude .svn \
                --exclude .hg \
                --exclude .bzr \
                --exclude .log \
                --exclude session \
                --exclude "*.png" \
                --exclude "*.jpg" \
                --exclude "*.jpeg" \
                --exclude "*.gif" \
                --exclude "*.webp" \
                --exclude "*.mp4" \
                --exclude "*.mkv" \
                --exclude "*.zip" \
                --exclude "*.tar" \
                --exclude "*.gz" \
                --exclude "*.jar" \
                --exclude "*.class" \
                --exclude "*.so" \
                --exclude "*.dll" \
                --exclude "*.log" \
                --exclude .netbeans \
                --exclude .eclipse \
                --exclude .p2 \
                --exclude .metadata \
                --exclude .settings \
                --exclude .project \
                --exclude .classpath \
                --exclude .factorypath \
                --exclude .gradle/caches \
                --exclude .gradle/wrapper \
                --exclude .oracle_jre_usage \
                --exclude oracle-java/userdir/var/cache \
                --exclude oracle-java/userdir/var/log \
                --exclude .jdt \
                --exclude .jdt.ls \
                --exclude .redhat \
                --exclude .ipynb_checkpoints \
                --exclude .pyright \
                --exclude .pytype \
                --exclude .hypothesis \
                --exclude .eslintcache \
                --exclude .stylelintcache \
                --exclude .cache-loader \
                --exclude .sass-cache \
                --exclude .jekyll-cache \
                --exclude .terraform \
                --exclude .terraform.d \
                --exclude .serverless \
                --exclude .aws \
                --exclude .kube/cache \
                --exclude thumbnails \
                --exclude .thumbnails \
                --exclude .Trash \
                --exclude Trash \
                --exclude lost+found \
                --exclude .DS_Store \
                --exclude "*.tmp" \
                --exclude "*.temp" \
                --exclude "*.bak" \
                --exclude "*.old" \
                --exclude "*.log" \
                --exclude "*.lock" \
                --exclude "*.cache" \
                --exclude "*.backup" \
                --exclude "*.backups" \
                --exclude "*.zwc" \
                --exclude icc \
                --exclude JetBrains \
                --exclude VIGXxDDXIemn \
                --exclude .docker/buildx \
                --exclude .java/ \
                --exclude code \
                --exclude Code \
                --exclude libreoffice \
                --exclude PrismLauncher \
                --exclude rstudio \
                --exclude x86_64-redhat-linux-gnu-library \
                --exclude ManicadosFull \
                --exclude WhiteSur-icon-theme \
                --exclude WhiteSur-gtk-theme \
                --exclude .sdkman \
                --exclude .themes \
                --exclude .icons \
                --exclude .vscode \
                . "$HOME" |
            xargs -0 -r stat --printf='%Y %n\n' 2>/dev/null |
            sort -rn |
            cut -d' ' -f2- |
            fzf \
                --no-sort \
                --exact \
                --delimiter="$HOME/" \
                --with-nth=2.. \
                --preview 'bat --style=numbers --color=always {} 2>/dev/null' \
                --preview-window=right:70%
        )

        [[ -z "$file" ]] && break

        "$editor" "$file"
    done
}


# cmatrix customization

cmatrix() {
    command cmatrix -C white -a -b -u 3 "$@"
}